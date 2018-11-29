//
//  XCLogManager.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/7/4.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCLogManager : NSObject

/// 记录log日志
+ (void)xc_redirectNSlogToDocumentFolder;

/// 读取log日志
+ (void)xc_readDataFromeFile;

/// 删除log日志
+ (void)xc_deleteLogData;

@end
