//
//  HF_MyScheduleHomeViewController.m
//  HiFanClassRoomHD
//
//  Created by XieHenry on 2018/11/28.
//  Copyright © 2018 XieHenry. All rights reserved.
//

#import "HF_MyScheduleHomeViewController.h"
#import "HF_MyScheduleHomeHeaderCell.h"
#import "HF_MyScheduleHomeUnFinishedCell.h"

@interface HF_MyScheduleHomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UITableView *tableView; //tableView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *unFinishedDataArray;
@property (nonatomic, strong) NSMutableArray *finishedDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HF_MyScheduleHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.unFinishedDataArray = [NSMutableArray array];
    self.finishedDataArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];

    self.unFinishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    self.dataArray = self.unFinishedDataArray;
    self.finishedDataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];

}


-(void)initUI {
    self.navBigLabel.text = @"My Schedule";
    self.titleLabel.text = @"课表";
    [self.rightButton setTitle:@"学习攻略" forState:(UIControlStateNormal)];
    [self.rightButton setImage:UIIMAGE_FROM_NAME(@"攻略") forState:(UIControlStateNormal)];
    
    
    @weakify(self);
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         NSLog(@"学习攻略");
     }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    // 注册头视图
    [self.collectionView registerClass:[HF_MyScheduleHomeHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HF_MyScheduleHomeHeaderCell"];
    //注册cell
    [self.collectionView registerClass:[HF_MyScheduleHomeUnFinishedCell class] forCellWithReuseIdentifier:@"HF_MyScheduleHomeUnFinishedCell"];
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
    
    static NSString *identify = @"HF_MyScheduleHomeUnFinishedCell";
    HF_MyScheduleHomeUnFinishedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, cell.width, cell.height);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = self.dataArray[indexPath.row];
//    [cell.contentView addSubview:label];
    
    return cell;
}


//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(LineW(285.3),LineH(213));
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(LineY(8.5), LineX(17), LineY(8.5), LineX(17));
}


//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return LineY(17);
}

//定义每个UICollectionView 的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return LineW(17);
}




//设置header的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(home_right_width,LineH(85));
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    HF_MyScheduleHomeHeaderCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HF_MyScheduleHomeHeaderCell" forIndexPath:indexPath];
    header.backgroundColor = UICOLOR_RANDOM_COLOR();
    
    header.unFinishedBlock = ^{
        [self.dataArray removeAllObjects];
        self.dataArray = self.unFinishedDataArray;
        [self.collectionView reloadData];
    };
    
    
    header.finishedBlock = ^{
        [self.dataArray removeAllObjects];
        self.dataArray = self.finishedDataArray;
        [self.collectionView reloadData];
    };
    
    return header;
}


//MARK:滑动动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y-90)/100.0f;
    
    if (offset_Y >0 && offset_Y <=64) {
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126)-offset_Y);
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        CGFloat fontSize =  (90-offset_Y)/90 * 38;
        int a = floor(fontSize); //floor 向下取整
        a = (a>20 ? a : 20);  //三目运算符
        self.navBigLabel.hidden = NO;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(a)];
        self.titleLabel.frame = CGRectMake(LineX(17), self.navView.height-LineH(a)-LineH(12), LineW(100), LineH(a));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), self.navView.height-LineH(16)-LineH(12), LineW(100), LineH(16));
        
        
        self.navBigLabel.frame = CGRectMake(LineX(14), self.navView.height-LineH(91), home_right_width-LineW(28), LineH(90));
        self.navBigLabel.alpha = -alpha;
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
        
    } else if (offset_Y >0 && offset_Y >64){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(64));
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        self.navBigLabel.hidden = YES;
        self.navBigLabel.alpha = 0;
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(20)];
       
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(32), LineW(100), LineH(20));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(36), LineW(100), LineH(16));
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
        
    } else if (offset_Y <0){
        
        self.navView.frame = CGRectMake(0, 0, home_right_width, LineH(126));
        self.collectionView.frame = CGRectMake(0, self.navView.y+self.navView.height, home_right_width, SCREEN_HEIGHT()-self.navView.height);
        
        self.navBigLabel.hidden = NO;
        self.navBigLabel.alpha = 1;
        self.navBigLabel.frame = CGRectMake(LineX(14), LineY(35), home_right_width-LineW(28), LineH(90));
        
        self.titleLabel.frame = CGRectMake(LineX(17), LineY(72), LineW(100), LineH(38));
        self.rightButton.frame = CGRectMake(home_right_width-LineW(120), LineY(93), LineW(100), LineH(16));
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:LineX(38)];
        self.lineView.frame = CGRectMake(LineX(17), self.navView.height-LineH(1), home_right_width-LineW(34), LineH(1));
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
