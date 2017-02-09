//
//  VMRedPacketsDetailViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsDetailViewController.h"

#import "YLInfiniteScrollView.h"
#import "VMRedPacketsDetailCell.h"
#import "VMRedPacketsItemModel.h"
//#import "VMRedPacketsHeaderView.h"
#import "VMRedPacketsDetailHeaderView.h"
#import "VMRedPacketsPhotoItem.h"
#import "VMAllDrawRedPacketsItemModel.h"

#define kRedPacketsScrollViewScale 0.5


@interface VMRedPacketsDetailViewController ()<YLInfiniteScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    // 定时器
    NSTimer *timer;
}

@property(nonatomic,strong)YLInfiniteScrollView *autoScrollView;

@property(nonatomic,strong)UILabel *titleLable;

@property(nonatomic,strong)UILabel *startTimeLable;

@property(nonatomic,strong)UIView *smallLineView;

@property(nonatomic,strong)VMRedPacketsDetailHeaderView *detailHeaderView;

@property(nonatomic,strong)UITableView *tableView;

// 轮播图的数据源
@property(nonatomic,strong)NSMutableArray *autoScrollArr;
// 列表的数据源
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger subTimeStamp;


@end

@implementation VMRedPacketsDetailViewController

#pragma mark - Init
- (void)viewDidLoad {
    self.title =@"红包详情";
    [super viewDidLoad];
    
    // 初始化数据源，现在是假数据
    [self initAllDatas];
    
    [self creaScrollView];
    [self.view addSubview:self.autoScrollView];
    
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.startTimeLable];
    [self.view addSubview:self.smallLineView];
    
    self.titleLable.text =self.itemModel.descStr;
    self.startTimeLable.text =[self.itemModel getTimeStr:self.itemModel.startTimeStr];
    
    
    
    [self.view addSubview:self.tableView];
    
    [self initTimer];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat superViewX =10 *kAppScale;
    CGFloat scrollViewH = SCREEN_WIDTH *kRedPacketsScrollViewScale;
    self.titleLable.frame =CGRectMake(superViewX,scrollViewH + 15 *kAppScale, SCREEN_WIDTH -2 *superViewX, 20 *kAppScale);
    self.startTimeLable.frame =CGRectMake(superViewX, CGRectGetMaxY(self.titleLable.frame) +4 *kAppScale, SCREEN_WIDTH -2 *superViewX, 16 *kAppScale);
    self.smallLineView.frame =CGRectMake(0, CGRectGetMaxY(self.startTimeLable.frame) +10 *kAppScale, SCREEN_WIDTH , 1);
    
    CGFloat tableViewY =CGRectGetMaxY(self.smallLineView.frame);
    self.tableView.frame =CGRectMake(0, tableViewY, SCREEN_WIDTH, SCREEN_HEIGHT -tableViewY -64);
    self.view.backgroundColor =UIColorFromHexValue(0xfffce5);
    self.tableView.backgroundColor =UIColorFromHexValue(0xfffce5);
    
//    self.titleLable.backgroundColor =[UIColor darkGrayColor];
//    self.startTimeLable.backgroundColor =[UIColor brownColor];
    
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //不能重新获得时间发布时间，故而定时器不要停止
    [timer invalidate];
    timer = nil;

}
-(void)dealloc {
    
    [timer invalidate];
    timer = nil;
}

#pragma mark - Private Methods
-(void)initTimer {

    if (self.itemModel.startTimeStr != 0) {
        timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    }
    WS(ws);
    self.detailHeaderView.btnSuperView.redPacketsBtnBlock =^(NSInteger btnTag) {
        if (btnTag ==1) {// 立即领取
            
            // 立即领取 红包
            [ws requestDrawRedPackets];

        }else { //去消费
            
            // 去消费红包
            [ws requestSpendRedPackets];

        }
    };

    
}

