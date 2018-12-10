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
    [self.unFinishedButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 70) forState:UIControlStateNormal];
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
    
    
//    self.lineAnimationView = [[UIView alloc]init];
//    self.lineAnimationView.backgroundColor = [UICOLOR_FROM_HEX(0x67D3CE) colorWithAlphaComponent:70];
//    [self addSubview:self.lineAnimationView];
//
//
//    [self.lineAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.unFinishedButton.mas_bottom).with.offset(-1);
//        make.left.right.equalTo(self.unFinishedButton);
//        make.height.mas_equalTo(3);
//    }];
    
    
    
    self.finishedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.finishedButton setTitle:@"已完成" forState:(UIControlStateNormal)];
    self.finishedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:LineX(22)];
    [self.finishedButton setTitleColor:UICOLOR_FROM_HEX_ALPHA(Color000000, 40) forState:UIControlStateNormal];
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


- (void)drawRect:(CGRect)rect {
    
}


@end
