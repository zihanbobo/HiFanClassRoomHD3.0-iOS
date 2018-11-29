//
//  GGT_ScheduleFinishedHomeModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ScheduleFinishedHomeModel : NSObject
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, copy) NSString *BeforeFilePathPad;
@property (nonatomic, assign) NSInteger BeforeState;
@property (nonatomic, assign) NSInteger AfterClassStatus;
@property (nonatomic, copy) NSString *AfterClassUrl;
@property (nonatomic, copy) NSString *AfterFilePathPad;
@property (nonatomic, assign) NSInteger ClassType;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, assign) NSInteger DetailRecordID;
@property (nonatomic, copy) NSString *EvaluateContent;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, assign) NSInteger GiftCount;
@property (nonatomic, assign) NSInteger IsComment;
@property (nonatomic, assign) NSInteger LessonCount;
@property (nonatomic, assign) NSInteger LessonId;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, assign) NSInteger Points;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StartTimePad;
@property (nonatomic, assign) NSInteger StudentGender;
@property (nonatomic, assign) NSInteger StudentId;

@property (nonatomic, strong) NSArray *StudentList;

@property (nonatomic, assign) NSInteger StudentStatus;
@property (nonatomic, assign) NSInteger TeacherGender;
@property (nonatomic, assign) NSInteger TeacherId;
@property (nonatomic, copy) NSString *TeacherImg;
@property (nonatomic, copy) NSString *TeacherName;



/*
{
    AfterClassStatus = 0;
    AfterClassUrl = "http://file.gogo-talk.com/UploadFiles/Web/courseware/After/A1/A1L2-2/index.html";
    AfterFilePathPad = "/courseware/After/A1/A1L2-2";
    ClassType = 0;
    DemandId = 1149;
    Describe = "to introduce grammar: prepositions-on, under, out, in";
    DetailRecordID = 1149;
    EvaluateContent = "我在这里等你回来测试";
    FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson2-2.png";
    FileTittle = "Unit2_Drink Lesson2-2";
    GiftCount = 0;
    IsComment = 1;
    LessonCount = 4;
    LessonId = 1149;
    LevelName = A1;
    Points = 3;
    StartTime = "2018-01-03 19:40:00";
    StartTimePad = "01月03 (周三) 19:40";
    StudentGender = 1;
    StudentId = 7519;
    StudentList =             (
                               {
                                   AttendLessonID = 1616;
                                   Gender = 1;
                                   HeadImg = "<null>";
                                   StudentID = 7519;
                               }
                               );
    StudentStatus = 3;
    TeacherGender = 0;
    TeacherId = 332;
    TeacherImg = "http://testht.hi-fan.cn//tchheadimages/192_20170910184116749.png";
    TeacherName = Lou;
}
*/


@end
