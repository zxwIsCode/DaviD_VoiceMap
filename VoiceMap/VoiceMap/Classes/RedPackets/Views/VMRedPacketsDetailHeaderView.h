//
//  VMRedPacketsDetailHeaderView.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VMRedPacketsItemModel.h"
#import "VMRedPacketsDetailCommonBtnSuperView.h"


#define kVMRedPacketsDetailHeaderViewHeight 225 *kAppScale

@interface VMRedPacketsDetailHeaderView : UIView

+(instancetype)HeaderView;

@property(nonatomic,strong)VMRedPacketsDetailCommonBtnSuperView *btnSuperView;


@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;



@end
