//
//  AppDelegate.m
//  ComeMoneyHere
//
//  Created by 李保东 on 16/11/14.
//  Copyright © 2016年 李保东. All rights reserved.
//

#import "AppDelegate.h"
#import "CMMainTabBarViewController.h"
#import "CMNewFetureViewController.h"


#define IsFirstLaunch @"CFBundleVersion"


@interface AppDelegate ()



@end

@implementation AppDelegate

#pragma mark - UIApplication Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UINavigationBar appearance]setBarTintColor:RGBCOLOR(129, 188, 53)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self initRootViewController];
    [self.window makeKeyAndVisible];

    
    [self initKeDaVoice];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"deviceToken=====%@",deviceToken);
    

}


-(void)initKeDaVoice {
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
#warning 上线就把log开关关了
//    [IFlySetting showLogcat:NO];

    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
#pragma mark - Private Methods
- (void)initRootViewController
{
    self.window.rootViewController =[[CMMainTabBarViewController alloc]init];

}






@end
