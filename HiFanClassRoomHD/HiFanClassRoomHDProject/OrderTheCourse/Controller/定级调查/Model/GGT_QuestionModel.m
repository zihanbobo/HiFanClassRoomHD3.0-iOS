//
//  GGT_QuestionModel.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/30.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_QuestionModel.h"
#import "GGT_AnswerModel.h"

@implementation GGT_QuestionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"QuestionValue" : [GGT_AnswerModel class]};
}
@end
