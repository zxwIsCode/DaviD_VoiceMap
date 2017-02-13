//
//  VMVoiceItem.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/20.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMVoiceItem.h"

@implementation VMVoiceItem

+(instancetype)updateWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
-(instancetype)initWithDic:(NSDictionary *)dic {
    if (self =[super init]) {
        if (dic) {
            self.audio =dic[@"audio"];
            self.text =dic[@"text"];
        }else {
            self.audio =@"xxx";
            self.text =@"测试没有数据";
        }
    }
    return self;

}

/**
 *  获得存储对象调用
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.audio = [decoder decodeObjectForKey:@"audio"];
        self.text = [decoder decodeObjectForKey:@"text"];

        
    }
    return self;
}

/**
 *  存储对象到文件调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.audio forKey:@"audio"];
    [encoder encodeObject:self.text forKey:@"text"];

}


@end
