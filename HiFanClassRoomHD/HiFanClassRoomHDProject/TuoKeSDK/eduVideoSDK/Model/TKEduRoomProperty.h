//
//  TKEduClassRoomProperty.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKMacro.h"
@interface TKEduRoomProperty : NSObject
//根据课堂返回的信息，可能重新复制
@property(nonatomic,copy) NSString * iRoomId;
@property(nonatomic,copy) NSString * iRoomName;
@property(nonatomic,copy) NSString * defaultServerArea;
@property(nonatomic,assign)RoomType iRoomType;
@property(nonatomic,copy)NSString *iPadLayout;//模板类型
@property(nonatomic,assign)UserType iUserType;
@property(nonatomic,copy) NSString  *iUserId;
@property(nonatomic,copy) NSString  *iCompanyID;
@property(nonatomic,strong) NSNumber  *iMaxVideo;
@property(nonatomic,assign) NSTimeInterval iEndTime;
@property(nonatomic,assign) NSTimeInterval iStartTime;
@property(nonatomic,assign) NSTimeInterval iCurrentTime;
@property(nonatomic,assign) NSTimeInterval iHowMuchTimeServerFasterThenMe;
//自定义白板颜色
@property (nonatomic,assign) NSNumber *whiteboardcolor;
//根据用户设置的信息，
@property(nonatomic,copy) NSString * sWebIp;
@property(nonatomic,copy) NSString * sWebPort;
@property(nonatomic,copy) NSString * sNickName;
@property(nonatomic,copy) NSString * sDomain;
@property(nonatomic,copy) NSString * sMeetingID;
@property(nonatomic,copy) NSString * sCmdPassWord;
@property(nonatomic,copy) NSString * sAuth;
@property(nonatomic,copy) NSString * sTS;
@property(nonatomic,copy) NSString * sLinkName;
@property(nonatomic,copy) NSString * sLinkUrl;
@property(nonatomic,copy) NSString * chairmanControl;

@property(nonatomic,assign) int  u32OtherID;
//用户自己设置的

@property(nonatomic,assign) int  sCmdUserRole;
@property(nonatomic,assign) int  sIsLiving;
@property(nonatomic,assign) bool  instFlag;
@property(nonatomic,assign) bool  bHorizontalScreen;
@property(nonatomic,assign) bool  bHideSelf;
@property(nonatomic,assign) bool  enableProximitySensor;
@property(nonatomic,assign) bool  videoType;

-(void)parseMeetingInfo:(NSDictionary*) params;
@end
