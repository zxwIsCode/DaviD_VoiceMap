//
//  VMVoiceViewController.m
//  VoiceMap
//
//  Created by 李保东 on 17/1/16.
//  Copyright © 2017年 DaviD. All rights reserved.
//

#import "VMVoiceViewController.h"
#import "ISRDataHelper.h"
#import "PcmPlayer.h"
#import "TTSConfig.h"
#import "VMUploadModel.h"
#import "VMVoiceItem.h"
#import "MJRefresh.h"

#import "LGAudioPlayer.h"
#import "VMVoiceMapHelper.h"

#import <CoreLocation/CoreLocation.h>

#define kVMVoiceVCCellId @"kVMVoiceVCCellId"



#define kTableViewHeight 44 *kAppScale

//#define kTableViewHeight 360 *kAppScale



typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2, //高异常分析需要的级别
    Paused              = 4,
};
@interface VMVoiceViewController ()<IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,LGAudioPlayerDelegate>

@property(nonatomic,strong)UIImageView *backgroundView;

@property(nonatomic,strong)UIButton *voiceBtn;

@property(nonatomic,strong)UITextField *textFeild;

@property(nonatomic,strong)UILabel *textLable;

@property(nonatomic,strong)UIButton *startBtn;

@property(nonatomic,strong)UITableView *tableView;


@property(nonatomic,strong)NSMutableString *voiceStr;

@property(nonatomic,strong)VMUploadModel *voiceModel;

@property(nonatomic,strong)NSMutableArray *allDataSource;

// 当前播放的数组的下标
@property(nonatomic,assign)NSInteger nowIndex;
// 每次请求数据的总个数
@property(nonatomic,assign)NSInteger requestTotolCount;
// 每次请求数据在总个数的第几个
@property(nonatomic,assign)NSInteger nextCount;


// 语音解析方面
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
//@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象

// 语音合成方面
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;

@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, assign) Status state;

// uri 合成地址（作为临时的，其他语音会覆盖这个地址）
@property (nonatomic, strong) NSString *uriPath;



// 定位方面
@property(nonatomic,strong)UILabel *placeLable;
// 定位类
@property (nonatomic,strong) CLLocationManager *manager;


@end

@implementation VMVoiceViewController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DDLog(@"%@",[VMVoiceMapHelper Wechat]);
    
    self.nowIndex =0;
    self.requestTotolCount =0;
    self.nextCount =0;
    
    [LGAudioPlayer sharePlayer].delegate = self;
    
//    self.allDataSource =[@[@"测试1你见过我么",@"测试2你吃的是什么",@"测试3我现在在北京",@"测试4你去过哪里",@"测试5你就是个二货"] mutableCopy];
    
    [self initAllDataSource];
    [self.view addSubview:self.backgroundView];
    
//    [self.backgroundView addSubview:self.startBtn];
    
    [self.view addSubview:self.tableView];
//    [self creatMJRefreshFooter];
    
    [self.backgroundView addSubview:self.voiceBtn];
    
//    [self.backgroundView addSubview:self.textFeild];
//    [self.backgroundView addSubview:self.textLable];
    
