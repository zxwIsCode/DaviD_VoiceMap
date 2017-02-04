//
//  VMRedPacketsListCell.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMRedPacketsItemModel.h"


#define kVMRedPacketsListCellHeight 88 *kAppScale



@interface VMRedPacketsListCell : UITableViewCell

@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;

+(instancetype)updateWithTableView:(UITableView *)tableView;

@end
