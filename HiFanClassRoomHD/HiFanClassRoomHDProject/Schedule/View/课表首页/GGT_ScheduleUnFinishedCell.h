//
//  GGT_ScheduleUnFinishedCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/14.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleUnFinishedHomeModel.h"

@interface GGT_ScheduleUnFinishedCell : BaseTableViewCell
//倒计时
@property (nonatomic, assign) NSInteger countDown;
- (void)getCellModel:(GGT_ScheduleUnFinishedHomeModel *)model;
@end
