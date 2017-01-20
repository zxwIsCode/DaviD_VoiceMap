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

@end
