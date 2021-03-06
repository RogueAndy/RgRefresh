//
//  UIScrollView+ZRRefresh.m
//  ZRRefreshDemo
//
//  Created by rogue on 2019/1/7.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIScrollView+ZRRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import <Reachability/Reachability.h>

@implementation UIScrollView (ZRRefresh)

#pragma mark - Refresh
-(void)zr_pullDown:(nullable ZR_PullRefreshBlock)pullDownBlock {
    __weak typeof(self) weakSelf = self;
    self.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if(!reach.isReachable) {
            // 没有网络的情况禁止刷新
            if([weakSelf isKindOfClass:[UITableView class]] || [weakSelf isKindOfClass:[UICollectionView class]]) {
                [(UITableView *)weakSelf reloadData];
            }
            [weakSelf zr_allEndRefreshing];
            return;
        }
        pullDownBlock ? pullDownBlock() : nil;
    }];
}

-(void)zr_pullUp:(nullable ZR_PullRefreshBlock)pullUpBlock{
    __weak typeof(self) weakSelf = self;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if(!reach.isReachable) {
            // 没有网络的情况禁止刷新
            [weakSelf zr_allEndRefreshing];
            return;
        }
        pullUpBlock ? pullUpBlock() : nil;
    }];
}

-(void)zr_pullDown:(nullable ZR_PullRefreshBlock)pullDownBlock
            pullUp:(nullable ZR_PullRefreshBlock)pullUpBlock {
    
    [self zr_pullDown:pullDownBlock];
    [self zr_pullUp:pullUpBlock];
}

#pragma mark - Begin Refreshing
//头视图开始刷新
-(void)zr_headerBeginRefreshing {
    [self.mj_header beginRefreshing];
}

//脚视图开始刷新
-(void)zr_footerBeginRefreshing {
    [self.mj_footer beginRefreshing];
}

#pragma mark - End Refreshing
-(void)zr_headerEndRefreshing {
    [self.mj_header endRefreshing];
}

-(void)zr_footerEndRefreshing {
    [self.mj_footer endRefreshing];
}

-(void)zr_allEndRefreshing {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
