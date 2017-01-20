//
//  VMUploadModel.h
//  VoiceMap
//
//  Created by 李保东 on 17/1/19.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface VMUploadModel : NSObject

@property(nonatomic,copy)NSString *deviceToken;

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *audio;

@property(nonatomic,copy)NSString *detailAddress;

@property(nonatomic,copy)CLLocation *nowLocation;

@end
