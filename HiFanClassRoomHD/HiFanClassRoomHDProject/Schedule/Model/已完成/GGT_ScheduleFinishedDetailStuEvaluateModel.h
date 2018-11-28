//
//  GGT_ScheduleFinishedDetailStuEvaluateModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/1/4.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ScheduleFinishedDetailStuEvaluateModel : NSObject

@property (nonatomic, copy) NSString *EnglistName;
@property (nonatomic, copy) NSString *EvaluateContent;
@property (nonatomic, copy) NSString *EvaluateTime;
@property (nonatomic, assign) NSInteger GiftCount;
@property (nonatomic, copy) NSString *HeadImg;
@property (nonatomic, assign) NSInteger Points;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, assign) NSInteger Sex;
@property (nonatomic, assign) NSInteger TeacherID;
@property (nonatomic, copy) NSString *teacherImg;
@property (nonatomic, assign) NSInteger teacherName;

/*
 EnglistName = xiaoran;
 EvaluateContent = "我在这里等你回来测试";
 EvaluateTime = "2018-01-04 13:33:03";
 GiftCount = 0;
 HeadImg = "";
 Points = 3;
 RealName = Student;
 Sex = 1;
 TeacherID = 332;
 teacherImg = "http://testht.hi-fan.cn//tchheadimages/192_20170910184116749.png";
 teacherName = Lou;
 */
@end
