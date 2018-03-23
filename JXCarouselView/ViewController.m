//
//  ViewController.m
//  JXCarouselView
//
//  Created by jiaxin on 2018/3/23.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ViewController.h"
#import "JXCarouselView.h"

@interface ViewController ()
@property (nonatomic, strong) JXCarouselView *carouselView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    JXCarouselView *view = [[JXCarouselView alloc] init];
//    view.images = @[[UIImage imageNamed:@"lufei1.jpg"],
//                    [UIImage imageNamed:@"lufei2.jpeg"],
//                    [UIImage imageNamed:@"lufei3.jpeg"],];
    view.imageURLArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521808988330&di=9a5cc015ff54bb3db7dd5ad3fb7a249a&imgtype=0&src=http%3A%2F%2Fcyf-img.bdstatic.com%2Fimg_5940f93bd3839_f2a64aa660e66b673515aa3c4c481a9f.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521808996123&di=c8b3c24089ebc3afa9adec9fdc4e4a22&imgtype=jpg&src=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D3023409474%2C2536571172%26fm%3D214%26gp%3D0.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521808988329&di=d5b485faf0f926d0db720ed29bb1a0ab&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fbaike%2Fpic%2Fitem%2F7dd98d1001e93901ff3126d27bec54e736d1962f.jpg",];
    [self.view addSubview:view];
    self.carouselView = view;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.carouselView.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 200);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
