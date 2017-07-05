//
//  WPCycleScrollViewCell.m
//  轮播Demo
//
//  Created by wupei on 4/7/17.
//  Copyright © 2017年 WP. All rights reserved.
//

#import "WPCycleScrollViewCell.h"

@interface WPCycleScrollViewCell ()

@property (nonatomic, weak) UIImageView *imageView;//图片视图

@end

@implementation WPCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
            UIImageView *imageView = [[UIImageView alloc] init];
            _imageView = imageView;
            _imageView.frame = self.bounds;
        
            [self.contentView addSubview:_imageView];
        
    }
    return self;
}

    
    


- (void)setImg:(UIImage *)img {
    _imageView.image = img;
}

@end
