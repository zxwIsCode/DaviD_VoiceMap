//
//  VMRedPacketsPhotoItem.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/6.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsPhotoItem.h"

@implementation VMRedPacketsPhotoItem

+(instancetype)updateWithRedPacketsPhotoItemDic:(NSDictionary *)dic {
    return [[self alloc]initWithRedPacketsPhotoItemDic:dic];

}

-(instancetype)initWithRedPacketsPhotoItemDic:(NSDictionary *)dic {
    if (self ==[super init]) {
        self.i =dic[@"i"];
    }
    return self;

}
@end
