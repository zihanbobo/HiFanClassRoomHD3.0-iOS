//
//  HF_MyScheduleHomeUnFinishedListModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_MyScheduleHomeUnFinishedListModel : NSObject
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, copy) NSString *BeforeFilePathPad;
@property (nonatomic, assign) NSInteger BeforeState;
@property (nonatomic, assign) NSInteger ClassType; //0 非付费 正式学员    2 付费 正式学员  1 体验学员
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, assign) NSInteger DemandId;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, assign) NSInteger DetailRecordID; //详情，取消预约，评价
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, assign) NSInteger LessonId;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, assign) NSInteger Num;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StartTimePad;
@property (nonatomic, assign) NSInteger StatusName;
@property (nonatomic, strong) NSArray *StudentList;

// 直播上课的信息
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *userrole;


/*
 {
 BeforeFilePath = "http://file.gogo-talk.com/UploadFiles/Web/courseware/Before/A1/A1-U3-L2/index.html";
 BeforeFilePathPad = "/courseware/Before/A1/A1-U3-L2";
 BeforeState = 0;
 ClassType = 0;
 CreateTime = "2018-01-04 10:40:04";
 DemandId = 1639;
 Describe = "to introduce grammar: articles-a, an, the";
 DetailRecordID = 1161;
 FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson3-2.png";
 FileTittle = "Unit3_Fruit Lesson3-2";
 LessonId = 1639;
 LevelName = A1;
 Num = 2;
 StartTime = "2018-01-04 15:20";
 StartTimePad = "01月04 (周四) 15:20";
 StatusName = 0;
 StudentList =             (
 {
 AttendLessonID = 1639;
 Gender = 1;
 HeadImg = "";
 StudentID = 7519;
 },
 {
 AttendLessonID = 1639;
 Gender = 0;
 HeadImg = "http://testapi.hi-fan.cn/CodeImage/1514975989477.jpg";
 StudentID = 8526;
 }
 );
 host = "global.talk-cloud.net";
 nickname = xiaoran;
 port = 443;
 serial = 0;
 server = global;
 userrole = 2;
 }
 */
@end
