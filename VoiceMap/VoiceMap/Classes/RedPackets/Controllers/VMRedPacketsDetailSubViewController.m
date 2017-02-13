//
//  VMRedPacketsDetailSubViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/10.
//  Copyright © 2017年 DaviD. All rights reserved.
//  红包未消费详情展示（详情中的详情）

#import "VMRedPacketsDetailSubViewController.h"

@interface VMRedPacketsDetailSubViewController ()

@end

@implementation VMRedPacketsDetailSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navigationLeftButtonClick:(id)sender {
    DDLog(@"count =%ld",self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count ==3 ) {
        UIViewController *vc =self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:vc animated:YES];
        
    }
}



@end
