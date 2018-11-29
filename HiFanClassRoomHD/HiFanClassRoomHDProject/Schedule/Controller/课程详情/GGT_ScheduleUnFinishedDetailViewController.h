//
//  GGT_ScheduleUnFinishedDetailViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshLoadData)(BOOL is);
@interface GGT_ScheduleUnFinishedDetailViewController : BaseViewController
@property (nonatomic, assign) NSInteger lessonId;
@property (nonatomic, copy) RefreshLoadData refreshLoadData;

@end
