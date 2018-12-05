//
//  BaseNavigationController.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseNavigationController.h"
//#import "GGT_MineViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(19),NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    [self setNavigationBarHidden:NO animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
