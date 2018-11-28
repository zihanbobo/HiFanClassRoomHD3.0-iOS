//
//  GGT_CustomPopAlertView.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/28.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CustomPopAlertView.h"

@interface GGT_CustomPopAlertView()
@property (nonatomic, strong) UIImageView *xc_contentImgView;
@property (nonatomic, strong) UIButton *xc_enterRoomButton;
@property (nonatomic, strong) UILabel *xc_contentLabel;

@end

@implementation GGT_CustomPopAlertView

// 修改背景图
+ (instancetype)viewWithMessage:(NSString *)message bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock
{
    GGT_CustomPopAlertView *shareView = [[GGT_CustomPopAlertView alloc] init];
    shareView.frame = [UIScreen mainScreen].bounds;
    shareView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.4);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
    
    shareView.cancleBlock = cancleBlock;
    shareView.enterBlock = enterBlock;
    
    [shareView initViewMessage:message buttonTitle:buttonTitle bgImg:bgImgName];
    
    [shareView initEnent];
//    [shareView setShowAnimation:XCAnimationNO];
    return shareView;
}

- (void)initViewMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName
{
    /// 背景图
    self.xc_contentImgView = ({
        UIImageView *xc_contentImgView = [UIImageView new];
        UIImage *img = UIIMAGE_FROM_NAME(bgImgName);
        xc_contentImgView.image = img;
        xc_contentImgView.contentMode = UIViewContentModeCenter;
        xc_contentImgView.frame = CGRectMake(0, 0, 428, 465);
        xc_contentImgView.userInteractionEnabled = YES;
        xc_contentImgView;
    });
    [self addSubview:self.xc_contentImgView];
    
    [self.xc_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(428, 465));
    }];
    

    /// 内容
    self.xc_contentLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(20);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.text = message;
        [label changeLineSpaceWithSpace:20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self.xc_contentImgView addSubview:self.xc_contentLabel];
    
    [self.xc_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentImgView.mas_left).offset(37);
        make.right.equalTo(self.xc_contentImgView.mas_right).offset(-61);
        make.top.equalTo(self.xc_contentImgView.mas_top).offset(179);
    }];
    
    /// 按钮
    self.xc_enterRoomButton = ({
        UIButton *xc_enterRoomButton = [UIButton new];
        xc_enterRoomButton.frame = CGRectMake(0, 0, 108, 36);
        [xc_enterRoomButton setTitle:buttonTitle forState:UIControlStateNormal];
        [xc_enterRoomButton setBackgroundColor:UICOLOR_FROM_HEX(ColorFF6600)];
        xc_enterRoomButton.titleLabel.font = Font(16);
        xc_enterRoomButton;
    });
    [self.xc_contentImgView addSubview:self.xc_enterRoomButton];
    
    [self.xc_enterRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xc_contentImgView.mas_left).offset(148);
        make.top.equalTo(self.xc_contentLabel.mas_bottom).offset(margin30);
        make.size.mas_equalTo(CGSizeMake(108, 36));
    }];
    
    // 需要更新 不然frame为0
    [self layoutIfNeeded];
    self.xc_enterRoomButton.layer.masksToBounds = YES;
    self.xc_enterRoomButton.layer.cornerRadius = self.xc_enterRoomButton.height/2.0f;
    
}

- (void)initEnent
{
    @weakify(self);
    [[self.xc_enterRoomButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.enterBlock) {
             self.enterBlock();
         }
         [self removeFromSuperview];
     }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
