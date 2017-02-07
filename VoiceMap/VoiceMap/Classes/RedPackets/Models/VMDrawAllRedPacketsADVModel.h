//
//  VMDrawAllRedPacketsADVModel.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/7.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMDrawAllRedPacketsADVModel : NSObject

@property(nonatomic,copy)NSString *advname;

@property(nonatomic,copy)NSString *advtitle;

@property(nonatomic,copy)NSString *content;

+(instancetype)updateWithVMDrawAllRedPacketsADVModelDic:(NSDictionary *)dic;

-(instancetype)initWithVMDrawAllRedPacketsADVModelDic:(NSDictionary *)dic;

@end
