//
//  GGT_CustomPopAlertView.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/28.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger , XCShowAnimationStyle) {
//    XCAnimationDefault    = 0,
//    XCAnimationLeftShake  ,
//    XCAnimationTopShake   ,
//    XCAnimationNO         ,
//};

typedef void(^XCAlertCancleBlock)(void);
typedef void(^XCAlertEnterBlock)(void);

@interface GGT_CustomPopAlertView : UIView

@property (nonatomic, copy) XCAlertCancleBlock cancleBlock;
@property (nonatomic, copy) XCAlertEnterBlock  enterBlock;

+ (instancetype)viewWithMessage:(NSString *)message bottomButtonTitle:(NSString *)buttonTitle bgImg:(NSString *)bgImgName cancleBlock:(XCAlertCancleBlock)cancleBlock enterBlock:(XCAlertEnterBlock)enterBlock;

@end
