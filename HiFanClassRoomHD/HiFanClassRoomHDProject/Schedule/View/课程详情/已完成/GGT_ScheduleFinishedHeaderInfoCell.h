//
//  GGT_ScheduleFinishedHeaderInfoCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/18.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleDetailModel.h"

@interface GGT_ScheduleFinishedHeaderInfoCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *xc_evaluateStatusButton; //是否评价状态
- (void)getCellModel :(GGT_ScheduleDetailModel *)model;

@end
