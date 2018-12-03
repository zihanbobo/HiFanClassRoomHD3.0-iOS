//
//  BaseScrollHeaderViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/30.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseScrollHeaderViewController.h"

@interface BaseScrollHeaderViewController ()
@end

@implementation BaseScrollHeaderViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.alpha = 1;
    
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, LineH(132))];
    self.navView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.navView];
    
    
    self.navImgView = [[UIImageView alloc] initWithFrame:CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75))];
    self.navImgView.alpha = 1;
    [self.navView addSubview:self.navImgView];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38))];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = Font(38);
    [self.navView addSubview:self.titleLabel];
    
    
    self.rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = Font(16);
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(2.5), 0, 0);
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(2.5));
    [self.navView addSubview:self.rightButton];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(LineX(17), LineY(125), home_right_width-LineW(34), LineH(1));
    self.navView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self.view addSubview:lineView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
