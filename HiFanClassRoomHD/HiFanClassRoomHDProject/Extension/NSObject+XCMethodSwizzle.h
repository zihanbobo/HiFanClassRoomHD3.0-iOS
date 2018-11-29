//
//  NSObject+XCMethodSwizzle.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/6/7.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XCMethodSwizzle)

+ (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end
