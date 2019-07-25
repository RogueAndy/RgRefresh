//
//  ViewController.m
//  RgRefreshDemo
//
//  Created by rogue on 2019/6/27.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = true;
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 setTitle:@"可点击的4" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(dodo4) forControlEvents:UIControlEventTouchUpInside];
    btn4.frame = CGRectMake(20, 450, 200, 30);
    [self.view addSubview:btn4];
}

- (void)dodo4 {
    TestViewController *vc = [TestViewController new];
    [self.navigationController pushViewController:vc animated:true];
}

@end
