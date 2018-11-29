//
//  GGT_GetBookingLevelsModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_GetBookingLevelsModel : NSObject
@property (nonatomic, assign) NSInteger BookingId;
@property (nonatomic, copy) NSString *BookingTitle;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *Introduction;
@property (nonatomic, assign) NSInteger Level;
@property (nonatomic, assign) NSInteger TotalCount;
@property (nonatomic, assign) NSInteger UsedCount;


/*
 BookingId = 160;
 BookingTitle = A1;
 FilePath = "";
 Introduction = "适合6-8岁的儿童学习";
 Level = 1;
 TotalCount = 161;
 UsedCount = 219;
 */


@end
