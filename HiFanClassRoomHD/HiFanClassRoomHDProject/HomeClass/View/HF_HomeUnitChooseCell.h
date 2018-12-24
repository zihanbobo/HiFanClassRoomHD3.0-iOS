//
//  HF_HomeUnitChooseCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeGetUnitInfoListModel.h"

@interface HF_HomeUnitChooseCell : UICollectionViewCell
//文字
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HF_HomeGetUnitInfoListModel *cellModel;
@property (nonatomic, strong) UIView *rightLineView;


@end
