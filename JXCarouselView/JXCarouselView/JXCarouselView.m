//
//  JXCarouselView.m
//  JXCarouselView
//
//  Created by jiaxin on 2018/3/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCarouselView.h"

@interface JXCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlHeight;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation JXCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}

- (void)initializeDatas {
    _pageControlHeight = 20.0;
    _currentIndex = 0;
}

- (void)initializeViews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
//    _scrollView.bounces = NO;
    [self addSubview:_scrollView];

    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_leftImageView];

    _centerImageView = [[UIImageView alloc] init];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_centerImageView];

    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_rightImageView];

    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = self.bounds.size;
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width*MIN(3, self.images.count), self.bounds.size.height);
    _scrollView.contentOffset = CGPointMake(self.images.count<=1?0:size.width, 0);
    _pageControl.frame = CGRectMake(10, size.height - self.pageControlHeight*2, 100, self.pageControlHeight);
    _leftImageView.frame = CGRectMake(0, 0, size.width, size.height);
    _centerImageView.frame = CGRectMake(size.width, 0, size.width, size.height);
    _rightImageView.frame = CGRectMake(size.width*2, 0, size.width, size.height);
}

- (void)setImageURLArray:(NSArray<NSString *> *)imageURLArray
{
    _imageURLArray = imageURLArray;

    _pageControl.numberOfPages = imageURLArray.count;
    _pageControl.currentPage = 0;
}

- (void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;

    [self reloadImages];
}

- (UIImage *)getImageWithTargetIndex:(NSInteger)targetIndex {
    targetIndex = [self getCorrectIndex:targetIndex];
    return self.images[targetIndex];
}

- (NSInteger)getCorrectIndex:(NSInteger)index {
    if (index < 0) {
        index = self.images.count - 1;
    }else if (index > self.images.count - 1) {
        index = 0;
    }
    return index;
}

- (void)reloadImages {
    _pageControl.numberOfPages = self.images.count;
    _pageControl.currentPage = self.currentIndex;

    _leftImageView.image = [self getImageWithTargetIndex:self.currentIndex - 1];
    _centerImageView.image = [self getImageWithTargetIndex:self.currentIndex];
    _rightImageView.image = [self getImageWithTargetIndex:self.currentIndex + 1];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@:%@,currentIndex:%ld", NSStringFromSelector(_cmd), [NSValue valueWithCGPoint:scrollView.contentOffset], self.currentIndex);
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    BOOL isNeedReload = NO;
    if (contentOffsetX <= 0) {
        //向左滑
        self.currentIndex = [self getCorrectIndex:self.currentIndex - 1];
        isNeedReload = YES;
    }else if (contentOffsetX >= scrollView.bounds.size.width*MIN(2, self.images.count - 1)) {
        //向右滑
        self.currentIndex = [self getCorrectIndex:self.currentIndex + 1];
        isNeedReload = YES;
    }
    if (isNeedReload) {
        self.pageControl.currentPage = self.currentIndex;
        [self reloadImages];
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
    }

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

@end
