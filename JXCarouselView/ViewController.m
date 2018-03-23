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
    view.images = @[[UIImage imageNamed:@"lufei1.jpg"],
                    [UIImage imageNamed:@"lufei2.jpeg"],
                    /*[UIImage imageNamed:@"lufei3.jpeg"],*/];
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
