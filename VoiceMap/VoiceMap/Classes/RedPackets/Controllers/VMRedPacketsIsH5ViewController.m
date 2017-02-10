//
//  VMRedPacketsIsH5ViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/2/9.
//  Copyright © 2017年 DaviD. All rights reserved.
//  红包详情界面（H5的界面）

#import "VMRedPacketsIsH5ViewController.h"

@interface VMRedPacketsIsH5ViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation VMRedPacketsIsH5ViewController

#pragma mark - Init

- (void)viewDidLoad {
    
    self.title =@"红包详情";
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self initWebView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.webView.backgroundColor =[UIColor redColor];
    
}

#pragma mark - Private Methods
-(void)initWebView {
    if (self.itemModel.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.itemModel.url]];
        [self.webView loadRequest:request];
    }else {
        [DisplayHelper displayWarningAlert:@"加载的Url网址为空,不能加载!"];
    }
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [[DisplayHelper shareDisplayHelper]showLoading:self.view noteText:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[DisplayHelper shareDisplayHelper]hideLoading:self.view];

    [DisplayHelper displaySuccessAlert:@"加载成功！"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[DisplayHelper shareDisplayHelper]hideLoading:self.view];

    [DisplayHelper displayWarningAlert:@"加载失败！"];

}
#pragma mark - Setter & Getter

-(UIWebView *)webView {
    if (!_webView) {
        _webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
        _webView.delegate =self;
    }
    return _webView;
}

@end
