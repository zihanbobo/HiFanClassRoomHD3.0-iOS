//
//  HF_HomeUnitJiangyiDownViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/25.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeUnitJiangyiDownLoadViewController.h"

@interface HF_HomeUnitJiangyiDownLoadViewController () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HF_HomeUnitJiangyiDownLoadViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self setLeftItem:@"箭头"];
    
    self.webView = [[WKWebView alloc] init];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
