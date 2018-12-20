//
//  GGT_ApplyViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/2.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import "GGT_ApplyViewController.h"

@interface GGT_ApplyViewController()
//教材
@property (nonatomic, strong) UILabel *jiaocaiLabel;
//上课时间
@property (nonatomic, strong) UILabel *classLabel;
@end


@implementation GGT_ApplyViewController
//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController ) { //&& self.xc_textView != nil
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = LineW(460);
        tempSize.height = LineH(316);
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"确认申请";
    self.navigationController.navigationBar.barTintColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(18),NSFontAttributeName,UICOLOR_FROM_HEX(Color0D0101),NSForegroundColorAttributeName, nil]];
    //隐藏导航下的黑线
    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.view.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self initUI];
}

- (void)initUI {
    //确认申请
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.text = @"确认申请";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(18);
    }];
    
    
    
    //关闭
    // 图像
    UIImageView *closeImgView = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"close");
        imgView;
    });
    [self.view addSubview:closeImgView];
    
    [closeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(24);
        make.right.equalTo(self.view.mas_right).offset(-24);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    
    
    UIButton *closeButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, 50, 50);
        xc_button;
    });
    [closeButton addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    // 图像
    UIImageView *iconImgView1 = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"Group-2");
        imgView;
    });
    [self.view addSubview:iconImgView1];
    
    [iconImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(119);
        make.top.equalTo(titleLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(25, 22));
    }];
    
    //教材
    self.jiaocaiLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
//        label.text = @"A2 Lesson1-1";
        label;
    });
    self.jiaocaiLabel.text = self.classNameStr;
    [self.view addSubview:self.jiaocaiLabel];
    
    [self.jiaocaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView1.mas_right).offset(11);
        make.bottom.equalTo(iconImgView1.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    
    // 图像2
    UIImageView *iconImgView2 = ({
        UIImageView *imgView = [UIImageView new];
        imgView.image = UIIMAGE_FROM_NAME(@"时间");
        imgView;
    });
    [self.view addSubview:iconImgView2];
    
    [iconImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(119);
        make.top.equalTo(iconImgView1.mas_bottom).offset(margin15);
        make.size.mas_equalTo(CGSizeMake(25, 22));
    }];
    
    
    //开课时间
    self.classLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(18);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
//        label.text = @"11月12日（周三）18:30";
        label;
    });
    self.classLabel.text = self.classTimeStr;
    [self.view addSubview:self.classLabel];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView2.mas_right).offset(11);
        make.bottom.equalTo(iconImgView2.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    
    NSArray *titleArray = @[@"1.申请提交成功将暂时冻结1课时；",@"2.开班成功前取消申请自动返还课时；",@"3.同一时间下满3位小伙伴申请即可成功开班；",@"4.开课前7小时未满3人，系统会自动取消申请并返还课时。"];
    for (NSInteger i = 0; i<titleArray.count; i++) {
        UILabel *label = [UILabel new];
        label.font = Font(14);
        label.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
        label.text = titleArray[i];
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(41);
            make.top.equalTo(self.classLabel.mas_bottom).offset(20+23*i);
            make.height.mas_equalTo(14);
        }];
    }
    
    
    //取消
    UIButton *cancleButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, 108, 36);
        [xc_button setTitle:@"取消" forState:UIControlStateNormal];
        [xc_button setTitleColor:UICOLOR_FROM_HEX(0x979797) forState:UIControlStateNormal];
        [xc_button xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:18];
        [xc_button addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(0x979797) CornerRadius:18];
        xc_button;
    });
    [cancleButton addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancleButton];
    
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.right.equalTo(self.view.mas_centerX).offset(-30);
        make.size.mas_equalTo(CGSizeMake(108, 36));
    }];
    
    
    //确定
    UIButton *sureButton = ({
        UIButton *xc_button = [UIButton new];
        xc_button.frame = CGRectMake(0, 0, 108, 36);
        [xc_button setTitle:@"确定" forState:UIControlStateNormal];
        [xc_button setTitleColor:UICOLOR_FROM_HEX(ColorFFFFFF) forState:UIControlStateNormal];
        [xc_button xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:18];
        [xc_button setBackgroundImage:UIIMAGE_FROM_NAME(@"enterButtonY") forState:UIControlStateNormal];
        xc_button;
    });
    [sureButton addTarget:self action:@selector(sureButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.left.equalTo(self.view.mas_centerX).offset(30);
        make.size.mas_equalTo(CGSizeMake(108, 36));
    }];
}


- (void)sureButton {
    if (self.sureBlock) {
        self.sureBlock(YES);
    }
}

- (void)rightAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
