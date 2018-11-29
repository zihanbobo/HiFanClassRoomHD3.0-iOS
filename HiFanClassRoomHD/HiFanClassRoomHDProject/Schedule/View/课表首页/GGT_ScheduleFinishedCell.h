//
//  GGT_ScheduleFinishedCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/14.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleFinishedHomeModel.h"

@interface GGT_ScheduleFinishedCell : BaseTableViewCell
//评价按钮
@property (nonatomic, strong) UIButton *evaluateStatusButton;
- (void)getCellModel:(GGT_ScheduleFinishedHomeModel *)model;
@end
