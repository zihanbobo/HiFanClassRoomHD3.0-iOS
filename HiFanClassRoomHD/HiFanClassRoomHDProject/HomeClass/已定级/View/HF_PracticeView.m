//
//  HF_PracticeView.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_PracticeView.h"

@implementation HF_PracticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPracticeView];
    }
    return self;
}
- (void)initPracticeView
{
    self.descLabel = [UILabel new];
    self.descLabel.font = [UIFont fontWithName:@"PingFangHK-Regular" size:LineX(14)];
    self.descLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    self.descLabel.numberOfLines = 0;
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(27);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        
    }];
    
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"244fa55f9ac2f89d1a07cd357ad9dae6"]];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(246);
        make.top.equalTo(self.descLabel.mas_bottom).offset(27);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    self.practiceButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [self.practiceButton setTitle:@"开始练习" forState:UIControlStateNormal];
    [self.practiceButton setTitleColor:UICOLOR_FROM_HEX(0xffffff) forState:UIControlStateNormal];
    self.practiceButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(14)];
    [self.practiceButton setBackgroundImage:[UIImage imageNamed:@"实心按钮"] forState:UIControlStateNormal];
    [self addSubview:self.practiceButton];
    [self.practiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(321);
        make.height.mas_equalTo(49);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-17);
    }];
    
    @weakify(self);
    [[self.practiceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.classAfterBtnBlock) {
             self.classAfterBtnBlock();
         }
     }];
}

-(void)setDesc:(NSString *)desc {
    self.descLabel.text = desc;
}

-(void)setImagePath:(NSString *)imagePath {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
}

@end
