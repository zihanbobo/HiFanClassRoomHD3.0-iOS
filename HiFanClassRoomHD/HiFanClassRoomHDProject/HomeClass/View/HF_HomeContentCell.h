//
//  HF_HomeContentCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/18.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeUnitCellModel.h"

typedef void(^SelectedBlock)(NSInteger index);
@interface HF_HomeContentCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) SelectedBlock selectedBlock;
@property (nonatomic,strong) NSMutableArray *collectionArray;
@end

