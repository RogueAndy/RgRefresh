//
//  UIViewController+ZREmptyScroll.m
//  RgRefreshDemo
//
//  Created by rogue on 2019/7/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIViewController+ZREmptyScroll.h"

#import <MJRefresh/MJRefresh.h>

#import "UIScrollView+ZRRefresh.h"
#import <Reachability/Reachability.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define ZR_refresh_scroll_matching_scale ([[UIScreen mainScreen] bounds].size.width / 375.0)

static NSString *key_rg_refresh_refreshBlock = @"key_rg_refresh_refreshBlock";
static NSString *key_rg_refresh_scroll = @"key_rg_refresh_scroll";
static NSString *key_rg_refresh_centerTip = @"key_rg_refresh_centerTip";
static NSString *key_rg_refresh_tableHeight = @"key_rg_refresh_tableHeight";
static NSString *key_rg_refresh_centerImg = @"key_rg_refresh_centerImg";
static NSString *key_rg_refresh_centerView = @"key_rg_refresh_centerView";
static NSString *key_rg_refresh_shouldShow = @"key_rg_refresh_shouldShow";
static NSString *key_rg_refresh_isDataNoWrong = @"key_rg_refresh_isDataNoWrong";

@interface UIViewController()

@property (nonatomic, weak) UIScrollView *category_scroll;

@property (nonatomic, strong) UIView *center_view;

@property (nonatomic, assign) BOOL shouldShow; // 第一次进去，不会显示空页面

@end

@implementation UIViewController (ZREmptyScroll)

#pragma mark - 分类属性

- (ZREmptyScrollType)isDataNoWrong {
    return [objc_getAssociatedObject(self, &key_rg_refresh_isDataNoWrong) integerValue];
}

