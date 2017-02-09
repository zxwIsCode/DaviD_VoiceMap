//
//  VMRedPacketsDetailHeaderView.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/5.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMRedPacketsDetailHeaderView.h"
#import "FALRButton.h"
#import "TYAttributedLabel.h"
@interface VMRedPacketsDetailHeaderView ()



@property(nonatomic,strong)UILabel *textViewLable;


@property(nonatomic,strong)UIView *bigLineView;

@end
@implementation VMRedPacketsDetailHeaderView

+(instancetype)HeaderView {
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        // 初始化

        self.btnSuperView =[VMRedPacketsDetailCommonBtnSuperView redPacketsFouctionBtn];
        self.bigLineView =[[UIView alloc]init];
        
        
        
        
        // 设置frame
        CGFloat superViewX =10 *kAppScale;

        self.textViewLable =[[UILabel alloc]init];
        self.textViewLable.numberOfLines =0;
        self.textViewLable.font =[UIFont systemFontOfSize:13 *kAppScale];
        self.textViewLable.textColor =UIColorFromHexValue(0x666666);


        
        
//        self.textView.frame =CGRectMake(superViewX, CGRectGetMaxY(self.smallLineView.frame) +10 *kAppScale, SCREEN_WIDTH -2 *superViewX, 160 *kAppScale);
        
        
        
        // 测试颜色
//        self.textViewLable.backgroundColor =[UIColor redColor];
//        self.btnSuperView.backgroundColor =[UIColor brownColor];
        
        self.backgroundColor =UIColorFromHexValue(0xfffce5);
        self.bigLineView.backgroundColor =UIColorFromHexValue(0xffc07d);
        
        // 添加到父View上

        [self addSubview:self.textViewLable];
        [self addSubview:self.btnSuperView];
        [self addSubview:self.bigLineView];

    }
    return self;
}
-(void)setItemModel:(VMRedPacketsItemModel *)itemModel {
    _itemModel =itemModel;
    

    self.textViewLable.text =itemModel.redPacketsDetailStr;
    
//    self.textViewLable =[[TYAttributedLabel alloc]initWithFrame:CGRectMake(superViewX, CGRectGetMaxY(self.smallLineView.frame) +10 *kAppScale, SCREEN_WIDTH -2 *superViewX, 160 *kAppScale)];
    CGFloat superViewX =10 *kAppScale;
    CGFloat detailHeaderViewH ;
    CGFloat textViewLableH;
    if (itemModel.redPacketsDetailStr) { // 有值
        CGFloat textViewLableW = SCREEN_WIDTH  -2 *superViewX;
        CGSize textViewLableSize = CGSizeMake(textViewLableW, MAXFLOAT);
        NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:13 *kAppScale ]};
        CGRect textViewLableFrame =[itemModel.redPacketsDetailStr boundingRectWithSize:textViewLableSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        textViewLableH =textViewLableFrame.size.height;
        detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight +textViewLableH -kVMRedPacketsDetailHeaderView_TextViewLableH;
        if (textViewLableH <kVMRedPacketsDetailHeaderView_TextViewLableH) { // //如果详情高度不够最小间距的话，就按最小间距处理
            textViewLableH =kVMRedPacketsDetailHeaderView_TextViewLableH;
            detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight;
        }
        self.textViewLable.frame = CGRectMake(superViewX, 5 *kAppScale, SCREEN_WIDTH -2 *superViewX, textViewLableH);
    }else { // 无值
        textViewLableH =kVMRedPacketsDetailHeaderView_TextViewLableH;
        detailHeaderViewH = kVMRedPacketsDetailHeaderViewHeight;
       self.textViewLable.frame = CGRectMake(superViewX, 5 *kAppScale, SCREEN_WIDTH -2 *superViewX, textViewLableH);
    }
    
    self.btnSuperView.frame =CGRectMake(0, CGRectGetMaxY(self.textViewLable.frame) +10 *kAppScale, SCREEN_WIDTH,kVMRedPacketsDetailCommonBtnSuperViewHeight);
    self.bigLineView.frame =CGRectMake(0, detailHeaderViewH -1, SCREEN_WIDTH, 1);
    
    self.btnSuperView.itemModel =itemModel;
    
}

@end
