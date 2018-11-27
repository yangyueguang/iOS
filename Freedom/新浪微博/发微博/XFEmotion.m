//  XFEmotion.m
//  
//  Created by Fay on 15/10/18.
//
#import "XFEmotion.h"
#import "MJExtension.h"
// 一页中最多3行
#define XFEmotionMaxRows 3
// 一行中最多7列
#define XFEmotionMaxCols 7
// 每一页的表情个数
#define XFEmotionPageSize ((XFEmotionMaxRows * XFEmotionMaxCols) - 1)
// 最近表情的存储路径
#define XFRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]
@interface XFEmotion () <NSCoding>
@end
@implementation XFEmotion
MJCodingImplementation
- (BOOL)isEqual:(XFEmotion *)other{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}
@end
@class XFEmotionTabBar;
@protocol XFEmotionTabBarDelegate <NSObject>
@optional
- (void)emotionTabBar:(XFEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType;
@end
@interface XFEmotionTabBarButton : UIButton
@end
@implementation XFEmotionTabBarButton
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return self;
}
//重写highlight方法，取消掉高亮状态
-(void)setHighlighted:(BOOL)highlighted {
    
    
    
}
@end
@interface XFEmotionTabBar : UIView
@property (nonatomic, weak) id<XFEmotionTabBarDelegate> delegate;
@end
@interface XFEmotionTabBar()
@property (nonatomic, weak) XFEmotionTabBarButton *selectedBtn;
@end
@implementation XFEmotionTabBar
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupBtn:@"最近" buttonType:XFEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:XFEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:XFEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:XFEmotionTabBarButtonTypeLxh];
        
    }
    return self;
}
/*创建一个按钮
 *
 *  @param title 按钮文字*/
- (XFEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(XFEmotionTabBarButtonType)buttonType {
    
    XFEmotionTabBarButton *btn = [[XFEmotionTabBarButton alloc]init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    
    if (buttonType == XFEmotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    
    
    return btn;
    
}
//重写delegate 方法
-(void)setDelegate:(id<XFEmotionTabBarDelegate>)delegate {
    
    _delegate = delegate;
    
    //选中默认按钮
    [self btnClick:(XFEmotionTabBarButton *)[self viewWithTag:XFEmotionTabBarButtonTypeDefault]];
    
    
}
/*按钮点击*/
- (void)btnClick:(XFEmotionTabBarButton *)btn {
    
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(int)btn.tag];
    }
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.frameWidth / btnCount;
    CGFloat btnH = self.frameHeight;
    for (int i = 0; i<btnCount; i++) {
        XFEmotionTabBarButton *btn = self.subviews[i];
        btn.frameY = 0;
        btn.frameWidth = btnW;
        btn.frameX = i * btnW;
        btn.frameHeight = btnH;
    }
}
@end
@implementation XFEmotionAttachment
- (void)setEmotion:(XFEmotion *)emotion{
    
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@implementation XFTextView
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    
    
    return self;
    
}
-(void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
    
    
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
    
}
-(void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self setNeedsDisplay];
    
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}
//移除通知
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
    
}
/**
 * 监听文字改变*/
-(void)textDidChange {
    
    //重绘
    [self setNeedsDisplay];
    
}
-(void)drawRect:(CGRect)rect {
    
    if (self.hasText) return;
    
    //文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    // 画文字
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attr];
    
    
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@implementation XFEmotionTextView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)insertEmotion:(XFEmotion *)emotion {
    
    if (emotion.code) {
        // insertText : 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        // 加载图片
        XFEmotionAttachment *attch = [[XFEmotionAttachment alloc] init];
        //传递数据
        attch.emotion = emotion;
        // 设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标位置
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]init];
        //拼接之前的文件
        [attributedText appendAttributedString:self.attributedText];
        
        //拼接图片
        NSUInteger loc = self.selectedRange.location;
        //[attributedText insertAttributedString:text atIndex:loc];
        [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:imageStr];
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        self.attributedText = attributedText;
        
        //移除光标到表情的后面
        self.selectedRange = NSMakeRange(loc + 1, 0);
        // 设置字体
        //        NSMutableAttributedString *attributedText = (NSMutableAttributedString *)self.attributedText;
        //        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        
    }
    
    
}
- (NSString *)fullText{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        XFEmotionAttachment *attch = attrs[@"NSAttachment"];
        
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}
/**
 selectedRange :
 1.本来是用来控制textView的文字选中范围
 2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
 
 关于textView文字的字体
 1.如果是普通文字（text），文字大小由textView.font控制
 2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
 **/
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@interface XFEmotionPageView : UIView
/** 这一页显示的表情（里面都是XFEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;
@end
@class XFEmotion;
@interface XFEmotionTool : NSObject
+ (void)addRecentEmotion:(XFEmotion *)emotion;
+ (NSArray *)recentEmotions;
@end
@implementation XFEmotionTool
static NSMutableArray *_recentEmotions;
+ (void)initialize{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XFRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}
+ (void)addRecentEmotion:(XFEmotion *)emotion{
    // 删除重复的表情
    [_recentEmotions removeObject:emotion];
    
    // 将表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情数据写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XFRecentEmotionsPath];
}
/*返回装着XFEmotion模型的数组*/
+ (NSArray *)recentEmotions{
    return _recentEmotions;
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@class XFEmotion;
@interface XFEmotionButton : UIButton
@property (nonatomic, strong) XFEmotion *emotion;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@implementation XFEmotionButton
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    
    // 按钮高亮的时候。不要去调整图片（不要调整图片会灰色）
    self.adjustsImageWhenHighlighted = NO;
    //    self.adjustsImageWhenDisabled
}
- (void)setEmotion:(XFEmotion *)emotion{
    _emotion = emotion;
    
    if (emotion.png) { // 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) { // 是emoji表情
        // 设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@interface XFEmotionPageView ()
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end
@implementation XFEmotionPageView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
    }
    return self;
}
-(void)setEmotions:(NSArray *)emotions {
    
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        XFEmotionButton *btn = [[XFEmotionButton alloc]init];
        [self addSubview:btn];
        //设置表情数据
        btn.emotion = emotions[i];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}
