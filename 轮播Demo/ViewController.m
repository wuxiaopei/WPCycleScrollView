//
//  ViewController.m
//  轮播Demo
//
//  Created by wupei on 4/7/17.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "ViewController.h"
#import "WPCycleScrollView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArr = @[@"h1.jpg",
                          @"h2.jpg",
                          @"h3.jpg",
                          @"h4.jpg",
                          ];;

    WPCycleScrollView *cycleView = [WPCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 180) shouldInfiniteLoop:YES imageNamesGroup:imageArr];
    
    [self.view addSubview:cycleView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
