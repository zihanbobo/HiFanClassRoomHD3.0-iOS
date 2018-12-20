//
//  HF_ClassDetailsTopView.m
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/19.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_ClassDetailsTopView.h"

@implementation HF_ClassDetailsTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initClassDetailsTopView];
    }
    return self;
}
- (void)initClassDetailsTopView
{
    //课程详情
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(20)];
    titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 70);
    titleLabel.text = @"课程详情";
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_offset(20);
    }];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.mas_top).offset(60);
        make.height.mas_offset(1);
    }];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = UICOLOR_FROM_HEX(ColorEAEFF3);
    [self addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_offset(1);
    }];
    
    //关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:UIIMAGE_FROM_NAME(@"close") forState:(UIControlStateNormal)];
    [self addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(17);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    //课程图片
    self.classImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"B1-U4"]];
    self.classImageView.layer.masksToBounds = YES;
    self.classImageView.layer.cornerRadius = 7;
    [self addSubview:self.classImageView];
    [self.classImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(17);
        make.top.equalTo(lineView.mas_bottom).offset(17);
        make.width.height.mas_equalTo(150);
    }];
    //课程名称
    self.classTitleLabel = [UILabel new];
    self.classTitleLabel.font = Font(18);
    self.classTitleLabel.text = @"Lesson2-2";
    self.classTitleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x000000, 70);
    [self.classTitleLabel sizeToFit];
    [self addSubview:self.classTitleLabel];
    [self.classTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(self.classImageView.mas_right).offset(17);
        make.top.equalTo(lineView.mas_bottom).offset(34);
    }];
    //课程级别
    UIView *levelView = [UIView new];
    levelView.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x67D3CE, 20);
    levelView.layer.borderWidth = 1;
    levelView.layer.borderColor = UICOLOR_FROM_HEX_ALPHA(0x67D3CE, 100).CGColor;
    levelView.layer.masksToBounds = YES;
    levelView.layer.cornerRadius = 9;
    [self addSubview:levelView];
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(18);
        make.left.equalTo(self.classImageView.mas_right).offset(17);
        make.top.equalTo(self.classTitleLabel.mas_bottom).offset(6);
    }];
    self.levelLabel = [UILabel new];
    self.levelLabel.font = Font(12);
    self.levelLabel.textColor = UICOLOR_FROM_HEX_ALPHA(0x02B6E3, 100);
    self.levelLabel.text = @"A1";
    [levelView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(levelView.mas_centerX);
        make.centerY.equalTo(levelView.mas_centerY);
        
    }];
    //关于按钮
    self.aboutButton = [UIButton new];
    [self.aboutButton setTitle:@"关于本课" forState:UIControlStateNormal];
    
    [self.aboutButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 70) forState:UIControlStateNormal];
    self.aboutButton.titleLabel.font = Font(19);
    [self addSubview:self.aboutButton];
    [self.aboutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(28);
        make.left.equalTo(self.classImageView.mas_right).offset(17);
        make.bottom.equalTo(self.classImageView.mas_bottom).offset(0);
    }];
    //课前预习按钮
    self.previewButton = [UIButton new];
    [self.previewButton setTitle:@"课前预习" forState:UIControlStateNormal];
    [self.previewButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
    self.previewButton.titleLabel.font = Font(19);
    [self addSubview:self.previewButton];
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aboutButton.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(28);
        make.left.equalTo(self.aboutButton.mas_right).offset(17);
    }];
    //课后练习按钮
    self.practiceButton = [UIButton new];
    [self.practiceButton setTitle:@"课后练习" forState:UIControlStateNormal];
    [self.practiceButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(0x000000, 40) forState:UIControlStateNormal];
    self.practiceButton.titleLabel.font = Font(19);
    [self addSubview:self.practiceButton];
    [self.practiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aboutButton.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(28);
        make.left.equalTo(self.previewButton.mas_right).offset(17);
    }];
    //按钮下划线
    CGFloat x = self.aboutButton.frame.origin.x;
    CGFloat y = self.aboutButton.frame.origin.y + self.aboutButton.frame.size.height;
    self.buttonLine = [UIView new];
    self.buttonLine.backgroundColor = UICOLOR_FROM_HEX_ALPHA(0x61D1D5, 100);
    [self addSubview:self.buttonLine];
    [self.buttonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.aboutButton).offset(0);
        make.height.mas_equalTo(3);
        make.top.equalTo(self.aboutButton.mas_bottom).offset(-6);
    }];
    
    
}
-(void)setImagePath:(NSString *)imagePath
{
    [self.classImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
}
@end
