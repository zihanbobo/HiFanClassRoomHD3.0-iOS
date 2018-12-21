//
//  HF_HomeUnitChooseView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeUnitChooseCell.h"

@interface HF_HomeUnitChooseView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@end
