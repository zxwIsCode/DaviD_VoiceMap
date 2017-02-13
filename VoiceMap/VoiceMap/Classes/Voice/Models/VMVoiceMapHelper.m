//
//  VMVoiceMapHelper.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/13.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMVoiceMapHelper.h"

#define VMVoiceHelperData @"VoiceMapHelper.data"


@implementation VMVoiceMapHelper

// 保存数据
+(void)saveWechatAccount:(VMVoiceItem *)user {
    
    NSString *wechatFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:VMVoiceHelperData];
    [NSKeyedArchiver archiveRootObject:user toFile:wechatFile];
    
}
// 取得数据
+(VMVoiceItem *)Wechat {
    NSString *wechatFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:VMVoiceHelperData];
    
    VMVoiceItem *wechat = [NSKeyedUnarchiver unarchiveObjectWithFile:wechatFile];
    return wechat;
    
}
@end
