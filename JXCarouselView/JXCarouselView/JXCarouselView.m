//
//  JXCarouselView.m
//  JXCarouselView
//
//  Created by jiaxin on 2018/3/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCarouselView.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const CGFloat pageControlBottom = 20.0;

@interface JXCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlHeight;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat startContentOffsetX;  //用于判断什么情况下刷新currentIndex

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
    _startContentOffsetX = 0;
    _pageControlCenter = CGPointZero;
}

- (void)initializeViews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_leftImageView];

    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_rightImageView];

    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize size = self.bounds.size;
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width*MIN(2, self.imageURLArray.count), self.bounds.size.height);
    _scrollView.contentOffset = CGPointMake(0, 0);

    _leftImageView.frame = CGRectMake(0, 0, size.width, size.height);
    _rightImageView.frame = CGRectMake(size.width, 0, size.width, size.height);
    [self configImageView:_leftImageView imageIndex:self.currentIndex];
    [self configImageView:_rightImageView imageIndex:self.currentIndex + 1];

    if (self.imageURLArray.count == 0) {
        _leftImageView.hidden = YES;
        _rightImageView.hidden = YES;
    }else if (self.imageURLArray.count == 1) {
        _rightImageView.hidden = YES;
    }

    _pageControl.numberOfPages = self.imageURLArray.count;
    _pageControl.currentPage = self.currentIndex;
    if (CGPointEqualToPoint(_pageControlCenter, CGPointZero)) {
        _pageControlCenter = CGPointMake(self.center.x, self.bounds.size.height - pageControlBottom - _pageControlHeight/2.0);
    }
    CGSize pageSize = [_pageControl sizeForNumberOfPages:self.imageURLArray.count];
    _pageControl.bounds = CGRectMake(0, 0, pageSize.width, _pageControlHeight);
    _pageControl.center = _pageControlCenter;
}

- (void)setImageURLArray:(NSArray<NSString *> *)imageURLArray
{
    _imageURLArray = imageURLArray;

    _currentIndex = 0;
    [self setNeedsLayout];
}

- (void)configImageView:(UIImageView *)imageView imageIndex:(NSInteger)index {
    if (self.imageURLArray.count == 0) {
        return;
    }
    index = [self getCorrectIndex:index];
    NSString *imageURL = self.imageURLArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed];
}

- (NSInteger)getCorrectIndex:(NSInteger)index {
    if (index < 0) {
        index = self.imageURLArray.count - 1;
    }else if (index > self.imageURLArray.count - 1) {
        index = 0;
    }
    return index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.imageURLArray.count <= 1) {
        return;
    }
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX < 0) {
        if (_startContentOffsetX == scrollView.bounds.size.width) {
            _startContentOffsetX = 0;
            self.currentIndex = [self getCorrectIndex:self.currentIndex - 1];
            _pageControl.currentPage = self.currentIndex;
        }
    }else if (contentOffsetX > scrollView.bounds.size.width) {
        if (_startContentOffsetX == 0) {
            _startContentOffsetX = scrollView.bounds.size.width;
            self.currentIndex = [self getCorrectIndex:self.currentIndex + 1];
            _pageControl.currentPage = self.currentIndex;
        }
    }
    if (contentOffsetX < 0) {
        //向右滑
        _startContentOffsetX = scrollView.bounds.size.width;
        [self configImageView:_leftImageView imageIndex:self.currentIndex - 1];
        [self configImageView:_rightImageView imageIndex:self.currentIndex];
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
    }else if (contentOffsetX > scrollView.bounds.size.width) {
        //向左滑
        _startContentOffsetX = 0;
        [self configImageView:_leftImageView imageIndex:self.currentIndex];
        [self configImageView:_rightImageView imageIndex:self.currentIndex + 1];
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.imageURLArray.count <= 1) {
        return;
    }
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX == 0) {
        if (_startContentOffsetX == scrollView.bounds.size.width) {
            _startContentOffsetX = 0;
            self.currentIndex = [self getCorrectIndex:self.currentIndex - 1];
            _pageControl.currentPage = self.currentIndex;
        }
    }else if (contentOffsetX == scrollView.bounds.size.width) {
        if (_startContentOffsetX == 0) {
            _startContentOffsetX = scrollView.bounds.size.width;
            self.currentIndex = [self getCorrectIndex:self.currentIndex + 1];
            _pageControl.currentPage = self.currentIndex;
        }
    }
}

@end
