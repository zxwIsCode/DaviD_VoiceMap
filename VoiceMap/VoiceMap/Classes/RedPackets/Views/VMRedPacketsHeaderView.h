//
//  VMRedPacketsHeaderView.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVMRedPacketsHeaderViewHeight 36 *kAppScale

@interface VMRedPacketsHeaderView : UITableViewHeaderFooterView
+(instancetype)updateWithHeaderTableView:(UITableView *)tableView;

@property(nonatomic,assign)NSInteger redPacketsCount;
@end
