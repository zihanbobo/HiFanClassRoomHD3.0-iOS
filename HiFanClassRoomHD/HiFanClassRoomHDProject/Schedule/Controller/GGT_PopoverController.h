//
//  GGT_PopoverController.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PopViewDismissBlock)(NSString *selectString);

@interface GGT_PopoverController : BaseViewController
@property (nonatomic, copy) PopViewDismissBlock dismissBlock;
@property (nonatomic, strong) NSMutableArray *xc_phraseMuArray;
@end
