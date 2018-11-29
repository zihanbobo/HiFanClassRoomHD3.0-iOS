//
//  GGT_ScheduleFinishedStuEvaluateCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/18.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleFinishedDetailStuEvaluateModel.h"
#import "ASStarRatingView.h"

@interface GGT_ScheduleFinishedStuEvaluateCell : UITableViewCell
@property (nonatomic, strong) ASStarRatingView *starRatingView;
- (void)getCellModel :(GGT_ScheduleFinishedDetailStuEvaluateModel *)model;

@end
