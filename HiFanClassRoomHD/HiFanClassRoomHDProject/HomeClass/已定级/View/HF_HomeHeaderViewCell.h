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
typedef void(^ClassBeforeBtnBlock1)(NSInteger index);
typedef void(^CellRightButtonBlock1)(UIButton *button,NSInteger index);

@interface HF_HomeHeaderViewCell : UITableViewCell
@property (nonatomic, copy) GonglueBtnBlock gonglueBtnBlock;
@property (nonatomic, copy) ClassDetailVcBlock classDetailVcBlock;
@property (nonatomic,strong) NSMutableArray *collectionDataArray;
@property (nonatomic,strong) ClassBeforeBtnBlock1 classBeforeBtnBlock1; //课前
//@property (nonatomic,strong) ClassAfterBtnBlock1 classAfterBtnBlock1;   //课后
@property (nonatomic,strong) CellRightButtonBlock1 cellRightButtonBlock1;   //课后

















@end
