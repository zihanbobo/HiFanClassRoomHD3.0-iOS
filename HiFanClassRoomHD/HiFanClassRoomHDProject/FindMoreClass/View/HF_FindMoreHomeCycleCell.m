//
//  HF_FindMoreHomeCycleCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/5.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_FindMoreHomeCycleCell.h"

@implementation HF_FindMoreHomeCycleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UIView *bgView = [[UIImageView alloc]init];
    bgView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(17);
        make.right.equalTo(self.contentView.mas_right).with.offset(-17);
        make.top.equalTo(self.contentView.mas_top).with.offset(50);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
    }];
    
}


@end
