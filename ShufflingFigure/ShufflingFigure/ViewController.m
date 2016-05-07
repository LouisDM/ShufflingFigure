//
//  ViewController.m
//  ShufflingFigure
//
//  Created by gdm on 16/5/7.
//  Copyright © 2016年 辜东明. All rights reserved.
//

#import "ViewController.h"
#import "ImageShuffingView.h"
@interface ViewController ()
{
    ImageShuffingView *imageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *imageUrlStr = @[
                             @"http://pic.qiantucdn.com/58pic/16/03/83/71m58PICtxj.jpg",
                             @"http://pic.qiantucdn.com/58pic/19/41/25/56cd456cf319e.jpg",
                             @"http://pic.qiantucdn.com/58pic/17/37/17/62S58PICF2C_1024.jpg"
                             ];
    
    imageView = [[ImageShuffingView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/3) andImageType:ImageUrlStr andImageArr:imageUrlStr andCurrentPageColor:[UIColor blueColor] andOtherPageColor:[UIColor lightGrayColor] andTime:6 andFather:self.view];
    
    imageView.chickBtn = ^(int index){
        NSLog(@"select index:%d",index);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
