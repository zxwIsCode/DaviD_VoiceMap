//
//  VMRedPacketsViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/16.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsMainViewController.h"
#import "VMRedPacketsListCell.h"
#import "VMRedPacketsItemModel.h"
#import "VMRedPacketsHeaderView.h"
#import "VMRedPacketsDetailViewController.h"
#import "MJRefresh.h"


@interface VMRedPacketsMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *allRedPacketsArr;

@property(nonatomic,assign)NSInteger page;

@end

@implementation VMRedPacketsMainViewController

#pragma mark - Init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.page =1;
    
    [self initWithDatas];
    
    
    
    [self.view addSubview:self.tableView];
    [self creatMJRefreshFooter];

    // Do any additional setup after loading the view.
}

-(void)creatMJRefreshFooter {
    
    WS(ws);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws initWithDatas];
    }];
    
//    self.tableView.mj_footer.backgroundColor =[UIColor redColor];
}
-(void)initWithDatas {
    
    
    CMHttpRequestModel *paramsModel =[[CMHttpRequestModel alloc]init];
    self.page ++;
    paramsModel.appendUrl =kMainGetRedPacketsList;
    [paramsModel.paramDic setObject:@(self.page) forKey:@"page"];
    [paramsModel .paramDic setObject:@(2) forKey:@"regionid"];
    
    // 包装参数设置
    WS(ws);
    [[DisplayHelper shareDisplayHelper]showLoading:self.view noteText:@"数据加载中..."];
    
    paramsModel.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.state ==CMReponseCodeState_Success) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
//                [DisplayHelper displaySuccessAlert:@"获得列表成功!"];
                NSArray *dataArr =(NSArray *)result.data;
                if (dataArr.count) {
                    NSMutableArray *tempArr =[NSMutableArray array];
                    for (int index =0; index <dataArr.count; index ++) {
                        NSDictionary *infoDic =dataArr[index];
                        VMRedPacketsItemModel *item =[VMRedPacketsItemModel updateWithRedPacketsItemDic:infoDic];
                        [tempArr addObject:item];
                    }
                    [ws.allRedPacketsArr addObjectsFromArray:tempArr];
                    [ws.tableView reloadData];

                }else {
                    ws.page --;
                    [DisplayHelper displayWarningAlert:@"请求成功,但是没有最新数据哦！"];

                }
                
            }else {// 失败,弹框提示
                ws.page --;

                DDLog(@"%@",result.error);
                [DisplayHelper displayWarningAlert:@"请求成功,但没有数据哦!"];
                
            }
        }else {
            ws.page --;

            [DisplayHelper displayWarningAlert:@"网络异常，请稍后再试!"];
            
        }
        // 停止刷新
        [ws.tableView.mj_footer endRefreshing];
        
        [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];
        
        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:paramsModel];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    
    self.tableView.backgroundColor =UIColorFromHexValue(0xfffce5);
}

//#pragma mark - 继承父类
//
//-(CMNavType)getNavType {
//    return CMNavTypeAll;
//}

#pragma mark -  UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allRedPacketsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VMRedPacketsListCell *cell =[VMRedPacketsListCell updateWithTableView:tableView];
    if (cell) {
        if (indexPath.row <self.allRedPacketsArr.count) {
            VMRedPacketsItemModel *item =self.allRedPacketsArr[indexPath.row];
            
            cell.itemModel =item;
            
        }
    }
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kVMRedPacketsHeaderViewHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    VMRedPacketsHeaderView *headerView =[VMRedPacketsHeaderView updateWithHeaderTableView:tableView];
    if (headerView) {
        headerView.redPacketsCount =self.allRedPacketsArr.count;
//        headerView.backgroundColor =[UIColor redColor];
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    VMRedPacketsDetailViewController *detailVC =[[VMRedPacketsDetailViewController alloc]init];
    
    VMRedPacketsItemModel *item =self.allRedPacketsArr[indexPath.row];
    detailVC.itemModel =item;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}



#pragma mark -  Setter & Getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces =NO;
        _tableView.rowHeight = kVMRedPacketsListCellHeight;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

-(NSMutableArray *)allRedPacketsArr {
    if (!_allRedPacketsArr) {
        _allRedPacketsArr =[NSMutableArray array];
    }
    return _allRedPacketsArr;
}


@end
