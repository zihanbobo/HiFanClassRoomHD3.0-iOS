//
//  HF_HomeHeaderModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_HomeHeaderModel : NSObject
@property (nonatomic, assign) NSInteger AttendLessonID;
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, assign) NSInteger ChapterID;
@property (nonatomic, copy) NSString *ChapterImagePath;
@property (nonatomic, copy) NSString *ChapterName;
@property (nonatomic, copy) NSString *LessonTime;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, copy) NSString *MonthOrWeek;
@property (nonatomic, copy) NSString *Nickname;
@property (nonatomic, assign) NSInteger StatusName; //0 是未开始  1 上课中 2 即将开始 3 已结束
@property (nonatomic, copy) NSString *TimeSpan;


@property (nonatomic, strong) NSString *Host;
@property (nonatomic, strong) NSString *Port;
@property (nonatomic, strong) NSString *RecordID;
@property (nonatomic, strong) NSString *Serial;
@property (nonatomic, strong) NSString *Server;
@property (nonatomic, strong) NSString *Userrole;



//AttendLessonID = 4012;
//BeforeFilePath = "https://file.gogo-talk.com/UploadFiles/Web/courseware/Before/A0/H5A0-U1-L4/index.html";
//ChapterID = 226;
//ChapterImagePath = "http://file.gogo-talk.com/UploadFiles/Booking/A0/Images/A0-1-4.png";
//ChapterName = "Unit1_Numbers Lesson1-4";
//Host = "global.talk-cloud.net";
//LessonTime = "2018-11-20T16:30:00";
//LevelName = A0;
//MonthOrWeek = "11月20日 （周二）";
//Nickname = XieHenry;
//Port = 80;
//RecordID = 3287;
//Serial = 654386379;
//Server = global;
//StatusName = 3;
//TimeSpan = "16:30";
//Userrole = 2;

@end
