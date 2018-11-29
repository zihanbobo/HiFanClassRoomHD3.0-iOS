//
//  GGT_ExperienceCourseModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_ExperienceCourseModel : NSObject
@property (nonatomic, strong) NSString *BdId;
@property (nonatomic, strong) NSString *BookingId;
@property (nonatomic, strong) NSString *BookingTitle;
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *Describe;
@property (nonatomic, strong) NSString *FilePath;
@property (nonatomic, strong) NSString *FileTittle;
@property (nonatomic, strong) NSString *LessonId;
@property (nonatomic, strong) NSString *Num;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSString *StartTimePad;
@property (nonatomic, strong) NSString *TiYanTitlePad;
@end

/*
 BdId = 10;
 BookingId = 1;
 BookingTitle = A1;
 CreateTime = "2017-11-29 18:01";
 Describe = "to talk about drinks and review the whole unit";
 FilePath = "/UploadFiles/Booking/A0/Lesson2-3.png";
 FilePathPad = "http://117.107.153.228:806/UploadFiles/Booking/A0/Lesson2-3.png";
 FileTittle = "Unit2_Drink Lesson2-3";
 LessonId = 2793;
 Num = 0;
 StartTime = "2017-11-29 21:20";
 StartTimePad = "21:20开课";
 TiYanTitlePad = "体验课";
 */
