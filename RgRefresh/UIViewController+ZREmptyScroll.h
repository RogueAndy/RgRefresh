//
//  UIViewController+ZREmptyScroll.h
//  RgRefreshDemo
//
//  Created by rogue on 2019/7/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZREmptyScroll)<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, assign) BOOL isDataNoWrong;// 是否是数据异常

@property (nonatomic, strong) void (^refreshBlock)(void);

/**
 table的高度建议 > 600;
 */
@property (nonatomic) CGFloat empty_table_height;

/**
 中心点提示的文字信息
 */
@property (nonatomic, strong) NSAttributedString *empty_centerTips;

/**
 中心点提示的图片
 */
@property (nonatomic, strong) UIImage *empty_centerImg;

/**
 手动设置代理
 
 @param scroll 对象
 */
- (void)setEmptyDelegate:(UIScrollView *)scroll tableHeight:(CGFloat)tableHeight;

@end

NS_ASSUME_NONNULL_END
