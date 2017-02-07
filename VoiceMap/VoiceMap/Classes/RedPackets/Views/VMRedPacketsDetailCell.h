//
//  VMRedPacketsDetailCell.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMRedPacketsItemModel.h"
#import "VMAllDrawRedPacketsItemModel.h"


#define kVMRedPacketsDetailCellHeight 68 *kAppScale

@interface VMRedPacketsDetailCell : UITableViewCell
+(instancetype)updateWithTableView:(UITableView *)tableView;

//@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;

@property(nonatomic,strong)VMAllDrawRedPacketsItemModel *allDrawModel;




@end
