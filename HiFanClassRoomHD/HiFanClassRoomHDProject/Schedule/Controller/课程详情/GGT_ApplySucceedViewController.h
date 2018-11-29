//
//  GGT_ApplySucceedViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/2.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"

@interface GGT_ApplySucceedViewController : BaseViewController

/**
 申请成功 邀请好友
 */
@property (nonatomic, copy) NSString *classTypeName;


//教材
@property (nonatomic, copy) NSString *jiaocaiStr;
//已申请06-12（周一）18:30 的课程
@property (nonatomic, copy) NSString *chengbanStr;
//二维码
@property (nonatomic, copy) NSString *codeStr;


//申请成功！还差1人开班
@property (nonatomic, copy) NSString *shenqingStr;

@end
