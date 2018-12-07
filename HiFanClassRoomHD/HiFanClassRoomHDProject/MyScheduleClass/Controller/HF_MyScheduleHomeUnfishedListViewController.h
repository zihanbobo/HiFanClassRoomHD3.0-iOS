//
//  HF_MyScheduleHomeUnfishedListViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/6.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScrollHeightBlock)(CGFloat height);
@interface HF_MyScheduleHomeUnfishedListViewController : BaseViewController
@property (nonatomic,copy) ScrollHeightBlock scrollHeightBlock;
@end
