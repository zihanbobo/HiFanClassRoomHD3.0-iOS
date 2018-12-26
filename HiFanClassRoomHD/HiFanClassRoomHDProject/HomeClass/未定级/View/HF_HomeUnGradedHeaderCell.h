//
//  HF_HomeUnGradedHeaderCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/26.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GonglueBtnBlock)(void);
@interface HF_HomeUnGradedHeaderCell : UITableViewCell
@property (nonatomic, copy) GonglueBtnBlock gonglueBtnBlock;
@end
