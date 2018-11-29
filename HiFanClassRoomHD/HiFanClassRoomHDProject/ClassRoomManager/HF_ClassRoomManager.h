//
//  HF_ClassRoomManager.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/28.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HF_ClassRoomModel.h"

typedef void(^TKLeftClassroomBlock)(void);
@interface HF_ClassRoomManager : NSObject

+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(HF_ClassRoomModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock;

@end
