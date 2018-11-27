//  MainViewController.m
//  CLKuGou
//  Created by Darren on 16/7/29.
#import "MainViewController.h"
#import "LinsenViewController.h"//听
#import "LookViewController.h"//看
#import "SingViewController.h"//唱
#import "SettingViewController.h"//左侧设置
#import "TabBarView.h"
//#import ""//右侧设置
#import "RESideMenu.h"//自定义转场
#define mainTextColor [UIColor whiteColor]
#define selectedColor [UIColor whiteColor]
#define titleFont [UIFont systemFontOfSize:18]
@interface TitleScrollHelper : NSObject
//计算间隔
+(CGFloat)caculateSpaceByTitleArray:(NSArray *)titleArray rect:(CGRect)rect;
//计算标题大小
+(CGSize)titleSize:(NSString *)title height:(CGFloat)height;
@end
@interface TitleScrollView : UIScrollView
typedef void (^SelectBlock)(NSInteger index);
/*创建一个标题滚动栏
 *  @param frame          布局
 *  @param titleArray     标题数组
 *  @param selected_index 默认选中按钮的索引
 *  @param scrollEnable   能否滚动
 *  @param isEqual        下面的条子是否按数量等分宽度 YES:等分 NO:按照标题宽度
 *  @param selectBlock    点击标题回调方法
 *
 *  @return 滚动视图对象*/
-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqual
                       color:(UIColor *)color
                 selectColor:(UIColor *)selectColor
                 SelectBlock:(SelectBlock)selectBlock;
/*修改选中标题
 *  @param selectedIndex 选中标题的索引*/
-(void)setSelectedIndex:(NSInteger)selectedIndex;
/*把按钮放出来以便改变可以其颜色 （陈亮）*/
@property (nonatomic,strong) UIButton *titleButton;
/*把line放出来,有的界面不需要显示,直接隐藏它 (郭长峰)*/
@property (nonatomic,strong) UILabel        *line;
@end
@implementation TitleScrollHelper
+(CGFloat)caculateSpaceByTitleArray:(NSArray *)titleArray rect:(CGRect)rect{
    CGFloat width = 0;
    for (NSString *title in titleArray){
        width =width + [TitleScrollHelper titleSize:title height:rect.size.height].width;
    }
    return (rect.size.width - width)/titleArray.count;
}
+(CGSize)titleSize:(NSString *)title height:(CGFloat)height{
    return [title boundingRectWithSize:CGSizeMake(0, height) options:3 attributes:@{NSFontAttributeName:titleFont} context:nil].size;
}
@end
@implementation TitleScrollView{
    UIButton       *selectedButt;
    SelectBlock    block;
    NSMutableArray *buttonArray;
    BOOL           isEqualWidth;
}
/*创建一个标题滚动栏
 *  @param frame          布局
 *  @param titleArray     标题数组
 *  @param selected_index 默认选中按钮的索引
 *  @param scrollEnable   能否滚动
 *  @param isEqual        下面的条子是否按数量等分宽度 YES:等分 NO:按照标题宽度
 *  @param selectBlock    点击标题回调方法
 *  @return 滚动视图对象*/
