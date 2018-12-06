//
//  HF_FindMoreHomeContentCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSInteger index);
@interface HF_FindMoreHomeContentCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) SelectedBlock selectedBlock;

@end
