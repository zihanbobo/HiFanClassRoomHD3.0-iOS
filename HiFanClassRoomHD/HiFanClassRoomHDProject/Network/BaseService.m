//
//  BaseService.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 16/7/29.
//  Copyright © 2016年 Chn. All rights reserved.
//

#import "BaseService.h"

@interface BaseService()
@property (nonatomic, assign) BOOL isShowMBP;
@end

@implementation BaseService

+ (instancetype)share {
    static BaseService *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

/**对网络请求进行单例处理**/
+ (AFHTTPSessionManager *)sharedHTTPSession {
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 10.f;
        
    });
    return manager;
}


- (instancetype)init {
    if (self = [super init]) {
        
        HF_Singleton *singleton = [HF_Singleton sharedSingleton];
        
        // 1. 获得网络监控管理者
        AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
        
        // 2. 设置网络状态改变后的处理
        [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            // 当网络状态改变了, 就会调用这个block
            switch (status) {
                case AFNetworkReachabilityStatusUnknown: // 未知网络
                    self.netWorkStaus = AFNetworkReachabilityStatusUnknown;
                    singleton.netStatus = NO;
                    
                    [self xc_reloadBaseURL];
#ifdef DEBUG
                    [self showExceptionDialog:@"未知网络"];
#endif
                    
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                {
                    self.netWorkStaus = AFNetworkReachabilityStatusNotReachable;
                    singleton.netStatus = NO;
                    [self showExceptionDialog:@"没有网络(断网)"];
                    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"没有网络" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertV show];
#pragma clang diagnostic pop
                    
                }
                    
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                    self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWWAN;
                    singleton.netStatus = YES;
                    
                    [self xc_reloadBaseURL];
                    
#ifdef DEBUG
                    [self showExceptionDialog:@"手机自带网络"];
#endif
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                    self.netWorkStaus = AFNetworkReachabilityStatusReachableViaWiFi;
                    singleton.netStatus = YES;
                    
                    [self xc_reloadBaseURL];
                    
#ifdef DEBUG
                    [self showExceptionDialog:@"WIFI"];
#endif
                    break;
            }
        }];
        
        // 3.开始监控
        [mgr startMonitoring];
        
    }
    return self;
}

// 当断网的时候 再次重新打开WIFI时  重新获取BaseURL
- (void)xc_reloadBaseURL {
    HF_Singleton *single = [HF_Singleton sharedSingleton];
    NSString *url = [NSString stringWithFormat:@"%@?Version=v%@", URL_GetUrl, APP_VERSION()];
    [[BaseService share] sendGetRequestWithPath:url token:NO viewController:nil showMBProgress:NO success:^(id responseObject) {
        
        single.base_url = responseObject[@"data"];
        //如果地址一样则为正式地址，为非审核状态，为NO。否则为测试地址，为YES
        if ([single.base_url isEqualToString:BASE_REQUEST_URL]) {
            
            single.isAuditStatus = NO;
        } else {
            
            single.isAuditStatus = YES;
        }
        
    } failure:^(NSError *error) {
        single.base_url = BASE_REQUEST_URL;
        
        // 暂时开启测试地址
//        NSString *url = [NSString stringWithFormat:@"%@:9332", BASE_REQUEST_URL];
//        single.base_url = url;
        
        single.isAuditStatus = NO;
    }];
}

