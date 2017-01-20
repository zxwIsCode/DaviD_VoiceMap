//
//  VMVoiceItem.h
//  VoiceMap
//
//  Created by 李保东 on 17/1/20.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMVoiceItem : NSObject

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *audio;

+(instancetype)updateWithDic:(NSDictionary *)dic;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
