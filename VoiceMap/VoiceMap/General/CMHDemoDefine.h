//
//  CMHDemoDefine.h
//  ComeMoneyHere
//
//  Created by 李保东 on 16/11/15.
//  Copyright © 2016年 李保东. All rights reserved.
//


/*************Test测试HTTP**************/

#define kTestHttpHost @"http://guangbo.langhu.net"

#define kComeIdHttpHost @"http://net.adwtp.com"

// 入口id匹配
#define kComeId 123

// 入口的提示信息
#define kComeMessage  @"请交余款哦！"


UIKIT_EXTERN NSString *const kComeAppId;//入口标示


// 语音
UIKIT_EXTERN NSString *const kReUploadVoiceAndLocation;  //上传我当前说的话和位置
UIKIT_EXTERN NSString *const kMainGetVoiceList; // 获得所有的会话列表

// 红包
UIKIT_EXTERN NSString *const kMainGetRedPacketsList; // 获得红包列表的接口
UIKIT_EXTERN NSString *const kReceiveImmediatelyRedPackets; // 点击立即领取红包的接口
UIKIT_EXTERN NSString *const kGoSpendRedPackets; // 点击去消费红包的接口
UIKIT_EXTERN NSString *const kGetAllRedPackets; // 红包详情页获得已领所有红包的接口





#define kTabBarButtonBaseTag 100
