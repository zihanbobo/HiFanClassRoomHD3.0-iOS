//
//  GGT_OrderClassCollectionViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/11/27.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_OrderClassCollectionViewCell.h"

@interface GGT_OrderClassCollectionViewCell()
//教材图片
@property (nonatomic, strong) UIImageView *teachingImgView;
//未解锁图片所在的view
@property (nonatomic, strong) UIView *unLockView;
//级别
@property (nonatomic, strong) UILabel *levelLabel;
//课程名称
@property (nonatomic, strong) UILabel *classNameLabel;
//预约状态
@property (nonatomic, strong) UIImageView *orderImgView;
//完成状态
@property (nonatomic, strong) UIImageView *finishImgView;
@end


@implementation GGT_OrderClassCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark 初始化界面
- (void)initView {
    //对CollectionCell进行裁切
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = LineW(10);
    self.contentView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //教材图片
    self.teachingImgView = [[UIImageView alloc]init];
    self.teachingImgView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    self.teachingImgView.frame = CGRectMake(0, 0, self.contentView.width, LineH(166));
    [self.contentView addSubview:self.teachingImgView];

    
    //未解锁图片
    self.unLockView = [[UIView alloc]init];
    self.unLockView.frame = CGRectMake(0, 0, self.teachingImgView.width, self.teachingImgView.height);
    self.unLockView.backgroundColor = [UICOLOR_FROM_HEX(0x000000) colorWithAlphaComponent:0.3f];
    [self.teachingImgView addSubview:self.unLockView];

    
    //锁 48*57
    UIImageView *lockImgView = [[UIImageView alloc]init];
    lockImgView.frame = CGRectMake((self.unLockView.width-LineW(48))/2, (self.unLockView.height-LineH(57))/2, LineW(48), LineH(57));
    lockImgView.image = UIIMAGE_FROM_NAME(@"锁.png");
    [self.unLockView addSubview:lockImgView];
    self.unLockView.hidden = YES;

    
    //已预约
    self.orderImgView = [[UIImageView alloc]init];
    self.orderImgView.frame = CGRectMake(self.contentView.width - LineW(65), LineH(15), LineW(65), LineH(28));
    self.orderImgView.image = UIIMAGE_FROM_NAME(@"已预约.png");
    [self.contentView addSubview:self.orderImgView];
    self.orderImgView.hidden = YES;

   
    //级别
    UIView *levelView = [[UIView alloc]init];
    levelView.frame = CGRectMake(LineX(11), self.teachingImgView.height + LineY(10), LineW(40), LineH(26));
    levelView.layer.masksToBounds = YES;
    levelView.layer.cornerRadius = LineH(13);
    levelView.layer.borderWidth = LineW(1);
    levelView.layer.borderColor = UICOLOR_FROM_HEX(Color2B8EEF).CGColor;
    levelView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(43, 142, 239, 0.1);
    [self.contentView addSubview:levelView];

    
    self.levelLabel = [[UILabel alloc]init];
    self.levelLabel.frame = CGRectMake(0, LineY(3), levelView.width, LineH(20));
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = Font(16);
//    self.levelLabel.text = @"A1";
    self.levelLabel.textColor = UICOLOR_FROM_HEX(Color2B8EEF);
    [levelView addSubview:self.levelLabel];
    

    //课程名称
    self.classNameLabel = [[UILabel alloc]init];
    self.classNameLabel.textAlignment = NSTextAlignmentLeft;
    self.classNameLabel.font = Font(18);
//    self.classNameLabel.text = @"Lesson1-1";
    self.classNameLabel.textColor = UICOLOR_FROM_HEX(0x0D0101);
    [self.contentView addSubview:self.classNameLabel];

    
    //已完成
    self.finishImgView = [[UIImageView alloc]init];
    self.finishImgView.image = UIIMAGE_FROM_NAME(@"finished.png");
    [self.contentView addSubview:self.finishImgView];
    self.finishImgView.hidden = YES;

}


- (void)getModel:(GGT_UnitBookListModel *)model {
    //教材图片
    if ([model.FilePath isKindOfClass:[NSString class]] && model.FilePath.length >0) {
        [self.teachingImgView sd_setImageWithURL:[NSURL URLWithString:model.FilePath] placeholderImage:UIIMAGE_FROM_NAME(@"默认") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            image = [image imageScaledToSize:CGSizeMake(LineW(203), LineW(152))];
            self.teachingImgView.image = image;
        }];
    }

    //级别
    self.levelLabel.text = [NSString stringWithFormat:@"%@",model.LevelName];
    
    
    //课程名称
    NSRange range;
    range = [model.FileTittle rangeOfString:@" "];
    if (range.location != NSNotFound) {
        NSString *titleStr = [model.FileTittle substringFromIndex:range.location];//截取下标 之后的字符串
        self.classNameLabel.text = titleStr;
    }else{
        //Not Found
        self.classNameLabel.text = model.FileTittle;
    }
    
    
    //未解锁图片 IsUnlock 0是未解锁，1是已解锁--如果未解锁的情况下，完成和预约的状态就不走了
    if (model.IsUnlock == 0) {
        self.unLockView.hidden = NO;
        self.classNameLabel.frame = CGRectMake(LineX(60), LineY(179), self.contentView.width-LineW(70), LineH(20));
        self.orderImgView.hidden = YES;
        self.finishImgView.hidden = YES;

        return;
    } else {
        self.unLockView.hidden = YES;
    }
    
    
    //预约状态 IsReservation 1：已预约  0：未预约
     if (model.IsReservation == 0) {
         self.orderImgView.hidden = YES;
    } else {
        self.orderImgView.hidden = NO;
    }
    

    
    //已完成 IsComplete 1：已完成  0：未完成
    if (model.IsComplete == 0) {
        self.finishImgView.hidden = YES;
        
        self.classNameLabel.frame = CGRectMake(LineX(60), LineY(179), self.contentView.width-LineW(70), LineH(20));

    } else {
        self.finishImgView.hidden = NO;
        self.classNameLabel.frame = CGRectMake(LineX(60), LineY(179), self.contentView.width-LineW(117), LineH(20));
        self.finishImgView.frame = CGRectMake(self.contentView.width - LineY(55), LineY(167), LineW(46), LineH(43));
    }
    
    
}

@end
