//
//  VMRedPacketsItemModel.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsItemModel.h"

@implementation VMRedPacketsItemModel
+(instancetype)updateWithRedPacketsItemDic:(NSDictionary *)dic {
    return [[self alloc]initWithRedPacketsItemDic:dic];
}

-(instancetype)initWithRedPacketsItemDic:(NSDictionary *)dic {
    if (self =[super init]) {
        self.descStr =@"欢迎来到这里抢些红包带走哦！";
        self.remarksStr =@"2017年02点24分开抢哦!";
        self.startTimeStr =@"开抢时间：2017年02点24分";
    }
    return self;
}


@end
