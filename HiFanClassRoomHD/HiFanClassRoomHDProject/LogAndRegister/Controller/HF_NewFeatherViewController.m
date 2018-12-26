//
//  HF_NewFeatherViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/25.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_NewFeatherViewController.h"
#import "HF_LoginViewController.h"

#define NEWVIEWCOUNT 2
@interface HF_NewFeatherViewController () <UIScrollViewDelegate>

@end

@implementation HF_NewFeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addScrollView];

}


- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*NEWVIEWCOUNT, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    CGFloat w = self.view.frame.size.width;
    CGFloat h =self.view.frame.size.height;
    
    for (int i = 0; i<NEWVIEWCOUNT; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        CGFloat x = i*w;
        imageView.frame = CGRectMake(x, 0, w, h);
        NSString *imageName = [NSString stringWithFormat:@"引导页-%d",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        if (i == NEWVIEWCOUNT - 1) {
            //添加button
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView.mas_centerX);
                make.bottom.mas_equalTo(imageView.mas_bottom).with.offset(-LineX(30));
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH()/2, LineH(60)));
            }];
            
            [scrollView addSubview:imageView];
        }
    }
    [self.view addSubview:scrollView];
}

- (void)btnAction:(UIButton *)btn {
    
    HF_LoginViewController *userLoginVc = [[HF_LoginViewController alloc] init];
    UINavigationController *mainVc = [[UINavigationController alloc]initWithRootViewController:userLoginVc];
    [self presentViewController:mainVc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
