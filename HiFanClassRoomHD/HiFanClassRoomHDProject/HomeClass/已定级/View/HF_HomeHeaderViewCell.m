//
//  HF_HomeHeaderViewCell.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/12/17.
//  Copyright © 2018 Chn. All rights reserved.
//

#import "HF_HomeHeaderViewCell.h"
#import "HF_HomeHeaderCollectionViewCell.h"
#import "HF_HomeHeaderPlaceHolderView.h"

@interface HF_HomeHeaderViewCell() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BaseScrollHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HF_HomeHeaderPlaceHolderView *placeHolderView;
@end

@implementation HF_HomeHeaderViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


- (void)setCollectionDataArray:(NSMutableArray *)collectionDataArray {
    if (collectionDataArray.count == 0) {
        self.placeHolderView.hidden = NO;
        [self.collectionView addSubview:self.placeHolderView];
        [self.placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.collectionView);
        }];
    } else {
        self.placeHolderView.hidden = YES;
    }
    
    self.dataArray = [NSMutableArray array];
    self.dataArray = collectionDataArray;
    [self reloadData];
}

- (void)reloadData {
    // 网络加载数据
    [kCountDownManager reload];
    // 刷新
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionView代理
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"HF_HomeHeaderCollectionViewCell";
    HF_HomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    HF_HomeHeaderModel *model = [self.dataArray safe_objectAtIndex:indexPath.row];
    cell.cellModel = model;
    
    
    cell.classBeforeBtnBlock = ^{
        if (self.classBeforeBtnBlock1) {
            self.classBeforeBtnBlock1(indexPath.row);
        }
    };
    
    cell.cellRightButtonBlock = ^(UIButton *button) {
        if (self.cellRightButtonBlock1) {
            self.cellRightButtonBlock1(button, indexPath.row);
        }
    };
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(480),LineH(159));
}



//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, LineX(17), 0, LineX(17));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineX(17);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.classDetailVcBlock) {
        self.classDetailVcBlock(indexPath.row);
    }
}

//MARK:UI加载
-(void)initUI {
    // 启动倒计时管理
    [kCountDownManager start];
    
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.height.mas_equalTo(106);
    }];
    
    @weakify(self);
    [[self.headerView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.gonglueBtnBlock) {
             self.gonglueBtnBlock();
         }
     }];
    
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(-0);
        make.bottom.equalTo(self.mas_bottom).offset(-0);
    }];
    
    //注册cell
    [self.collectionView registerClass:[HF_HomeHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"HF_HomeHeaderCollectionViewCell"];
}

//获取时间段
-(NSString *)getTheTimeBucket {
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:12]] == NSOrderedAscending) {
        return @"上午好"; //good morning
    } else if ([currentDate compare:[self getCustomDateWithHour:12]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending) {
        return @"下午好"; //good afternoon
    } else {
        return @"晚上好"; //good evening
    }
}


//MARK:懒加载
-(BaseScrollHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [[BaseScrollHeaderView alloc] init];
        self.headerView.titleLabel.text = [self getTheTimeBucket];
        if ([[self getTheTimeBucket] isEqualToString:@"上午好"]) {
            self.headerView.navBigLabel.text = @"Good Morning";
        } else if ([[self getTheTimeBucket] isEqualToString:@"下午好"]) {
            self.headerView.navBigLabel.text = @"Good Afternoon";
        } else if ([[self getTheTimeBucket] isEqualToString:@"晚上好"]) {
            self.headerView.navBigLabel.text = @"Good Evening";
        }
        [self.headerView.rightButton setTitle:@"课程攻略" forState:UIControlStateNormal];
        [self.headerView.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略1") forState:UIControlStateNormal];
    }
    return _headerView;
}


-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

-(HF_HomeHeaderPlaceHolderView *)placeHolderView {
    if (!_placeHolderView) {
        self.placeHolderView = [[HF_HomeHeaderPlaceHolderView alloc] init];
        self.placeHolderView.hidden = YES;
    }
    return _placeHolderView;
}

//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}


@end
