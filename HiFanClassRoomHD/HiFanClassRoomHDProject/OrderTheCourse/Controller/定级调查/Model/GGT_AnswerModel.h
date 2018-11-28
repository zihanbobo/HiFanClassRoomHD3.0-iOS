//
//  GGT_AnswerModel.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/30.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XCAnswerTypeSelect,              // 0    // 选中的cell
    XCAnswerTypeDeselect,         // 1    // 没有预约课
} XCAnswerType;

@interface GGT_AnswerModel : NSObject
@property (nonatomic, strong) NSString *Key;
@property (nonatomic, strong) NSString *Text;
@property (nonatomic, strong) NSString *Value;
@property (nonatomic, assign) XCAnswerType type;
@end

/*
 {
     Key = 1;
     Question = "孩子学习英语已有多久 :";
     QuestionValue =                 (
         {
             Key = 1;
             Text = "1年以下";
             Value = 1;
         },
         {
             Key = 2;
             Text = "1-2年";
             Value = 2;
         },
         {
             Key = 3;
             Text = "2-3年";
             Value = 3;
         },
         {
             Key = 4;
             Text = "3年以上";
             Value = 4;
         }
     );
 }
 */