//    [self.backgroundView addSubview:self.placeLable];
    
    
    // 添加手势
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopSayTapGesture:)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
//    self.uploader = [[IFlyDataUploader alloc] init];
    
    //demo录音文件保存路径
    
    //     使用-(void)synthesize:(NSString *)text toUri:(NSString*)uri接口时， uri 需设置为保存音频的完整路径
    //     若uri设为nil,则默认的音频保存在library/cache下
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //uri合成路径设置
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //pcm播放器初始化
    _audioPlayer = [[PcmPlayer alloc] init];
    
    //避免同时产生多个按钮事件
    [self setExclusiveTouchForButtons:self.view];
    
    [self initCLLocationManger];

}
-(void)viewWillAppear:(BOOL)animated {
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [super viewWillAppear:animated];
    
//    self.backgroundView.frame =self.view.bounds;
//    
//    self.startBtn.bounds =CGRectMake(0, 0, 100, 100);
//    self.startBtn.center =CGPointMake(SCREEN_WIDTH *0.5, 120 *kAppScale);
//    
//    CGFloat voiceBtnWidth =300 *kAppScale ;
//    self.voiceBtn.bounds =CGRectMake(0, 0, voiceBtnWidth, voiceBtnWidth *412/578.0);
//    self.voiceBtn.center =CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT -180);
//    
//    self.textFeild.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
//    self.textFeild.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.startBtn.frame) +20 *kAppScale);
//    
//    self.textFeild.backgroundColor =[UIColor whiteColor];
//    
//    self.textLable.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
//    self.textLable.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.textFeild.frame) +20 *kAppScale);
//    
//    self.placeLable.frame =CGRectMake(0, 0, 200, 40);
//    
//    // 测试颜色
//    self.textLable.backgroundColor =[UIColor whiteColor];
////    self.tableView.backgroundColor =[UIColor brownColor];
//    
//    [self initRecognizer];//初始化识别对象
//    
//    [self initSynthesizer];


}
-(void)viewWillDisappear:(BOOL)animated {
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [super viewWillDisappear:animated];
    
    [_iflyRecognizerView cancel]; //取消识别
    [_iflyRecognizerView setDelegate:nil];
    [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    // 停止语音合成的播放
    [self stopPlayVoice];
    // 停止播放
    [[LGAudioPlayer sharePlayer]stopAudioPlayer];
}
-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [super viewDidAppear:animated];
    
    self.backgroundView.frame =self.view.bounds;
    
    self.startBtn.bounds =CGRectMake(0, 0, 100, 100);
    self.startBtn.center =CGPointMake(SCREEN_WIDTH *0.5, 120 *kAppScale);
    
    CGFloat voiceBtnWidth =300 *kAppScale ;
    self.voiceBtn.bounds =CGRectMake(0, 0, voiceBtnWidth, voiceBtnWidth *412/578.0);
    self.voiceBtn.center =CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT -180);
    
    self.textFeild.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
    self.textFeild.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.startBtn.frame) +20 *kAppScale);
    
    self.textFeild.backgroundColor =[UIColor whiteColor];
    
    self.textLable.bounds =CGRectMake(0, 0, SCREEN_WIDTH -60 *kAppScale, 24 *kAppScale);
    self.textLable.center =CGPointMake(SCREEN_WIDTH *0.5, CGRectGetMaxY(self.textFeild.frame) +20 *kAppScale);
    
    self.placeLable.frame =CGRectMake(0, 0, 200, 40);
    
    // 测试颜色
    self.textLable.backgroundColor =[UIColor whiteColor];
    //    self.tableView.backgroundColor =[UIColor brownColor];
    
    [self initRecognizer];//初始化识别对象
    
    [self initSynthesizer];

}
-(void)viewDidDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [super viewDidDisappear:animated];
}
#pragma mark - Private Methods

-(void)creatMJRefreshFooter {
    
    WS(ws);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws initAllDataSource];
    }];
    
//    self.tableView.mj_footer.backgroundColor =[UIColor redColor];
}
// 停止语音合成的播放
-(void)stopPlayVoice {
    [_iFlySpeechSynthesizer stopSpeaking];
    [_audioPlayer stop];
    _iFlySpeechSynthesizer.delegate = nil;
}
// 播放对应的数据
-(void)playNextDatas {
    
    
    if (self.nowIndex +1 <self.allDataSource.count) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:self.nowIndex +1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        VMVoiceItem *voiceItem =self.allDataSource[self.nowIndex +1];
        // index传的是下标
//#warning 播放下一条数据暂时屏蔽了
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:voiceItem.audio atIndex:self.nowIndex +1];

