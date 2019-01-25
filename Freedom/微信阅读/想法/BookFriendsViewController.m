//  WXBaseViewController.m
//  WFCoretext
//  Created by Super on 14/10/28.
#import "BookFriendsViewController.h"
#import "BookFriendsTableViewCell.h"
#import "BookFriendsMode.h"
typedef  void(^didRemoveImage)(void);
@interface YMShowImageView : UIView<UIScrollViewDelegate>{
    UIImageView *showImage;
}
@property (nonatomic,copy) didRemoveImage removeImg;
- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray;
@end
@implementation YMShowImageView{
    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
}
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray{
    self = [super initWithFrame:frame];
    if (self) {
        self_Frame = frame;
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
    }
    return self;
}
- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray{
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    float W = self.frame.size.width;
    for (int i = 0; i < appendArray.count; i ++) {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *img = [appendArray objectAtIndex:i];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
    }
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - 9999), 0) animated:YES];
    page = clickTag - 9999;
}
- (void)disappear{
    _removeImg();
}
- (void)changeBig:(UITapGestureRecognizer *)tapGes{
    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    if (doubleClick == YES){
        [currentScrollView zoomToRect:zoomRect animated:YES];
    }else{
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    doubleClick = !doubleClick;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;
}
- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    // DLog(@" === %f",zoomRect.origin.x);
    return zoomRect;
}
- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    [bgView addSubview:self];
    _removeImg = tempBlock;
    [UIView animateWithDuration:.4f animations:^(){
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - ScorllViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width;
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    if (scrollV_next.zoomScale != 1.0){
        scrollV_next.zoomScale = 1.0;
    }
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    // DLog(@"page == %d",page);
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
}
@end
@protocol InputDelegate <NSObject>
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag;
- (void)destorySelf;
@end
@interface YMReplyInputView : UIView<UITextViewDelegate>{
    CGFloat topGap;
    CGFloat keyboardAnimationDuration;
    UIViewAnimationCurve keyboardAnimationCurve;
    int inputHeight;
    int inputHeightWithShadow;
    UIView *tapView;
}
@property (strong, nonatomic) UIButton* sendButton;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UILabel* lblPlaceholder;
@property (strong, nonatomic) UIImageView* inputBackgroundView;
@property (strong, nonatomic) UITextField *textViewBackgroundView;
@property (assign, nonatomic) BOOL autoResizeOnKeyboardVisibilityChanged;
@property (readwrite, nonatomic) CGFloat keyboardHeight;
@property (assign, nonatomic) id<InputDelegate>delegate;
@property (assign, nonatomic) NSInteger replyTag;
- (NSString*)text;
- (void)setText:(NSString*)text;
- (void)setPlaceholder:(NSString*)text;
- (void)showCommentView;
- (id) initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
- (void)disappear;
@end
@implementation YMReplyInputView
- (void) composeView{
    keyboardAnimationDuration = 0.4f;
    self.keyboardHeight = 216;
    topGap = 8;
    inputHeight = 38.0f;
    inputHeightWithShadow = 44.0f;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    CGSize size = self.frame.size;
    _inputBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _inputBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _inputBackgroundView.contentMode = UIViewContentModeScaleToFill;
    _inputBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_inputBackgroundView];
    _textViewBackgroundView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textViewBackgroundView.borderStyle = UITextBorderStyleRoundedRect;
    _textViewBackgroundView.autoresizingMask = UIViewAutoresizingNone;
    _textViewBackgroundView.userInteractionEnabled = NO;
    _textViewBackgroundView.enabled = NO;
    [self addSubview:_textViewBackgroundView];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(70.0f, topGap, 185 + APPW - 320, 0)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsMake(-4, -2, -4, 0);
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_textView];
    [self adjustTextInputHeightForText:@"" animated:NO];
    _lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(78.0f, topGap+2, 160, 20)];
    _lblPlaceholder.font = [UIFont systemFontOfSize:15.0f];
    _lblPlaceholder.text = @"评论...";
    _lblPlaceholder.textColor = [UIColor lightGrayColor];
    _lblPlaceholder.backgroundColor = [UIColor clearColor];
    [self addSubview:_lblPlaceholder];
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发表" forState:0];
    [_sendButton setBackgroundImage:[[UIImage imageNamed:@"button_send_comment"] stretchableImageWithLeftCapWidth:3 topCapHeight:22] forState:UIControlStateNormal];
    _sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_sendButton];
    [self sendSubviewToBack:_inputBackgroundView];
    self.backgroundColor = [UIColor colorWithRed:(0xD9 / 255.0) green:(0xDC / 255.0) blue:(0xE0 / 255.0) alpha:1.0];
    [self showCommentView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //最上面的一条细线
    UILabel *dividLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPW, 1)];
    dividLbl.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1.0];
    [self addSubview:dividLbl];
    self.backgroundColor = [UIColor whiteColor];
    _textView.frame = CGRectMake(5, _textView.frame.origin.y, APPW - 10 - 65, _textView.frame.size.height);
    CGRect f = _textView.frame;
    f.size.height = f.size.height+3;
    _textViewBackgroundView.frame = f;
    _lblPlaceholder.frame = CGRectMake(8, topGap+2, 230, 20);
    _lblPlaceholder.backgroundColor = [UIColor clearColor];
    _sendButton.frame = CGRectMake(APPW - 10 - 55,_textView.frame.origin.y, 55, 27);
}
- (void) awakeFromNib{[super awakeFromNib];
    [self composeView];
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil){
        [self listenForKeyboardNotifications:NO];
    }else{
        [self listenForKeyboardNotifications:YES];
    }
}
- (void) adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated{
    int h1 = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName: _textView.font } context:nil].size.height;
    int h2 = [text boundingRectWithSize:CGSizeMake(_textView.bounds.size.width - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName: _textView.font } context:nil].size.height;
    [UIView animateWithDuration:(animated ? .1f : 0) animations:^{
         int h = h2 == h1 ? inputHeightWithShadow : h2 + 24;
         if (h>78) {
             h =78;
         }
         int delta = h - self.frame.size.height;
         CGRect r2 = CGRectMake(0, self.frame.origin.y - delta, self.frame.size.width, h);
         self.frame = r2;
         _inputBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, h);
         CGRect r = _textView.frame;
         r.origin.y = topGap;
         r.size.height = h - 18;
         _textView.frame = r;
     } completion:^(BOOL finished){ }];
}
- (id) initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView{
    self = [super initWithFrame:frame];
    if (self){
        tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, APPH)];
        tapView.backgroundColor = [UIColor blackColor];
        tapView.userInteractionEnabled = YES;
        [bgView addSubview:tapView];
        tapView.hidden = YES;
        UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        [tapView addGestureRecognizer:tapGer];
        [self composeView];
    }
    return self;
}
- (void) fitText{
    [self adjustTextInputHeightForText:_textView.text animated:YES];
}
- (BOOL)resignFirstResponder{
    if (super.isFirstResponder)
        return [super resignFirstResponder];else if ([_textView isFirstResponder])
            return [_textView resignFirstResponder];
    return NO;
}
#pragma mark - Public Methods
- (NSString*)text{
    return _textView.text;
}
- (void) setText:(NSString*)text{
    _textView.text = text;
    _lblPlaceholder.hidden = text.length > 0;
    [self fitText];
}
- (void) setPlaceholder:(NSString*)text{
    _lblPlaceholder.text = text;
}
#pragma mark - Display
- (void)beganEditing{
    if (_autoResizeOnKeyboardVisibilityChanged){
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^{
             self.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight);
         } completion:^(BOOL fin){}];
        [self fitText];
    }
}
- (void)endedEditing{
    if (_autoResizeOnKeyboardVisibilityChanged){
        UIViewAnimationOptions opt = animationOptionsWithCurve(keyboardAnimationCurve);
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:opt animations:^{
             self.transform = CGAffineTransformIdentity;
         } completion:^(BOOL fin){}];
        [self fitText];
    }
    _lblPlaceholder.hidden = _textView.text.length > 0;
}
#pragma mark - Keyboard Notifications
- (void)listenForKeyboardNotifications:(BOOL)listen{
    if (listen){
        [self listenForKeyboardNotifications:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    }
}
- (void)updateKeyboardProperties:(NSNotification*)n{
    NSNumber *d = [[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationDuration = [d floatValue];
    d = [[n userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if (d!=nil && [d isKindOfClass:[NSNumber class]])
        keyboardAnimationCurve = [d integerValue];
    NSValue *v = [[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    if ([v isKindOfClass:[NSValue class]]){
        CGRect r = [v CGRectValue];
        r = [self.window convertRect:r toView:self];
        self.keyboardHeight = r.size.height;
    }
}
- (void)keyboardWillShow:(NSNotification*)n{
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self updateKeyboardProperties:n];
}
- (void)keyboardWillHide:(NSNotification*)n{
    [self updateKeyboardProperties:n];
}
- (void)keyboardDidHide:(NSNotification*)n{
}
- (void)keyboardDidShow:(NSNotification*)n{
    if ([_textView isFirstResponder]){
        [self beganEditing];
    }
}
static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve){
    UIViewAnimationOptions opt = (UIViewAnimationOptions)curve;
    return opt << 16;
}
#pragma mark - UITextFieldDelegate Delegate
- (void) textViewDidBeginEditing:(UITextView*)textview{
    [self beganEditing];
}
- (void) textViewDidEndEditing:(UITextView*)textview{
    [self endedEditing];
    _autoResizeOnKeyboardVisibilityChanged = NO;
}
- (BOOL) textView:(UITextView*)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if ([text isEqualToString:@"\n"]){
        [self performSelector:@selector(returnButtonPressed:) withObject:nil afterDelay:.1];
        return NO;
    }else if (range.location >= 140||range.location + text.length >140){
        //[self.superview makeToast:@"超过字数限制啦" duration:0.5f position:@"center-38"];
        return  YES;
    }else if (text.length > 0){
        [self adjustTextInputHeightForText:[NSString stringWithFormat:@"%@%@", textview.text, text] animated:YES];
    }
    return YES;
}
- (void) textViewDidChange:(UITextView*)textview{
    _lblPlaceholder.hidden = textview.text.length > 0;
    [self fitText];
    if(_textView.text.length == 141){
// [self.superview makeToast:@"超过字数限制啦" duration:0.5f position:@"center-38"];
    }
}
#pragma mark THChatInput Delegate
- (void) sendButtonPressed:(id)sender{
    if ([_textView.text isEqualToString:@""]) {
        return;
    }
    [_delegate YMReplyInputWithReply:_textView.text appendTag:_replyTag];
    [self disappear];
}
- (void)returnButtonPressed:(id)sender{
    [self sendButtonPressed:sender];
}
- (void)showCommentView{
    self.hidden = NO;
    tapView.hidden = NO;
    tapView.alpha = 0.6;
    _autoResizeOnKeyboardVisibilityChanged = YES;
    [self.textView becomeFirstResponder];
    [self beganEditing];
}
- (void)disappear{
    [self endedEditing];
    self.hidden = YES;
    tapView.hidden = YES;
    tapView.alpha = 1.0;
    _autoResizeOnKeyboardVisibilityChanged = NO;
    [self.textView resignFirstResponder];
    [_delegate destorySelf];
}
@end
typedef void(^DidSelectedOperationBlock)(NSInteger operationType);
@interface WFPopView : UIView
@property (nonatomic, assign) BOOL shouldShowed;
@property (nonatomic, copy) DidSelectedOperationBlock didSelectedOperationCompletion;
+ (instancetype)initailzerWFOperationView;
- (void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour;
- (void)dismiss;
@end
@interface WFPopView ()
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, assign) CGRect targetRect;
@end
@implementation WFPopView
+ (instancetype)initailzerWFOperationView {
    WFPopView *operationView = [[WFPopView alloc] initWithFrame:CGRectZero];
    return operationView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        [self addSubview:self.replyButton];
        [self addSubview:self.likeButton];
    }
    return self;
}
#pragma mark - Action
- (void)operationDidClicked:(UIButton *)sender {
    [self dismiss];
    if (self.didSelectedOperationCompletion) {
        self.didSelectedOperationCompletion(sender.tag);
    }
}
#pragma mark - Propertys
- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.tag = 0;
        [_replyButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _replyButton.frame = CGRectMake(0, 0, CGSizeMake(120, 34).width / 2.0, CGSizeMake(120, 34).height);
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyButton;
}
- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.tag = 1;
        [_likeButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.frame = CGRectMake(CGRectGetMaxX(_replyButton.frame), 0, CGRectGetWidth(_replyButton.bounds), CGRectGetHeight(_replyButton.bounds));
        [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _likeButton;
}
#pragma mark - 公开方法
- (void)showAtView:(UITableView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour {
    self.targetRect = targetRect;
    if (self.shouldShowed) {
        return;
    }
    [containerView addSubview:self];
    CGFloat width = CGSizeMake(120, 34).width;
    CGFloat height = CGSizeMake(120, 34).height;
    self.frame = CGRectMake(targetRect.origin.x, targetRect.origin.y - 5, 0, height);
    self.shouldShowed = YES;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(targetRect.origin.x - width, targetRect.origin.y - 5, width, height);
    } completion:^(BOOL finished) {
        [_replyButton setTitle:@"评论" forState:UIControlStateNormal];
        [_likeButton setTitle:(isFavour?@"取消赞":@"赞") forState:UIControlStateNormal];
    }];
}
- (void)dismiss {
    if (!self.shouldShowed) {
        return;
    }
    self.shouldShowed = NO;
    [UIView animateWithDuration:0.25f animations:^{
        [_replyButton setTitle:nil forState:UIControlStateNormal];
        [_likeButton setTitle:nil forState:UIControlStateNormal];
        CGFloat height = CGSizeMake(120, 34).height;
        self.frame = CGRectMake(self.targetRect.origin.x, self.targetRect.origin.y - 5, 0, height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
@interface BookFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>{
    NSMutableArray *_imageDataSource;
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    NSMutableArray *_tableDataSource;//tableview数据源
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    UITableView *mainTable;
    UIView *popView;
    YMReplyInputView *replyView ;
    NSInteger _replyIndex;
}
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end
@implementation BookFriendsViewController
#pragma mark - 数据源
- (void)configData{
    NSString *kAdmin = @"杨越光";
    NSString *kContentText1 = @"思想不会流血，不会感到痛苦，思想不会死去";
    NSString *kContentText2 = @"这张面具之下，不是肉体，而是一种思想但思想是不怕子弹的";
    NSString *kContentText3 = @"Most people are so ungrateful to be alive. But not you. Not anymore. ";
    NSString *kContentText4 = @"活着本来没有什么意义，但只要活着就会发现很多有趣的13688919929事，就像你发现了花，我又发现你一样[em:03:]。";
    NSString *kContentText5 = @"地狱的房间已满，于是，[em:02:][em:02:]死亡爬上了人间如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中";
    NSString *kContentText6 = @"如果一个人觉得他自己死的很不值,就会把诅咒留在他生前接触过的地方[em:02:]只要有人经过这些地方[em:02:]就会被咒语套中";
    NSString *kShuoshuoText1 = @"驱魔人 “你可知道邪恶深藏于你心深处，但我会始终在你的[em:02:]左右，握着我的手，我会让你看到神迹，抱紧信仰，除此你一无所有！”";
    NSString *kShuoshuoText2 = @"李太啊，我的饺子最好吃，劲道、柔软、不露馅[em:03:]揉面的时候要一直揉到面团表面象剥了壳的鸡蛋，吃起来一包鲜汁";
    NSString *kShuoshuoText3 = @"如果晚上月亮升起的时候，月光www.baidu.com照到我的门口，我希望[em:03:]月光www.baidu.com女神能满足我一个愿望，我想要一双人类的手。我想用我的双手把我的爱人紧紧地拥在怀中，哪怕只有一次。如果我从来没有品尝过温暖的感觉，也许我不会这样寒冷；如果我从没有感受过爱情的甜美，我也许就不会这样地痛苦。如果我没有遇到善良的佩格，如果我从来不曾离开过我的房间，我就不会知道我原来是这样的孤独";
    NSString *kShuoshuoText4 = @"人有的时候很脆弱，会遇到很多不如意18618881888的事，日积月累就会形成心结，就算想告诉亲戚朋友，他们也未必懂得怎样[em:03:]开解";
    NSString *kShuoshuoText5 = @"如果是像金钱这种东西被抢走的话，再抢[em:03:]回来就好了！但如果是人性或温暖的心的话……那就只有遇上心中同样是空虚的人，才有www.baidu.com办法帮你填补起内心的空洞";
    NSString *kShuoshuoText6 = @"双目瞪人玛[em:03:]丽肖,傀儡为子常怀抱,汝辈小儿需切记,梦中遇她莫尖叫";
    NSLog(@"%@%@",kShuoshuoText2,kShuoshuoText6);
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    WFReplyBody *body1 = [[WFReplyBody alloc] init];
    body1.replyUser = kAdmin;
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    WFReplyBody *body2 = [[WFReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
    WFReplyBody *body3 = [[WFReplyBody alloc] init];
    body3.replyUser = @"山姆";
    body3.repliedUser = @"";
    body3.replyInfo = kContentText3;
    WFReplyBody *body4 = [[WFReplyBody alloc] init];
    body4.replyUser = @"雷锋";
    body4.repliedUser = @"简森·阿克斯";
    body4.replyInfo = kContentText4;
    WFReplyBody *body5 = [[WFReplyBody alloc] init];
    body5.replyUser = kAdmin;
    body5.repliedUser = @"";
    body5.replyInfo = kContentText5;
    WFReplyBody *body6 = [[WFReplyBody alloc] init];
    body6.replyUser = @"红领巾";
    body6.repliedUser = @"";
    body6.replyInfo = kContentText6;
    WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[@"a",@"a",@"a"];
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody1.posterImgstr = @"mao.jpg";
    messBody1.posterName = @"迪恩·温彻斯特";
    messBody1.posterIntro = @"这个人很懒，什么都没有留下";
    messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
    messBody1.isFavour = YES;
    WFMessageBody *messBody2 = [[WFMessageBody alloc] init];
    messBody2.posterContent = kShuoshuoText1;
    messBody2.posterPostImage = @[@"a",@"a",@"a"];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4, nil];
    messBody2.posterImgstr = @"mao.jpg";
    messBody2.posterName = @"山姆·温彻斯特"; 
    messBody2.posterIntro = @"这个人很懒，什么都没有留下";
    messBody2.posterFavour = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    messBody2.isFavour = NO;
    WFMessageBody *messBody3 = [[WFMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText3;
    messBody3.posterPostImage = @[@"a",@"a",@"a",@"a",@"a",@"a"];
    messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2,body4,body6,body5,body4, nil];
    messBody3.posterImgstr = @"mao.jpg";
    messBody3.posterName = @"伊利丹怒风";
    messBody3.posterIntro = @"这个人很懒，什么都没有留下";
    messBody3.posterFavour = [NSMutableArray arrayWithObjects:@"路人甲",kAdmin,@"希尔瓦娜斯",@"鹿盔",@"黑手", nil];
    messBody3.isFavour = YES;
    WFMessageBody *messBody4 = [[WFMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText4;
    messBody4.posterPostImage = @[@"a",@"a",@"a",@"a",@"a"];
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
    messBody4.posterImgstr = @"mao.jpg";
    messBody4.posterName = @"基尔加丹";
    messBody4.posterIntro = @"这个人很懒，什么都没有留下";
    messBody4.posterFavour = [NSMutableArray arrayWithObjects:@"",nil];
    messBody4.isFavour = NO;
    WFMessageBody *messBody5 = [[WFMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText5;
    messBody5.posterPostImage = @[@"a",@"a",@"a",@"a"];
    messBody5.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5, nil];
    messBody5.posterImgstr = @"mao.jpg";
    messBody5.posterName = @"阿克蒙德";
    messBody5.posterIntro = @"这个人很懒，什么都没有留下";
    messBody5.posterFavour = [NSMutableArray arrayWithObjects:@"希尔瓦娜斯",@"格鲁尔",@"魔兽世界5区石锤人类联盟女圣骑丨阿诺丨",@"钢铁女武神",@"魔兽世界5区石锤人类联盟女盗贼chaotics",@"克苏恩",@"克尔苏加德",@"钢铁议会", nil];
    messBody5.isFavour = NO;
    WFMessageBody *messBody6 = [[WFMessageBody alloc] init];
    messBody6.posterContent = kShuoshuoText5;
    messBody6.posterPostImage = @[@"a",@"a",@"a",@"a",@"a"];
    messBody6.posterReplies = [NSMutableArray arrayWithObjects:body2,body4,body5,body4,body6, nil];
    messBody6.posterImgstr = @"mao.jpg";
    messBody6.posterName = @"红领巾";
    messBody6.posterIntro = @"这个人很懒，什么都没有留下";
    messBody6.posterFavour = [NSMutableArray arrayWithObjects:@"爆裂熔炉",@"希尔瓦娜斯",@"阿尔萨斯",@"死亡之翼",@"玛里苟斯", nil];
    messBody6.isFavour = NO;
    [_contentDataSource addObject:messBody1];
    [_contentDataSource addObject:messBody2];
    [_contentDataSource addObject:messBody3];
    [_contentDataSource addObject:messBody4];
    [_contentDataSource addObject:messBody5];
    [_contentDataSource addObject:messBody6];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [backBtn setTitle:[NSString stringWithFormat:@"我是返回,该登陆用户为%@",@"杨越光"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
    [self configData];
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
             WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
             YMTextData *ymData = [[YMTextData alloc] init ];
             ymData.messageBody = messBody;
             [ymDataArray addObject:ymData];
         }
     NSDate* tmpStartData = [NSDate date];
     for (YMTextData *ymData in ymDataArray) {
         ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
         ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
         ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
         ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
         [_tableDataSource addObject:ymData];
     }
     double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
     DLog(@"cost time = %f", deltaTime);
     dispatch_async(dispatch_get_main_queue(), ^{
         [mainTable reloadData];
     });
    });
}
- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//**///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _tableDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return 50 + 20 + ym.replyHeight + ym.showImageHeight  + 30 + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + 30 + ym.favourHeight + (ym.favourHeight == 0?0:8);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ILTableViewCell";
    BookFriendsTableViewCell *cell = (BookFriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BookFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.tag = indexPath.row;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - 按钮动画
- (void)replyAction:(UIButton *)sender{
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:[NSIndexPath indexPathWithIndex:sender.tag]];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = [NSIndexPath indexPathWithIndex:sender.tag];
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
}
- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(NSInteger operationType) {
            switch (operationType) {
                case 0:[ws addLike];break;
                case 1:[ws replyMessage: nil];break;
                default:break;
            }
        };
    }
    return _operationView;
}
#pragma mark - 赞
- (void)addLike{
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:@"杨越光"];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:@"杨越光"];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    //清空属性数组。否则会重复添加
    [ymData.attributedDataFavour removeAllObjects];
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [mainTable reloadData];
}
#pragma mark - 真の评论
- (void)replyMessage:(UIButton *)sender{
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, APPW,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];
}
#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.operationView dismiss];
}
#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];
}
#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        [UIView animateWithDuration:0.5f animations:^{
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
    }];
}
#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
}
#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    [self.operationView dismiss];
    _replyIndex = replyIndex;
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:@"杨越光"]) {
        [self showAlerWithtitle:@"删除评论？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //delete
                YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
                WFMessageBody *m = ymData.messageBody;
                [m.posterReplies removeObjectAtIndex:_replyIndex];
                ymData.messageBody = m;
                [ymData.completionReplySource removeAllObjects];
                [ymData.attributedDataReply removeAllObjects];
                ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
                [_tableDataSource replaceObjectAtIndex:index withObject:ymData];
                [mainTable reloadData];
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        } ac3:nil completion:^{
            _replyIndex = -1;
        }];
    }else{
       //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, APPW,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        [self.view addSubview:replyView];
    }
}
#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = @"杨越光";
        body.repliedUser = @"";
        body.replyInfo = replyText;
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
    }else{
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = @"杨越光";
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
    }
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    [mainTable reloadData];
}
- (void)destorySelf{
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
}
- (void)dealloc{
    DLog(@"销毁");
}
@end
