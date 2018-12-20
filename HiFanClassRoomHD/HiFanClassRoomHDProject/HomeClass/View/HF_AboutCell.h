//
//  HF_AboutCell.h
//  HiFanClassRoomHD
//
//  Created by 何建新 on 2018/12/20.
//  Copyright © 2018 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HF_AboutCell : UITableViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) NSString *content;
@end

NS_ASSUME_NONNULL_END