//                [self startPlayingText:self.allDataSource[self.nowIndex +1] and:self.nowIndex +2];
    }
    
}
-(void)initAllDataSource {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSMutableArray *tempArr =[NSMutableArray array];
//        for (int index =0; index <2; index ++) {
//            VMVoiceItem *voiceItem =[[VMVoiceItem alloc]init];
//            voiceItem.text =[NSString stringWithFormat:@"你大爷来了%d",index +1];
//            [tempArr addObject:voiceItem];
//        }
//        self.requestTotolCount = tempArr.count;
//        self.nowIndex =self.allDataSource.count -1;
//        self.nextCount =0;
//        [self.allDataSource addObjectsFromArray:tempArr];
//        [self.tableView reloadData];
//        // 播放对应的数据
//        [self playNextDatas];
//    });
//    
//    
//    return ;
    
    CMHttpRequestModel *paramsModel =[[CMHttpRequestModel alloc]init];
    
    paramsModel.appendUrl =kMainGetVoiceList;
    
    // 包装参数设置
    WS(ws);
    [[DisplayHelper shareDisplayHelper]showLoading:self.view noteText:@"数据再次加载中..."];

    paramsModel.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.state ==CMReponseCodeState_Success) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
                NSArray *listArr =(NSArray *)result.data;
                if (listArr.count) { // 请求拥有数据
                    NSMutableArray *tempArr =[NSMutableArray array];
                    for (NSDictionary *voiceDic in listArr) {
                        VMVoiceItem *voiceItem =[VMVoiceItem updateWithDic:voiceDic];
                        [tempArr addObject:voiceItem];
                        
#warning 加数据到本地开始
                        VMVoiceItem *mapItem =  [VMVoiceMapHelper Wechat];
                        if ([mapItem.audio isEqualToString:voiceItem.audio] && mapItem.audio.length !=0) {
                            [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];

                            [DisplayHelper displayWarningAlert:@"请求成功,但没有最新数据哦!"];
                            return ;
                        }
                        [VMVoiceMapHelper saveWechatAccount:voiceItem];
#warning 加数据到本地结束

                    }
                    ws.requestTotolCount = tempArr.count;
                    ws.nextCount =0;
                    ws.nowIndex =ws.allDataSource.count -1;
//                    if (ws.allDataSource.count ==0) { // 第一次播放的话，就从0开始
//                        ws.nowIndex =0;
//                    }else {
//                    // 重置最后一次播放的数组的下标为上一次最后一个元素
//                    ws.nowIndex =ws.allDataSource.count -1;
//                    }
                    // 添加为新数组
                    [ws.allDataSource addObjectsFromArray:tempArr];

                    [ws.tableView reloadData];
                    // 播放对应的数据
                    [ws playNextDatas];
                    
                    
                }
                else { // 请求没有数据
                    [DisplayHelper displayWarningAlert:@"请求成功,但没有数据哦!"];
                }
                
            }else {// 失败,弹框提示
                
                DDLog(@"%@",result.error);
                [DisplayHelper displayWarningAlert:@"请求成功,但没有数据哦!"];

            }
        }else {
            [DisplayHelper displaySuccessAlert:@"获得列表成功,但是服务端没有返回数据哦!"];
            
        }
        // 停止刷新
        [ws.tableView.mj_footer endRefreshing];
        
        [[DisplayHelper shareDisplayHelper]hideLoading:ws.view];

        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:paramsModel];
}
-(void)initCLLocationManger {
    
    self.manager.delegate = self;
    // 请求授权，记得修改的infoplist，NSLocationAlwaysUsageDescription（描述）
    [self.manager requestAlwaysAuthorization];
}

//  设置合成参数
- (void)initSynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
//#warning 语速给设置正常化
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
//    [_iFlySpeechSynthesizer setParameter:@"100" forKey:[IFlySpeechConstant SPEED]];

    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
}

/**
 设置识别参数
 ****/
