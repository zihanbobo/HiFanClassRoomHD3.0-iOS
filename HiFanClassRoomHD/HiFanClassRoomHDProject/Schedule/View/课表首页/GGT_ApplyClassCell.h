//
//  GGT_ApplyClassCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/2/8.
//  Copyright © 2018年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGT_ApplyClassModel.h"

@interface GGT_ApplyClassCell : UITableViewCell
// 取消申请
@property (nonatomic, strong) UIButton *cancleClassButton;
// 邀请好友
@property (nonatomic, strong) UIButton *yaoqingButton;

- (void)getModel:(GGT_ApplyClassModel *)model;
@end
