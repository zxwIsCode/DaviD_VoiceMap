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

+(instancetype)updateWithRedPacketsItemDic:(NSDictionary *)dic;

-(instancetype)initWithRedPacketsItemDic:(NSDictionary *)dic;

@end
