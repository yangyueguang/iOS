//  XFNewFeatureController.m
//  Freedom
//  Created by Fay on 15/9/19.
#import "XFNewFeatureController.h"
#import "SinaTabBarController.h"
#define KCount 4
@interface XFNewFeatureController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic,weak) UIButton *shareBtn;
@end
@implementation XFNewFeatureController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    CGFloat scrollW = scrollView.frameWidth;
    CGFloat scrollH = scrollView.frameHeight;
    scrollView.contentSize = CGSizeMake(scrollW * KCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
   
    for (int i = 0; i < KCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frameX = i * scrollW;
        imageView.frameY = 0;
        imageView.frameWidth = scrollW;
        imageView.frameHeight = scrollH;
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d@2x",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if (i == KCount -1) {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setImage:[UIImage imageNamed:Pgou_gray] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:Pgou_g] forState:UIControlStateSelected];
            [shareBtn setTitle:@"分享至微博" forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            shareBtn.center = CGPointMake(imageView.frameWidth *0.24,imageView.frameHeight * 0.70);
            shareBtn.frameHeight = 30;
            shareBtn.frameWidth = 200;
            [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
            self.shareBtn = shareBtn;
            [imageView addSubview:shareBtn];
            
            
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundImage:[UIImage imageWithColor:yellowcolor] forState:UIControlStateNormal];
            [startBtn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(235, 108, 1)] forState:UIControlStateHighlighted];
            [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
            [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            startBtn.frame = CGRectMake(APPW/4, APPH * 0.80, APPW/2, 40);
            [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:startBtn];
        }
      
        
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = KCount;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.center =CGPointMake(scrollW * 0.5, scrollH - 40) ;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    
}
//开始按钮
-(void)startClick {
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [[XFTabBarViewController alloc]init];
    [self presentViewController:[[SinaTabBarController alloc]init] animated:YES completion:^{
        
    }];
    
    
}
//分享按钮
-(void)shareClick {
    
    self.shareBtn.selected = !self.shareBtn.isSelected;
    
}
//监听pageControl
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double page = scrollView.contentOffset.x / scrollView.frameWidth;
    
    self.pageControl.currentPage = (int)(page + 0.5);
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
