//
//  HF_MineHomeInfoModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/12.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_MineHomeInfoModel : NSObject
//缺席
@property (nonatomic, assign) NSInteger AbsentCount;
//已说
@property (nonatomic, assign) NSInteger AccumulateCount;
@property (nonatomic, assign) NSInteger Age;
@property (nonatomic, assign) NSInteger ClassHour;
@property (nonatomic, copy) NSString *EName;
@property (nonatomic, copy) NSString *ExpireTime;
@property (nonatomic, assign) NSInteger Gender;
@property (nonatomic, assign) NSInteger GiftCount;
//头像
@property (nonatomic, copy) NSString *HeadImg;
//迟到
@property (nonatomic, assign) NSInteger LateCount;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, assign) NSInteger TotalPoints;
@property (nonatomic, assign) NSInteger UserCategory;
@property (nonatomic, strong) NSArray *dicList;
//剩余课程
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, copy) NSString *Level;

/*
 AbsentCount = 0;
 AccumulateCount = 0;
 Age = 1;
 ClassHour = 0;
 EName = aaaaaa;
 ExpireTime = "";
 Gender = 1;
 GiftCount = 0;
 HeadImg = "";
 ImageUrl = "";
 LateCount = 0;
 Name = Student;
 TotalPoints = 0;
 UserCategory = 0;
 dicList =         (
 {
 name = "个人信息";
 pic = "Personal_information";
 },
 {
 name = "我的课时";
 pic = class;
 },
 {
 name = "设置";
 pic = "Set_up_the";
 }
 );
 
 totalCount = 0;
 */
@end
