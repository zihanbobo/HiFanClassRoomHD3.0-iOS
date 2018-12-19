//
//  HF_HomeHeaderView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HF_HomeHeaderModel.h"

typedef void(^GonglueBtnBlock)(void);
typedef void(^ClassDetailVcBlock)(void);
@interface HF_HomeHeaderView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy) GonglueBtnBlock gonglueBtnBlock;
@property (nonatomic, copy) ClassDetailVcBlock classDetailVcBlock;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectionDataArray;

@end
