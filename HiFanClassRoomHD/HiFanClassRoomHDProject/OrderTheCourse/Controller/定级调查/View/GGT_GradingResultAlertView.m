//
//  GGT_GradingResultAlertView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/1.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_GradingResultAlertView.h"

@interface GGT_GradingResultAlertView()

@property (nonatomic, strong) UIImageView *xc_contentImgView;
@property (nonatomic, strong) UILabel *xc_topTitleLabel;
@property (nonatomic, strong) UILabel *xc_middleMessageLabel;
@property (nonatomic, strong) UILabel *xc_bottomMessageLabel;
@property (nonatomic, strong) UIButton *xc_enterRoomButton;

@end

@implementation GGT_GradingResultAlertView


// 修改背景图
+ (instancetype)viewWithTitle:(NSString *)title middleMessage:(NSString *)middleMessage bottomMessage:(NSString *)bottomMessage bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;
{
    GGT_GradingResultAlertView *shareView = [[GGT_GradingResultAlertView alloc] init];
    shareView.frame = [UIScreen mainScreen].bounds;
    shareView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(0, 0, 0, 0.4);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
    
    
    shareView.cancleBlock = cancleBlock;
    shareView.enterBlock = enterBlock;
    
    [shareView buildViewWithTitle:title middleMessage:middleMessage bottomMessage:bottomMessage bottomButtonTitle:buttonTitle bgImg:bgImgName];
    
    [shareView initEnent];
//    [shareView setShowAnimation:XCAnimationNO];
    
    return shareView;
}

- (void)buildViewWithTitle:(NSString *)title middleMessage:(NSString *)middleMessage bottomMessage:(NSString *)bottomMessage bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName
{
    // 背景图
    self.xc_contentImgView = ({
        UIImageView *xc_contentImgView = [UIImageView new];
        UIImage *img = UIIMAGE_FROM_NAME(bgImgName);
        xc_contentImgView.image = img;
        xc_contentImgView.contentMode = UIViewContentModeCenter;
        xc_contentImgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        xc_contentImgView.userInteractionEnabled = YES;
        xc_contentImgView;
    });
    [self addSubview:self.xc_contentImgView];
    
    [self.xc_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.xc_contentImgView.width));//428*425
        make.height.equalTo(@(self.xc_contentImgView.height));
        make.centerX.centerY.equalTo(self);
    }];
    
    // 顶部title
    self.xc_topTitleLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(24);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.text = title;
//        [label changeLineSpaceWithSpace:20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self.xc_contentImgView addSubview:self.xc_topTitleLabel];
    
    [self.xc_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_contentImgView.mas_top).offset(148);
//        make.left.equalTo(self.xc_contentImgView.mas_left).offset(37);
//        make.right.equalTo(self.xc_contentImgView.mas_right).offset(-61);
        make.centerX.equalTo(self.xc_contentImgView);
    }];
    
    
    // 中间内容
    self.xc_middleMessageLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(20);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.text = middleMessage;
        [label changeLineSpaceWithSpace:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self.xc_contentImgView addSubview:self.xc_middleMessageLabel];
    
    [self.xc_middleMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_topTitleLabel.mas_bottom).offset(margin20);
        make.centerX.equalTo(self.xc_topTitleLabel.mas_centerX);
        make.width.equalTo(@(330));
    }];
    
    // 底部文字
    self.xc_bottomMessageLabel = ({
        UILabel *label = [UILabel new];
        label.font = Font(20);
        label.textColor = UICOLOR_FROM_HEX(Color0D0101);
        label.text = bottomMessage;
        [label changeLineSpaceWithSpace:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label;
    });
    [self.xc_contentImgView addSubview:self.xc_bottomMessageLabel];
    
    [self.xc_bottomMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xc_middleMessageLabel.mas_bottom).offset(margin20);
        make.width.centerX.equalTo(self.xc_middleMessageLabel);
    }];
    
    // 底部按钮
    self.xc_enterRoomButton = ({
        UIButton *xc_enterRoomButton = [UIButton new];
        xc_enterRoomButton.frame = CGRectMake(0, 0, 0, 0);
        [xc_enterRoomButton setTitle:buttonTitle forState:UIControlStateNormal];
        [xc_enterRoomButton setBackgroundColor:UICOLOR_FROM_HEX(ColorFF6600)];
        xc_enterRoomButton.titleLabel.font = Font(16);
        xc_enterRoomButton;
    });
    [self.xc_contentImgView addSubview:self.xc_enterRoomButton];
    
    [self.xc_enterRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xc_topTitleLabel);
        make.bottom.equalTo(self.xc_contentImgView.mas_bottom).offset(-22);
        make.width.equalTo(@(108));
        make.height.equalTo(@(36));
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

//-(void)setShowAnimation:(XCShowAnimationStyle)animationStyle
//{
//    int count = 4;
//    switch (animationStyle) {
//
//        case XCAnimationDefault:
//        {
//            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                [self.xc_contentImgView.layer setValue:@(0) forKeyPath:@"transform.scale"];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.23 * count delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    [self.xc_contentImgView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.09 *count delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        [self.xc_contentImgView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:0.05 *count delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                            [self.xc_contentImgView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
//                        } completion:^(BOOL finished) {
//
//                        }];
//                    }];
//                }];
//            }];
//        }
//            break;
//
//        case XCAnimationLeftShake:{
//
//            CGPoint startPoint = CGPointMake(-self.xc_contentImgView.width, self.center.y);
//            self.xc_contentImgView.layer.position=startPoint;
//
//            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
//            //velocity:弹性复位的速度
//            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
//                self.xc_contentImgView.layer.position=self.center;
//
//            } completion:^(BOOL finished) {
//
//            }];
//        }
//            break;
//
//        case XCAnimationTopShake:{
//
//            CGPoint startPoint = CGPointMake(self.center.x, -self.xc_contentImgView.frame.size.height);
//            self.xc_contentImgView.layer.position=startPoint;
//
//            //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
//            //velocity:弹性复位的速度
//            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
//                self.xc_contentImgView.layer.position=self.center;
//
//            } completion:^(BOOL finished) {
//
//            }];
//        }
//            break;
//
//        case XCAnimationNO:{
//
//        }
//
//            break;
//
//        default:
//            break;
//    }
//
//}


@end
