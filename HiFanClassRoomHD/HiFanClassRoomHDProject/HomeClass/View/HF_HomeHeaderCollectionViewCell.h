//
//  HF_HomeHeaderCollectionViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeHeaderModel.h"

typedef void(^ClassBeforeBtnBlock)(void);
typedef void(^ClassAfterBtnBlock)(void);
@interface HF_HomeHeaderCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) HF_HomeHeaderModel *cellModel;
@property (nonatomic,strong) ClassBeforeBtnBlock classBeforeBtnBlock; //课前
@property (nonatomic,strong) ClassAfterBtnBlock classAfterBtnBlock;   //课后

@end
