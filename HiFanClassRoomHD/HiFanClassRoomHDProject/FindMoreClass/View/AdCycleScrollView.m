//
//  AdCycleScrollView.m
//  Ad
//
//  Created by RF on 15/5/10.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import "AdCycleScrollView.h"
#import "AdCollectionViewCell.h"
#import "UIImageView+WebCache.h"

NSString *const ID = @"cycleCell";

@interface AdCycleScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation AdCycleScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.pageControlAliment = AdCycleScrollViewPageControlAlimentCenter;
        _autoScrollTimeInterval = 3.0;
    }
    return self;
}


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray{
    AdCycleScrollView *adCycleScrollView = [[self alloc] initWithFrame:frame];
    adCycleScrollView.imagesUrlArray = imagesArray;
    return adCycleScrollView;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _flowLayout.itemSize = self.frame.size;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}

- (void)setUpMainView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor lightGrayColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[AdCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}

- (void)setImagesUrlArray:(NSArray *)imagesUrlArray{
    if (imagesUrlArray.count == 0) {
        _totalItemsCount = 300;
        _imagesUrlArray = @[@"",@"",@""];
    }else{
        _totalItemsCount = imagesUrlArray.count*100;
        _imagesUrlArray = imagesUrlArray;
    }
    
    [self setUpMainView];
    [self setupTimer];
    [self setupPageControl];
    [_mainView reloadData];
}

- (void)setupPageControl{
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imagesUrlArray.count;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)refreshPageControlStyle{
    switch (self.pageControlAliment) {
        case AdCycleScrollViewPageControlNone:
            
            break;
        case AdCycleScrollViewPageControlAlimentLeft:
        {
            _pageControl.frame = CGRectMake(0, self.bounds.size.height-25, 80, 20);
        }
            break;
        case AdCycleScrollViewPageControlAlimentCenter:
        {
            _pageControl.frame = CGRectMake((self.bounds.size.width-80)/2, self.bounds.size.height-25, 80, 20);
        }
            break;
        case AdCycleScrollViewPageControlAlimentRight:
        {
            _pageControl.frame = CGRectMake(self.bounds.size.width-80 -15, self.bounds.size.height-25, 80, 20);
        }
            break;
        default:
            break;
    }

}

- (void)automaticScroll
{
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagesUrlArray.count;
    NSString *url = [self.imagesUrlArray safe_objectAtIndex:itemIndex];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_placeholder"] options:SDWebImageRefreshCached];
    if (_titlesArray.count)
    {
        cell.title = _titlesArray[itemIndex];
    }
    else
    {
        cell.bgView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagesUrlArray.count];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger itemIndex = (scrollView.contentOffset.x + self.mainView.frame.size.width * 0.5) / self.mainView.frame.size.width;
    NSInteger indexOnPageControl = itemIndex % self.imagesUrlArray.count;
    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}


@end
