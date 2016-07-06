//
//  ViewController.m
//  截图-测试1
//
//  Created by macbook on 15/8/20.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ViewController.h"
#import "CliperView.h"
#import "Define.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 截屏视图类
    CliperView *cliper = [[CliperView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
    [self.view addSubview:cliper];
    /**
     添加约束 全屏
     */
    NSArray *HCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cliper]|" options:0 metrics:nil views:@{@"cliper":cliper}];
    NSArray *VCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cliper]|" options:0 metrics:nil views:@{@"cliper":cliper}];
    [self.view addConstraints:HCons];
    [self.view addConstraints:VCons];
    
}


// 关闭自动旋转
//-(BOOL)shouldAutorotate{
//    return NO;
//}

@end
