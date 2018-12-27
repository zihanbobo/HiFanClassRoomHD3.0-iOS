//
//  HF_LaunchMovieViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FinishedBlock)(void);
@interface HF_LaunchMovieViewController : BaseViewController
@property (nonatomic,copy) FinishedBlock finishedBlock;
@end
