//
//  GGT_LevelMenuViewController.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^GetBookingIdBlock)(NSString *levelStr,NSInteger bookingIdS);
@interface GGT_LevelMenuViewController : BaseViewController

@property (nonatomic,copy) GetBookingIdBlock getBookingIdBlock;

@end
