//
//  HF_MineHomeFooterView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginOutButtonBlock)(void);
@interface HF_MineHomeFooterView : UITableViewCell
@property (nonatomic,copy) LoginOutButtonBlock loginOutButtonBlock;
@end
