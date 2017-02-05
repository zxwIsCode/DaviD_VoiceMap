//
//  VMRedPacketsItemModel.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMRedPacketsItemModel : NSObject

@property(nonatomic,copy)NSString *iconUrl;

@property(nonatomic,copy)NSString *descStr;

@property(nonatomic,copy)NSString *remarksStr;

@property(nonatomic,copy)NSString *startTimeStr;

// 红包的详情介绍
@property(nonatomic,copy)NSString *redPacketsDetailStr;

// 是否已经领取
@property(nonatomic,strong)NSNumber *isDrawNum;

// 是否已经消费
@property(nonatomic,strong)NSNumber *isSpendNum;

+(instancetype)updateWithRedPacketsItemDic:(NSDictionary *)dic;

-(instancetype)initWithRedPacketsItemDic:(NSDictionary *)dic;

@end
