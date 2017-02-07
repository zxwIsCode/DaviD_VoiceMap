//
//  VMRedPacketsHeaderView.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsHeaderView.h"
#import "FALRButton.h"

@interface VMRedPacketsHeaderView ()

@property(nonatomic,strong)UILabel *allRedPacketsLable;

@property(nonatomic,strong)FALRButton *leftRightBtn;

@property(nonatomic,strong)UIView *lineView;

@end

@implementation VMRedPacketsHeaderView
+(instancetype)updateWithHeaderTableView:(UITableView *)tableView {
    static NSString *ID = @"SVMRedPacketsHeaderViewId";
    VMRedPacketsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (!headerView) {
        headerView = [[VMRedPacketsHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return headerView;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.allRedPacketsLable =[[UILabel alloc]init];
        self.leftRightBtn =[FALRButton leftRightButton];
        self.leftRightBtn.imagRatio =0.3;
        self.lineView =[[UIView alloc]init];
        
        [self.leftRightBtn setTitleColor:UIColorFromHexValue(0x333333) forState:UIControlStateNormal];
        self.allRedPacketsLable.font=[UIFont systemFontOfSize:15 *kAppScale];
        
        self.allRedPacketsLable.frame =CGRectMake(10 *kAppScale, 0, SCREEN_WIDTH -120 *kAppScale, kVMRedPacketsHeaderViewHeight);
        CGFloat leftRightBtnW =40 *kAppScale;
        self.leftRightBtn.frame =CGRectMake(SCREEN_WIDTH -leftRightBtnW -10*kAppScale, 0, leftRightBtnW, kVMRedPacketsHeaderViewHeight);
        self.lineView.frame =CGRectMake(0, kVMRedPacketsHeaderViewHeight -1, SCREEN_WIDTH, 1);
        
//        self.allRedPacketsLable.backgroundColor =[UIColor darkGrayColor];
//        self.leftRightBtn.backgroundColor =[UIColor blueColor];
        self.backgroundColor =UIColorFromHexValue(0xfffce5);
        self.contentView.backgroundColor =UIColorFromHexValue(0xfffce5);

        self.lineView.backgroundColor =UIColorFromHexValue(0xffc07d);

        
        [self.contentView addSubview:self.allRedPacketsLable];
        [self.contentView addSubview:self.leftRightBtn];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

-(void)setRedPacketsCount:(NSInteger)redPacketsCount {
    _redPacketsCount =redPacketsCount;
    self.allRedPacketsLable.text =[NSString stringWithFormat:@"您所在的城市共有%ld个红包",redPacketsCount];
    [self.leftRightBtn setImage:[UIImage imageNamed:@"icon_xingxing"] forState:UIControlStateNormal];
    [self.leftRightBtn setTitle:[NSString stringWithFormat:@"%ld",redPacketsCount] forState:UIControlStateNormal];
}



@end
