//
//  UIViewController+ZREmptyScroll.m
//  RgRefreshDemo
//
//  Created by rogue on 2019/7/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIViewController+ZREmptyScroll.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIScrollView+ZRRefresh.h"
#import "MJRefresh.h"

#import <objc/runtime.h>
#import <objc/message.h>

#define ZR_refresh_scroll_matching_scale ([[UIScreen mainScreen] bounds].size.width / 375.0)

static NSString *key_rg_refresh_centerTip = @"key_rg_refresh_centerTip";
static NSString *key_rg_refresh_centerTip_y = @"key_rg_refresh_centerTip_y";
static NSString *key_rg_refresh_centerImg = @"key_rg_refresh_centerImg";

@interface UIViewController()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, weak) UIScrollView *category_scroll;

@end

@implementation UIViewController (ZREmptyScroll)

- (NSAttributedString *)empty_centerTips {
    return objc_getAssociatedObject(self, &key_rg_refresh_centerTip);
}

- (void)setEmpty_centerTips:(NSAttributedString *)empty_centerTips {
    objc_setAssociatedObject(self, &key_rg_refresh_centerTip, empty_centerTips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)empty_centerTips_y {
    NSNumber *number = objc_getAssociatedObject(self, &key_rg_refresh_centerTip_y);
    return number.floatValue;
}

- (void)setEmpty_centerTips_y:(CGFloat)empty_centerTips_y {
    objc_setAssociatedObject(self, &key_rg_refresh_centerTip_y, [NSNumber numberWithFloat:empty_centerTips_y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)empty_centerImg {
    return objc_getAssociatedObject(self, &key_rg_refresh_centerImg);
}

- (void)setEmpty_centerImg:(UIImage *)empty_centerImg {
    objc_setAssociatedObject(self, &key_rg_refresh_centerImg, empty_centerImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEmptyDelegate:(UIScrollView *)scroll {
    self.category_scroll = scroll;
    
    scroll.emptyDataSetSource = self;
    scroll.emptyDataSetDelegate = self;
}

#pragma mark - Emtpy Scroll

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.empty_centerTips) {
        return self.empty_centerTips;
    }
    return [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1], NSFontAttributeName: [UIFont systemFontOfSize:(ZR_refresh_scroll_matching_scale * 15)]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.empty_centerImg) {
        return self.empty_centerImg;
    }
    return [UIImage imageNamed:@"empty_nodata"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.empty_centerTips_y != 0) {
        return self.empty_centerTips_y;
    }
    return -(100 * ZR_refresh_scroll_matching_scale);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if(self.category_scroll.mj_header && [self.category_scroll respondsToSelector:@selector(zr_headerBeginRefreshing)]) {
        [self.category_scroll mj_header];
    }
}

- (NSString *)imageName:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RgRefresh" ofType :@"bundle"];
    return [path stringByAppendingPathComponent:imageName];
}

@end
