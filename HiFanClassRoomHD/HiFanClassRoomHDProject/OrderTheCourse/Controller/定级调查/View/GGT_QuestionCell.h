//
//  GGT_QuestionCell.h
//  HiFanClassRoomHD
//
//  Created by 辰 on 2017/11/29.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_QuestionCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) GGT_AnswerModel *xc_answerModel;

@end
