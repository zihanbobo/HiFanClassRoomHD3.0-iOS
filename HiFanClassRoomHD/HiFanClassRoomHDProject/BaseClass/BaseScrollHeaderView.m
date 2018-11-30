//
//  BaseScrollHeaderView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/30.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseScrollHeaderView.h"

@implementation BaseScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}


-(void)buildUI {
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, home_right_width, LineH(132))];
    self.navView.backgroundColor = [UIColor greenColor];
    //    self.navView.alpha = 1;
    [self addSubview:self.navView];
    
    
    self.navImgView = [[UIImageView alloc] initWithFrame:CGRectMake(LineX(14), LineY(32), LineW(618), LineH(75))];
    self.navImgView.image = UIIMAGE_FROM_NAME(@"Reservations");
    self.navImgView.alpha = 1;
    [self.navView addSubview:self.navImgView];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LineX(17), LineY(78), LineW(100), LineH(38))];
    self.titleLabel.text = @"约课";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = Font(38);
    [self.navView addSubview:self.titleLabel];
    
    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.frame = CGRectMake(home_right_width-LineW(120), LineY(99), LineW(100), LineH(16));
    [self.button setTitle:@"学习攻略" forState:(UIControlStateNormal)];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = Font(16);
    [self.navView addSubview:self.button];
    
    @weakify(self);
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"学习攻略");
     }];
}

@end
