//
//  GGT_ScheduleDetailModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/21.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ScheduleDetailModel : NSObject
@property (nonatomic, assign) NSInteger AfterClassStatus;
@property (nonatomic, copy) NSString *AfterClassUrl;
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, assign) NSInteger BeforeState;
@property (nonatomic, assign) NSInteger ClassType;
@property (nonatomic, assign) NSInteger DemandId;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, assign) NSInteger DetailRecordID;
@property (nonatomic, copy) NSString *EvaluateContent;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, assign) NSInteger GiftCount;
@property (nonatomic, assign) NSInteger IsComment;
@property (nonatomic, assign) NSInteger LessonId;
@property (nonatomic, assign) NSInteger Level;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, assign) NSInteger Points;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StartTimePad;
@property (nonatomic, assign) NSInteger StatusName;
@property (nonatomic, assign) NSInteger StudentCount;
@property (nonatomic, assign) NSInteger StudentId;

@property (nonatomic, strong) NSArray *StudentList;

@property (nonatomic, assign) NSInteger StudentStatus;
@property (nonatomic, assign) NSInteger TeacherGender;
@property (nonatomic, assign) NSInteger TeacherId;
@property (nonatomic, copy) NSString *TeacherImg;
@property (nonatomic, copy) NSString *TeacherName;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, assign) NSInteger OpenClassType;
@property (nonatomic, assign) NSInteger ResidueNum;


// 直播上课的信息
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *userrole;

/*
{
    AfterClassStatus = 0;
    AfterClassUrl = "http://file.gogo-talk.com/UploadFiles/Web/courseware/After/A1/A1L2-2/index.html";
    BeforeFilePath = "http://file.gogo-talk.com/UploadFiles/Web/courseware/Before/A1/A1-U2-L2/index.html";
    BeforeState = 0;
    ClassType = 2;
    DemandId = 1616;
    Describe = "to introduce grammar: prepositions-on, under, out, in";
    DetailRecordID = 1149;
    EvaluateContent = "我在这里等你回来测试";
    FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson2-2.png";
    FileTittle = "Unit2_Drink Lesson2-2";
    GiftCount = 0;
    IsComment = 1;
    LessonId = 1149;
    Level = 1;
    LevelName = A1;
    Points = 3;
    StartTime = "2018-01-03 19:40";
    StartTimePad = "01月03 (周三) 19:40";
    StatusName = 2;
    StudentCount = 3;
    StudentId = 7519;
    StudentList =             (
                               {
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
                               }
                               );
    StudentStatus = 3;
    TeacherGender = 0;
    TeacherId = 332;
    TeacherImg = "http://testht.hi-fan.cn//tchheadimages/192_20170910184116749.png";
    TeacherName = Lou;
    host = "global.talk-cloud.net";
    nickname = xiaoran;
    port = 443;
    serial = 0;
    server = global;
    userrole = 2;
 shareUrl = "http://www.baidu.com";
 OpenClassType = 1;
 ResidueNum = 2;

}
 */

@end
