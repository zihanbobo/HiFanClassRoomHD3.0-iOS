//
//  GGT_OrderCourseTableViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_OrderCourseTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) GGT_ExperienceCourseModel *xc_model;

// 进入教室按钮
@property (nonatomic, strong) UIButton *xc_enterButton;

@end
