//
//  VMDrawAllRedPacketsADVModel.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/7.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMDrawAllRedPacketsADVModel.h"

@implementation VMDrawAllRedPacketsADVModel

+(instancetype)updateWithVMDrawAllRedPacketsADVModelDic:(NSDictionary *)dic {
    return [[self alloc]initWithVMDrawAllRedPacketsADVModelDic:dic];
}

-(instancetype)initWithVMDrawAllRedPacketsADVModelDic:(NSDictionary *)dic {
    if (self =[super init]) {
        self.advname =dic[@"advname"];
        self.advtitle =dic[@"advtitle"];
        self.content =dic[@"content"];
        self.mId =dic[@"id"];

    }
    return self;
}
@end
