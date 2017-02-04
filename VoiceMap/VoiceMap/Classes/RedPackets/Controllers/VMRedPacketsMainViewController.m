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


@interface VMRedPacketsMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *allRedPacketsArr;

@end

@implementation VMRedPacketsMainViewController

#pragma mark - Init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    for (int index =0; index <12; index ++) {
        VMRedPacketsItemModel *item =[VMRedPacketsItemModel updateWithRedPacketsItemDic:nil];
        [self.allRedPacketsArr addObject:item];
    }
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    
    self.tableView.backgroundColor =[UIColor purpleColor];
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
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
//        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = kVMRedPacketsListCellHeight;
        _tableView.showsVerticalScrollIndicator = NO;
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