-(void)initRecognizer {
    
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
// 开始播放对应的文字信息 ,暂时无用了

// voiceItem的数据源
// index 播放的第几个，即下标加1
-(void)startPlayingText:(VMVoiceItem *)voiceItem and:(NSInteger )index {
    
    if ([voiceItem.text isKindOfClass:[NSNull class]]) { // 请求第四条数据为空的情况测试
//#warning 请求第四条数据为空的情况测试
        _iFlySpeechSynthesizer.delegate = self;
//        NSString *speakStr =[NSString stringWithFormat:@"播放第%ld条数据为:无效的文本信息",index];
        [_iFlySpeechSynthesizer startSpeaking:@"播放数据为:无效的文本信息"];
        if (_iFlySpeechSynthesizer.isSpeaking) {
            _state = Playing;
        }
        DDLog(@"无效的文本信息");
        return;
    }
    if ([voiceItem.text isEqualToString:@""]) {
        DDLog(@"无效的文本信息");
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    [[DisplayHelper shareDisplayHelper]showLoading:self.view noteText:@"合成中..."];
    
    _iFlySpeechSynthesizer.delegate = self;
    
//    NSString *speakStr =[NSString stringWithFormat:@"播放第%ld条数据为:%@",index,voiceItem.text];
    NSString *speakStr =[NSString stringWithFormat:@"播放数据为:%@",voiceItem.text];

    [_iFlySpeechSynthesizer startSpeaking:speakStr];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}
// 开始uri合成，但是不播放
-(void)startUriSyntheticVoice {

    if ([self.textFeild.text isEqualToString:@""]) {
        DDLog(@"无效的文本信息");
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    NSString* str= self.textFeild.text;
    
    
    [_iFlySpeechSynthesizer synthesize:str toUri:_uriPath];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
    self.voiceModel.audio =_uriPath;

}
-(void)reUploadToService {
    CMHttpRequestModel *model =[[CMHttpRequestModel alloc]init];
    
    model.appendUrl =kReUploadVoiceAndLocation;
    
    // 包装参数设置
    
    DDLog(@"uuid =%@",self.voiceModel.deviceToken);
    [model.paramDic setObject:self.voiceModel.deviceToken forKey:@"user_id"];
    [model.paramDic setObject:@(1) forKey:@"contentType"];
    [model.paramDic setObject:@(2) forKey:@"regionid"];
    [model.paramDic setObject:self.voiceModel.text forKey:@"text"];
    [model.paramDic setObject:self.voiceModel.audio forKey:@"audio"];
    
    // 位置信息有关
    [model.paramDic setObject:self.voiceModel.detailAddress forKey:@"location"];
    [model.paramDic setObject:[NSString stringWithFormat:@"%f",self.voiceModel.nowLocation.coordinate.longitude] forKey:@"longitude"];
    [model.paramDic setObject:[NSString stringWithFormat:@"%f",self.voiceModel.nowLocation.coordinate.latitude]  forKey:@"latitude"];
    
    [model.paramDic setObject:@"" forKey:@"image"];

    model.callback =^(CMHttpResponseModel *result, NSError *error) {
        
        if (result) {
            if (result.state ==CMReponseCodeState_Success) {// 成功,做自己的逻辑
                DDLog(@"%@",result.data);
                [DisplayHelper displaySuccessAlert:@"上传语音成功!"];
                
            }else {// 失败,弹框提示
                //            mAlertView(@"提示", result.alertMsg);
                //            [CMHttpStateTools showHtttpStateView:result.state];
                
                DDLog(@"%@",result.error);
            }
        }else {
            [DisplayHelper displaySuccessAlert:@"上传服务端成功,但是服务端没有返回数据哦!"];

        }
        
        
    };
    [[CMHTTPSessionManager sharedHttpSessionManager] sendHttpRequestParam:model];

}
- (void)playUriAudio
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    DDLog(@"uri合成完毕，即将开始播放");
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:_uriPath sampleRate:[instance.sampleRate integerValue]];
    [_audioPlayer play];
    
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
// 开始获得语音
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
     [_iflyRecognizerView start];

}
// Uri 语音合成
-(void)startSyntheticVoiceClick:(UIButton *)button {
    button.selected =!button.selected;
    if ([self.textFeild.text isEqualToString:@""]) {
        DDLog(@"无效的文本信息");
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    NSString* str= self.textFeild.text;
    
    
    [_iFlySpeechSynthesizer synthesize:str toUri:_uriPath];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
    
}

-(void)stopSayTapGesture:(UITapGestureRecognizer *)gesture {
    DDLog(@"停止说话");
}

#pragma mark - CLLocationManagerDelegate

/** 定位服务状态改变时调用*/
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            DDLog(@"用户还未决定授权");
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [manager requestAlwaysAuthorization];
            }
            break;
        }
        case kCLAuthorizationStatusRestricted: {
            DDLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied: {
            
            if ([CLLocationManager locationServicesEnabled]) {
                DDLog(@"定位服务开启,被拒绝");
            }
            else{
                DDLog(@"定位服务关闭,不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways: {
            DDLog(@"获得前后台授权");
            [self startLocation];
            
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            DDLog(@"获得前后台授权");
            [self startLocation];
            break;
        }
    }
}

-(void)startLocation {
    [self.manager startUpdatingLocation];
    
    //设置精确度
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    //设置过滤距离
    self.manager.distanceFilter = 1000;
    
    //开始定位方向
    [self.manager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //获取当前位置
    CLLocation *location = manager.location;
    
    // 地址的编码通过经纬度得到具体的地址
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        if (placemark.location) {
            self.voiceModel.nowLocation =placemark.location;

        }
        
        //        //打印地址
                DDLog(@"dic =%@",placemark.addressDictionary[@"City"]);
        NSString *citys = placemark.addressDictionary[@"City"];
        NSDictionary *addressDic = placemark.addressDictionary;
        if ([addressDic.allKeys containsObject:@"FormattedAddressLines"]) {
            NSArray *array =addressDic[@"FormattedAddressLines"];
            if (array.count) {
                NSString *address =[array firstObject];
                if (address.length) {
                    self.voiceModel.detailAddress =address;
                }else {
                    self.voiceModel.detailAddress =citys;
                }
            }
        }
        
        
        NSString *city =placemark.locality;
        if (city.length) {
            NSString *cityStr =[city substringToIndex:city.length -1];
            self.placeLable.text =cityStr;
        
        }
        
    }];
    
    //停止定位
    [self.manager stopUpdatingLocation];
    
}

