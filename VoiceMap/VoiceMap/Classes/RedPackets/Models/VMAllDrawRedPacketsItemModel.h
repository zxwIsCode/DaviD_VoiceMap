//
//  VMAllDrawRedPacketsItemModel.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/7.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMDrawAllRedPacketsADVModel.h"

@interface VMAllDrawRedPacketsItemModel : NSObject

@property(nonatomic,copy)NSString *iconUrl;


@property(nonatomic,copy)NSString *advid;

@property(nonatomic,copy)NSString *mId;

@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSString *userid;

@property(nonatomic,strong)VMDrawAllRedPacketsADVModel *advModel;

+(instancetype)updateWithAllDrawRedPacketsItemModelDic:(NSDictionary *)dic;

-(instancetype)initWithAllDrawRedPacketsItemModelDic:(NSDictionary *)dic;


@end
