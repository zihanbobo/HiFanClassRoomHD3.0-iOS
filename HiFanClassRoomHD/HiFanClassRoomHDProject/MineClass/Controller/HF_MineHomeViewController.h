//
//  HF_MineViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^HiddenBlock)(void);
@interface HF_MineHomeViewController : BaseViewController
@property (nonatomic,copy) HiddenBlock hiddenBlock;

@end
