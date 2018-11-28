//
//  GGT_ScheduleStudentModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/20.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ScheduleStudentModel : NSObject
//公共
@property (nonatomic, assign) NSInteger Gender;
@property (nonatomic, copy) NSString *HeadImg;

//未完成列表-已完成列表
@property (nonatomic, assign) NSInteger AttendLessonID;
@property (nonatomic, assign) NSInteger StudentID;

//课程详情
@property (nonatomic, copy) NSString *CommentTime;
@property (nonatomic, copy) NSString *EName;
@property (nonatomic, copy) NSString *EvaluateContent;
@property (nonatomic, assign) NSInteger GiftCount;
@property (nonatomic, assign) NSInteger IsComment;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, assign) NSInteger Points;
@property (nonatomic, assign) NSInteger StudentType;



/* 未完成列表-已完成列表
 AttendLessonID = 1639;
 Gender = 1;
 HeadImg = "";
 StudentID = 7519;
 */


/* 课程详情
 CommentTime = "2018/1/4 13:33:03";
 EName = xiaoran;
 EvaluateContent = "我在这里等你回来测试";
 Gender = 1;
 GiftCount = 0;
 HeadImg = "";
 IsComment = 1;
 Name = Student;
 Points = 3;
 StudentID = 7519;
 StudentType = 2;
 */

@end
