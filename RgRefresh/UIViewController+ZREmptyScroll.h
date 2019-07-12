//
//  UIViewController+ZREmptyScroll.h
//  RgRefreshDemo
//
//  Created by rogue on 2019/7/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZREmptyScroll)

/**
 中心点提示的文字信息
 */
@property (nonatomic, strong) NSAttributedString *empty_centerTips;

/**
 以全屏为中心，往上移动则为 负数，往下移动则为正数
 */
@property (nonatomic) CGFloat empty_centerTips_y;

/**
 中心点提示的图片
 */
@property (nonatomic, strong) UIImage *empty_centerImg;

- (void)setEmptyDelegate:(UIScrollView *)scroll;

@end

NS_ASSUME_NONNULL_END
