//
//  MyRefresh.h
//  iTour
//
//  Created by Super on 2017/8/25.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRefresh : UIControl

- (void)attachToScrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;

- (void)endRefreshing;
@end