-(void)timer:(NSTimer*)timerr{
//    self.itemModel.startTimeStr =self.itemModel.startTimeStr -1;
    
    self.startTimeLable.text =[self.itemModel getTimeStr:self.itemModel.startTimeStr];
    
    if ([self.startTimeLable.text isEqualToString:StartTimerStopText]) { //开抢时间到，就停止定时器
        [timer invalidate];
        timer = nil;

        self.detailHeaderView.btnSuperView.bigButton.backgroundColor =UIColorFromHexValue(0xff8400);
        self.detailHeaderView.btnSuperView.bigButton.userInteractionEnabled =YES;
        
    }
}
// 更改界面立即领取到去消费
-(void)changeDraw2SpendMoney {
    self.detailHeaderView.btnSuperView.bigButton.backgroundColor =UIColorFromHexValue(0xff8400);
    [self.detailHeaderView.btnSuperView.bigButton setTitle:@"去消费" forState:UIControlStateNormal];
}
// 更改界面消费到消费成功
-(void)changeSpendFinishMoney {
    [self.detailHeaderView.btnSuperView.bigButton removeFromSuperview];
    self.detailHeaderView.btnSuperView.isleftBtn.hidden =NO;
    self.detailHeaderView.btnSuperView.isRightBtn.hidden =NO;
    [self.detailHeaderView.btnSuperView.isleftBtn setTitle:@"已领取" forState:UIControlStateNormal];
    [self.detailHeaderView.btnSuperView.isRightBtn setTitle:@"已消费" forState:UIControlStateNormal];
    self.detailHeaderView.btnSuperView.isleftBtn.userInteractionEnabled =NO;
    self.detailHeaderView.btnSuperView.isRightBtn.userInteractionEnabled =NO;
    
    self.detailHeaderView.btnSuperView.isleftBtn.backgroundColor =UIColorFromHexValue(0x5a5a5a);
    self.detailHeaderView.btnSuperView.isRightBtn.backgroundColor =UIColorFromHexValue(0x5a5a5a);
}
// 立即领取 红包
-(void)requestDrawRedPackets {
    CMHttpRequestModel *paramsModel =[[CMHttpRequestModel alloc]init];
    paramsModel.appendUrl =kReceiveImmediatelyRedPackets;
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor]UUIDString];

    [paramsModel.paramDic setObject:uuidStr forKey:@"userid"];
    [paramsModel .paramDic setObject:@(self.itemModel.mId) forKey:@"id"];
    [paramsModel .paramDic setObject:@(2) forKey:@"regionid"];
    
    // 包装参数设置
    WS(ws);
    
    paramsModel.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.code == 101) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
                if (result.alertMsg) {
                    [DisplayHelper displaySuccessAlert:result.alertMsg];
                }else {
                    [DisplayHelper displaySuccessAlert:@"获取红包成功哦！"];
                }
                // 更改界面立即领取到去消费
                [ws changeDraw2SpendMoney];
               
                
            }else {// 失败,弹框提示
                
                DDLog(@"%@",result.error);
                if (result.alertMsg) {
                    [DisplayHelper displayWarningAlert:result.alertMsg];

                }else {
                    [DisplayHelper displayWarningAlert:@"请求成功,但没有数据哦!"];
                }
            }
        }else {
            
            [DisplayHelper displayWarningAlert:@"网络异常，请稍后再试!"];
            
        }
//        [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];
        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:paramsModel];
}

// 去消费红包
-(void)requestSpendRedPackets {
    CMHttpRequestModel *paramsModel =[[CMHttpRequestModel alloc]init];
    paramsModel.appendUrl =kGoSpendRedPackets;
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    
    [paramsModel.paramDic setObject:uuidStr forKey:@"userid"];
    [paramsModel .paramDic setObject:@(self.itemModel.mId) forKey:@"advid"];
    [paramsModel .paramDic setObject:@(2) forKey:@"regionid"];
    
    // 包装参数设置
    WS(ws);
    
    paramsModel.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.state ==CMReponseCodeState_Success) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
                if (result.alertMsg) {
                    [DisplayHelper displaySuccessAlert:result.alertMsg];
                }else {
                    [DisplayHelper displaySuccessAlert:@"消费红包成功！"];
                }
                
                // // 更改界面消费到消费成功
                [ws changeSpendFinishMoney];
               

                
            }else {// 失败,弹框提示
                
                DDLog(@"%@",result.error);
                if (result.alertMsg) {
                    [DisplayHelper displayWarningAlert:result.alertMsg];
                    
                }else {
                    [DisplayHelper displayWarningAlert:@"请求成功,但是消费红包失败！"];
                }
            }
        }else {
            
            [DisplayHelper displayWarningAlert:@"网络异常，请稍后再试!"];
            
        }
//        [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];
        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:paramsModel];
}



-(void)initAllDatas {
    
    // 轮播图数据源
    for (VMRedPacketsPhotoItem *photoItem in self.itemModel.picArray) {
        [self.autoScrollArr addObject:photoItem.i];
    }
//    self.autoScrollArr =[@[@"http://jiamenkou.123jmk.com/Uploads/HomeCarousel/2017-01-10/58743eac9a9ed.png"] mutableCopy];
#warning 这里是为了测试的假数据
//    for (int index =0; index <8; index ++) {
//        VMRedPacketsItemModel *item =[VMRedPacketsItemModel updateWithRedPacketsItemDic:nil];
//        [self.dataArray addObject:item];
//    }
    
    CMHttpRequestModel *paramsModel =[[CMHttpRequestModel alloc]init];
    paramsModel.appendUrl =kGetAllRedPackets;
    NSString *uuidStr = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
    
    [paramsModel.paramDic setObject:uuidStr forKey:@"userid"];

    // 包装参数设置
    WS(ws);
    
    paramsModel.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.state ==CMReponseCodeState_Success) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
