//
//  WPCycleScrollView.h
//  轮播Demo
//
//  Created by wupei on 4/7/17.
//  Copyright © 2017年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCycleScrollView : UIView

//* 是否无限循环,默认Yes 
@property (nonatomic,assign) BOOL infiniteLoop;
//* 是否自动滑动
@property (nonatomic, assign) BOOL autoScroll;

//* 自动滚动间隔时间,默认2s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup;


@end
