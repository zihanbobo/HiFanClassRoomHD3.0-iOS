//
//  GGT_ScheduleUnFisishedHeaderInfoCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleDetailModel.h"

@interface GGT_ScheduleUnFisishedHeaderInfoCell : BaseTableViewCell
// 邀请好友
//@property (nonatomic, strong) UIButton *yaoqingButton;

- (void)getCellModel :(GGT_ScheduleDetailModel *)model;
//倒计时
@property (nonatomic, assign) NSInteger countDown;
@end
