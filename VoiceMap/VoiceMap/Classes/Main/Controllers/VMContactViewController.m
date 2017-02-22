//
//  VMContactViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/21.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMContactViewController.h"

#define ScreenRect [[UIScreen mainScreen] bounds]
@interface VMContactViewController ()

@property (nonatomic, strong) VMVoiceViewController *voiceVC;
@property (nonatomic, strong) VMRedPacketsMainViewController *redPacketsVC;
@property (nonatomic, strong) NHSegmentView *segmentView;

@end

@implementation VMContactViewController

- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    ///switch View
    
    [self.view addSubview:self.segmentView];
    
    CGFloat originY = CGRectGetMaxY(self.segmentView.frame);
    self.pageContentFrame = CGRectMake(0,
                                       originY,
                                       rect.size.width,
                                       rect.size.height-originY);
    
}
- (void)viewDidLoad {
    
    self.title =@"红包列表";
    [super viewDidLoad];
    self.navigationItem.title = @"语音";
    self.segmentView.conditions = @[@"语音", @"红包"];
    self.contentControllers = (NSArray<NHPageContentViewControllerDelegate> *)[NSArray arrayWithObjects:self.voiceVC, self.redPacketsVC, nil];
    // Do any additional setup after loading the view.
}


#pragma mark Action Methods
- (void)changeViewController:(NHSegmentView *)segment
{
    self.currentIdx = segment.currentIndex;
}

- (void)didShowControllerAtIndex:(NSInteger)idx
{
    self.segmentView.currentIndex = idx;
    self.voiceVC.pageCount =idx;
    self.redPacketsVC.comeId =self.voiceVC.comeId;
    
}

-(CMNavType)getNavType {
    return CMNavTypeOnlyTitle;
}

#pragma mark - Setter & Getter

- (NHSegmentView *)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [[NHSegmentView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH , 0)];
//        _segmentView.hidden=YES;
//        _segmentView.layer.borderWidth =1;
//        _segmentView.layer.borderColor =UIColorFromHexValue(0xdcdcdc).CGColor;
        [_segmentView addTarget:self
                         action:@selector(changeViewController:)
               forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentView;
}

-(VMVoiceViewController *)voiceVC {
    if (!_voiceVC) {
        _voiceVC =[[VMVoiceViewController alloc]init];
        _voiceVC.nav =self.navigationController;
    }
    return _voiceVC;
}

-(VMRedPacketsMainViewController *)redPacketsVC {
    if (!_redPacketsVC) {
        _redPacketsVC =[[VMRedPacketsMainViewController alloc]init];
        _redPacketsVC.nav =self.navigationController;
    }
    return _redPacketsVC;
}

@end
