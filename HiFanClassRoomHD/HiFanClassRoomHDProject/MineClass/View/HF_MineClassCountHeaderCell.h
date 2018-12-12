//
//  HF_MineClassCountHeaderCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/11.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBlock)(void);
@interface HF_MineClassCountHeaderCell : UITableViewCell
@property (nonatomic,copy) BackBlock backBlock;
@end
