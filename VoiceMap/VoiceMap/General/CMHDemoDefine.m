//
//  CMHDemoDefine.m
//  ComeMoneyHere
//
//  Created by 李保东 on 16/11/15.
//  Copyright © 2016年 李保东. All rights reserved.
//


// 语音
NSString *const kReUploadVoiceAndLocation = @"/admin.php/Publish/put_data";//上传我当前说的话和位置
NSString *const kMainGetVoiceList = @"/index.php/Index/ajax_getData/msg/2"; // 获得所有的会话列表

// 红包
NSString *const kMainGetRedPacketsList = @"/index.php/adver/index_aj/regionid/2/maxid/"; // 获得红包列表的接口
NSString *const kReceiveImmediatelyRedPackets = @"/index.php/Adver/ling"; // 点击立即领取红包的接口
NSString *const kGoSpendRedPackets = @"/index.php/Adver/useAdv"; // 点击去消费红包的接口
NSString *const kGetAllRedPackets = @"/index.php/Adver/hasAdvs/regionid/2"; // 红包详情页获得已领所有红包的接口





