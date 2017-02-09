//
//  VMRedPacketsDetailCell.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsDetailCell.h"


@interface VMRedPacketsDetailCell ()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *descLable;

@property(nonatomic,strong)UILabel *startTimeLable;

@property(nonatomic,strong)UIButton *isDrawBtn;

@property(nonatomic,strong)UIButton *isSpendBtn;

@property(nonatomic,strong)UIView *lineView;

@end

@implementation VMRedPacketsDetailCell

+(instancetype)updateWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"VMRedPacketsDetailCellId";
    VMRedPacketsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VMRedPacketsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 初始化
        self.iconImageView =[[UIImageView alloc]init];
        self.descLable =[[UILabel alloc]init];
        self.startTimeLable =[[UILabel alloc]init];
        self.isDrawBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.isSpendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.lineView =[[UIView alloc]init];
        
        self.descLable.textColor =UIColorFromHexValue(0x333333);
        self.startTimeLable.textColor =UIColorFromHexValue(0x666666);
        
        self.descLable.font =[UIFont systemFontOfSize:15 *kAppScale];
        self.startTimeLable.font =[UIFont systemFontOfSize:13 *kAppScale];
        self.isDrawBtn.titleLabel.font =[UIFont systemFontOfSize:13 *kAppScale];
        self.isSpendBtn.titleLabel.font =[UIFont systemFontOfSize:13 *kAppScale];
        
        self.isDrawBtn.layer.cornerRadius =3 *kAppScale;
        self.isSpendBtn.layer.cornerRadius =3 *kAppScale;
        self.lineView.alpha =0.2;
        
        [self.isDrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.isSpendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


        // 设置frame
        CGFloat cellSpacing =10 *kAppScale;
        CGFloat isDrawBtnW =60 *kAppScale;
        CGFloat descLableH =20 *kAppScale;
        CGFloat iconImageViewWH =kVMRedPacketsDetailCellHeight -2 *cellSpacing;
        self.iconImageView.frame =CGRectMake(cellSpacing, cellSpacing, iconImageViewWH, iconImageViewWH);
        CGFloat descLableW =SCREEN_WIDTH - CGRectGetMaxX(self.iconImageView.frame) - 3 *cellSpacing -isDrawBtnW;
        self.descLable.frame =CGRectMake(CGRectGetMaxX(self.iconImageView.frame) +cellSpacing, cellSpacing, descLableW, descLableH);
          self.startTimeLable.frame =CGRectMake(CGRectGetMaxX(self.iconImageView.frame) +cellSpacing, CGRectGetMaxY(self.descLable.frame) +8 *kAppScale, descLableW, descLableH);
        CGFloat isDrawBtnX =SCREEN_WIDTH -cellSpacing -isDrawBtnW;
        self.isDrawBtn.frame =CGRectMake(isDrawBtnX, cellSpacing, isDrawBtnW, descLableH);
        self.isSpendBtn.frame =CGRectMake(isDrawBtnX, CGRectGetMaxY(self.isDrawBtn.frame) +8 *kAppScale, isDrawBtnW, descLableH);
        self.lineView.frame =CGRectMake(10 *kAppScale, kVMRedPacketsDetailCellHeight -1, SCREEN_WIDTH -2 *10 *kAppScale, 1);

        

        // 添加测试颜色
        self.backgroundColor =UIColorFromHexValue(0xfffce5);
        self.isDrawBtn.backgroundColor =UIColorFromHexValue(0xf40000);
        self.isSpendBtn.backgroundColor =UIColorFromHexValue(0x7fbe26);
        self.lineView.backgroundColor =UIColorFromHexValue(0x999999);

        
//        self.iconImageView.backgroundColor =[UIColor blueColor];
//        self.descLable.backgroundColor =[UIColor yellowColor];
//        self.startTimeLable.backgroundColor =[UIColor brownColor];
        // 添加到父View
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.descLable];
        [self.contentView addSubview:self.startTimeLable];
        [self.contentView addSubview:self.isDrawBtn];
        [self.contentView addSubview:self.isSpendBtn];
        [self.contentView addSubview:self.lineView];


        
    }
    return self;
}


-(void)setAllDrawModel:(VMAllDrawRedPacketsItemModel *)allDrawModel {
    _allDrawModel =allDrawModel;
    
    self.iconImageView.image =[UIImage imageNamed:allDrawModel.iconUrl];
    self.descLable.text =allDrawModel.advModel.advname;
    self.startTimeLable.text =allDrawModel.advModel.advtitle;
    [self.isDrawBtn setTitle:@"已领取" forState:UIControlStateNormal];
    if ([allDrawModel.status intValue] ==1) {
        [self.isSpendBtn setTitle:@"未消费" forState:UIControlStateNormal];
        self.isSpendBtn.backgroundColor =UIColorFromHexValue(0x7fbe26);
       
    }else {
        [self.isSpendBtn setTitle:@"已消费" forState:UIControlStateNormal];
        self.isSpendBtn.backgroundColor =UIColorFromHexValue(0x5a5a5a);
      
    }

}

@end
