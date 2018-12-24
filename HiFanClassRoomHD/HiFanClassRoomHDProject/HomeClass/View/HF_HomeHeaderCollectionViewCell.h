//
//  HF_HomeHeaderCollectionViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeHeaderModel.h"

typedef void(^ClassBeforeBtnBlock)(void); //课前
typedef void(^CellRightButtonBlock)(UIButton *button);  //课后---进入教室
@interface HF_HomeHeaderCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) HF_HomeHeaderModel *cellModel;
@property (nonatomic,strong) ClassBeforeBtnBlock classBeforeBtnBlock;    //课前
@property (nonatomic,strong) CellRightButtonBlock cellRightButtonBlock;  //课后---进入教室
//倒计时
@property (nonatomic, assign) NSInteger countDown;
@end
