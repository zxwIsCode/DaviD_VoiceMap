//
//  VMRedPacketsDetailCommonBtnSuperView.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VMRedPacketsDetailCommonBtnSuperView.h"
#import "VMRedPacketsItemModel.h"
#define kVMRedPacketsDetailCommonBtnSuperViewHeight 36 *kAppScale


@interface VMRedPacketsDetailCommonBtnSuperView : UIView

+(instancetype)redPacketsFouctionBtn;

@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;

@end