#pragma mark - LGAudioPlayerDelegate
//LGAudioPlayerStateNormal = 0,/**< 未播放状态 */
//LGAudioPlayerStatePlaying = 2,/**< 正在播放 */
//LGAudioPlayerStateCancel = 3,/**< 播放被取消 */
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    
    DDLog(@"audioPlayerState = %ld index =%lu",audioPlayerState,index);

    if (audioPlayerState == LGAudioPlayerStateCancel) {
        //        text = @"合成结束";
        self.nowIndex ++;
        self.nextCount ++;
        if (self.nextCount ==self.requestTotolCount && self.requestTotolCount !=0) { // 本次请求的列表播放完毕
            
            //            self.nextCount =1;
            // 执行下次请求
            [self initAllDataSource];
            return ;
        }
        
        [self playNextDatas];
        
    }
    
}

#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{
    [[DisplayHelper shareDisplayHelper]hideLoading:self.view];
    if (_state  != Playing) {
        DDLog(@"开始播放");
    }
    _state = Playing;
}

/**
 缓冲进度回调
 
 progress 缓冲进度
 msg 附加信息
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}


/**
 播放进度回调
 
 progress 缓冲进度
 
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    NSLog(@"speak progress %2d%%.", progress);
}


/**
 合成暂停回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakPaused
{
    DDLog(@"播放暂停");
    
    _state = Paused;
    if (self.nowIndex >0) { // 播放暂停的话，重新播放当前的数据
        self.nowIndex --;
        self.nextCount --;
    }
    [self playNextDatas];
    _state = Playing;

}

/**
 恢复合成回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakResumed
{
    DDLog(@"播放继续");
    _state = Playing;
}

/**
 合成结束（完成）回调
 
 对uri合成添加播放的功能
 ****/
