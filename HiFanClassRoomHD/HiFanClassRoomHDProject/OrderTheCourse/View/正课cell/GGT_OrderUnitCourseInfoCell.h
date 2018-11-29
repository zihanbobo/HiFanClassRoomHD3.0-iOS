//
//  GGT_OrderUnitCourseInfoCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ClassBookDetailModel.h"

@protocol getClassStatusDelegate<NSObject>
-(void)getClassStatus:(BOOL)isShowRightBtn;
@end

@interface GGT_OrderUnitCourseInfoCell : BaseTableViewCell
// 邀请好友
//@property (nonatomic, strong) UIButton *yaoqingButton;
- (void)getModel:(GGT_ClassBookDetailModel *)model;
//倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, weak) id<getClassStatusDelegate>degegate;

@end
