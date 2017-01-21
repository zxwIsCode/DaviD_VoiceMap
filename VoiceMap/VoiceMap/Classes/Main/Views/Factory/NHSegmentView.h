//
//  GWSegmentView.h
//  GowildXB
//
//  Created by Charse on 16/7/23.
//  Copyright © 2016年 Shenzhen Gowild Robotics Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHSegmentView : UIControl
{
    BOOL _valueChange;
    
    NSInteger _touchBeganIndex;
    UIView *_lineView;
}

@property (nonatomic, strong) NSArray *conditions;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL showSpecLine;
@property (nonatomic, strong) UIFont *titleFont;

@end
