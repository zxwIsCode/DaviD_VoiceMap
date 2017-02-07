//
//  VMAllDrawRedPacketsItemModel.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/7.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMAllDrawRedPacketsItemModel.h"

@implementation VMAllDrawRedPacketsItemModel

-(VMDrawAllRedPacketsADVModel *)advModel {
    if (!_advModel) {
        _advModel =[[VMDrawAllRedPacketsADVModel alloc]init];
    }
    return _advModel;
}

+(instancetype)updateWithAllDrawRedPacketsItemModelDic:(NSDictionary *)dic {
    return [[self alloc]initWithAllDrawRedPacketsItemModelDic:dic];
}

-(instancetype)initWithAllDrawRedPacketsItemModelDic:(NSDictionary *)dic {
    if (self =[super init]) {
        self.iconUrl =@"icon_hb";
        self.advid =dic[@"advid"];
        self.mId =dic[@"id"];
        self.status =dic[@"status"];
        self.userid =dic[@"userid"];
        self.advModel =[VMDrawAllRedPacketsADVModel updateWithVMDrawAllRedPacketsADVModelDic:dic[@"adv"]];

    }
    return self;
}

@end
