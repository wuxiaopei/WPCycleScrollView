//
//  WPCycleScrollView.m
//  轮播Demo
//
//  Created by wupei on 4/7/17.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPCycleScrollView.h"
#import "WPCycleScrollViewCell.h"


@interface WPCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *mainView;// 显示图片的 collectionView

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;// 布局属性

@property (nonatomic, strong) NSArray *imageGroup;//图片数组

@property (nonatomic, assign) NSInteger totalItems;// item 的数量

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation WPCycleScrollView

static NSString * const ID = @"collectViewID";

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup {
    
    WPCycleScrollView *cycleView = [[WPCycleScrollView alloc] initWithFrame:frame];
    
    cycleView.infiniteLoop = infiniteLoop;
    cycleView.imageGroup = [imageNamesGroup copy];
    
    return cycleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;

    if (_mainView.contentOffset.x == 0 && _totalItems > 0) {
        NSInteger targeIndex = 0;
        if (self.infiniteLoop) {//无限循环
            // 如果是无限循环，应该默认把 collection 的 item 滑动到 中间位置。
            // 注意：此处 totalItems 的数值，其实是图片数组数量的 100 倍。
            // 乘以 0.5 ，正好是取得中间位置的 item 。图片也恰好是图片数组里面的第 0 个。
            targeIndex = _totalItems * 0.5;
        }else {
            targeIndex = 0;
        }

        //默认的图片位置
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)setImageGroup:(NSArray *)imageGroup {
    
    _imageGroup = imageGroup;
    
    // 这一句是关键，如果是无限循环，就让 item 的总数乘以 100 。
    
    _totalItems = self.infiniteLoop ? imageGroup.count * 100 : imageGroup.count;
    
    if (_imageGroup.count > 1) {
        self.mainView.scrollEnabled = YES;
        //处理是否自动滑动，定时器问题
        [self setAutoScroll:self.autoScroll];
    }else{
        self.mainView.scrollEnabled = NO;
        [self setAutoScroll:NO];
    }
    
    
    
    [self.mainView reloadData];
    
}

- (void)setAutoScroll:(BOOL)autoScroll {
    
    _autoScroll = autoScroll;
    
    //创建之前，停止定时器
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
    
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer  = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
    
}

- (void)automaticScroll {
    
    if (0 == _totalItems) {
        return;
    }
    
    NSInteger currentIndex = [self currentIndex];
    
    NSInteger targetIndex = currentIndex + 1;
    
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex{
    if (targetIndex >= _totalItems) {//调到中间的任意一组里面的 第0个图片
        if (self.infiniteLoop) {//无限循环
            targetIndex = _totalItems * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

- (NSInteger)currentIndex {
    
    if (_mainView.frame.size.width == 0 || _mainView.frame.size
        .height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {//水平滑动
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    }else{
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5)/ _flowLayout.itemSize.height;
    }
    return MAX(0,index);
}

- (void)initialization {
    _infiniteLoop = YES;
    
    _autoScroll = YES;//默认自动滑动
    
    _autoScrollTimeInterval = 2; //默认间隔两秒
    
    
}
- (void)setupMainView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;//间距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    
    _flowLayout = flowLayout;
    
    // 设置单个 cell 的尺寸
    _flowLayout.itemSize = self.frame.size;
    
    [mainView registerClass:[WPCycleScrollViewCell class] forCellWithReuseIdentifier:ID];
    
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.scrollsToTop = NO;

    mainView.delegate = self;
    mainView.dataSource = self;
    
    _mainView = mainView;
    
    [self addSubview:mainView];
}

#pragma - mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WPCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    // 利用取余运算，使得图片数组里面的图片，是一组一组的排列的。
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    cell.img = [UIImage imageNamed:self.imageGroup[itemIndex]];
    
    return cell;
    
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.imageGroup.count;
}

#pragma - mark UICollectionViewDelegate




@end
