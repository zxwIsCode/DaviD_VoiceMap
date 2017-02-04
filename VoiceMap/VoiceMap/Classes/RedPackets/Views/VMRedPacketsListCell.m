//
//  VMRedPacketsListCell.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/4.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsListCell.h"

@interface VMRedPacketsListCell ()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *descLable;

@property(nonatomic,strong)UILabel *remarksLable;

@property(nonatomic,strong)UILabel *startTimeLable;

@property(nonatomic,strong)UIView *lineView;

@end

@implementation VMRedPacketsListCell

+(instancetype)updateWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"VMRedPacketsListCellId";
    VMRedPacketsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[VMRedPacketsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 初始化
        
        self.iconImageView =[[UIImageView alloc]init];
        self.descLable =[[UILabel alloc]init];
        self.remarksLable =[[UILabel alloc]init];
        self.startTimeLable =[[UILabel alloc]init];
        self.lineView =[[UIView alloc]init];
        
        self.descLable.font =[UIFont systemFontOfSize:15 *kAppScale];
        self.remarksLable.font =[UIFont systemFontOfSize:13 *kAppScale];
        self.startTimeLable.font =[UIFont systemFontOfSize:13 *kAppScale];

        // 设置frame
        CGFloat cellSpacing =20 *kAppScale;
        CGFloat iconImageViewH = 52 *kAppScale;
        CGFloat iconImageViewY = (kVMRedPacketsListCellHeight -iconImageViewH) *0.5;
        self.iconImageView.frame =CGRectMake(cellSpacing, iconImageViewY, iconImageViewH *64/82.0, iconImageViewH);
        
        CGFloat descLableX =CGRectGetMaxX(self.iconImageView.frame) +10 *kAppScale;
        CGFloat descLableW =SCREEN_WIDTH - descLableX -cellSpacing;
        self.descLable.frame =CGRectMake(descLableX, CGRectGetMinY(self.iconImageView.frame) - 2*kAppScale, descLableW, 24 *kAppScale);
        self.remarksLable.frame =CGRectMake(descLableX, CGRectGetMaxY(self.descLable.frame), descLableW, 18 *kAppScale);
        self.startTimeLable.frame =CGRectMake(descLableX, CGRectGetMaxY(self.remarksLable.frame), descLableW, 18 *kAppScale);
        self.lineView.frame =CGRectMake(10 *kAppScale, kVMRedPacketsListCellHeight -1, SCREEN_WIDTH -2 *10 *kAppScale, 1);
        // 添加测试颜色
        
//        self.iconImageView.backgroundColor =[UIColor redColor];
        
//        self.descLable.backgroundColor =[UIColor blueColor];
//        self.remarksLable.backgroundColor =[UIColor yellowColor];
//        self.startTimeLable.backgroundColor =[UIColor brownColor];
        self.lineView.backgroundColor =[UIColor redColor];

        
        // 添加到父View
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.descLable];
        [self.contentView addSubview:self.remarksLable];
        [self.contentView addSubview:self.startTimeLable];
        [self.contentView addSubview:self.lineView];

        
    }
    return self;
}

-(void)setItemModel:(VMRedPacketsItemModel *)itemModel {
    
    _itemModel =itemModel;
    
    self.iconImageView.image =[UIImage imageNamed:itemModel.iconUrl];
    self.descLable.text =itemModel.descStr;
    self.remarksLable.text =itemModel.remarksStr;
    self.startTimeLable.text =itemModel.startTimeStr;
}


@end
