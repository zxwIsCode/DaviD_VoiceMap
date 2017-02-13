//
//  VMVoiceViewController.h
//  VoiceMap
//
//  Created by 李保东 on 17/1/16.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "CMBaseViewController.h"

@interface VMVoiceViewController : CMBaseViewController

@property (nonatomic,weak) UINavigationController *nav;

// 记录2个界面在容器中调换的情况
@property(nonatomic,assign)NSInteger pageCount;

@end