//监听删除按钮点击
-(void)deleteClick {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidDeleteNotification" object:nil];
    
    
}
-(void)btnClick:(XFEmotionButton *)btn{
    
    [self selectEmotion:btn.emotion];
    
}
-(void)selectEmotion:(XFEmotion *)emotion {
    
    //将这个表情存进沙盒
    [XFEmotionTool addRecentEmotion:emotion];
    
    
    //发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"SelectEmotionKey"] = emotion;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EmotionDidSelectNotification" object:nil userInfo:userInfo];
    
    
    
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    //内边距
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnw = (self.frameWidth - 2 * inset) /XFEmotionMaxCols;
    CGFloat btnH = (self.frameHeight - inset) /XFEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i+1];
        btn.frameWidth = btnw;
        btn.frameHeight = btnH;
        btn.frameX = inset + (i%XFEmotionMaxCols) * btnw;
        btn.frameY = inset + (i/XFEmotionMaxCols) * btnH;
        
    }
    // 删除按钮
    self.deleteButton.frame = CGRectMake(self.frameWidth - inset - btnw,  self.frameHeight - btnH, btnw, btnH);
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
@interface XFEmotionListView : UIView
/** 表情(里面存放的XFEmotion模型) */
@property (nonatomic, strong) NSArray *emotions;
@end
@interface XFEmotionListView ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;
@end
@implementation XFEmotionListView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 1.UIScollView
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        //私有属性，使用KVC赋值
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
    }
    return self;
}
// 根据emotions，创建对应个数的表情
-(void)setEmotions:(NSArray *)emotions {
    
    _emotions = emotions;
    
    // 删除之前的控件
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //计算页码
    NSUInteger count = (emotions.count + XFEmotionPageSize - 1) /XFEmotionPageSize;
    // 1.设置页数
    self.pageControl.numberOfPages = count;
    // 2.创建用来显示每一页表情的控件
    for (int i = 0; i<self.pageControl.numberOfPages; i++) {
        XFEmotionPageView *pageView = [[XFEmotionPageView alloc]init];
        // 计算这一页的表情范围
        NSRange range;
        range.location  = i *XFEmotionPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if (left >= XFEmotionPageSize) {
            range.length = XFEmotionPageSize;
        }else {
            
            range.length = left;
        }
        
        //设置这一页表情
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    [self setNeedsLayout];
    
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    //1.pageControl
    self.pageControl.frameWidth = self.frameWidth;
    self.pageControl.frameHeight = 35;
    self.pageControl.frameX = 0;
    self.pageControl.frameY = self.frameHeight - self.pageControl.frameHeight;
    
    //2.scrollView
    self.scrollView.frameWidth = self.frameWidth;
    self.scrollView.frameHeight = self.pageControl.frameY;
    self.scrollView.frameX = self.scrollView.frameY = 0;
    //3.设置scrollerView内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i<count; i++) {
        XFEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.frameHeight = self.scrollView.frameHeight;
        pageView.frameWidth = self.scrollView.frameWidth;
        pageView.frameX = i * pageView.frameWidth;
        pageView.frameY = 0;
    }
    //4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.frameWidth, 0);
    
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double pageNum = scrollView.contentOffset.x / scrollView.frameWidth;
    
    self.pageControl.currentPage = (int)(pageNum + 0.5);
    
    
}
@end
@interface XFEmotionKeyboard()<XFEmotionTabBarDelegate>
/** 保存正在显示listView */
@property (nonatomic, weak) XFEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) XFEmotionListView *recentListView;
@property (nonatomic, strong) XFEmotionListView *defaultListView;
@property (nonatomic, strong) XFEmotionListView *emojiListView;
@property (nonatomic, strong) XFEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) XFEmotionTabBar *tabBar;
@end
@implementation XFEmotionKeyboard
#pragma mark - 懒加载
-(XFEmotionListView *)recentListView{
    if (!_recentListView) {
        self.recentListView = [[XFEmotionListView alloc] init];
        //加载沙盒中的数据
        self.recentListView.emotions = [XFEmotionTool recentEmotions];
        
    }
    return _recentListView;
}
-(XFEmotionListView *)defaultListView {
    
    if (!_defaultListView) {
        self.defaultListView = [[XFEmotionListView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        
        self.defaultListView.emotions = [XFEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
        
    }
    return _defaultListView;
    
}
- (XFEmotionListView *)emojiListView{
    if (!_emojiListView) {
        self.emojiListView = [[XFEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [XFEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
    }
    return _emojiListView;
}
- (XFEmotionListView *)lxhListView{
    if (!_lxhListView) {
        self.lxhListView = [[XFEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [XFEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        
    }
    return _lxhListView;
}
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        XFEmotionTabBar *tabbar = [[XFEmotionTabBar alloc]init];
        tabbar.delegate = self;
        [self addSubview:tabbar];
        self.tabBar = tabbar;
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    
    
    return self;
}
-(void)emotionDidSelect {
    self.recentListView.emotions = [XFEmotionTool recentEmotions];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 1.tabbar
    self.tabBar.frameWidth = self.frameWidth;
    self.tabBar.frameHeight = 37;
    self.tabBar.frameX = 0;
    self.tabBar.frameY = self.frameHeight - self.tabBar.frameHeight;
    
    // 2.表情内容
    self.showingListView.frameX = self.showingListView.frameY = 0;
    self.showingListView.frameWidth = self.frameWidth;
    self.showingListView.frameHeight = self.tabBar.frameY;
    
}
#pragma mark - XFEmotionTabBarDelegate
- (void)emotionTabBar:(XFEmotionTabBar *)tabBar didSelectButton:(XFEmotionTabBarButtonType)buttonType {
    
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换contentView上面的listview
    switch (buttonType) {
        case XFEmotionTabBarButtonTypeDefault:{//默认
            
            [self addSubview:self.defaultListView];
            
            break;
        }
        case XFEmotionTabBarButtonTypeLxh:{//浪小花
            [self addSubview:self.lxhListView];
            
            break;
        }
        case XFEmotionTabBarButtonTypeEmoji:{ //Emoji
            [self addSubview:self.emojiListView];
            
            break;
        }
            
        case XFEmotionTabBarButtonTypeRecent:{ //最近
            
            [self addSubview:self.recentListView];
            break;
        }
            
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    [self setNeedsLayout];
}
@end
@interface XFComposeToolbar()
@property (nonatomic, weak) UIButton *emotionButton;
@end
@implementation XFComposeToolbar
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:XFComposeToolbarButtonTypeCamera];
        
        [self setupBtn:Palbum_gray highImage:Palbum_y type:XFComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:XFComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:XFComposeToolbarButtonTypeTrend];
        
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:XFComposeToolbarButtonTypeEmotion];
    }
    return self;
}
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认的图片名
    NSString *image = @"compose_emoticonbutton_background";
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    
    // 显示键盘图标
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    
    // 设置图片
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}
/**
 * 创建一个按钮*/
- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(XFComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
    return btn;
}
-(void)btnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:(int)btn.tag];
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.frameWidth / count;
    CGFloat btnH = self.frameHeight;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.frameY = 0;
        btn.frameWidth = btnW;
        btn.frameX = i * btnW;
        btn.frameHeight = btnH;
    }
}
@end
@implementation XFComposePhotosView
-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _photos = [NSMutableArray array];
    }
    return self;
}
-(void)addPhoto:(UIImage *)photo {
    
    UIImageView *photoView = [[UIImageView alloc]init];
    photoView.image = photo;
    
    [self addSubview:photoView];
    //图片储存
    [self.photos addObject:photo];
    
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 80;
    CGFloat imageMargin = 10;
    
    for (int i = 0 ; i<count; i++) {
        UIImageView *image = self.subviews[i];
        
        int col = i % maxCol;
        image.frameX = col * (imageWH + imageMargin) + imageMargin;
        
        int row = i / maxCol;
        image.frameY = row * (imageWH + imageMargin);
        image.frameWidth = imageWH;
        image.frameHeight = imageWH;
        
        
    }
    
}
@end
