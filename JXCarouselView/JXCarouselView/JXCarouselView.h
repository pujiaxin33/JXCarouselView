//
//  JXCarouselView.h
//  JXCarouselView
//
//  Created by jiaxin on 2018/3/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXCarouselView : UIView

@property (nonatomic, strong) NSArray <NSString *>*imageURLArray;
@property (nonatomic, strong) NSArray <UIImage *> *images;
@property (nonatomic, assign) CGPoint pageControlCenter;    //默认距离父视图下方20pt

//- (instancetype)initWithImageURLArray:(NSArray <NSString *>*)imageURLArray;

@end
