//  E_SearchViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "UIScrollView+MJRefresh.h"
/*搜索页面*/
@protocol E_SearchViewControllerDelegate <NSObject>
- (void)turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord;
@end
@interface E_SearchViewController : UIViewController
@property(nonatomic,assign)id<E_SearchViewControllerDelegate>delegate;
@end
