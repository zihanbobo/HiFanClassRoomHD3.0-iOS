//
//  HF_Singleton.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/4/26.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGT_UnitBookListHeaderModel.h"

@interface HF_Singleton : NSObject

+ (HF_Singleton *)sharedSingleton;
//是否显示我的界面
@property (nonatomic,assign) BOOL isShowMineView;

//网络状态
@property (nonatomic) BOOL netStatus;

//照相机权限
@property (nonatomic) BOOL cameraStatus;

//麦克风权限
@property (nonatomic) BOOL micStatus;

//我的-我的课时课程数量
@property (nonatomic, copy) NSString *leftTotalCount;

/**
 @abstract 是否在审核状态,YES是审核状态，NO为正式地址
 **/
@property (nonatomic) BOOL isAuditStatus;

// 学生是否在教室
@property (nonatomic) BOOL isInRoom;

//BASE_URL
@property (nonatomic, strong) NSString *base_url;

//是否更新的判断
@property (nonatomic) BOOL isShowVersionUpdateAlert;

//刚定级学员，是否需要重新加载数据,如果不重新加载会造成我的部分缺少数据
@property (nonatomic) BOOL isRefreshSelfInfoData;


//我的-清除缓存的大小
@property (nonatomic, copy) NSString *cacheSize;


/**
 @abstract 获取当前时间
 **/

-(NSString *)nowDateString;
/**
 @abstract 计算时间差
 **/
- (NSTimeInterval )pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime  class:(NSString *)className;


@end
