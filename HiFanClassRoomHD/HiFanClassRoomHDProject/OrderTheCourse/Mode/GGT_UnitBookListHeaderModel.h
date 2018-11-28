//
//  GGT_UnitBookListHeaderModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/30.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_UnitBookListHeaderModel : NSObject
@property (nonatomic, assign) NSInteger BookingId;
@property (nonatomic, copy) NSString *Introduction;
@property (nonatomic, assign) NSInteger Level;
@property (nonatomic, copy) NSString *LevelName;
@property (nonatomic, assign) NSInteger TotalCount;
@property (nonatomic, assign) NSInteger UseCount;


/*
 {
 BookingId = 1;
 Introduction = "适合6-8岁的儿童学习";
 Level = 1;
 LevelName = A1;
 TotalCount = 15;
 UseCount = 6;
 }
 */
@end