#pragma mark - public method
#pragma mark 不带 参数加密
- (void)requestWithPath:(NSString *)urlStr
                 method:(NSInteger)method
             parameters:(id)parameters
                  token:(BOOL)isLoadToken
         viewController:(UIViewController *)viewController
                success:(AFNSuccessResponse)success
                failure:(AFNFailureResponse)failure {
    
    self.manager = [BaseService sharedHTTPSession];
    
    NSString *pinjieUrlStr = urlStr;
    
    
    HF_Singleton *single = [HF_Singleton sharedSingleton];
    
    urlStr = [single.base_url stringByAppendingPathComponent:urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSLog(@"打印token----%@",[UserDefaults() objectForKey:K_userToken]);
    
    [MBProgressHUD hideHUDForView:viewController.view];
    
    
    if (self.isShowMBP) {
        if (viewController) {
            [MBProgressHUD showLoading:viewController.view];
        }
    }
    
    
    switch (method) {
        case XCHttpRequestGet:
        {
            
            self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"charset=utf-8", nil];
            
            if (isLoadToken == YES) {
                //可不写，但是不能写在判断外，否则会出错
                //self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                //在设置header头
                [self.manager.requestSerializer setValue:[UserDefaults() objectForKey:K_userToken] forHTTPHeaderField:@"Authorization"];
            }
            
            
            [self.manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                NSDictionary *dic = responseObject;
                if ([[dic objectForKey:xc_returnCode]integerValue] == 1)
                {
                    success(responseObject);
                    NSLog(@"%@-Get请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,responseObject);
                    
                }
                else if ([[dic objectForKey:xc_returnCode]integerValue] == 1000 || [[dic objectForKey:xc_returnCode]integerValue] == 1002) {
                    NSLog(@"%@-Get请求地址:\n%@---登陆过期日志:\n%@",[viewController class],urlStr,responseObject);
                    
                    //如果登录过期和未检测到权限，都需要重新请求token
                    [self refreshToken:pinjieUrlStr method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
                    
                    return ;
                    
                }
                else {
                    NSError *error;
                    if ([dic objectForKey:xc_returnMsg] && [dic objectForKey:xc_returnCode]) {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:[dic objectForKey:xc_returnMsg], xc_returnCode:[dic objectForKey:xc_returnCode]}];
                    } else {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                    }
                    failure(error);
                    
                    NSLog(@"%@-Get请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,error);

                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:viewController.view];
                failure(error);
                NSLog(@"%@-Get请求地址:\n%@---error日志:\n%@",[viewController class],urlStr,error);
                
#ifdef DEBUG
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                    single.netStatus = NO;
                }
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#endif
                
            }];
        }
            break;
        case XCHttpRequestPost:
        {
            
            self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            
            if (isLoadToken == YES) {
                //在设置header头
                [self.manager.requestSerializer setValue:[UserDefaults() objectForKey:K_userToken] forHTTPHeaderField:@"Authorization"];
            }
            
            [self.manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                
                NSDictionary *dic = responseObject;
                if ([[dic objectForKey:xc_returnCode]integerValue] == 1)
                {
                    success(responseObject);
                    NSLog(@"%@-Post请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,responseObject);
                    
                }
                else if ([[dic objectForKey:xc_returnCode]integerValue] == 1000 || [[dic objectForKey:xc_returnCode]integerValue] == 1002) {
                    NSLog(@"%@-Post请求地址:\n%@---登陆过期日志:\n%@",[viewController class],urlStr,responseObject);
                    
                    //如果登录过期和未检测到权限，都需要重新请求token
                    [self refreshToken:pinjieUrlStr method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
                    
                    return ;
                    
                }
                else {
                    NSError *error;
                    if ([dic objectForKey:xc_returnMsg] && [dic objectForKey:xc_returnCode]) {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:[dic objectForKey:xc_returnMsg], xc_returnCode:[dic objectForKey:xc_returnCode]}];
                    } else {
                        error = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                    }
                    
                    failure(error);
                    NSLog(@"%@-Post请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,error);

                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:viewController.view];
                
                failure(error);
                NSLog(@"%@-Post请求地址:\n%@---error日志:\n%@",[viewController class],urlStr,error);
                
                
#ifdef DEBUG
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1002 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                    single.netStatus = NO;
                }
#else
                NSError *newError = [[NSError alloc]initWithDomain:@"com.gogo-talk.GoGoTalk" code:1001 userInfo:@{xc_message:xc_alert_message}];
                NSDictionary *userInfoDic = newError.userInfo;
                if (viewController) {
                    [MBProgressHUD showMessage:userInfoDic[xc_message] toView:viewController.view];
                }
#endif
                
            }];
        }
            break;
            case AFHttpRequestGet:
        {
            self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"charset=utf-8", nil];
            
            if (isLoadToken == YES) {
                //可不写，但是不能写在判断外，否则会出错
                //self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                //在设置header头
                [self.manager.requestSerializer setValue:[UserDefaults() objectForKey:K_userToken] forHTTPHeaderField:@"Authorization"];
            }
            
            
            [self.manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:viewController.view];
                success(responseObject);

                NSLog(@"%@-Get请求地址:\n%@---success日志:\n%@",[viewController class],urlStr,responseObject);
              
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:viewController.view];
                failure(error);
                NSLog(@"%@-Get请求地址:\n%@---error日志:\n%@",[viewController class],urlStr,error);
            }];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - POST 带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure {
    self.isShowMBP = YES;
    [self requestWithPath:url method:XCHttpRequestPost parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - GET 带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure {
    self.isShowMBP = YES;
    [self requestWithPath:url method:XCHttpRequestGet parameters:nil token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - POST 判断是否带MBP带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                 showMBProgress:(BOOL)isShow
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure {
    self.isShowMBP = isShow;
    [self requestWithPath:url method:XCHttpRequestPost parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
}

#pragma mark - GET 判断是否带MBP带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                showMBProgress:(BOOL)isShow
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure {
    self.isShowMBP = isShow;
    [self requestWithPath:url method:XCHttpRequestGet parameters:nil token:isLoadToken viewController:viewController success:success failure:failure];
}



#pragma mark - 原生AF GET 判断是否带MBP
- (void)sendAFGetRequestWithPath:(NSString *)url
                           token:(BOOL)isLoadToken
                  viewController:(UIViewController *)viewController
                  showMBProgress:(BOOL)isShow
                         success:(AFNSuccessResponse)success
                         failure:(AFNFailureResponse)failure {
    self.isShowMBP = isShow;
    [self requestWithPath:url method:AFHttpRequestGet parameters:nil token:isLoadToken viewController:viewController success:success failure:failure];
}



#pragma mark - private method
#pragma mark 弹出网络错误提示框
- (void)showExceptionDialog:(NSString *)message {
    NSLog(@"%@", message);
}

#pragma mark 弹出网络错误提示框2----暂时不用，替换成了MBProgressHUD
- (void)alertErrorMessage:(NSError *)error {
    NSDictionary *userInfoDic = error.userInfo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:userInfoDic[xc_message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertV show];
#pragma clang diagnostic pop

}

- (void)refreshToken:(NSString *)url method:(NSInteger)method parameters:(id)parameters token:(BOOL)isLoadToken viewController:(UIViewController *)viewController success:(AFNSuccessResponse)success failure:(AFNFailureResponse)failure {

    
    NSString *userName = [UserDefaults() objectForKey:@"phoneNumber"];
    
    NSString *password = [UserDefaults() objectForKey:K_password];
    
    //如果都为空，退出到登录页
    if (IsStrEmpty(userName) || IsStrEmpty(password)) {
        if (viewController) {
            [MBProgressHUD showMessage:@"登录过期，请重新登录" toView:viewController.view];
        }

        HF_LoginViewController *loginVc = [[HF_LoginViewController alloc]init];
        [UserDefaults() setObject:@"no" forKey:@"login"];
        [UserDefaults() setObject:@"" forKey:K_userToken];
        [UserDefaults() setObject:@"" forKey:K_AccountID];
        [UserDefaults() synchronize];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
        viewController.view.window.rootViewController = nav;
        
        return;
    }
    
    
    NSDictionary *postDic = @{@"UserName":userName,@"Password":password};
    
    //使用af原生请求，防止弹出MBProgressHUD动画。
    self.manager = [BaseService sharedHTTPSession];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    HF_Singleton *single = [HF_Singleton sharedSingleton];
    
    
    NSString *urlStr = [single.base_url stringByAppendingPathComponent:URL_Login];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self.manager POST:urlStr parameters:postDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"result"] isEqual:@1]) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [UserDefaults() setObject:responseObject[@"data"][@"userToken"] forKey:K_userToken];
                [UserDefaults() setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"accountID"]] forKey:K_AccountID];
                [UserDefaults() synchronize];

                //重新请求
                [self requestWithPath:url method:method parameters:parameters token:isLoadToken viewController:viewController success:success failure:failure];
            });
        } else {
            
            // 取消所有的网络请求
            [self.manager.operationQueue cancelAllOperations];
            // 清空密码
            [UserDefaults() setObject:@"" forKey:K_password];
            
            [MBProgressHUD showMessage:@"登录过期，请重新登录" toView:[UIApplication sharedApplication].keyWindow];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HF_LoginViewController *loginVc = [[HF_LoginViewController alloc]init];
                [UserDefaults() setObject:@"no" forKey:@"login"];
                [UserDefaults() setObject:@"" forKey:K_userToken];
                [UserDefaults() setObject:@"" forKey:K_AccountID];
                [UserDefaults() synchronize];
                BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVc];
                viewController.view.window.rootViewController = nav;
            });
            
        }
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];
    
}


@end
