//
//  UIScrollView+ZRRefresh.h
//  ZRRefreshDemo
//
//  Created by rogue on 2019/1/7.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZRRefresh)

typedef void (^ZR_PullRefreshBlock) (void);

#pragma mark - Refresh
/**
 *  下拉刷新
 *
 *  @param pullDownBlock 下拉block
 */
- (void)zr_pullDown:(nullable ZR_PullRefreshBlock)pullDownBlock;

/**
 *  上拉刷新
 *
 *  @param pullUpBlock 上拉block
 */
- (void)zr_pullUp:(nullable ZR_PullRefreshBlock)pullUpBlock;

/**
 *  上、下拉刷新
 *
 *  @param pullDownBlock 下拉block
 *  @param pullUpBlock   上拉block
 */
- (void)zr_pullDown:(nullable ZR_PullRefreshBlock)pullDownBlock
             pullUp:(nullable ZR_PullRefreshBlock)pullUpBlock;

#pragma mark - Begin Refreshing
/**
 *  头视图开始刷新
 */
- (void)zr_headerBeginRefreshing;

/**
 *  脚视图开始刷新
 */
- (void)zr_footerBeginRefreshing;

#pragma mark - End Refreshing
/**
 *  头视图停止刷新
 */
- (void)zr_headerEndRefreshing;

/**
 *  脚视图停止刷新
 */
- (void)zr_footerEndRefreshing;

/**
 *  都停止刷新
 */
- (void)zr_allEndRefreshing;

@end

NS_ASSUME_NONNULL_END