-(instancetype)initWithFrame:(CGRect)frame
                  TitleArray:(NSArray *)titleArray
               selectedIndex:(NSInteger)selected_index
                scrollEnable:(BOOL)scrollEnable
              lineEqualWidth:(BOOL)isEqual
                       color:(UIColor *)color
                 selectColor:(UIColor *)selectColor
                 SelectBlock:(SelectBlock)selectBlock;{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        CGFloat orign_x = 0;
        CGFloat height = self.frame.size.height;
        
        CGFloat space = scrollEnable?20:[TitleScrollHelper caculateSpaceByTitleArray:titleArray rect:frame];
        buttonArray = [NSMutableArray new];
        block = selectBlock;
        isEqualWidth = isEqual;
        for (int i = 0; i<titleArray.count; i++)
        {
            NSString *title =titleArray[i];
            CGSize size = [TitleScrollHelper titleSize:title height:frame.size.height];
            self.titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
            self.titleButton.frame = CGRectMake(orign_x, 0, size.width+space, height);
            [self.titleButton setTitle:title forState:UIControlStateNormal];
            [self.titleButton setTitleColor:color forState:UIControlStateNormal];
            [self.titleButton setTitleColor:selectColor forState:UIControlStateSelected];
            [self.titleButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            self.titleButton.titleLabel.font =titleFont;
            self.titleButton.tag = i;
            orign_x = orign_x+space+size.width;
            self.contentSize = CGSizeMake(orign_x, height);
            if (i == selected_index)
            {
                [self.titleButton setSelected:YES];
                selectedButt = self.titleButton;
                self.line =[[UILabel alloc]init];
                self.line.backgroundColor = selectColor;
                [self addSubview:self.line];
            }
            [buttonArray addObject:self.titleButton];
            [self addSubview:self.titleButton];
            
        }
        [self buttonOffset:selectedButt];
    }
    return self;
}
//按钮点击
-(void)headButtonClick:(UIButton *)butt{
    [self buttonOffset:butt animated:YES];
    for (UIButton *button in buttonArray){
        BOOL isSelected = button.tag == butt.tag?YES:NO;
        [button setSelected:isSelected];
    }block(butt.tag);
}
//点击控制滚动视图的偏移量
-(void)buttonOffset:(UIButton *)butt animated:(BOOL)animated{
    if (animated){
        [UIView animateWithDuration:0.2 animations:^{
            [self buttonOffset:butt];
        }];
    }else{
        [self buttonOffset:butt];
    }
}
-(void)buttonOffset:(UIButton *)butt{
    CGSize size = [TitleScrollHelper titleSize:butt.titleLabel.text height:butt.frame.size.height];
    CGFloat width = isEqualWidth?self.frame.size.width/buttonArray.count:size.width;
    self.line.bounds = CGRectMake(0, 0, width, 3);
    self.line.center = CGPointMake(butt.center.x, butt.frame.size.height-0.75);
    for (UIButton *button in buttonArray){
        BOOL isSelected = button.tag == butt.tag?YES:NO;
        [button setSelected:isSelected];
    }
    if (butt.center.x<=self.center.x){
        self.contentOffset = CGPointMake(0, 0);
    }else if ((butt.center.x>self.center.x)&&((self.contentSize.width-butt.center.x)>(self.frame.size.width/2.0))){
        self.contentOffset = CGPointMake(butt.center.x-self.center.x, 0);
    }else{
        self.contentOffset = CGPointMake(self.contentSize.width-self.frame.size.width, 0);
    }
}
/*修改选中标题
 *  @param selectedIndex 选中标题的索引*/
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    for (UIButton *butt in buttonArray){
        if (butt.tag == selectedIndex){
            [self buttonOffset:butt animated:YES];break;
        }
    }
}
@end
@interface MainViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, strong) TitleScrollView *titleView;
@property (nonatomic, strong) TabBarView *coustomTabBar;
@end
@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupChildViews];
    [self setupContentView];
    
    _coustomTabBar = [TabBarView show];
    _coustomTabBar.frame = CGRectMake(0, APPH-TabBarH, APPW, TabBarH);
    [self.view addSubview:_coustomTabBar];
//    [self setupRightGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage) name:@"ChangeMainVCContentEnable" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight|UIRectEdgeBottom;
}
- (void)getMessage{
    self.contentView.userInteractionEnabled = YES;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (TitleScrollView *)titleView{
    if (_titleView == nil) {
        _titleView = [[TitleScrollView alloc] initWithFrame:CGRectMake(100, 34, APPW-200, 30) TitleArray:@[@"听",@"看",@"唱"] selectedIndex:0 scrollEnable:NO lineEqualWidth:NO color:[UIColor whiteColor] selectColor:[UIColor orangeColor] SelectBlock:^(NSInteger index) {
            [self titleClick:index];
        }];
    }return _titleView;
}
- (void)setupNav{
    [self.navBar addSubview:self.titleView];    
    self.leftItem.image = [UIImage imageNamed:@"placeHoder-128"];
    self.leftItem.frame = CGRectMake(15, 34, 25, 25);
    RViewsBorder(self.leftItem, self.leftItem.frameWidth*0.5, 1, [UIColor grayColor]);
    self.rightItem.image = [UIImage imageNamed:@"main_search"];
    self.rightItem.frame = CGRectMake(APPW-40, 34, 20, 20);
    self.navBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
}
- (void)setupChildViews{
    LinsenViewController *linsenVc = [[LinsenViewController alloc] init];
    [self addChildViewController:linsenVc];
    LookViewController *lookVc = [[LookViewController alloc] init];
    [self addChildViewController:lookVc];
    SingViewController *singVc = [[SingViewController alloc] init];
    [self addChildViewController:singVc];
}
- (void)titleClick:(NSInteger)index{
    [self.titleView setSelectedIndex:index];
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = index * self.contentView.frameWidth;
    [self.contentView setContentOffset:offset animated:YES];
}
//  底部的scrollView
- (void)setupContentView{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.bounces = NO;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.frameWidth * self.childViewControllers.count, 0);
    self.contentView = contentView;
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frameWidth;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frameX = scrollView.contentOffset.x;
    vc.view.frameY = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.frameHeight = scrollView.frameHeight; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.frameWidth;
    [self titleClick:index];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alphe = scrollView.contentOffset.x / scrollView.frameWidth;
    self.navBar.backgroundColor = [UIColor colorWithRed:51/255. green:124/255. blue:200/255. alpha:alphe];
}
#pragma mark - 抽屉效果
-(void)leftItemTouched:(id)sender{
    // 如果是已经跳转了，点击后没有反应
     [self.sideMenuViewController presentLeftMenuViewController];
    
}
@end