- (void)setIsDataNoWrong:(ZREmptyScrollType)isDataNoWrong {
    objc_setAssociatedObject(self, &key_rg_refresh_isDataNoWrong, @(isDataNoWrong), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)shouldShow {
    NSNumber *number = objc_getAssociatedObject(self, &key_rg_refresh_shouldShow);
    return [number boolValue];
}

- (void)setShouldShow:(BOOL)shouldShow {
    objc_setAssociatedObject(self, &key_rg_refresh_shouldShow, [NSNumber numberWithBool:shouldShow], OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(void))refreshBlock {
    return objc_getAssociatedObject(self, &key_rg_refresh_refreshBlock);
}

- (void)setRefreshBlock:(void (^)(void))refreshBlock {
    objc_setAssociatedObject(self, &key_rg_refresh_refreshBlock, refreshBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScrollView *)category_scroll {
    return objc_getAssociatedObject(self, &key_rg_refresh_scroll);
}

- (void)setCategory_scroll:(UIScrollView *)category_scroll {
    objc_setAssociatedObject(self, &key_rg_refresh_scroll, category_scroll, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)empty_centerTips {
    return objc_getAssociatedObject(self, &key_rg_refresh_centerTip);
}

- (void)setEmpty_centerTips:(NSAttributedString *)empty_centerTips {
    objc_setAssociatedObject(self, &key_rg_refresh_centerTip, empty_centerTips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)empty_table_height {
    NSNumber *number = objc_getAssociatedObject(self, &key_rg_refresh_tableHeight);
    return number.floatValue;
}

- (void)setEmpty_table_height:(CGFloat)empty_table_height {
    objc_setAssociatedObject(self, &key_rg_refresh_tableHeight, [NSNumber numberWithFloat:empty_table_height], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)empty_centerImg {
    return objc_getAssociatedObject(self, &key_rg_refresh_centerImg);
}

- (void)setEmpty_centerImg:(UIImage *)empty_centerImg {
    objc_setAssociatedObject(self, &key_rg_refresh_centerImg, empty_centerImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)center_view {
    return objc_getAssociatedObject(self, &key_rg_refresh_centerView);
}

- (void)setCenter_view:(UIView *)center_view {
    objc_setAssociatedObject(self, &key_rg_refresh_centerView, center_view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 设置代理

- (void)setEmptyDelegate:(UIScrollView *)scroll tableHeight:(CGFloat)tableHeight {
    self.category_scroll = scroll;
    self.empty_table_height = tableHeight;
    
    scroll.emptyDataSetSource = self;
    scroll.emptyDataSetDelegate = self;
}

#pragma mark - Emtpy Scroll

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (!self.shouldShow) {
        self.shouldShow = true;
        return false;
    }
    return true;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat tableHeight = self.empty_table_height;
    CGFloat centerX = [[UIScreen mainScreen] bounds].size.width / 2.0;
    CGFloat centerY = tableHeight / 2.0;
    if(tableHeight == 0) {
        return [UIView new];
    }
    
    if(!self.center_view) {
        
        self.center_view = [[UIView alloc] init];
        self.center_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.center_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tableHeight];
        [self.center_view addConstraint:heightConstraint];
        
        // 文本显示
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1], NSFontAttributeName: [UIFont systemFontOfSize:(ZR_refresh_scroll_matching_scale * 14)]}];
        if(self.empty_centerTips) {
            attString = self.empty_centerTips;
        }
        
        UILabel *lab = [UILabel new];
        lab.tag = 71002;
        lab.frame = CGRectMake(0, 0, centerX * 2, 20);
        lab.center = CGPointMake(centerX, centerY - ZR_refresh_scroll_matching_scale * 30);
        lab.attributedText = attString;
        lab.textAlignment = NSTextAlignmentCenter;
        [self.center_view addSubview:lab];
        
        
        // 显示图片
        UIImageView *imgView = [UIImageView new];
        imgView.tag = 71003;
        imgView.frame = CGRectMake(0, 0, ZR_refresh_scroll_matching_scale * 160, ZR_refresh_scroll_matching_scale * 130);
        UIImage *img = [UIImage imageNamed:[self imageName:@"empty_nodata"]];
        if(self.empty_centerImg) {
            img = self.empty_centerImg;
        }
        imgView.image = img;
        imgView.center = CGPointMake(centerX, lab.center.y - ZR_refresh_scroll_matching_scale * 80);
        [self.center_view addSubview:imgView];
        
        
        // 刷新按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 71004;
        btn.frame = CGRectMake(0, 0, ZR_refresh_scroll_matching_scale * 80, ZR_refresh_scroll_matching_scale * 26);
        btn.center = CGPointMake(centerX, lab.center.y + ZR_refresh_scroll_matching_scale * 70);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = ZR_refresh_scroll_matching_scale * 13;
        [btn addTarget:self action:@selector(executeRefresh) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithRed:61/255.0 green:126/255.0 blue:255/255.0 alpha:1.0];
        btn.titleLabel.font = [UIFont systemFontOfSize:ZR_refresh_scroll_matching_scale * 12];
        [btn setTitle:@"刷新一下" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.center_view addSubview:btn];
    }
    
    UILabel *lab = [self.center_view viewWithTag:71002];
    UIImageView *img = [self.center_view viewWithTag:71003];
    UIButton *btn = [self.center_view viewWithTag:71004];
    NSString *tips = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if(!reach.isReachable) {
        /// 没有网络直接拦截，显示无信号哦
        self.isDataNoWrong = ZREmptyNoSignal;
    }
    
    switch (self.isDataNoWrong) {
        case ZREmptySuccessNoData:
        {
            /// 成功但是无数据
            tips = @"暂无数据";
            img.image = [UIImage imageNamed:[self imageName:@"empty_wrong"]];
            btn.hidden = true;
            
            lab.center = CGPointMake(centerX, centerY + ZR_refresh_scroll_matching_scale * 30);
            img.center = CGPointMake(centerX, lab.center.y - ZR_refresh_scroll_matching_scale * 80);
            btn.center = CGPointMake(centerX, lab.center.y + ZR_refresh_scroll_matching_scale * 70);
            
        }
            break;
        case ZREmptyFail:
        {
            /// 失败
            tips = @"暂无数据";
            img.image = [UIImage imageNamed:[self imageName:@"empty_wrong"]];
            btn.hidden = false;
            
            lab.center = CGPointMake(centerX, centerY - ZR_refresh_scroll_matching_scale * 30);
            img.center = CGPointMake(centerX, lab.center.y - ZR_refresh_scroll_matching_scale * 80);
            btn.center = CGPointMake(centerX, lab.center.y + ZR_refresh_scroll_matching_scale * 70);
        }
            break;
        case ZREmptyNoSignal:
        {
            /// 无信号
            tips = @"网络不给力，点击重试";
            img.image = [UIImage imageNamed:[self imageName:@"empty_nosignal"]];
            btn.hidden = false;
            
            lab.center = CGPointMake(centerX, centerY - ZR_refresh_scroll_matching_scale * 30);
            img.center = CGPointMake(centerX, lab.center.y - ZR_refresh_scroll_matching_scale * 80);
            btn.center = CGPointMake(centerX, lab.center.y + ZR_refresh_scroll_matching_scale * 70);
        }
            break;
        default:
        {
            /// 成功
            tips = @"暂无数据";
            img.image = [UIImage imageNamed:[self imageName:@"empty_wrong"]];
            btn.hidden = false;
            
            lab.center = CGPointMake(centerX, centerY + ZR_refresh_scroll_matching_scale * 30);
            img.center = CGPointMake(centerX, lab.center.y - ZR_refresh_scroll_matching_scale * 80);
            btn.center = CGPointMake(centerX, lab.center.y + ZR_refresh_scroll_matching_scale * 70);
            
        }
            break;
    }
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:tips attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1], NSFontAttributeName: [UIFont systemFontOfSize:(ZR_refresh_scroll_matching_scale * 14)]}];
    if(self.empty_centerTips) {
        attString = self.empty_centerTips;
    }
    lab.attributedText = attString;
    lab.textAlignment = NSTextAlignmentCenter;
    
    return self.center_view;
}

- (void)executeRefresh {
    
    if(self.refreshBlock) {
        self.refreshBlock();
        return;
    }
    
    if(self.category_scroll.mj_header && [self.category_scroll respondsToSelector:@selector(zr_headerBeginRefreshing)]) {
        [self.category_scroll zr_headerBeginRefreshing];
    }
}

#pragma mark - 使用默认图片

- (NSString *)imageName:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RgRefresh" ofType :@"bundle"];
    return [path stringByAppendingPathComponent:imageName];
}

@end
