//
//  GGT_OrderUnitCourseCollectionCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/28.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_OrderUnitCourseModel.h"
#import "GGT_StudentIconModel.h"

@interface GGT_OrderUnitCourseCollectionCell : UICollectionViewCell
//加入  按钮
@property (nonatomic, strong) UIButton *joinButton;

- (void)getCellModel:(GGT_OrderUnitCourseModel *)OrderUnitCourseModel;
@end
