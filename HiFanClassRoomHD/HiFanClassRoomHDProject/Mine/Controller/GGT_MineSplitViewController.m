//
//  GGT_MineSplitViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineSplitViewController.h"
#import "GGT_MineLeftViewController.h"
#import "GGT_SelfInfoViewController.h"

@interface GGT_MineSplitViewController () <UISplitViewControllerDelegate>
@property (nonatomic, strong) GGT_MineLeftViewController *mineLeftVC;
@end

@implementation GGT_MineSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    
    self.mineLeftVC = [[GGT_MineLeftViewController alloc] init];
    __weak GGT_MineSplitViewController *weakself  = self;
    
    self.mineLeftVC.refreshLoadData = ^(BOOL is) {
        if (is == YES) {
            [weakself showLoadingView];
            weakself.loadingView.loadingFailedBlock = ^(UIButton *btn){
                [weakself.mineLeftVC refreshLodaData];
            };
        } else {
            [weakself hideLoadingView];
        }
    };
    
    
    GGT_SelfInfoViewController *mineRightVc = [[GGT_SelfInfoViewController alloc] init];
    BaseNavigationController *detailNav = [[BaseNavigationController alloc] initWithRootViewController:mineRightVc];
    self.viewControllers = @[self.mineLeftVC, detailNav];

    //使用UISplitViewController前，第一步要做的是设置ViewControllers数组，再设置控制器的其他属性
    self.delegate = self;
}


#pragma mark 网络请求失败后，重新点击按钮加载数据
- (void)showLoadingView{
    if (!self.loadingView) {
        _loadingView = [[GGT_LoadingView alloc] initWithFrame:CGRectMake(0, 0,home_right_width, SCREEN_HEIGHT())];
    }
    [self.view addSubview:_loadingView];
}

- (void)hideLoadingView{
    double delaySeconds = 0.5;
    __weak GGT_MineSplitViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView = nil;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //刷新数据
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.isRefreshSelfInfoData == YES) {
        [self.mineLeftVC refreshHeaderLodaData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
