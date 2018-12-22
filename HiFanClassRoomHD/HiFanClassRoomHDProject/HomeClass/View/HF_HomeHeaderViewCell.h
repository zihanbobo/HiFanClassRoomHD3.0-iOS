//
//  HF_HomeHeaderViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeHeaderModel.h"

typedef void(^GonglueBtnBlock)(void);
typedef void(^ClassDetailVcBlock)(NSInteger index);
@interface HF_HomeHeaderViewCell : UITableViewCell
@property (nonatomic, copy) GonglueBtnBlock gonglueBtnBlock;
@property (nonatomic, copy) ClassDetailVcBlock classDetailVcBlock;
@property (nonatomic,strong) NSMutableArray *collectionDataArray;
@end
