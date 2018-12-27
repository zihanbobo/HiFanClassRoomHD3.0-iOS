//
//  HF_ServiceHomeContentCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/27.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_ServiceHomeContentCell.h"

@implementation HF_ServiceHomeContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        [self initUI];
    }
    return self;
}

-(void)initUI {
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = UIIMAGE_FROM_NAME(@"服务聊天背景");
    [self addSubview:bgImgView];
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
    }];
}


@end
