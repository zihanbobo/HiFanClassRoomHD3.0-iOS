//
//  HF_PracticeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_PracticeViewController.h"

@interface HF_PracticeViewController () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;

@end

@implementation HF_PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlString = [NSString stringWithFormat:@"%@?lessonid=%ld&tonken=%@",self.webUrl,(long)self.lessonid,[UserDefaults() objectForKey:K_userToken]];
    self.urlString = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@-Get请求地址:\n%@---success日志",[HF_PracticeViewController class],self.urlString);

    
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
    
    [self setNavView];

}

-(void)setNavView {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:UIIMAGE_FROM_NAME(@"close") forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(17);
        make.top.equalTo(self.view.mas_top).offset(17);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    
    @weakify(self);
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    titleLabel.textColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    titleLabel.text = self.titleStr;
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(closeButton.mas_centerY);
        make.height.mas_equalTo(30);
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

//状态条隐藏
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
