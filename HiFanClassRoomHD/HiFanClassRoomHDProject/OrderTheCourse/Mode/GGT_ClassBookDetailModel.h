//
//  GGT_ClassBookDetailModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/30.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ClassBookDetailModel : NSObject
@property (nonatomic, assign) NSInteger BDEId;
@property (nonatomic, assign) NSInteger DemandId;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, assign) NSInteger DetailRecordID;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, assign) NSInteger LessionId;
@property (nonatomic, copy) NSString *LevelName;

@property (nonatomic, assign) NSInteger OpenClassType; //1 加入班级  2 申请开班
@property (nonatomic, assign) NSInteger ResidueNum;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StartTimePad;

@property (nonatomic, copy) NSString *Time;
@property (nonatomic, copy) NSString *shareUrl;

// 直播上课的信息
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *userrole;


/*
 BDEId = 9;
 DemandId = 0;
 Describe = "to introduce grammar: prepositions-on, under, out, in";
 DetailRecordID = 0;
 FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson2-2.png";
 FileTittle = "Unit2_Drink Lesson2-2";
 LessionId = 0;
 LevelName = A1;
 OpenClassType = 1;
 ResidueNum = 0;
 StartTime = "";
 StartTimePad = "02月05日 (周一) 10:23";
 Time = "2018-02-05 10:23";
 host = "global.talk-cloud.net";
 nickname = XieHenry;
 port = 443;
 serial = 0;
 server = global;
 userrole = 2;
 shareUrl = "http://www.baidu.com";
 */


//@property (nonatomic, assign) NSInteger BDEId;
//@property (nonatomic, assign) NSInteger DemandId;
//@property (nonatomic, copy) NSString *Describe;
//@property (nonatomic, assign) NSInteger DetailRecordID;
//@property (nonatomic, copy) NSString *FilePath;
//@property (nonatomic, copy) NSString *FileTittle;
//@property (nonatomic, assign) NSInteger LessionId;
//@property (nonatomic, copy) NSString *LevelName;
//@property (nonatomic, copy) NSString *StartTime;
//@property (nonatomic, copy) NSString *Time;
//// 直播上课的信息
//@property (nonatomic, strong) NSString *host;
//@property (nonatomic, strong) NSString *nickname;
//@property (nonatomic, strong) NSString *port;
//@property (nonatomic, strong) NSString *serial;
//@property (nonatomic, strong) NSString *server;
//@property (nonatomic, strong) NSString *userrole;
//
//
//@property (nonatomic, strong) NSString *userid;
//@property (nonatomic, copy) NSString *StartTimePad;




/*
{
    data =     (
                {
                    BDEId = 4544;
                    DemandId = 0;
                    Describe = "to introduce vocabulary about foods: chocolate, cookie, pizza, sandwich, hamburger, French fries";
                    DetailRecordID = 0;
                    FilePath = "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson1-1.png";
                    FileTittle = "Unit1_Food Lesson1-1";
                    LessionId = 0;
                    LevelName = A1;
                    StartTime = "";
                    Time = "2017-12-27 18:21";
                    host = "global.talk-cloud.net";
                    nickname = "";
                    port = 443;
                    serial = 0;
                    server = global;
                    userrole = 2;
                }
                );
    msg = "成功";
    result = 1;
}
 */
@end
