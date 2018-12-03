//
//  HF_MyScheduleHomeHeaderCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/3.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_MyScheduleHomeHeaderCell.h"


@interface HF_MyScheduleHomeHeaderCell()
//未完成
@property (nonatomic, strong) UIButton *unFinishedButton;
//已完成
@property (nonatomic, strong) UIButton *finishedButton;
@end

@implementation HF_MyScheduleHomeHeaderCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView {
    self.unFinishedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.unFinishedButton setTitle:@"未完成" forState:(UIControlStateNormal)];
    self.unFinishedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(22)];
    self.unFinishedButton.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 40);
    [self addSubview:self.unFinishedButton];
    
    [self.unFinishedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(50);
        make.left.equalTo(self.mas_left).with.offset(18);
        make.height.mas_equalTo(22);
    }];
    
    
    @weakify(self);
    [[self.unFinishedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.unFinishedBlock) {
             self.unFinishedBlock();
         }
     }];
    
    
    
    self.finishedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.finishedButton setTitle:@"已完成" forState:(UIControlStateNormal)];
    self.finishedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(22)];
    self.finishedButton.titleLabel.textColor = UICOLOR_FROM_HEX_ALPHA(Color000000, 100);
    [self addSubview:self.finishedButton];
    
    [self.finishedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(50);
        make.left.equalTo(self.unFinishedButton.mas_right).with.offset(25);
        make.height.mas_equalTo(22);
    }];
    
    
    [[self.finishedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.finishedBlock) {
             self.finishedBlock();
         }
     }];
    
}
@end
