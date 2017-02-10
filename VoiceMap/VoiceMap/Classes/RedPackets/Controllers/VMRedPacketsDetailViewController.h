//
//  VMRedPacketsDetailViewController.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//  红包详情界面（非H5）

#import "CMBaseViewController.h"

#import "VMRedPacketsItemModel.h"

typedef void(^VMDeleteRedPacketsBlock)(VMRedPacketsItemModel *itemModel);

@interface VMRedPacketsDetailViewController : CMBaseViewController

@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;

@property(nonatomic,copy)VMDeleteRedPacketsBlock deleteBlock;

@end
