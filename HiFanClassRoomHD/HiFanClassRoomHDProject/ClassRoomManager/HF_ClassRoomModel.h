//
//  HF_ClassRoomModel.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/28.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HF_ClassRoomModel : NSObject

@property (nonatomic, assign) NSInteger LessonId;

// 直播上课的信息
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *userrole;

@end
