//
//  VMUploadModel.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/19.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMUploadModel.h"

@implementation VMUploadModel

-(NSString *)deviceToken {
    return [[[UIDevice currentDevice] identifierForVendor]UUIDString];
}

@end
