//
//  BaseViewController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

    //设置导航颜色
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"] forBarMetrics:UIBarMetricsDefault];
    
    //设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : UICOLOR_FROM_HEX(Color000000),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20]}];
}

#pragma mark 导航左侧,图片带文字
- (void)setLeftItem:(NSString *)imageName title:(NSString *)title {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *leftBtnTitle = title;
    UIImage *leftBtnImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
    [leftBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = Font(20);
    [leftBtn setImage:leftBtnImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 280, 40);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 0);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark 导航右侧,图片带文字
- (void)setRightItem:(NSString *)imageName title:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font(16);
    rightBtn.frame = CGRectMake(0, 0, 120, 22);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 0);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5,0,2.5,0);
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}


//状态条显示，并设置为白色
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark 左侧返回按钮
- (void)setLeftBackButton {
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width =  0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,imageItem];
}

#pragma mark 导航左侧图片
- (void)setLeftItem:(NSString *)imageName {
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,imageItem];
}




#pragma mark 导航右侧文字
- (void)setRightBarButtonItemTitle:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, LineW(44), LineH(44));
    rightBtn.titleLabel.font = Font(16);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = - LineX(5);
    self.navigationItem.rightBarButtonItems = @[spacer,rightItem];
}

#pragma mark 导航右侧图片
- (void)setRightButtonWithImg:(NSString *)imageName {
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    UIBarButtonItem *navSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navSpace.width = - LineX(5);
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:navSpace,imageItem, nil];
    
}


#pragma mark 左侧按钮的点击事件
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右侧按钮的点击事件
- (void)rightAction {
    
}


// 设置屏幕选装  需要在xcode中开启支持屏幕旋转
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)dealloc {
    NSLog(@"控制器--%@--销毁了", [self class]);
}

#pragma mark 网络请求失败后，重新点击按钮加载数据
- (void)showLoadingView {
    
    if (!self.loadingView) {
        _loadingView = [[HF_LoadingView alloc] initWithFrame:CGRectMake(0, 0,home_right_width, SCREEN_HEIGHT())];
    }
    
    [self.view addSubview:_loadingView];
}

- (void)hideLoadingView {
    
    double delaySeconds = 0.5;
    __weak BaseViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        [weakSelf.loadingView hideLoadingView];
        
        weakSelf.loadingView = nil;
        
    });
}

- (NSMutableArray *)refreshImages{
    if (!_refreshImages) {
        //刷新状态的图片数组
        _refreshImages = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 52; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shuaxin_%ld",i]];
            [_refreshImages addObject:image];
        }
    }
    return _refreshImages;
}

- (NSMutableArray *)pullingImages{
    
    if (!_pullingImages) {
        //下拉过程的数组
        _pullingImages = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 52; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"shuaxin_%ld",i]];
            [_pullingImages addObject:image];
        }
    }
    return _pullingImages;
    
}
@end
