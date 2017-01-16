//
//  VMVoiceViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/16.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMVoiceViewController.h"
#import "ISRDataHelper.h"

@interface VMVoiceViewController ()<IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate>

@property(nonatomic,strong)UIImageView *backgroundView;

@property(nonatomic,strong)UIButton *voiceBtn;

@property(nonatomic,strong)UITextField *textFeild;

@property(nonatomic,strong)UILabel *textLable;

//@property(nonatomic,strong)NSMutableString *voiceStr;


// 语音识别方面
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象

@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象

@end

@implementation VMVoiceViewController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.voiceBtn];
    [self.backgroundView addSubview:self.textFeild];
    
    [self.backgroundView addSubview:self.textLable];
    
    // 添加手势
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopSayTapGesture:)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    self.uploader = [[IFlyDataUploader alloc] init];
    
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    
    //避免同时产生多个按钮事件
    [self setExclusiveTouchForButtons:self.view];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.backgroundView.frame =self.view.bounds;
    
    self.voiceBtn.bounds =CGRectMake(0, 0, 100, 100);
    self.voiceBtn.center =CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT *0.5);
    
    self.textFeild.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
    self.textFeild.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.voiceBtn.frame) +20 *kAppScale);
    
    self.textFeild.backgroundColor =[UIColor whiteColor];
    
    self.textLable.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
    self.textLable.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.textFeild.frame) +20 *kAppScale);
    
    self.textLable.backgroundColor =[UIColor whiteColor];

    
    [self initRecognizer];//初始化识别对象

}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_iflyRecognizerView cancel]; //取消识别
    [_iflyRecognizerView setDelegate:nil];
    [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
}

#pragma mark - Private Methods

/**
 设置识别参数
 ****/
-(void)initRecognizer {
    //初始化语音识别控件
//    [self.textFeild setText:@""];
//    [self.textFeild resignFirstResponder];
    
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;

    if (!_iflyRecognizerView) {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
        [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

    }
}

/**
 设置UIButton的ExclusiveTouch属性
 ****/
-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
        {
            [((UIButton *)button) setExclusiveTouch:YES];
        }
        else if ([button isKindOfClass:[UIView class]])
        {
            [self setExclusiveTouchForButtons:button];
        }
    }
}

#pragma mark - 继承父类
-(CMNavType)getNavType {
    return CMNavTypeNone;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}
#pragma mark - Action Methods
-(void)startSayMeClick:(UIButton *)button {
    button.selected =!button.selected;
    
    if (!_iflyRecognizerView) {
        [self initRecognizer];
    }
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    BOOL ret = [_iflyRecognizerView start];

}

-(void)stopSayTapGesture:(UITapGestureRecognizer *)gesture {
    DDLog(@"停止说话");
   
}

#pragma mark - IFlyRecognizerViewDelegate


/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast {
    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:result];
    
    if (isLast) {
        DDLog(@"语音结束为%@",result);
    }
    self.textFeild.text =[NSString stringWithFormat:@"%@",resultFromJson];
    self.textLable.text =[NSString stringWithFormat:@"%@",resultFromJson];

    DDLog(@"识别成功%@",result);
}

/*!
 *  识别结束回调
 *
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error {
    DDLog(@"识别失败%@",error);
//    self.textFeild.text =[NSString stringWithFormat:@"%@",result];

//    if (error.errorCode ==0) {// 听写正确
//        self.textFeild.text =[NSString stringWithFormat:@"%@",self.voiceStr];
//
//    }

}

#pragma mark - Setter & Getter

-(UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.backgroundColor =[UIColor redColor];
//        [_voiceBtn setImage:[UIImage imageNamed:@"icon_yuyin"] forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"点我说" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"开始说" forState:UIControlStateHighlighted];
        [_voiceBtn setTitle:@"开始说" forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(startSayMeClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _voiceBtn;
}

-(UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_beijing"]];
        _backgroundView.userInteractionEnabled =YES;
    }
    return _backgroundView;
}

-(UITextField *)textFeild {
    if (!_textFeild ) {
        _textFeild =[[UITextField alloc]init];
    }
    return _textFeild;
}

-(UILabel *)textLable {
    if (!_textLable) {
        _textLable =[[UILabel alloc]init];
    }
    return _textLable;
}

//-(NSMutableString *)voiceStr {
//    if (!_voiceStr) {
//        _voiceStr =[NSMutableString string];
//    }
//    return _voiceStr;
//}



@end