- (void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s,error=%d",__func__,error.errorCode);
    
    if (error.errorCode != 0) {
        DDLog(@"uri合成回调播放出错");

        return;
    }
    NSString *text ;
    if (error.errorCode == 0) {
//        text = @"合成结束";
        self.nowIndex ++;
        self.nextCount ++;
        if (self.nextCount ==self.requestTotolCount && self.requestTotolCount !=0) { // 本次请求的列表播放完毕
            
//            self.nextCount =1;
            // 执行下次请求
            [self initAllDataSource];
            return ;
        }
       
        [self playNextDatas];
        
    }else {
        self.nowIndex --;

        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
    _state = NotStart;
}

#pragma mark - IFlyRecognizerViewDelegate

/*!
 *  回调返回识别结果
 *
 *  @param resultArray 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，sc为识别结果的置信度
 *  @param isLast      -[out] 是否最后一个结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast {
    
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [self.voiceStr appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:self.voiceStr];
    
    
    if ([resultFromJson isEqualToString:@"。"] ||[resultFromJson isEqualToString:@"?"] ||[resultFromJson isEqualToString:@"!"] || (resultFromJson.length == 0)) { //声音出错的情况（还未说完或者特殊字符）
        
    }else { // 可识别的声音
        
        self.textFeild.text =resultFromJson;
        self.textLable.text =resultFromJson;
        self.voiceModel.text =self.textFeild.text;
        DDLog(@"textFeild = %@",self.textFeild.text);
        
        
//        // 包装成Model
//        VMVoiceItem *voiceItem = [[VMVoiceItem alloc]init];
//        voiceItem.audio =@"dfdsflk";
//        voiceItem.text =self.voiceModel.text;
//        // 添加到数据源，刷新表格
//        [self.allDataSource addObject:voiceItem];
//        [self.tableView reloadData];
        
        //开始自己的业务：
        
        //1.uri合成但不播放
        [self startUriSyntheticVoice];
        //2. 上传到我的后台
        [self reUploadToService];
        
        
    }
//    self.textFeild.text =resultFromJson;
//    self.textLable.text =resultFromJson;
    
    if (isLast) {
        [ISRDataHelper stringFromJson:self.voiceStr];
        DDLog(@"语音结束为%@",self.voiceStr);
        _voiceStr =nil;
    }
    DDLog(@"识别成功%@",self.voiceStr);
}

/*!
 *  识别结束回调
 *
 *  @param error 识别结束错误码
 */
- (void)onError: (IFlySpeechError *) error {
    DDLog(@"识别失败%@",error);
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =kVMVoiceVCCellId;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    if (indexPath.row <self.allDataSource.count) {
        cell.backgroundColor =[UIColor clearColor];
//        cell.textLabel.text =[NSString stringWithFormat:@"开发中第%ld条",indexPath.row +1];
        VMVoiceItem *voiceItem =self.allDataSource[indexPath.row];
        if (![voiceItem.text isKindOfClass:[NSNull class]]) {
            cell.textLabel.text =voiceItem.text;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if (indexPath.row <self.allDataSource.count) {
//        VMVoiceItem *voiceItem =self.allDataSource[indexPath.row];
//
//        [[LGAudioPlayer sharePlayer] playAudioWithURLString:voiceItem.audio atIndex:self.nowIndex +1];
//
////        [self startPlayingText:self.allDataSource[indexPath.row] and:self.allDataSource.count];
//    }
    
}

#pragma mark - Setter & Getter

-(UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_yuyin"] forState:UIControlStateNormal];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_yuyin"] forState:UIControlStateHighlighted];
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_yuyin"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(startSayMeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}
-(UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.backgroundColor =[UIColor redColor];
        [_startBtn setTitle:@"开始说" forState:UIControlStateNormal];
        [_startBtn setTitle:@"停止说" forState:UIControlStateHighlighted];
        [_startBtn setTitle:@"停止说" forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(startSyntheticVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
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
-(UILabel *)placeLable {
    if (!_placeLable) {
        _placeLable =[[UILabel alloc]init];
        _placeLable.text =@"当前位置";
        _placeLable.backgroundColor =[UIColor redColor];
        _placeLable.textAlignment =NSTextAlignmentCenter;
    }
    return _placeLable;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kTableViewHeight)];
        _tableView.backgroundColor =[UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.userInteractionEnabled =NO;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

-(CLLocationManager *)manager {
    if (!_manager) {
        _manager =[[CLLocationManager alloc]init];
    }
    return _manager;
}
-(NSMutableString *)voiceStr {
    if (!_voiceStr) {
        _voiceStr =[NSMutableString string];
    }
    return _voiceStr;
}

-(VMUploadModel *)voiceModel {
    if (!_voiceModel) {
        _voiceModel =[[VMUploadModel alloc]init];
    }
    return _voiceModel;
}
-(NSMutableArray *)allDataSource {
    if (!_allDataSource) {
        _allDataSource =[NSMutableArray array];
    }
    return _allDataSource;
}

-(void)setPageCount:(NSInteger)pageCount {
    _pageCount =pageCount;
    if (pageCount) {
        [[LGAudioPlayer sharePlayer]stopAudioPlayer];
    }
}

@end