//                [DisplayHelper displaySuccessAlert:@"获取已领取红包列表成功哦！"];
                NSArray *dataArr =(NSArray *)result.data;
                if (dataArr.count) {
                    NSMutableArray *tempArr =[NSMutableArray array];
                    for (int index =0; index <dataArr.count; index ++) {
                        NSDictionary *infoDic =dataArr[index];
                        VMAllDrawRedPacketsItemModel *item =[VMAllDrawRedPacketsItemModel updateWithAllDrawRedPacketsItemModelDic:infoDic];
                        [tempArr addObject:item];
                    }
                    [ws.dataArray addObjectsFromArray:tempArr];
                    
                    // 判断当前的红包是否已经领过
//                    BOOL isFond =NO;
                    for (VMAllDrawRedPacketsItemModel *allRedItemModel in ws.dataArray) {
                        if ([allRedItemModel.advModel.mId integerValue] == ws.itemModel.mId) {
                            if ([allRedItemModel.status integerValue] ==1) {
                                // 更改界面立即领取到去消费
                                [ws changeDraw2SpendMoney];
                            }else if ([allRedItemModel.status integerValue] ==2) {
                                // 更改界面消费到消费成功
                                [ws changeSpendFinishMoney];
                            }
                           
//                            isFond =YES;
                        }
                    }
                    
                    [ws.tableView reloadData];
                    
                }                
                
            }else {// 失败,弹框提示
                
                DDLog(@"%@",result.error);
                if (result.alertMsg) {
                    [DisplayHelper displayWarningAlert:result.alertMsg];

                    
                }else {
                    [DisplayHelper displayWarningAlert:@"请求成功,但没有数据哦!"];
                }
            }
        }else {
            
            [DisplayHelper displayWarningAlert:@"网络异常，请稍后再试!"];
            
        }
        [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];
        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:paramsModel];
    
    
}
-(void)creaScrollView {
    self.autoScrollView = [[YLInfiniteScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH *kRedPacketsScrollViewScale)];
    _autoScrollView.delegate = self;
    _autoScrollView.images = self.autoScrollArr;
}

#pragma mark -  UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VMRedPacketsDetailCell *cell =[VMRedPacketsDetailCell updateWithTableView:tableView];
    if (cell) {
        if (indexPath.row <self.dataArray.count) {
            VMAllDrawRedPacketsItemModel *allDrawModel =self.dataArray[indexPath.row];
            
            cell.allDrawModel =allDrawModel;
            
        }
    }
    
    return cell;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kVMRedPacketsDetailHeaderViewHeight;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    VMRedPacketsHeaderView *headerView =[VMRedPacketsHeaderView updateWithHeaderTableView:tableView];
//    if (headerView) {
//        headerView.redPacketsCount =self.dataArray.count;
//    }
//    return headerView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    VMRedPacketsDetailViewController *detailVC =[[VMRedPacketsDetailViewController alloc]init];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark - YLInfiniteScrollViewDelegate


- (void)scrollViewImageClick:(NSInteger)selectTag {
    DDLog(@"selectTag = %ld",selectTag);
}

#pragma mark - Setter & Getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces =YES;
        _tableView.tableHeaderView =self.detailHeaderView;
        _tableView.rowHeight = kVMRedPacketsDetailCellHeight;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}
-(NSMutableArray *)autoScrollArr {
    if (!_autoScrollArr) {
        _autoScrollArr =[NSMutableArray array];
    }
    return _autoScrollArr;
}
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}

-(VMRedPacketsDetailHeaderView *)detailHeaderView {
    if (!_detailHeaderView) {
        _detailHeaderView =[VMRedPacketsDetailHeaderView HeaderView];
        _detailHeaderView.userInteractionEnabled =YES;
        _detailHeaderView.itemModel =self.itemModel;
        
        CGFloat superViewX =10 *kAppScale;
        CGFloat textViewLableW = SCREEN_WIDTH  -2 *superViewX;
        CGSize textViewLableSize = CGSizeMake(textViewLableW, MAXFLOAT);
        NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:13 *kAppScale ]};
        CGRect textViewLableFrame =[self.itemModel.redPacketsDetailStr boundingRectWithSize:textViewLableSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        CGFloat textViewLableH =textViewLableFrame.size.height;
        CGFloat detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight +textViewLableH -kVMRedPacketsDetailHeaderView_TextViewLableH;
        if (textViewLableH <kVMRedPacketsDetailHeaderView_TextViewLableH) { //如果详情高度不够最小间距的话，就按最小间距处理
            detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight;
        }
        
        _detailHeaderView.frame =CGRectMake(0, 0, SCREEN_WIDTH , detailHeaderViewH);
    }
    return _detailHeaderView;
}

-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable =[[UILabel alloc]init];
        _titleLable.font=[UIFont systemFontOfSize:14 *kAppScale];

    }
    return _titleLable;
}

-(UILabel *)startTimeLable {
    if (!_startTimeLable) {
        _startTimeLable =[[UILabel alloc]init];
        _startTimeLable.font =[UIFont systemFontOfSize:12 *kAppScale];
        _startTimeLable.textColor =UIColorFromHexValue(0xf40000);
    }
    return _startTimeLable;
}
-(UIView *)smallLineView {
    if (!_smallLineView) {
        _smallLineView =[[UIView alloc]init];
        _smallLineView.backgroundColor =UIColorFromHexValue(0xffc07d);

    }
    return _smallLineView;
}




@end
