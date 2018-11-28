//
//  GGT_ScheduleStudentIconView.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2017/12/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ScheduleStudentIconView.h"


@interface GGT_ScheduleStudentIconView() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end



@implementation GGT_ScheduleStudentIconView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCollectionView];
    }
    return self;
}


- (void)getCellArr:(NSArray *)array {
    
    [self.dataArray removeAllObjects];
    self.dataArray = [NSMutableArray array];
    
    for (NSDictionary *bigdic in array) {
        GGT_ScheduleStudentModel *model = [GGT_ScheduleStudentModel yy_modelWithDictionary:bigdic];
        [self.dataArray addObject:model];
    }
    
    [_collectionView reloadData];
}


#pragma mark 初始化UICollectionView
- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource =self;
    _collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];


    //注册cell
    [_collectionView registerClass:[GGT_ScheduleStudentIconViewCell class] forCellWithReuseIdentifier:@"GGT_ScheduleStudentIconViewCell"];
}


#pragma mark -- UICollectionViewDelegate-------------
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"GGT_ScheduleStudentIconViewCell";
    GGT_ScheduleStudentIconViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell initWithFrame:cell.frame withHeight:self.viewHeight];

    
    
    GGT_ScheduleStudentModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    [cell getModel:model];
    
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewHeight == LineH(56)) {
        return CGSizeMake(self.viewHeight,self.viewHeight);
    } else if (self.viewHeight == LineH(133)) {
        return CGSizeMake(LineW(100),LineH(133));
    }
    return CGSizeMake(0,0);
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    if (self.viewHeight == LineH(56)) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (self.viewHeight == LineH(133)) {
        return UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.viewHeight == LineH(56)) {
        return margin10;
    } else if (self.viewHeight == LineH(133)) {
        return margin44;
    }
    return 0;
}

@end




#pragma mark----GGT_ScheduleStudentIconViewCell
@interface GGT_ScheduleStudentIconViewCell()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@end 

@implementation GGT_ScheduleStudentIconViewCell

- (instancetype)initWithFrame:(CGRect)frame withHeight:(CGFloat)height{
    if (self = [super initWithFrame:frame]) {
        [self initUI:height];
    }
    return self;
}


- (void)initUI:(CGFloat)height {
    
    //学生头像
    self.iconImgView = [UIImageView new];
    self.iconImgView.image = UIIMAGE_FROM_NAME(@"kb_iconList");
    [self.contentView addSubview:self.iconImgView];
    
    //学生姓名
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"Student";
    self.nameLabel.font = Font(18);
    self.nameLabel.textColor = UICOLOR_FROM_HEX(Color4A4A4A);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    
    
    if (height == LineH(56)) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.iconImgView.layer.masksToBounds = YES;
        self.iconImgView.layer.cornerRadius = LineH(28);

    } else {
        self.iconImgView.layer.masksToBounds = YES;
        self.iconImgView.layer.cornerRadius = LineH(50);
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(LineH(100));
        }];
        
        
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView.mas_bottom).offset(LineY(8));
            make.left.equalTo(self.contentView.mas_left).offset(LineX(0));
            make.right.equalTo(self.contentView.mas_right).offset(-LineX(0));
            make.height.mas_equalTo(LineH(25));
        }];
    }

}



- (void)getModel:(GGT_ScheduleStudentModel *)model {
    //如果model为空，代表没有学生预约，需要显示默认头像
    if ((model== nil) || ([model isEqual:[NSNull null]])) {
        self.iconImgView.image = UIIMAGE_FROM_NAME(@"kb_iconList");
        return;
    }
    
    //Gender 0女 girl  1男 boy
    if (model.Gender == 0) {
        if (IsStrEmpty(model.HeadImg)) {
            self.iconImgView.image = UIIMAGE_FROM_NAME(@"girl");
        } else {
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"girl")];
        }
        
    } else {
        if (IsStrEmpty(model.HeadImg)) {
            self.iconImgView.image = UIIMAGE_FROM_NAME(@"boy");
        } else {
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.HeadImg]] placeholderImage:UIIMAGE_FROM_NAME(@"boy")];
        }
    }
    
    
    if (!IsStrEmpty(model.EName)) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.EName];
    }
    
}


@end
