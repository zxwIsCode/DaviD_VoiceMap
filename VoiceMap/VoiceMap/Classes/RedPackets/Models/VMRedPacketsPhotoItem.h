//
//  VMRedPacketsPhotoItem.h
//  VoiceMap
//
//  Created by 李保东 on 17/2/6.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMRedPacketsPhotoItem : NSObject

@property(nonatomic,copy)NSString *i;

+(instancetype)updateWithRedPacketsPhotoItemDic:(NSDictionary *)dic;

-(instancetype)initWithRedPacketsPhotoItemDic:(NSDictionary *)dic;
@end
