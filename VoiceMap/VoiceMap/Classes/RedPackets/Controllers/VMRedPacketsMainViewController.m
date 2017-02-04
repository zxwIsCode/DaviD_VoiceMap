//
//  VMRedPacketsViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/16.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsMainViewController.h"

@interface VMRedPacketsMainViewController ()

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation VMRedPacketsMainViewController

#pragma mark - Init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 继承父类

-(CMNavType)getNavType {
    return CMNavTypeAll;
}

-(NSString *)customNavigationTitleViewTitleStr {
    return @"红包列表";
}

#pragma mark -  Setter & Getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}


@end
