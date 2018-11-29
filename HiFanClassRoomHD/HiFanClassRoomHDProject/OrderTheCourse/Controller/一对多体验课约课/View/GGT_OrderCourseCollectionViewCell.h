//
//  GGT_OrderCourseCollectionViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_OrderCourseCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) GGT_DateModel *xc_model;

@end
