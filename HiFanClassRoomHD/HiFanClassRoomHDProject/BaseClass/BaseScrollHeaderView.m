//
//  BaseScrollHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/13.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseScrollHeaderView.h"

@implementation BaseScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView {
    //MARK:导航View
    self.navView = [[UIView alloc] init];
    self.navView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.navView];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(106);
    }];
    
    
    //MARK:导航背景大字体 106-90-1 = 15
    self.navBigLabel = [[UILabel alloc] init];
    self.navBigLabel.alpha = 1;
    self.navBigLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:LineH(86)];
    self.navBigLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 5);
    [self.navView addSubview:self.navBigLabel];
    
    [self.navBigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_top).offset(15);
        make.left.equalTo(self.navView.mas_left).with.offset(14);
        make.right.equalTo(self.navView.mas_right).with.offset(-14);
        make.height.mas_equalTo(90);
    }];
    
    
    //MARK:导航文字 106-38-16 = 52
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
    self.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    [self.navView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_top).offset(52);
        make.left.equalTo(self.navView.mas_left).with.offset(17);
        make.right.equalTo(self.navView.mas_right).with.offset(-17);
        make.height.mas_equalTo(38);
    }];
    
    
    //MARK:导航按钮 106-16-17 = 73
    self.rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.rightButton.frame = CGRectMake(0, 0, LineW(110), LineH(40));
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = Font(16);
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -LineW(3), 0, 0);
    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -LineW(3));
    [self.navView addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_top).offset(63);
        make.right.equalTo(self.navView.mas_right).with.offset(-17);
        make.height.mas_equalTo(40);
    }];
    
    
    //MARK:导航分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UICOLOR_FROM_HEX(0xEAEFF3);
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_top).offset(105);
        make.left.equalTo(self.navView.mas_left).with.offset(17);
        make.right.equalTo(self.navView.mas_right).with.offset(-17);
        make.height.mas_equalTo(1);
    }];
}

@end
