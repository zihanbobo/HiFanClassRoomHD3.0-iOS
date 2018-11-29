//
//  GGT_PracticeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_PracticeViewController.h"

@interface GGT_PracticeViewController () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;
@end

@implementation GGT_PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.title = self.titleStr;
    [self setLeftBackButton];
    
    self.urlString = [NSString stringWithFormat:@"%@?lessonid=%@&tonken=%@",self.webUrl,self.lessonid,[UserDefaults() objectForKey:K_userToken]];
    self.urlString = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@-Get请求地址:\n%@---success日志",[GGT_PracticeViewController class],self.urlString);
    
    self.webView = [[WKWebView alloc] init];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    self.webView.scrollView.bounces = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0);
    }];

}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showLoading:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");
    [MBProgressHUD hideHUDForView:self.view];
}


-(void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
