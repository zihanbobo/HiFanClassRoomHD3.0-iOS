//
//  GGT_DateModel.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/29.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCCellITypeSelect,              // 0    // 选中的cell
    XCCellTypeDeselect,         // 1    // 没有预约课
} XCCellType;

@interface GGT_DateModel : NSObject
@property (nonatomic, assign) XCCellType selectType;
@property (nonatomic, assign) NSInteger IsPuncTuation;
@property (nonatomic, strong) NSString *Time;
@property (nonatomic, strong) NSString *WeekDay;
@property (nonatomic, strong) NSString *DateTime;
@end

/*
 IsPuncTuation = 0;     是否为周六或者周日 1是 0不是
 Time = "12-08";
 WeekDay = "周五";
 DateTime = "2017-12-12";
 */
