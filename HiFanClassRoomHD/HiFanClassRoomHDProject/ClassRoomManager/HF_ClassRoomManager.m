//
//  HF_ClassRoomManager.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/28.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import "HF_ClassRoomManager.h"

// 拓课
#import "TKEduClassRoom.h"
#import "TKMacro.h"
#import "TKUtil.h"


@interface HF_ClassRoomManager ()<TKEduRoomDelegate>
@property (nonatomic, copy) TKLeftClassroomBlock xc_leftRoomBlock;
@end

@implementation HF_ClassRoomManager 

+ (instancetype)share {
    static HF_ClassRoomManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

#pragma mark - 进入拓课的方法
+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(HF_ClassRoomModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock {
    HF_ClassRoomManager *manager = [HF_ClassRoomManager share];
    [manager enterTKClassroomWithCourseModel:model viewController:viewController];
    manager.xc_leftRoomBlock = leftRoomBlock;
}


- (void)enterTKClassroomWithCourseModel:(HF_ClassRoomModel *)model viewController:(UIViewController *)viewController {
    
        //增加上课记录的日志
        NSString *urlStr = [NSString stringWithFormat:@"%@?attendLessonID=%ld",URL_AppEntryRoomLessonInOutRecord,(long)model.LessonId];
        [[BaseService share] sendGetRequestWithPath:urlStr token:YES viewController:viewController showMBProgress:NO success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    
    
    
    //    model.serial = @"755158726";
    //    model.serial = @"240966698";
    //    model.nickname = @"student";
    //    model.host = sHost;
    
    //port  2.1.0为443，2.1.8为80，需要后台返回不同的信息，暂时写死（后台不好操作）
    NSLog(@"serial:%@ host:%@ userid:%@ port:%@ nickname:%@ userrole:%@",model.serial,model.host,[UserDefaults() objectForKey:K_AccountID],model.port,model.nickname,model.userrole);
    
    
    NSDictionary *tDict;
    model.port = @"80";
    if (!IsStrEmpty([UserDefaults() objectForKey:K_AccountID])) {
        tDict = @{
                  @"serial"   :model.serial,
                  @"host"    :model.host,
                  @"userid"  :[UserDefaults() objectForKey:K_AccountID],
                  @"port"    :model.port,
                  @"nickname":model.nickname,    // 学生密码567
                  @"userrole":model.userrole,    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                  @"server":@"global",
                  @"playback":@"0"
                  };
    } else {
        tDict = @{
                  @"serial"   :model.serial,
                  @"host"    :model.host,
                  @"port"    :model.port,
                  @"nickname":model.nickname,    // 学生密码567
                  @"userrole":model.userrole,    //用户身份，0：老师；1：助教；2：学生；3：旁听；4：隐身用户
                  @"server":@"global",
                  @"playback":@"0"
                  };
    }
    
    
    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:viewController Delegate:self isFromWeb:NO];
}


#pragma mark TKEduEnterClassRoomDelegate
//error.code  Description:error.description
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc {
    TKLog(@"-----onEnterRoomFailed");
}

- (void) onKitout:(EKickOutReason)reason {
    TKLog(@"-----onKitout");
}

- (void) joinRoomComplete {
    TKLog(@"-----joinRoomComplete");
}

- (void) leftRoomComplete {
    TKLog(@"-----leftRoomComplete");
}

- (void) onClassBegin {
    TKLog(@"-----onClassBegin");
}
- (void) onClassDismiss {
    NSLog(@"-----onClassDismiss");
}

- (void) onCameraDidOpenError {
    TKLog(@"-----onCameraDidOpenError");
}

@end
