//
//  GGT_OrderUnitCourseModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/30.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGT_StudentIconModel.h"

@interface GGT_OrderUnitCourseModel : NSObject

@property (nonatomic, assign) NSInteger IsMake; //是否可以加入,0=可以加入,1=不可以加入.
@property (nonatomic, copy) NSString *LessonTime;
@property (nonatomic, assign) NSInteger ResidueNum;
@property (nonatomic, assign) NSInteger ShowStatus; //显示状态: 0=申请开班,1=加入班级,2=已满班
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *WeekDay;


/*
 IsMake = 0;
 LessonTime = "2018-02-03T14:40:00";
 ResidueNum = 0;
 ShowStatus = 2;
 StartTime = "14:40";
 WeekDay = "02月03日 (周六) 14:40";
*/

//@property (nonatomic, assign) NSInteger IsMake;
//@property (nonatomic, assign) NSInteger LessonId;
//@property (nonatomic, copy) NSString *StartTime;
//@property (nonatomic, copy) NSString *LesssTime;
//@property (nonatomic, strong) NSArray *StuList;
//@property (nonatomic, assign) NSInteger count;
//@property (nonatomic, assign) NSInteger scount;


/*
{
    LessonId = 2804;
    StartTime = "2017-11-30T16:00:00";
 LesssTime = "06:40";
    StuList =             (
                           {
                               Area = "<null>";
                               Birthday = "<null>";
                               City = "<null>";
                               CreateTime = "<null>";
                               Description = "<null>";
                               EName = "<null>";
                               EnglishLearnAge = 0;
                               Gender = "<null>";
                               HeadImg = "http://learnapi.gogo-talk.com:8333/CodeImage/1508305665612.jpg";
                               InviteNumber = "<null>";
                               IsOrgLearn = 0;
                               IsSetPwd = 0;
                               Levels = "<null>";
                               Mobile = "<null>";
                               Name = "<null>";
                               OpenId = "<null>";
                               OrgId = "<null>";
                               OrgLearnYear = 0;
                               Province = "<null>";
                               Source = "<null>";
                               SourceDetail = "<null>";
                               Status = "<null>";
                               StudentId = 567;
                           }
                           );
    count = 3;
    scount = 3;
}
*/



@end
















