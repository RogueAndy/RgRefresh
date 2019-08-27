//
//  TestViewController.m
//  RgRefreshDemo
//
//  Created by rogue on 2019/7/25.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "TestViewController.h"
#import "UIViewController+ZREmptyScroll.h"

// iPhone X、XR、XS、XS Max 判断
#define ZRScrollIPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 导航栏高度
#define ZRScrollSafeAreaTopHeight (ZRScrollIPHONE_X ? 88 : 64)

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arr = [NSMutableArray arrayWithObjects:@"2", @"3", nil];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, ZRScrollSafeAreaTopHeight, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - ZRScrollSafeAreaTopHeight)];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UIView *clear = [UIView new];
    clear.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = clear;
    [self setEmptyDelegate:self.table tableHeight:[[UIScreen mainScreen] bounds].size.height - ZRScrollSafeAreaTopHeight];
    [self.view addSubview:self.table];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 setTitle:@"可点击的4" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(dodo4) forControlEvents:UIControlEventTouchUpInside];
    btn4.frame = CGRectMake(20, 200, 200, 30);
    [self.view addSubview:btn4];
}

- (void)dodo4 {
    self.arr = [NSMutableArray new];
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"dwdwa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

- (void)dealloc {
    NSLog(@"dwadawdwawadwadad");
}

@end
