//
//  HF_MineHomeTableViewCell.h
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/10.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HF_MineHomeTableViewCell : UITableViewCell
@property (nonatomic,copy) NSString *leftLabelString;
@property (nonatomic, strong) UILabel *rightLabel;    //说明
@property (nonatomic, strong)UIImageView *enterImgView;
@end
