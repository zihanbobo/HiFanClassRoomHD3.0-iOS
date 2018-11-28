//
//  GGT_GradingResultAlertView.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/12/1.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCAlertCancleBlock)(void);
typedef void(^XCAlertEnterBlock)(void);

@interface GGT_GradingResultAlertView : UIView

@property (nonatomic, copy) XCAlertCancleBlock cancleBlock;
@property (nonatomic, copy) XCAlertEnterBlock  enterBlock;

+ (instancetype)viewWithTitle:(NSString *)title middleMessage:(NSString *)middleMessage bottomMessage:(NSString *)bottomMessage bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

@end
