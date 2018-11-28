//
//  HF_HomeLeftView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_HomeLeftView.h"

@implementation HF_HomeLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}


//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.titleLabel.font = Font(14);
    
    
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGFloat totalHeight = LineH(55);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - LineH(imageSize.height)), 0.0, 0.0, - LineW(titleSize.width));
    btn.titleEdgeInsets = UIEdgeInsetsMake(LineH(7), - LineW(imageSize.width), - ((totalHeight-LineH(17)) ), 0);
}

- (void)drawRect:(CGRect)rect {
    [self.peopleIconButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(30)];
    [self.peopleIconButton addBorderForViewWithBorderWidth:1.0f BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:LineH(30)];

    
    
//    [self.classImgView xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(6)];
//    [self.classEnterButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];
//    //    [self.yaoqingButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(19)];
//
//    [self.classLevelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(12)];
//    [self.classLevelLabel addBorderForViewWithBorderWidth:0.5f BorderColor:UICOLOR_FROM_HEX(kThemeColor) CornerRadius:LineH(12)];
}


- (void)initView {
    //MARK:设置view的颜色为渐变色
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)UICOLOR_FROM_HEX(0x67D3CE).CGColor,(id)UICOLOR_FROM_HEX(0x02B6E3).CGColor, nil];
    layer.locations = @[@0.0f,@0.6f,@1.0f];//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];

    
    
    //MARK:头像按钮
    self.peopleIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.peopleIconButton];
    
    
    [self.peopleIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(64);
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    
    self.optionsView = [[UIView alloc]init];
    [self addSubview:self.optionsView];
    
    
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(LineY(163));
        make.height.mas_offset(LineH(314)); //88*3+25+25
    }];
    
    
    // 课表按钮
    UIButton *scheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scheduleButton setTitle:@"课表" forState:UIControlStateNormal];
    scheduleButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    scheduleButton.backgroundColor = UICOLOR_FROM_HEX(Color2B8EEF);
    [scheduleButton setImage:UIIMAGE_FROM_NAME(@"kebiao") forState:UIControlStateNormal];
    [scheduleButton setImage:UIIMAGE_FROM_NAME(@"kebiao") forState:UIControlStateSelected];
    scheduleButton.tag = 100;
    scheduleButton.selected = YES;
    [scheduleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:scheduleButton];
    [self.optionsView addSubview:scheduleButton];
    
    
    [scheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(self.optionsView.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];
    
    
    // 约课按钮
    UIButton *bookClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookClassButton setTitle:@"约课" forState:UIControlStateNormal];
    bookClassButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    [bookClassButton setImage:UIIMAGE_FROM_NAME(@"yueke") forState:UIControlStateNormal];
    [bookClassButton setImage:UIIMAGE_FROM_NAME(@"yueke") forState:UIControlStateSelected];
    bookClassButton.tag = 101;
    bookClassButton.selected = NO;
    [bookClassButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:bookClassButton];
    [self.optionsView addSubview:bookClassButton];
    
    
    [bookClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(scheduleButton.mas_bottom).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];
    
    
    // 我的按钮
    UIButton *mineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mineButton setTitle:@"我的" forState:UIControlStateNormal];
    mineButton.frame = CGRectMake(0, 0, LineW(88), LineH(88));
    [mineButton setImage:UIIMAGE_FROM_NAME(@"wode") forState:UIControlStateNormal];
    [mineButton setImage:UIIMAGE_FROM_NAME(@"wode") forState:UIControlStateSelected];
    mineButton.tag = 102;
    mineButton.selected = NO;
    [mineButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:mineButton];
    [self.optionsView addSubview:mineButton];
    
    [mineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.bottom.equalTo(self.optionsView.mas_bottom).with.offset(-0);
        make.size.mas_equalTo(CGSizeMake(LineW(88), LineH(88)));
    }];
    
    
    
    
    // 检测按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setImage:UIIMAGE_FROM_NAME(@"jiance") forState:UIControlStateNormal];
    checkButton.tag = 103;
    [checkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkButton];
    
    
    // 电话按钮
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:UIIMAGE_FROM_NAME(@"kefu") forState:UIControlStateNormal];
    phoneButton.tag = 104;
    [phoneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneButton];
    
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(phoneButton.mas_top).with.offset(-LineY(10));
        make.size.mas_equalTo(CGSizeMake(LineW(50), LineH(50))); //28 27
    }];
    
    
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).with.offset(-LineH(30));
        make.size.mas_equalTo(CGSizeMake(LineW(50), LineH(50))); //26  26
    }];
    
    
    GGT_Singleton *single = [GGT_Singleton sharedSingleton];
    if (single.isAuditStatus) {
        phoneButton.hidden = YES;
    } else {
        phoneButton.hidden = NO;
    }
    
}

- (void)buttonAction:(UIButton *)button {
    
    if ([self.optionsView.subviews containsObject:button]) {
        for (UIView *view in self.optionsView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.selected = NO;
                btn.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    button.selected = YES;
    
    
    if (button.tag == 100 || button.tag == 101 || button.tag == 102) {
        button.backgroundColor = UICOLOR_FROM_HEX(Color2B8EEF);
    }
    
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button);
    }
}

@end
