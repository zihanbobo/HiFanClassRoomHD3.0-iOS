//
//  GGT_ClassRoomManager.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/28.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGT_ClassRoomModel.h"

typedef void(^TKLeftClassroomBlock)(void);
@interface GGT_ClassRoomManager : NSObject

+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_ClassRoomModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock;

@end
