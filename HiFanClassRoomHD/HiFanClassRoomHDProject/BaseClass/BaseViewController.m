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
    
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);

    //设置导航颜色
//    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(0x02B6E3);
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorFFFFFF);

//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//
    
    //设置导航不透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(20),NSFontAttributeName,UICOLOR_FROM_HEX(ColorFFFFFF),NSForegroundColorAttributeName, nil]];
}

#pragma mark --- 导航栏设置
- (void)setNavationStyle{
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(0xf2f2f2);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LineW(890));
        make.height.mas_equalTo(1);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    //左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *leftBtnTitle = @"Stage2 已完成3节/共15节";
    UIImage *leftBtnImage = [[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
    [leftBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = Font(20);
    [leftBtn setImage:leftBtnImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 280, 20);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 0);
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    
    //右侧按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(helpBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    NSString *title = @"取消课程规则";
    UIImage *image = [[UIImage imageNamed:@"帮助"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
    [rightBtn setImage:image forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font(16);
    rightBtn.frame = CGRectMake(0, 0, 120, 22);
    //    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:10.f]];
    //    CGSize imageSize = image.size;
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 0);
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5,0,2.5,0);
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
}


//状态条显示，并设置为白色
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 左侧返回按钮
- (void)setLeftBackButton {
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width =  0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,imageItem];
}

#pragma mark 导航左侧图片
- (void)setLeftItem:(NSString *)imageName {
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,imageItem];
}

#pragma mark 导航左侧,图片带文字
- (void)setLeftItem:(NSString *)imageName title:(NSString *)title {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setImage:UIIMAGE_FROM_NAME(imageName) forState:UIControlStateNormal];
    [leftBtn setImage:UIIMAGE_FROM_NAME(imageName) forState:UIControlStateHighlighted];
    [leftBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateSelected];
    leftBtn.frame = CGRectMake(0, 0, LineW(86), LineH(44));
    leftBtn.titleLabel.font = Font(16);
    // 重点位置开始
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,0);
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, LineW(11), 0, -LineW(11));
    // 重点位置结束
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = rightItem;
    
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
    UIBarButtonItem *navSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
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
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc
{
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


@end
