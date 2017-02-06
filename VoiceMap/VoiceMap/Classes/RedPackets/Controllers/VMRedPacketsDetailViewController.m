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

#define kRedPacketsScrollViewScale 0.5


@interface VMRedPacketsDetailViewController ()<YLInfiniteScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)YLInfiniteScrollView *autoScrollView;

@property(nonatomic,strong)UIView *titleSuperView;

@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)UIView *btnSuperView;

@property(nonatomic,strong)VMRedPacketsDetailHeaderView *detailHeaderView;

@property(nonatomic,strong)UITableView *tableView;

// 轮播图的数据源
@property(nonatomic,strong)NSMutableArray *autoScrollArr;
// 列表的数据源
@property(nonatomic,strong)NSMutableArray *dataArray;


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
    [self.view addSubview:self.tableView];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.frame =CGRectMake(0, SCREEN_WIDTH *kRedPacketsScrollViewScale, SCREEN_WIDTH, SCREEN_HEIGHT -SCREEN_WIDTH *kRedPacketsScrollViewScale -64);
    self.tableView.backgroundColor =UIColorFromHexValue(0xfffce5);
    
}

#pragma mark - Private Methods

-(void)initAllDatas {
    self.autoScrollArr =[@[@"http://jiamenkou.123jmk.com/Uploads/HomeCarousel/2017-01-10/58743eac9a9ed.png"] mutableCopy];
    
    for (int index =0; index <8; index ++) {
        VMRedPacketsItemModel *item =[VMRedPacketsItemModel updateWithRedPacketsItemDic:nil];
        [self.dataArray addObject:item];
    }
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
            VMRedPacketsItemModel *item =self.dataArray[indexPath.row];
            
            cell.itemModel =item;
            
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
        _tableView.bounces =NO;
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
        CGFloat detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight +textViewLableH -160 *kAppScale;
        if (textViewLableH <160 *kAppScale) { //如果详情高度不够160的话，就按160处理
            detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight;
        }
        
        _detailHeaderView.frame =CGRectMake(0, 0, SCREEN_WIDTH , detailHeaderViewH);
    }
    return _detailHeaderView;
}




@end
