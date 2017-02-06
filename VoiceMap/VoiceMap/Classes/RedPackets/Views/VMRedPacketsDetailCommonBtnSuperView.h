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

typedef void(^VMClickButtonBlock)(NSInteger btnTag);

@interface VMRedPacketsDetailCommonBtnSuperView : UIView

+(instancetype)redPacketsFouctionBtn;

@property(nonatomic,strong)VMRedPacketsItemModel *itemModel;

@property(nonatomic,strong)UIButton *bigButton;

@property(nonatomic,strong)UIButton *isleftBtn;

@property(nonatomic,strong)UIButton *isRightBtn;

@property(nonatomic,copy)VMClickButtonBlock redPacketsBtnBlock;



@end
