//
//  CMMainTabBarViewController.m
//  ComeMoneyHere
//
//  Created by 李保东 on 16/11/15.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "CMMainTabBarViewController.h"
#import "CMNavViewController.h"
#import "VMRedPacketsViewController.h"
#import "VMVoiceViewController.h"

#import "CMCustomTabBar.h"

@interface CMMainTabBarViewController ()<CMCustomTabBarDelegate>

@property(nonatomic,strong)VMRedPacketsViewController *redPacketsVC;

@property(nonatomic,strong)VMVoiceViewController *voiceVC;

@property(nonatomic,strong)CMCustomTabBar *customTabBar;

@end

@implementation CMMainTabBarViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupCustomTabBar];
    
    [self setupAllChildViewControllers];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

#pragma mark - Private Methods


-(void)setupCustomTabBar {
    CMCustomTabBar *customTabBar =[[CMCustomTabBar alloc]init];
    CGFloat tabBarHeight =84 *kAppScale;
    customTabBar.frame =CGRectMake(0, 49.0 -tabBarHeight, SCREEN_WIDTH, tabBarHeight);
    [self.tabBar addSubview:customTabBar];
    self.customTabBar =customTabBar;
    self.customTabBar.delegate =self;
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.语音
    [self setupChildViewController:self.voiceVC title:@"语音" imageName:@"icon_shouye" selectedImageName:@"icon_shouyebian" andIndex:0];
    
    // 2.发红包
    [self setupChildViewController:self.redPacketsVC title:@"发红包" imageName:@"icon_renwu" selectedImageName:@"icon_renwubian" andIndex:1];
    
        
}

/**
 *  初始化一个子控制器
 
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName andIndex:(NSInteger)index
{
    // 1.设置控制器的属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];

    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2.包装一个导航控制器
    CMNavViewController *nav = [[CMNavViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 自定义TabBar的SubViews
    [self.customTabBar creatAllTabBarSubViews:childVc.tabBarItem andIndex:index];
    
    
}
#pragma mark - CMCustomTabBarDelegate

-(void)tabBar:(CMCustomTabBar *)tabBar didSelectVC:(NSInteger)lastIndex andNext:(NSInteger)nextIndex {
    self.selectedIndex =nextIndex -kTabBarButtonBaseTag;
}

#pragma mark - Setter & Getter
-(VMRedPacketsViewController *)redPacketsVC {
    if (!_redPacketsVC) {
        _redPacketsVC =[[VMRedPacketsViewController alloc]init];
    }
    return _redPacketsVC;
}

-(VMVoiceViewController *)voiceVC {
    if (!_voiceVC) {
        _voiceVC =[[VMVoiceViewController alloc]init];
    }
    return _voiceVC;
}

@end
