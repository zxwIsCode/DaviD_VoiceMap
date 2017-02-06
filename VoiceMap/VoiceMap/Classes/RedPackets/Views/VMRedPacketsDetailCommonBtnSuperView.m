//
//  VMRedPacketsDetailCommonBtnSuperView.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsDetailCommonBtnSuperView.h"

@interface VMRedPacketsDetailCommonBtnSuperView ()



@end

@implementation VMRedPacketsDetailCommonBtnSuperView
+(instancetype)redPacketsFouctionBtn {
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self ==[super initWithFrame:frame]) {
        
        self.bigButton =[UIButton buttonWithType:UIButtonTypeCustom];
        self.isleftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.isRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnSpacing =10 *kAppScale;
        self.bigButton.frame =CGRectMake(btnSpacing, 0, SCREEN_WIDTH -2 *btnSpacing, kVMRedPacketsDetailCommonBtnSuperViewHeight);
        CGFloat lrBtnW =(SCREEN_WIDTH -3 *btnSpacing) *0.5;
        self.isleftBtn.frame =CGRectMake(btnSpacing, 0, lrBtnW, kVMRedPacketsDetailCommonBtnSuperViewHeight);
        self.isRightBtn.frame =CGRectMake(CGRectGetMaxX(self.isleftBtn.frame) +btnSpacing, 0, lrBtnW, kVMRedPacketsDetailCommonBtnSuperViewHeight);
        
        // Target事件
        [self.bigButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.isleftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.isRightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];


        
        [self addSubview:self.bigButton];
        [self addSubview:self.isRightBtn];
        [self addSubview:self.isleftBtn];
        
    }
    return self;
}

-(void)setItemModel:(VMRedPacketsItemModel *)itemModel {
    _itemModel =itemModel;
    if ([itemModel.isDrawNum intValue] ==YES && [itemModel.isSpendNum intValue] ==YES) {
        self.bigButton.hidden =YES;
        [self.isleftBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.isRightBtn setTitle:@"已消费" forState:UIControlStateNormal];
        self.isleftBtn.userInteractionEnabled =NO;
        self.isRightBtn.userInteractionEnabled =NO;

        self.isleftBtn.backgroundColor =UIColorFromHexValue(0x5a5a5a);
        self.isRightBtn.backgroundColor =UIColorFromHexValue(0x5a5a5a);

    }else {
        
        self.isleftBtn.hidden =YES;
        self.isRightBtn.hidden =YES;
        
        if ([itemModel.isDrawNum intValue] ==NO) {// 未领取
            [self.bigButton setTitle:@"立即领取" forState:UIControlStateNormal];
            
            if (itemModel.startTimeStr >0) {
                self.bigButton.backgroundColor =UIColorFromHexValue(0x5a5a5a);
                self.bigButton.userInteractionEnabled =NO;


            }else {
                self.bigButton.backgroundColor =UIColorFromHexValue(0xff8400);
                self.bigButton.userInteractionEnabled =YES;


            }

        }else { // 已经领取
            if ([itemModel.isSpendNum intValue] ==NO) {
                [self.bigButton setTitle:@"去消费" forState:UIControlStateNormal];
                self.bigButton.backgroundColor =UIColorFromHexValue(0xff8400);
                self.bigButton.userInteractionEnabled =YES;


            }
        }
        
    }
}
-(void)buttonClick:(UIButton *)button {
    
    if (self.redPacketsBtnBlock) {
        if ([button.titleLabel.text isEqualToString:@"已领取"]) {
            [DisplayHelper displayWarningAlert:@"您已经领取了奖励哦!"];
            //        DDLog(@"您已经领取了奖励哦!");
        }else if ([button.titleLabel.text isEqualToString:@"已消费"]) {
            [DisplayHelper displayWarningAlert:@"您已经消费了奖励哦!"];
        }else if ([button.titleLabel.text isEqualToString:@"立即领取"]) {
            
            self.redPacketsBtnBlock(1);

//            [DisplayHelper displaySuccessAlert:@"您正在领取奖励哦!"];
        }else if ([button.titleLabel.text isEqualToString:@"去消费"]) {
            self.redPacketsBtnBlock(2);
//            [DisplayHelper displaySuccessAlert:@"您正在消费奖励哦!"];
        }
    }
    
    
    
}

@end
