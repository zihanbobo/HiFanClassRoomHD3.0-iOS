//
//  HF_HomeUnitChooseView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeUnitChooseCell.h"

typedef void(^SelectedUnitIdBlock)(NSInteger unitId);
@interface HF_HomeUnitChooseView : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectionUnitArray;
@property (nonatomic,copy) SelectedUnitIdBlock selectedUnitIdBlock;
@end
