//
//  VMRedPacketsItemModel.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsItemModel.h"

@implementation VMRedPacketsItemModel
+(instancetype)updateWithRedPacketsItemDic:(NSDictionary *)dic {
    return [[self alloc]initWithRedPacketsItemDic:dic];
}

-(instancetype)initWithRedPacketsItemDic:(NSDictionary *)dic {
    if (self =[super init]) {
        self.iconUrl =@"icon_hb";
        self.descStr =@"欢迎来到这里抢些红包带走哦！";
        self.remarksStr =@"2017年02点24分开抢哦!";
        self.startTimeStr =@"开抢时间：2017年02点24分";
        
        self.redPacketsDetailStr =@"贝克汉姆曾拿到世界上第一台镀金苹果笔记本电脑，当他想在ins上向粉丝展示这个伟大的礼物时，却被他的公关顾问——奥利维拉阻止了。“你是公众人物，要时刻注意保持自己的正面形象；你和维多利亚都要注意，你们一直以来也做的不错。我们都知道这位英国金童曾经叱咤世界足坛，我们听过他的风流韵事，我们嫉妒他富可敌国家庭美满，但我们是否了解他一直标榜的自己所从事的慈善事业？当地时间2月3日，贝克汉姆与奥利维拉邮件往来的大部分内容被欧洲新闻调查协作组织截获并曝出：\n他做慈善的根本动机只是为了博得名声获取爵位，日入数万英镑却极其吝啬。\n听到这些的时候，你会不会感觉贝克汉姆的人设要崩？英国国内对于这次贝克汉姆遭遇名声危机的主流观点是：“追求名利的贝克汉姆到头来可能两手空空，最起码在2017年理应如此。不堪事迹被曝出——做慈善只为博爵位？贝克汉姆这次被曝出的不堪事迹包括：拒绝用自己的钱来投身公益，即便从联合国儿童基金会工作中获得百万也不愿意为基金会集资。\n要求联合国儿童基金会为他支付2014年前往菲律宾参加慈善活动的6685英镑机票费用。\n他说，“说实话，我觉得无论如何都不应该让我付任何钱。\n”事实上赞助商们帮他付了私人飞机的所有费用；此外，贝克汉姆对联合国儿童基金会的捐赠超过了100万英镑，根据合同，机票和酒店相关费用自行支付，捐赠期为2016年底前，而支付期则为日后。官方拒绝澄清费用相关疑惑。";
        self.isDrawNum =@(1);
        self.isSpendNum =@(1);
    }
    return self;
}


@end
