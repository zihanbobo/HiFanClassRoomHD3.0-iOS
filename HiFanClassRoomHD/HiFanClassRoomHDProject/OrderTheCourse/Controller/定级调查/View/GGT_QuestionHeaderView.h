//
//  GGT_QuestionHeaderView.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/29.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_QuestionHeaderView : UICollectionReusableView
+ (instancetype)headerWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) GGT_QuestionModel *xc_questionModel;

@end
