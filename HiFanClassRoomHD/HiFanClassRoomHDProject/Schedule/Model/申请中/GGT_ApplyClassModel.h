//
//  GGT_ApplyClassModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/8.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ApplyClassModel : NSObject
@property (nonatomic, assign) NSInteger DetailRecordID;
@property (nonatomic, assign) NSInteger LessonId;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StartTimePad;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, assign) NSInteger DemandId;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, assign) NSInteger Num;
@property (nonatomic, strong) NSArray *StudentList;
@property (nonatomic, assign) NSInteger BeforeState;
@property (nonatomic, copy) NSString *BeforeFilePath;
@property (nonatomic, copy) NSString *BeforeFilePathPad;
@property (nonatomic, assign) NSInteger ClassType;
@property (nonatomic, assign) NSInteger StatusName;
@property (nonatomic, assign) NSInteger OpenClassType;
@property (nonatomic, assign) NSInteger ResidueNum;
@property (nonatomic, copy) NSString *shareUrl;

// 直播上课的信息
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *userrole;
@property (nonatomic, strong) NSString *server;


/*
{
    "data": [{
        "DetailRecordID": 25,
        "LessonId": 4,
        "CreateTime": "2018-02-08 16:33:58",
        "StartTime": "2018-02-09 20:40",
        "StartTimePad": "02月09日 (周五) 20:40",
        "LevelName": "A1",
        "FileTittle": "Unit1_Food Lesson1-1",
        "Describe": "to introduce vocabulary about foods: chocolate, cookie, pizza, sandwich, hamburger, French fries",
        "DemandId": 4,
        "FilePath": "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson1-1.png",
        "Num": 2,
        "StudentList": [{
            "AttendLessonID": 4,
            "Gender": 1,
            "StudentID": 10456,
            "HeadImg": ""
        }, {
            "AttendLessonID": 4,
            "Gender": 1,
            "StudentID": 235,
            "HeadImg": "http://testapi.hi-fan.cn/CodeImage/1508222067098.jpg"
        }],
        "BeforeState": 0,
        "BeforeFilePath": "http://file.gogo-talk.com/UploadFiles/Web/courseware/Before/A1/A1-U1-L1/index.html",
        "BeforeFilePathPad": "/courseware/Before/A1/A1-U1-L1",
        "ClassType": 0,
        "StatusName": 0,
        "OpenClassType": 2,
        "ResidueNum": 1,
        "serial": "0",
        "host": "global.talk-cloud.net",
        "port": 443,
        "nickname": "XieHenry",
        "userrole": 2,
        "server": "global"
    }],
}
*/

@end
