//
//  GGT_ScheduleStudentIconView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ScheduleStudentModel.h"

@interface GGT_ScheduleStudentIconView : UIView
@property CGFloat viewHeight;
- (void)getCellArr:(NSArray *)array;
@end


@interface GGT_ScheduleStudentIconViewCell : UICollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame withHeight:(CGFloat)height;
- (void)getModel:(GGT_ScheduleStudentModel *)model;
@end
