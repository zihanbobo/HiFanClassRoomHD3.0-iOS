//
//  GGT_UnitBookListModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_UnitBookListModel : NSObject
@property (nonatomic, assign) NSInteger BDEId;
@property (nonatomic, assign) NSInteger BookingId;
@property (nonatomic, copy) NSString *Describe;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *FileTittle;
@property (nonatomic, assign) NSInteger IsComplete;
@property (nonatomic, assign) NSInteger IsReservation;
@property (nonatomic, assign) NSInteger IsUnlock;
@property (nonatomic, assign) NSInteger Level;
@property (nonatomic, copy) NSString *LevelName;

/*
 "BDEId": 4544,
 "BookingId": 160,
 "Describe": "to introduce vocabulary about foods: chocolate, cookie, pizza, sandwich, hamburger, French fries",
 "FilePath": "http://file.gogo-talk.com/UploadFiles/Booking/A1/Lesson1-1.png",
 "FileTittle": "Unit1_Food Lesson1-1",
 "IsComplete": 1,
 "IsReservation": 0,
 "IsUnlock": 1,
 "Level": 1,
 "LevelName": "A1"
*/

@end
