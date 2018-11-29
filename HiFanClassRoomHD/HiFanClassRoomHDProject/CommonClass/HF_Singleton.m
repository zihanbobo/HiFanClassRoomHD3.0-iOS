//
//  HF_Singleton.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "HF_Singleton.h"


static HF_Singleton *singleton = nil;
@implementation HF_Singleton

+ (HF_Singleton *)sharedSingleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[HF_Singleton alloc]init];
    });
    
    return singleton;
}


//MARK:获取当前时间
-(NSString *)nowDateString {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowDateString = [dateFomatter stringFromDate:nowDate];
    return nowDateString;
}

//MARK:计算时间差
- (NSTimeInterval )pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime  class:(NSString *)className {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  //根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSLog(@"starTime:%@   endTime:%@",starTime,endTime);
    NSLog(@"控制器:%@====计算时间差:%f",className,time);
    return time;
}
@end
