//
//  HF_BaseTabbarLeftView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_BaseTabbarLeftView.h"

@interface HF_BaseTabbarLeftView()
//课表和我的view
@property (nonatomic,strong) UIView *optionsView;
@property (nonatomic,strong) UIButton *peopleIconButton;
@property (nonatomic,strong) UIVisualEffectView *effe;
@end


@implementation HF_BaseTabbarLeftView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
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
    self.peopleIconButton.tag = 99;
    [self.peopleIconButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.peopleIconButton];
    
    [self.peopleIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(64);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    //等级
//    self.levelLabel = [[UILabel alloc] init];
//    self.levelLabel.textColor = UICOLOR_FROM_HEX(ColorFFFFFF);
//    self.levelLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(12)];
//    self.levelLabel.text = @"A9";
//    self.levelLabel.textAlignment = NSTextAlignmentCenter;
//    self.levelLabel.backgroundColor = [UICOLOR_FROM_HEX(ColorFFFFFF) colorWithAlphaComponent:0.4];
//    [self addSubview:self.levelLabel];
//
//    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-16);
//        make.bottom.equalTo(self.peopleIconButton.mas_bottom).offset(7);
//        make.size.mas_equalTo(CGSizeMake(30, 16));
//    }];
    
    //小三角
    self.sanjiaoImgView = [[UIImageView alloc] init];
    self.sanjiaoImgView.image = UIIMAGE_FROM_NAME(@"小三角");
    [self addSubview:self.sanjiaoImgView];
    
    [self.sanjiaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.centerY.equalTo(self.peopleIconButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    self.sanjiaoImgView.hidden = YES;
    
    
    self.optionsView = [[UIView alloc]init];
    [self addSubview:self.optionsView];
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.peopleIconButton.mas_bottom).with.offset(40);
        make.height.mas_offset(399); //133*3
    }];
    
    //MARK:首页
    UIButton *homeButton = [self buildButtonTitle:@"首页" setImage:@"shouye_tabbar"];
    homeButton.frame = CGRectMake(0, 0, LineW(100), LineH(133));
    homeButton.backgroundColor = UICOLOR_FROM_HEX_ALPHA(ColorFFFFFF, 20);
    homeButton.titleLabel.font = Font(14);
    homeButton.tag = 100;
    homeButton.selected = YES;
    [homeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:homeButton];
    [self.optionsView addSubview:homeButton];
    
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(self.optionsView.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 133));
    }];
    
    
    
    //MARK:发现按钮
    UIButton *findMoreButton = [self buildButtonTitle:@"发现" setImage:@"faxian_tabbar"];
    findMoreButton.frame = CGRectMake(0, 0, LineW(100), LineH(133));
    findMoreButton.titleLabel.font = Font(14);
    findMoreButton.tag = 101;
    findMoreButton.selected = NO;
    [findMoreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:findMoreButton];
    [self.optionsView addSubview:findMoreButton];
    
    [findMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.top.equalTo(homeButton.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 133));
    }];
    
    
    //MARK:课程按钮
//    UIButton *courseButton = [self buildButtonTitle:@"课程" setImage:@"kebiao_tabbar"];
//    courseButton.titleLabel.font = Font(14);
//    courseButton.frame = CGRectMake(0, 0, LineW(100), LineH(133));
//    courseButton.tag = 102;
//    courseButton.selected = NO;
//    [courseButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self initButton:courseButton];
//    [self.optionsView addSubview:courseButton];
//
//    [courseButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.optionsView.mas_centerX);
//        make.top.equalTo(findMoreButton.mas_bottom).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(100, 133));
//    }];
    
    
    //MARK:服务按钮
    UIButton *fuwuButton = [self buildButtonTitle:@"服务" setImage:@"xiaolian_tabbar"];
    fuwuButton.titleLabel.font = Font(14);
    fuwuButton.frame = CGRectMake(0, 0, LineW(100), LineH(133));
    fuwuButton.tag = 102;
    fuwuButton.selected = NO;
    [fuwuButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self initButton:fuwuButton];
    [self.optionsView addSubview:fuwuButton];
    
    [fuwuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.optionsView.mas_centerX);
        make.bottom.equalTo(self.optionsView.mas_bottom).with.offset(-0);
        make.size.mas_equalTo(CGSizeMake(100, 133));
    }];
}


-(UIButton *)buildButtonTitle:(NSString *)title setImage:(NSString *)imageString {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateSelected];
    return button;
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
        button.backgroundColor = UICOLOR_FROM_HEX_ALPHA(ColorFFFFFF, 20);
    }
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button);
    }
}


//MARK:将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGFloat totalHeight = LineH(55);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - LineH(imageSize.height)), 0.0, 0.0, - LineW(titleSize.width));
    btn.titleEdgeInsets = UIEdgeInsetsMake(LineH(7), - LineW(imageSize.width), - ((totalHeight-LineH(17)) ), 0);
}


- (void)drawRect:(CGRect)rect {
    [self.peopleIconButton xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:LineH(30)];
    [self.peopleIconButton addBorderForViewWithBorderWidth:2.0f BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:LineH(30)];

    [self.levelLabel addBorderForViewWithBorderWidth:1 BorderColor:UICOLOR_FROM_HEX(ColorFFFFFF) CornerRadius:8];
    [self.levelLabel xc_SetCornerWithSideType:XCSideTypeAll cornerRadius:8];
}

@end
