//
//  NSArray+Log.m
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//


#import "NSArray+Log.h"
#import "NSString+unicode.h"
#import <objc/runtime.h>

@implementation NSArray (Log)

#ifdef DEBUG
- (NSString *)descriptionWithLocale:(id)locale{
    return self.debugDescription;
}

- (NSString *)xy_debugDescription{
    return self.xy_debugDescription.unicodeString;
}

+ (void)load{
    [self swapMethod];
}

+ (void)swapMethod{
    Method method1 = class_getInstanceMethod(self, @selector(debugDescription));
    Method method2 = class_getInstanceMethod(self, @selector(xy_debugDescription));
    
    method_exchangeImplementations(method1, method2);
}
#endif

@end
