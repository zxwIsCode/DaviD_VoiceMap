//
//  CMHttpResponseModel.m
//  ComeMoneyHere
//
//  Created by 李保东 on 16/11/15.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "CMHttpResponseModel.h"

@implementation CMHttpResponseModel

@synthesize error = _error;
@synthesize code = _code;
@synthesize data = _data;
//@synthesize maxid = _maxid;


-(id)initWithData:(id)responseData err:(NSError *)err {
    if (self =[super init]) {
        DDLog(@"返回数据为：responseData = %@ err =%@",responseData,err);
        if (err) {// 有错误的处理
//            _isSucc =NO;
            _state =CMReponseCodeState_Faild;
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                NSNumber *code = [responseData objectForKey:@"ret"];
                NSString *errorMsg =[responseData objectForKey:@"message"];
                _error = [NSError errorWithDomain:errorMsg
                                             code:code.integerValue
                                         userInfo:nil];
            }
            
        }else {
            if ([responseData isKindOfClass:[NSDictionary class]]) {// 正常返回数据处理
                NSNumber *codeNum =responseData[@"ret"];
                
                id data = [responseData valueForKey:@"info"];
//                NSNumber *maxIds =responseData[@"maxid"];
//#warning app红包部分返回参数不同的情况单独处理开始
                if (![codeNum intValue]) {
                    codeNum =responseData[@"tag"];
                    if (![codeNum intValue]) {// 还为空，说明是程序入口判断情况
                        codeNum =responseData[@"code"];
                    }
                    _code = [codeNum integerValue];
                }
                if (!data) {
                     data = [responseData valueForKey:@"advs"];
                }
                
//#warning app红包部分返回参数不同的情况单独处理结束

                if ([codeNum intValue] ==100) {
//                    _isSucc =YES;
                    _state =CMReponseCodeState_Success;
                    _data =data;
//                    _maxid=[maxIds integerValue];

                }else  {
                    _state =CMReponseCodeState_NoData;
                    _data =data;
                }
//                else if ([codeNum intValue] ==205) {
//                    _state =CMReponseCodeState_NoParams;
//                    _data =data;
//                }
                
                NSString *alertMsg =[responseData objectForKey:@"message"];
                _alertMsg =alertMsg;

            }else {// 服务器返回数据问题
                
//                _isSucc = NO;
                _state =CMReponseCodeState_Faild;

                _error = [NSError errorWithDomain:@"服务器返回数据结构异常"
                                             code:-100
                                         userInfo:nil];
                
            }
            
        }
    }
    return self;
}
@end
