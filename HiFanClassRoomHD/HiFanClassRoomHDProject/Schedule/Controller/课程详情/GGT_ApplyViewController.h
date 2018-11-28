//
//  GGT_ApplyViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/2.
//  Copyright © 2018年 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SureBlock)(BOOL sure);
@interface GGT_ApplyViewController : BaseViewController

//确定
@property (nonatomic, copy) SureBlock sureBlock;

@property (nonatomic, copy) NSString *classNameStr;
@property (nonatomic, copy) NSString *classTimeStr;
@end
