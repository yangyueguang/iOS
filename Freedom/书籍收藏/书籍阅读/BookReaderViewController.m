//  E_ScrollViewController.m
//   Freedom
//  Created by Super on 14-8-8.
#import "BookReaderViewController.h"
#import "E_ReaderViewController.h"
#import "E_Paging.h"
#import "BookSubViews.h"
#import "E_CommentViewController.h"
#import "E_SearchViewController.h"
#import "E_WebViewControler.h"
/*change by tiger --*/
@protocol CDSideBarControllerDelegate <NSObject>
- (void)menuButtonClicked:(int)index;
- (void)changeGestureRecognizers;
@end
@interface CDSideBarController : NSObject{
    UIView              *_backgroundMenuView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}
@property (nonatomic, strong) UIView *backgroundMenuView;
@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;
@property (nonatomic, retain) UITapGestureRecognizer *singleTap;
@property (nonatomic, retain) id<CDSideBarControllerDelegate> delegate;
- (CDSideBarController*)initWithImages:(NSArray*)buttonList;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)showMenu;
@end
@implementation CDSideBarController
- (CDSideBarController*)initWithImages:(NSArray*)images{
    //    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _menuButton.frame = CGRectMake(0, 0, 40, 40);
    //    [_menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    //    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    int index = 0;
    for (UIImage *image in [images copy]){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 50 + (80 * index), 50, 50);
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position{
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [view addGestureRecognizer:_singleTap];
    for (UIButton *button in _buttonList){
        [_backgroundMenuView addSubview:button];
    }
    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    [view addSubview:_backgroundMenuView];
}
#pragma mark -
#pragma mark Menu button action
- (void)dismissMenuWithSelection:(UIButton*)button{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}
- (void)dismissMenu{
    if (_isOpen)
    {
        _isOpen = !_isOpen;
        [self performDismissAnimation];
    }
}
- (void)showMenu{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}
- (void)onMenuButtonClick:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:button.tag];
    [self dismissMenuWithSelection:button];
}
#pragma mark -
#pragma mark - Animations
- (void)performDismissAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    } completion:^(BOOL finished) {
        [_delegate changeGestureRecognizers];
    }];
}
- (void)performOpenAnimation{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}
@end
@interface BookReaderViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,E_ReaderViewControllerDelegate,E_SettingTopBarDelegate,E_SettingBottomBarDelegate,E_DrawerViewDelegate,CDSideBarControllerDelegate,E_SearchViewControllerDelegate>{
    UIPageViewController * _pageViewController;
    E_Paging             * _paginater;
    BOOL _isTurnOver;     //是否跨章；
    BOOL _isRight;       //翻页方向  yes为右 no为左
    BOOL _pageIsAnimating;          //某些特别操作会导致只调用datasource的代理方法 delegate的不调用
    UITapGestureRecognizer *tapGesRec;
    E_SettingTopBar *_settingToolBar;
    E_SettingBottomBar *_settingBottomBar;
    UIButton *_searchBtn;
    UIButton *_markBtn;
    UIButton *_shareBtn;
    CGFloat   _panStartY;
    UIImage  *_themeImage;
    CDSideBarController *sideBar;
    NSString      *_searchWord;//用来接受搜索页面的keyword
}
@property (copy, nonatomic) NSString* chapterTitle_;
@property (copy, nonatomic) NSString* chapterContent_;
@property (unsafe_unretained, nonatomic) int fontSize;
@property (unsafe_unretained, nonatomic) NSUInteger readOffset;
@property (assign, nonatomic) NSInteger readPage;
@end
@implementation BookReaderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
   [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.hidesBottomBarWhenPushed = YES;//用push方法推出时，Tabbar隐藏
   
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [E_HUDView showMsg:@"长按选择文本" inView:nil];
    UIImage *sina = [UIImage imageNamed:@"u_icon_sina"];
    UIImage *friend=[UIImage imageNamed:@"friend"];
    UIImage *weixin = [UIImage imageNamed:@"u_icon_wechart"];
    UIImage *menu = [UIImage imageNamed:@"menuClose"];
    NSArray *imageList = [NSArray arrayWithObjects:sina,friend,weixin,menu,nil];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
    [sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, 50)];
    sideBar.singleTap.enabled = NO;
    //设置总章节数
    [E_ReaderDataSource shareInstance].totalChapter = 7;
    self.fontSize = [E_CommonManager fontSize];
    _pageIsAnimating = NO;
    NSInteger themeID = [E_CommonManager Manager_getReadTheme];
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld",(long)themeID]];
    }
    E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] openChapter];
    [self parseChapter:chapter];
    [self initPageView:NO];
    tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callToolBar)];
    [self.view addGestureRecognizer:tapGesRec];
    UIPanGestureRecognizer *panGesRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(LightRegulation:)];
    panGesRec.maximumNumberOfTouches = 2;
    panGesRec.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesRec];
  
}
- (void)LightRegulation:(UIPanGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            _panStartY = touchPoint.y;
        }break;
        case UIGestureRecognizerStateChanged:{
            CGFloat offSetY = touchPoint.y - _panStartY;
           // DLog(@"offSetY == %f",offSetY);
            CGFloat light = [UIScreen mainScreen].brightness;
            if (offSetY >=0 ) {
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight = percent + light;
                if (regulaLight >= 1.0) {
                    regulaLight = 1.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            }else{
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight = light + percent;
                if (regulaLight <= 0.0) {
                    regulaLight = 0.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            }
        }break;
        case UIGestureRecognizerStateEnded:{
        }break;
        default:
            break;
    }
}
- (void)callToolBar{
    if (_settingToolBar == nil) {
        _settingToolBar= [[E_SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
        [self.view addSubview:_settingToolBar];
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }else{
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    if (_settingBottomBar == nil) {
        _settingBottomBar = [[E_SettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
        [self.view addSubview:_settingBottomBar];
        _settingBottomBar.chapterTotalPage = _paginater.pageCount;
        _settingBottomBar.chapterCurrentPage = _readPage;
        _settingBottomBar.currentChapter = [E_ReaderDataSource shareInstance].currentChapterIndex;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
        
    }else{
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
    
}
- (void)initPageView:(BOOL)isFromMenu;{
    if (_pageViewController) {
       //  DLog(@"remove pageViewController");
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
   
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    if (isFromMenu == YES) {
        [self showPage:0];
    }else{
        NSUInteger beforePage = [[E_ReaderDataSource shareInstance] openPage];
        [self showPage:beforePage];
    }
}
#pragma mark - readerVcDelegate
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    if (yesOrNo == NO) {
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }else{
        _pageViewController.delegate = nil;
        _pageViewController.dataSource = nil;
    }
}
- (void)ciBaWithString:(NSString *)ciBaString{
   
    E_WebViewControler *webView = [[E_WebViewControler alloc] initWithSelectString:ciBaString];
    [self presentViewController:webView animated:YES completion:NULL];
}
#pragma mark - 点击侧边栏目录跳转
- (void)turnToClickChapter:(NSInteger)chapterIndex{
    E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] openChapter:chapterIndex + 1];//加1 是因为indexPath.row从0 开始的
    [self parseChapter:chapter];
    [self initPageView:YES];
}
- (void)sliderToChapterPage:(NSInteger)chapterIndex{
    //DLog(@"update");
    [self showPage:chapterIndex - 1];
}
#pragma mark - 点击侧边栏书签跳转
- (void)turnToClickMark:(E_Mark *)eMark{
    E_EveryChapter *e_chapter = [[E_ReaderDataSource shareInstance] openChapter:[eMark.markChapter integerValue]];
    [self parseChapter:e_chapter];
    if (_pageViewController) {
         DLog(@"remove pageViewController");
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    int showPage = [self findOffsetInNewPage:NSRangeFromString(eMark.markRange).location];
    [self showPage:showPage];
}
#pragma mark - 上一章
- (void)turnToPreChapter{
    if ([E_ReaderDataSource shareInstance].currentChapterIndex <= 1) {
        [E_HUDView showMsg:@"已经是第一章" inView:self.view];
        return;
    }
    [self turnToClickChapter:[E_ReaderDataSource shareInstance].currentChapterIndex - 2];
    
}
#pragma mark - 下一章
- (void)turnToNextChapter{
    if ([E_ReaderDataSource shareInstance].currentChapterIndex == [E_ReaderDataSource shareInstance].totalChapter) {
        [E_HUDView showMsg:@"已经是最后一章" inView:self.view];
        return;
    }
    [self turnToClickChapter:[E_ReaderDataSource shareInstance].currentChapterIndex];
}
#pragma mark - 隐藏设置bar
- (void)hideTheSettingBar{
    if (_settingToolBar == nil) {
       
    }else{
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    if (_settingBottomBar == nil) {
     }else{
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}
#pragma mark --
- (void)parseChapter:(E_EveryChapter *)chapter{
    self.chapterContent_ = chapter.chapterContent;
    self.chapterTitle_ = chapter.chapterTitle;
    [self configPaginater];
}
- (void)configPaginater{
    _paginater = [[E_Paging alloc] init];
    E_ReaderViewController *temp = [[E_ReaderViewController alloc] init];
    temp.delegate = self;
    [temp view];
    _paginater.contentFont = self.fontSize;
    _paginater.textRenderSize = [temp readerTextSize];
    _paginater.contentText = self.chapterContent_;
    [_paginater paginate];
}
- (void)readPositionRecord{
    int currentPage = [_pageViewController.viewControllers.lastObject currentPage];
    NSRange range = [_paginater rangeOfPage:currentPage];
    self.readOffset = range.location;
}
- (void)fontSizeChanged:(int)fontSize{
    [self readPositionRecord];
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    int showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage:showPage];
    
}
#pragma mark - 直接隐藏多功能下拉按钮
- (void)hideMultifunctionButton{
    if (_searchBtn) {
        [_shareBtn removeFromSuperview];_shareBtn = nil;[_markBtn removeFromSuperview];_markBtn = nil;[_searchBtn removeFromSuperview];_searchBtn = nil;
       
    }
}
#pragma mark - TopbarDelegate
- (void)goBack{
    sideBar.singleTap.enabled = NO;
    [sideBar.backgroundMenuView removeFromSuperview];
    [E_CommonManager saveCurrentPage:_readPage];
    [E_CommonManager saveCurrentChapter:[E_ReaderDataSource shareInstance].currentChapterIndex];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - 动画显示或隐藏多功能下拉按钮
- (void)showMultifunctionButton{
    if (_searchBtn) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [_shareBtn removeFromSuperview];
            _shareBtn = nil;
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_markBtn removeFromSuperview];
                _markBtn = nil;
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [_searchBtn removeFromSuperview];
                                            _searchBtn = nil;
          });
            });
        });
        return;
    }
   
    _searchBtn = [UIButton buttonWithType:0];
    _searchBtn.frame = CGRectMake(self.view.frame.size.width - 70, 20 + 44 + 16, 44, 44);
    [_searchBtn setTitle:@"搜索" forState:0];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _searchBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _searchBtn.layer.cornerRadius = 22;
    [_searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    _markBtn = [UIButton buttonWithType:0];
    [_markBtn setTitle:@"书签" forState:0];
    _markBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _markBtn.frame = CGRectMake(self.view.frame.size.width - 70 , 20 + 44 + 16 + 44 + 16, 44, 44);
    _markBtn.layer.cornerRadius = 22;
    NSRange range = [_paginater rangeOfPage:_readPage];
    if ([E_CommonManager checkIfHasBookmark:range withChapter:[E_ReaderDataSource shareInstance].currentChapterIndex]) {
        _markBtn.selected = YES;
    }else{
        _markBtn.selected = NO;
    }
    if (_markBtn.selected == YES) {
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
    }else{
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    _markBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_markBtn addTarget:self action:@selector(doMark) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = [UIButton buttonWithType:0];
    _shareBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _shareBtn.frame = CGRectMake(self.view.frame.size.width - 70, 20 + 44 + 16 + 44 + 16 + 44 + 16, 44, 44);
    [_shareBtn setTitle:@"分享" forState:0];
    _shareBtn.layer.cornerRadius = 22;
    [_shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[self.view addSubview:_searchBtn];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view addSubview:_markBtn];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view addSubview:_shareBtn];
            });
            });
    });
    
}
#pragma mark - 多功能按钮群中的搜索按钮触发事件
- (void)doSearch{
    [self hideMultifunctionButton];
    [self hideTheSettingBar];
    sideBar.singleTap.enabled = NO;
    E_SearchViewController *searchVc = [[E_SearchViewController alloc] init];
    searchVc.delegate = self;
    [self presentViewController:searchVc animated:YES completion:NULL];
}
- (void)doShare{
    tapGesRec.enabled = NO;
    sideBar.singleTap.enabled = YES;
    for (int i = 0; i < _pageViewController.gestureRecognizers.count; i ++) {
        UIGestureRecognizer *ges = (UIGestureRecognizer *)[_pageViewController.gestureRecognizers objectAtIndex:i];
        ges.enabled = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_shareBtn removeFromSuperview];_shareBtn = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_markBtn removeFromSuperview];_markBtn = nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.09 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [_searchBtn removeFromSuperview];_searchBtn = nil;[self hideTheSettingBar]; [sideBar showMenu];
                });
            });
        });
    });
}
- (void)doMark{
    _markBtn.selected = !_markBtn.selected;
    if (_markBtn.selected == YES) {
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
    }else{
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    NSRange range = [_paginater rangeOfPage:_readPage];
    [E_CommonManager saveCurrentMark:[E_ReaderDataSource shareInstance].currentChapterIndex andChapterRange:range byChapterContent:_paginater.contentText];
}
#pragma mark - searchViewControllerDelegate -
- (void)turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord{
    _searchWord = keyWord;
    E_EveryChapter *e_chapter = [[E_ReaderDataSource shareInstance] openChapter:[chapter integerValue]];//加1 是因为indexPath.row从0 开始的
    [self parseChapter:e_chapter];
    if (_pageViewController) {
        // DLog(@"remove pageViewController");
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    int showPage = [self findOffsetInNewPage:searchRange.location - [[E_ReaderDataSource shareInstance] getChapterBeginIndex:[chapter integerValue]]];
    [self showPage:showPage];
}
#pragma mark - CDSideBarDelegate -- add by tiger-
- (void)changeGestureRecognizers{
    tapGesRec.enabled = YES;
    for (int i = 0 ; i < _pageViewController.gestureRecognizers.count; i ++) {
        UIGestureRecognizer *ges = (UIGestureRecognizer *)[_pageViewController.gestureRecognizers objectAtIndex:i];
        ges.enabled = YES;
    }
}
- (void)menuButtonClicked:(int)index{
    if (index == 0) {
        [E_HUDView showMsg:@"分享至新浪" inView:self.view];
    }else if (index == 1){
        [E_HUDView showMsg:@"分享至朋友圈" inView:self.view];
    }else if(index == 2){
        [E_HUDView showMsg:@"分享至微信" inView:self.view];
    }
}
#pragma mark - 底部左侧按钮触发事件
- (void)callDrawerView{
    [self callToolBar];
    tapGesRec.enabled = NO;
    sideBar.singleTap.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        E_DrawerView *drawerView = [[E_DrawerView alloc] initWithFrame:self.view.frame parentView:self.view];drawerView.delegate = self;
        [self.view addSubview:drawerView];
    });
    
}
#pragma mark - 底部右侧按钮触发事件
- (void)callCommentView{
    E_CommentViewController *e_commentVc = [[E_CommentViewController alloc] init];
    [self presentViewController:e_commentVc animated:YES completion:NULL];
}
- (void)openTapGes{
    tapGesRec.enabled = YES;
}
// //////////////////////////////////////////////////////////////////
#pragma mark - 改变主题
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme{
    if (theme == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld",(long)theme]];
    }
    [self showPage:self.readPage];
}
#pragma mark - 根据偏移值找到新的页码
- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset{
    int pageCount = _paginater.pageCount;
    for (int i = 0; i < pageCount; i++) {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset) {
            return i;
        }
    }
    return 0;
}
//显示第几页
- (void)showPage:(NSUInteger)page{
    E_ReaderViewController *readerController = [self readerControllerWithPage:page];
    [_pageViewController setViewControllers:@[readerController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL f){
                                     
                                 }];
}
- (E_ReaderViewController *)readerControllerWithPage:(NSUInteger)page{
    _readPage = page;
    E_ReaderViewController *textController = [[E_ReaderViewController alloc] init];
    textController.delegate = self;
    textController.keyWord = _searchWord;
    textController.themeBgImage = _themeImage;
    if (_themeImage == nil) {
        textController.view.backgroundColor = [UIColor whiteColor];
    }else{
        textController.view.backgroundColor = [UIColor colorWithPatternImage:_themeImage];
    }
    [textController view];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    textController.chapterTitle = self.chapterTitle_;
    textController.font = self.fontSize;
    textController.text = [_paginater stringOfPage:page];
    if (_settingBottomBar) {
        float currentPage = [[NSString stringWithFormat:@"%ld",_readPage] floatValue] + 1;
        float totalPage = [[NSString stringWithFormat:@"%ld",textController.totalPage] floatValue];
        float percent;
        if (currentPage == 1) {//强行放置头部
            percent = 0;
        }else{
            percent = currentPage/totalPage;
        }
        [_settingBottomBar changeSliderRatioNum:percent];
    }
    _searchWord = nil;
    return textController;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIPageViewDataSource And UIPageViewDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    _isTurnOver = NO;
    _isRight = NO;
   // DLog(@"go before");
    E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    if (_pageIsAnimating && currentPage <= 0) {
        E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
        [self parseChapter:chapter];
    }
    if (currentPage <= 0) {
        _isTurnOver = YES;
        E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] preChapter];
        if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""]) {
            _pageIsAnimating = NO;
            return  nil;
        }
        [self parseChapter:chapter];
        currentPage = self.lastPage + 1;
    }
    _pageIsAnimating = YES;
    E_ReaderViewController *textController = [self readerControllerWithPage:currentPage - 1];
    return textController;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    _isTurnOver = NO;
    _isRight = YES;
   //  DLog(@"go after");
    E_ReaderViewController *reader = (E_ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    if (_pageIsAnimating && currentPage <= 0) {
        E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
        [self parseChapter:chapter];
    }
    if (currentPage >= self.lastPage) {
        _isTurnOver = YES;
        E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
        if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""]) {
            _pageIsAnimating = NO;
            return nil;
        }
        [self parseChapter:chapter];
        currentPage = -1;
    }
    _pageIsAnimating = YES;
    E_ReaderViewController *textController = [self readerControllerWithPage:currentPage + 1];
    return textController;
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    _pageIsAnimating = NO;
    
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        //翻页完成
    }else{ //翻页未完成 又回来了。
        if (_isTurnOver && !_isRight) {//往右翻 且正好跨章节
            E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] nextChapter];
            [self parseChapter:chapter];
        }else if(_isTurnOver && _isRight){//往左翻 且正好跨章节
            E_EveryChapter *chapter = [[E_ReaderDataSource shareInstance] preChapter];
            [self parseChapter:chapter];
        }
    }
}
- (NSUInteger)lastPage{
    return _paginater.pageCount - 1;
}
@end
