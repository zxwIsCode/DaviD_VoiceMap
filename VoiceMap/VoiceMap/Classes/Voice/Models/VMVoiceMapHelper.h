//
//  VMVoiceMapHelper.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/13.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMVoiceItem.h"

@interface VMVoiceMapHelper : NSObject


// 保存微信数据
+(void)saveWechatAccount:(VMVoiceItem *)user;
// 取得微信数据
+(VMVoiceItem *)Wechat;
@end
