//
//  HF_MineHomeHeaderCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_MineHomeInfoModel.h"

typedef void(^BackBlock)(void);
@interface HF_MineHomeHeaderCell : UITableViewCell
@property (nonatomic,copy) BackBlock backBlock;
@property (nonatomic,strong) HF_MineHomeInfoModel *cellModel;
@end
