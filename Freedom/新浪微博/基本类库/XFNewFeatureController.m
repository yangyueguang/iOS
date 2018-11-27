//  XFNewFeatureController.m
//  Freedom
//  Created by Fay on 15/9/19.
#import "SinaNewFeatureController.h"
#import "SinaTabBarController.h"

@interface SinaNewFeatureController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic,weak) UIButton *shareBtn;
@end
@implementation SinaNewFeatureController
- (void)viewDidLoad {
    [super viewDidLoad];

    int KCount = 4;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat scrollH = scrollView.frameHeight;
    scrollView.contentSize = CGSizeMake(scrollW * KCount, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
   
    for (int i = 0; i < KCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * scrollW, 0, scrollW, scrollH)];
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d@2x",i+1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        if (i == KCount -1) {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setImage:[UIImage imageNamed:@"u_gou_gray"] forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:@"u_gou_g"] forState:UIControlStateSelected];
            [shareBtn setTitle:@"分享至微博" forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            shareBtn.center = CGPointMake(imageView.frame.size.width *0.24,imageView.frameHeight * 0.70);
            shareBtn.frameSize = CGSizeMake(200, 30);
            [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
            self.shareBtn = shareBtn;
            [imageView addSubview:shareBtn];
            
            
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
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
    
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.pageControl.currentPage = (int)(page + 0.5);
    
    
}

@end
