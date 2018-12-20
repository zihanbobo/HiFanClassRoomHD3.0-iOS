//
//  HF_Request_URL.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/5/10.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#ifndef HF_Request_URL_h
#define HF_Request_URL_h

//正式地址
//static NSString * const BASE_REQUEST_URL = @"http://hfapi.gogo-talk.com";

//测试地址
static NSString * const BASE_REQUEST_URL = @"http://testapi.hi-fan.cn"; //2.0
//static NSString * const BASE_REQUEST_URL = @"https://hftestapi.gogo-talk.com"; //2.0
//static NSString * const BASE_REQUEST_URL = @"http://117.107.153.200:8080"; //2.0


/*登录注册*/
//登录·
static NSString * const URL_Login = @"/api/APP/Login";


/*首页*/
//轮播课程列表
static NSString * const URL_GetLessonList = @"/api/Resources/GetLessonList";
//获取用户喜欢的资源信息
static NSString * const URL_GetLikeList = @"/api/Resources/GetLikeList";
//更新喜欢记录
static NSString * const URL_UpdataLike = @"/api/Resources/updataLike";
//根据Level获取对应的unit信息
static NSString * const URL_GetUnitInfoList = @"/api/Resources/GetUnitInfoList";




/*发现*/
//获取广告位轮播图列表
static NSString * const URL_GetAdvertPositionList = @"api/Resources/GetAdvertPositionList";
//获取教学资源类型
static NSString * const URL_GetInstructionalTypeList = @"api/Resources/GetInstructionalTypeList";
//获取对应类型的教学资源
static NSString * const URL_GetInstructionalInfoList = @"api/Resources/GetInstructionalInfoList";




/*课表*/
//申请中
static NSString * const URL_GetSubscribeLessonMyLess = @"api/homepage/GetSubscribeLessonMyLess";
//未完成
static NSString * const URL_GetNotMyLess = @"api/homepage/GetNotMyLess";
//已完成
static NSString * const URL_GetCompleteMyLess = @"api/homepage/GetCompleteMyLess";
//课程详情
static NSString * const URL_GetLessonDeatil = @"api/homepage/GetLessonDeatil";
//学生对老师的评价
static NSString * const URL_Tch_Comment = @"api/homepage/Tch_Comment";
//课前预习
static NSString * const URL_AddBeforeLog = @"api/Lesson/AddBeforeLog";
//课后练习
static NSString * const URL_AddAfterLog = @"api/Lesson/AddAfterLog";
//课程详情-获取评价信息
static NSString * const URL_GetCompleteLessonInfo = @"api/HomePage/GetCompleteLessonInfo";
//获取常用语句
static NSString * const URL_GetContrastInfo = @"api/APP/GetContrastInfo";



/*约课*/
//获取时间
static NSString * const URL_GetDate = @"api/homepage/GetDay";
//正式学员和体验课学员的判断
static NSString * const URL_IsOfficial = @"api/App/IsOfficial";
//检查是否有课时
static NSString * const URL_CheckClassHour = @"api/App/CheckClassHour";
//判断是否定级过
static NSString * const URL_GetRecommendedCourses = @"api/HomePage/GetRecommendedCourses";
/*体验课*/
//推荐的课程
static NSString * const URL_GetLessonRoomN = @"api/Demands/GetLessonRoomN";
//分级调查数据
static NSString * const URL_AppGetSurvey = @"api/App/AppGetSurvey";
//提交分级数据，获取信息
static NSString * const URL_GradeInvestigation = @"api/HomePage/GradeInvestigation";
//是否是第一次登录体验课
static NSString * const URL_SearchFirstLogin = @"api/App/SearchFirstLogin";
//已确认-取消体验课弹窗
static NSString * const URL_SetFirstLogin = @"api/App/SetFirstLogin";
/*正课*/
//获取教材等级列表--popVc
static NSString * const URL_GetBookList = @"api/homepage/GetBookList";
//获取当前的定级以及课程数量，使用情况---正课header
static NSString * const URL_GetBookOverInfo = @"api/HomePage/GetBookOverInfo";
//所选定级的教材
static NSString * const URL_GetUnitBookList = @"Api/HomePage/GetUnitBookList";
//二级界面
//当前章节课程是否有约课
static NSString * const URL_GetClassBookDetails = @"api/Demands/ClassBookDetails";

//获取可预约的课表
//static NSString * const URL_GetLessonRoom = @"Api/Demands/GetLessonRoom";
static NSString * const URL_GetAttendLessonList = @"Api/Demands/GetAttendLessonList";

//加入房间---约课
//static NSString * const URL_JoinLessonRoom = @"Api/Demands/JoinLessonRoom";
static NSString * const URL_JoinAttendLesson = @"Api/Demands/JoinAttendLesson";

//申请开班
static NSString * const URL_JoinSubscribeLesson = @"Api/Demands/JoinSubscribeLesson";
//本月取消次数
static NSString * const URL_CancelLessonCount = @"Api/Demands/CancelLessonCount";
//取消约课
static NSString * const URL_CancelLesson = @"Api/Demands/CancelLesson";





/*我的*/
//获取课程统计信息
static NSString * const URL_GetLessonStatistics = @"/api/APP/GetLessonStatistics";
//获取左侧选项数据
static NSString * const URL_GetInfo = @"/api/APP/GetInfo";
//获取我的课时
static NSString * const URL_GetMyClassHour = @"/api/APP/GetMyClassHour";
static NSString * const URL_GetClassHourPage = @"/api/Lesson/GetClassHourPage";

//获取学生信息列表
static NSString * const URL_GetStudentInfo = @"/api/APP/AppGetStudentInfo";



/*特殊接口*/
// 获取baseURL
static NSString * const URL_GetUrl = @"Api/app/GetUrl";
// 版本更新接口
static NSString * const URL_VersionUpdateNew = @"api/APP/VersionUpdateNew";
// 获取人工检测设备的房间信息
static NSString * const URL_GetOnlineInfns = @"api/APP/GetOnlineInfns";
//进入教室的记录日志
static NSString * const URL_AppEntryRoomLessonInOutRecord = @"api/APP/AppEntryRoomLessonInOutRecord";


/*************以下接口暂时无用*****************************/
/*登录注册*/
//注册
static NSString * const URL_Resigt = @"/api/APP/AppRegist";
//app 发送短信验证码
static NSString * const URL_GetChangePasswordSMS = @"/api/APP/AppSendChangePwdSMS";
//修改密码（根据手机号修改密码）
static NSString * const URL_ChangePwdByCode = @"/api/APP/AppChangePwdByCode";

#endif /* HF_Request_URL_h */
