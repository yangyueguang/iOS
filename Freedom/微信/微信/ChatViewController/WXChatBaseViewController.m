//  FreedomBaseViewController.m
//  Freedom
// Created by Super
#import "WXChatBaseViewController.h"
#import "WXMessageManager.h"
#import "WXUserHelper.h"
#import "NSFileManager+expanded.h"
#define     SIZE_TIPS    CGSizeMake(55, 100)
#define     WIDTH_TEXTVIEW          self.frame.size.width * 0.94
@interface WXTextDisplayView : UIView
@property (nonatomic, strong) NSAttributedString *attrString;
- (void)showInView:(UIView *)view withAttrText:(NSAttributedString *)attrText animation:(BOOL)animation;
@end
@interface WXTextDisplayView ()
@property (nonatomic, strong) UITextView *textView;
@end
@implementation WXTextDisplayView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}
- (void)showInView:(UIView *)view withAttrText:(NSAttributedString *)attrText animation:(BOOL)animation{
    [view addSubview:self];
    [self setFrame:view.bounds];
    [self setAttrString:attrText];
    [self setAlpha:0];
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:1.0];
    } completion:^(BOOL finished) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}
- (void)setAttrString:(NSAttributedString *)attrString{
    _attrString = attrString;
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
    [mutableAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0f] range:NSMakeRange(0, attrString.length)];
    [self.textView setAttributedText:mutableAttrString];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(WIDTH_TEXTVIEW, MAXFLOAT)];
    size.height = size.height > APPH ? APPH : size.height;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}
- (void)dismiss{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - Getter -
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setTextAlignment:NSTextAlignmentCenter];
        [_textView setEditable:NO];
    }
    return _textView;
}
@end
@interface WXEmojiDisplayView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXEmojiDisplayView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, SIZE_TIPS.width, SIZE_TIPS.height)]) {
        [self setImage:[UIImage imageNamed:@"emojiKB_tips"]];
        [self addSubview:self.imageLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect{
    [self setRect:rect];
    [self setEmoji:emoji];
}
- (void)setEmoji:(TLEmoji *)emoji{
    _emoji = emoji;
    if (emoji.type == TLEmojiTypeEmoji) {
        [self.imageLabel setHidden:NO];
        [self.imageView setHidden:YES];
        [self.titleLabel setHidden:YES];
        [self.imageLabel setText:emoji.emojiName];
    }else if (emoji.type == TLEmojiTypeFace) {
        [self.imageLabel setHidden:YES];
        [self.imageView setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.imageView setImage:[UIImage imageNamed:emoji.emojiName]];
        [self.titleLabel setText:[emoji.emojiName substringWithRange:NSMakeRange(1, emoji.emojiName.length - 2)]];
    }
}
- (void)setRect:(CGRect)rect{
    self.center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height - self.frameHeight + 15.0+self.frameHeight/2);
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(12);
        make.right.mas_equalTo(self).mas_equalTo(-12);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self);
        make.width.mas_lessThanOrEqualTo(self);
    }];
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.and.centerX.mas_equalTo(self.imageView);
        make.top.mas_equalTo(self).mas_offset(12);
    }];
}
#pragma mark - Getter -
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}
- (UILabel *)imageLabel{
    if (_imageLabel == nil) {
        _imageLabel = [[UILabel alloc] init];
        [_imageLabel setTextAlignment:NSTextAlignmentCenter];
        [_imageLabel setHidden:YES];
        [_imageLabel setFont:[UIFont systemFontOfSize:30.0f]];
    }
    return _imageLabel;
}
@end
@interface UIButton (add)
- (void) setImage:(UIImage *)image imageHL:(UIImage *)imageHL;
@end
@implementation UIButton (add)
- (void) setImage:(UIImage *)image imageHL:(UIImage *)imageHL{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:imageHL forState:UIControlStateHighlighted];
}
+ (UIButton *)initBtnWithFrame:(CGRect)frame target:(id)target method:(SEL)method title:(NSString *)title setimageName:(NSString *)setimageName backImageName:(NSString *)backImageName;{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setImage:[UIImage imageNamed:setimageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
    return btn;
}
@end
@interface WXChatBar () <UITextViewDelegate>{
    UIImage *kVoiceImage;
    UIImage *kVoiceImageHL;
    UIImage *kEmojiImage;
    UIImage *kEmojiImageHL;
    UIImage *kMoreImage;
    UIImage *kMoreImageHL;
    UIImage *kKeyboardImage;
    UIImage *kKeyboardImageHL;
}
@property (nonatomic, strong) UIButton *modeButton;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *talkButton;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *moreButton;
@end
@implementation WXChatBar
- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:UIColor(245.0, 245.0, 247.0, 1.0)];
        [self p_initImage];
        
        [self addSubview:self.modeButton];
        [self addSubview:self.voiceButton];
        [self addSubview:self.textView];
        [self addSubview:self.talkButton];
        [self addSubview:self.emojiButton];
        [self addSubview:self.moreButton];
        
        [self p_addMasonry];
        
        self.status = TLChatBarStatusInit;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}
#pragma mark - Public Methods
- (void)sendCurrentText{
    if (self.textView.text.length > 0) {     // send Text
        if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(chatBar:sendText:)]) {
            [_dataDelegate chatBar:self sendText:self.textView.text];
        }
    }
    [self.textView setText:@""];
    [self textViewDidChange:self.textView];
}
- (void)addEmojiString:(NSString *)emojiString{
    NSString *str = [NSString stringWithFormat:@"%@%@", self.textView.text, emojiString];
    [self.textView setText:str];
    [self textViewDidChange:self.textView];
}
- (void)setActivity:(BOOL)activity{
    _activity = activity;
    if (activity) {
        [self.textView setTextColor:[UIColor blackColor]];
    }else{
        [self.textView setTextColor:[UIColor grayColor]];
    }
}
- (BOOL)isFirstResponder{
    if (self.status == TLChatBarStatusEmoji || self.status == TLChatBarStatusKeyboard || self.status == TLChatBarStatusMore) {
        return YES;
    }
    return NO;
}
- (BOOL)resignFirstResponder{
    if (self.status == TLChatBarStatusEmoji || self.status == TLChatBarStatusKeyboard || self.status == TLChatBarStatusMore) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusInit];
        }
        [self.textView resignFirstResponder];
        self.status = TLChatBarStatusInit;
        [_moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        [_emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
    }
    return [super resignFirstResponder];
}
#pragma mark - Delegate -
//MARK: UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self setActivity:YES];
    if (self.status != TLChatBarStatusKeyboard) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusKeyboard];
        }
        if (self.status == TLChatBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }else if (self.status == TLChatBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        self.status = TLChatBarStatusKeyboard;
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendCurrentText];
        return NO;
    }else if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, MAXFLOAT)].height;
    height = height > 36 ? height : 36;
    height = (height <= 115 ? height : textView.frameHeight);
    if (height != textView.frameHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            [textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            [self.superview layoutIfNeeded];
            if (_delegate && [_delegate respondsToSelector:@selector(chatBar:didChangeTextViewHeight:)]) {
                [_delegate chatBar:self didChangeTextViewHeight:textView.frameHeight];
            }
        } completion:^(BOOL finished) {
            if (_delegate && [_delegate respondsToSelector:@selector(chatBar:didChangeTextViewHeight:)]) {
                [_delegate chatBar:self didChangeTextViewHeight:textView.frameHeight];
            }
        }];
    }
}
#pragma mark - Event Response
- (void)modeButtonDown{
    if (self.status == TLChatBarStatusEmoji) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusInit];
        }
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        self.status = TLChatBarStatusInit;
        
    }else if (self.status == TLChatBarStatusMore) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusInit];
        }
        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        self.status = TLChatBarStatusInit;
    }
}
- (void)voiceButtonDown{
    [self.textView resignFirstResponder];
    
    // 开始文字输入
    if (self.status == TLChatBarStatusVoice) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusKeyboard];
        }
        [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
        [self.textView becomeFirstResponder];
        [self.textView setHidden:NO];
        [self.talkButton setHidden:YES];
        self.status = TLChatBarStatusKeyboard;
    }else{          // 开始语音
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusVoice];
        }
        if (self.status == TLChatBarStatusKeyboard) {
            [self.textView resignFirstResponder];
        }else if (self.status == TLChatBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }else if (self.status == TLChatBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        [self.talkButton setHidden:NO];
        [self.textView setHidden:YES];
        [self.voiceButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        self.status = TLChatBarStatusVoice;
    }
}
- (void)emojiButtonDown{
    // 开始文字输入
    if (self.status == TLChatBarStatusEmoji) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusKeyboard];
        }
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        [self.textView becomeFirstResponder];
        self.status = TLChatBarStatusKeyboard;
    }else{      // 打开表情键盘
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusEmoji];
        }
        if (self.status == TLChatBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }else if (self.status == TLChatBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        [self.emojiButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = TLChatBarStatusEmoji;
    }
}
- (void)moreButtonDown{
    // 开始文字输入
    if (self.status == TLChatBarStatusMore) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusKeyboard];
        }
        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        [self.textView becomeFirstResponder];
        self.status = TLChatBarStatusKeyboard;
    }else{      // 打开更多键盘
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [_delegate chatBar:self changeStatusFrom:self.status to:TLChatBarStatusMore];
        }
        if (self.status == TLChatBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }else if (self.status == TLChatBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        [self.moreButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = TLChatBarStatusMore;
    }
}
- (void)talkButtonTouchDown:(UIButton *)sender{
    if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(chatBarRecording:)]) {
        [_dataDelegate chatBarRecording:self];
    }
}
- (void)talkButtonTouchUpInside:(UIButton *)sender{
    if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(chatBarFinishedRecoding:)]) {
        [_dataDelegate chatBarFinishedRecoding:self];
    }
}
- (void)talkButtonTouchCancel:(UIButton *)sender{
    if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(chatBarDidCancelRecording:)]) {
        [_dataDelegate chatBarDidCancelRecording:self];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-4);
        make.width.mas_equalTo(0);
    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).mas_offset(-7);
        make.left.mas_equalTo(self.modeButton.mas_right).mas_offset(1);
        make.width.mas_equalTo(38);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(7);
        make.bottom.mas_equalTo(self).mas_offset(-7);
        make.left.mas_equalTo(self.voiceButton.mas_right).mas_offset(4);
        make.right.mas_equalTo(self.emojiButton.mas_left).mas_offset(-4);
        make.height.mas_equalTo(36);
    }];
    
    [self.talkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.textView);
        make.size.mas_equalTo(self.textView);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self).mas_offset(-1);
    }];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self.moreButton.mas_left);
    }];
}
- (void)p_initImage{
    kVoiceImage = [UIImage imageNamed:@"chat_toolbar_voice"];
    kVoiceImageHL = [UIImage imageNamed:@"chat_toolbar_voice_HL"];
    kEmojiImage = [UIImage imageNamed:@"chat_toolbar_emotion"];
    kEmojiImageHL = [UIImage imageNamed:@"chat_toolbar_emotion_HL"];
    kMoreImage = [UIImage imageNamed:@"chat_toolbar_more"];
    kMoreImageHL = [UIImage imageNamed:@"chat_toolbar_more_HL"];
    kKeyboardImage = [UIImage imageNamed:@"chat_toolbar_keyboard"];
    kKeyboardImageHL = [UIImage imageNamed:@"chat_toolbar_keyboard_HL"];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, APPW, 0);
    CGContextStrokePath(context);
}
#pragma mark - Getter
- (UIButton *)modeButton{
    if (_modeButton == nil) {
        _modeButton = [[UIButton alloc] init];
        [_modeButton setImage:[UIImage imageNamed:@"chat_toolbar_texttolist"] imageHL:[UIImage imageNamed:@"chat_toolbar_texttolist_HL"]];
        [_modeButton addTarget:self action:@selector(modeButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}
- (UIButton *)voiceButton{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
        [_voiceButton addTarget:self action:@selector(voiceButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_textView.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        [_textView.layer setCornerRadius:4.0f];
        [_textView setDelegate:self];
        [_textView setScrollsToTop:NO];
    }
    return _textView;
}
- (UIButton *)talkButton{
    if (_talkButton == nil) {
        _talkButton = [[UIButton alloc] init];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_talkButton setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        [_talkButton setBackgroundImage:[FreedomTools imageWithColor:[UIColor colorWithWhite:0.0 alpha:0.1]] forState:UIControlStateHighlighted];
        [_talkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_talkButton.layer setMasksToBounds:YES];
        [_talkButton.layer setCornerRadius:4.0f];
        [_talkButton.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_talkButton.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        [_talkButton setHidden:YES];
        [_talkButton addTarget:self action:@selector(talkButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(talkButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    }
    return _talkButton;
}
- (UIButton *)emojiButton{
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc] init];
        [_emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        [_emojiButton addTarget:self action:@selector(emojiButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}
- (UIButton *)moreButton{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        [_moreButton addTarget:self action:@selector(moreButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (NSString *)curText{
    return self.textView.text;
}
@end
@implementation WXChatBaseViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view addSubview:self.chatTableVC.tableView];
    [self addChildViewController:self.chatTableVC];
    [self.view addSubview:self.chatBar];
    
    [self p_addMasonry];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Public Methods -
- (void)setPartner:(id<WXChatUserProtocol>)partner{
    if (_partner && [[_partner chat_userID] isEqualToString:[partner chat_userID]]) {
        return;
    }
    _partner = partner;
    [self.navigationItem setTitle:[_partner chat_username]];
    [self resetChatVC];
}
- (void)setChatMoreKeyboardData:(NSMutableArray *)moreKeyboardData{
    [self.moreKeyboard setChatMoreKeyboardData:moreKeyboardData];
}
- (void)setChatEmojiKeyboardData:(NSMutableArray *)emojiKeyboardData{
    [self.emojiKeyboard setEmojiGroupData:emojiKeyboardData];
}
- (void)resetChatVC{
    NSString *chatViewBGImage = [[NSUserDefaults standardUserDefaults] objectForKey:[@"CHAT_BG_" stringByAppendingString:[self.partner chat_userID]]];
    if (chatViewBGImage == nil) {
        chatViewBGImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHAT_BG_ALL"];
        if (chatViewBGImage == nil) {
            [self.view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
        }else{
            NSString *imagePath = [NSFileManager pathUserChatBackgroundImage:chatViewBGImage];
            UIImage *image = [UIImage imageNamed:imagePath];
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
    }else{
        NSString *imagePath = [NSFileManager pathUserChatBackgroundImage:chatViewBGImage];
        UIImage *image = [UIImage imageNamed:imagePath];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
    
    [self resetChatTVC];
}
/*发送图片消息*/
- (void)sendImageMessage:(UIImage *)image{
    NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 0.5));
    NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
    NSString *imagePath = [NSFileManager pathUserChatImage:imageName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    WXImageMessage *message = [[WXImageMessage alloc] init];
    message.fromUser = self.user;
    message.messageType = TLMessageTypeImage;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.content[@"path"] = imageName;
    message.imageSize = image.size;
    [self sendMessage:message];
    if ([self.partner chat_userType] == TLChatUserTypeUser) {
        WXImageMessage *message1 = [[WXImageMessage alloc] init];
        message1.fromUser = self.partner;
        message1.messageType = TLMessageTypeImage;
        message1.ownerTyper = TLMessageOwnerTypeFriend;
        message1.content[@"path"] = imageName;
        message1.imageSize = image.size;
        [self sendMessage:message1];
    }else{
        for (id<WXChatUserProtocol> user in [self.partner groupMembers]) {
            WXImageMessage *message1 = [[WXImageMessage alloc] init];
            message1.friendID = [user chat_userID];
            message1.fromUser = user;
            message1.messageType = TLMessageTypeImage;
            message1.ownerTyper = TLMessageOwnerTypeFriend;
            message1.content[@"path"] = imageName;
            message1.imageSize = image.size;
            [self sendMessage:message1];
        }
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.chatTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
}
#pragma mark - Getter -
- (WXChatTableViewController *)chatTableVC{
    if (_chatTableVC == nil) {
        _chatTableVC = [[WXChatTableViewController alloc] init];
        [_chatTableVC setDelegate:self];
    }
    return _chatTableVC;
}
- (WXChatBar *)chatBar{
    if (_chatBar == nil) {
        _chatBar = [[WXChatBar alloc] init];
        [_chatBar setDelegate:self];
        [_chatBar setDataDelegate:self];
    }
    return _chatBar;
}
- (TLEmojiKeyboard *)emojiKeyboard{
    if (_emojiKeyboard == nil) {
        _emojiKeyboard = [TLEmojiKeyboard keyboard];
        [_emojiKeyboard setKeyboardDelegate:self];
        [_emojiKeyboard setDelegate:self];
    }
    return _emojiKeyboard;
}
- (TLMoreKeyboard *)moreKeyboard{
    if (_moreKeyboard == nil) {
        _moreKeyboard = [TLMoreKeyboard keyboard];
        [_moreKeyboard setKeyboardDelegate:self];
        [_moreKeyboard setDelegate:self];
    }
    return _moreKeyboard;
}
- (WXEmojiDisplayView *)emojiDisplayView{
    if (_emojiDisplayView == nil) {
        _emojiDisplayView = [[WXEmojiDisplayView alloc] init];
    }
    return _emojiDisplayView;
}
- (WXImageExpressionDisplayView *)imageExpressionDisplayView{
    if (_imageExpressionDisplayView == nil) {
        _imageExpressionDisplayView = [[WXImageExpressionDisplayView alloc] init];
    }
    return _imageExpressionDisplayView;
}
//MARK: TLChatBarDataDelegate
- (void)chatBar:(WXChatBar *)chatBar sendText:(NSString *)text{
    WXTextMessage *message = [[WXTextMessage alloc] init];
    message.fromUser = self.user;
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.content[@"text"] = text;
    [self sendMessage:message];
    if ([self.partner chat_userType] == TLChatUserTypeUser) {
        WXTextMessage *message1 = [[WXTextMessage alloc] init];
        message1.fromUser = self.partner;
        message1.messageType = TLMessageTypeText;
        message1.ownerTyper = TLMessageOwnerTypeFriend;
        message1.content[@"text"] = text;
        [self sendMessage:message1];
    }else{
        for (id<WXChatUserProtocol> user in [self.partner groupMembers]) {
            WXTextMessage *message1 = [[WXTextMessage alloc] init];
            message1.friendID = [user chat_userID];
            message1.fromUser = user;
            message1.messageType = TLMessageTypeText;
            message1.ownerTyper = TLMessageOwnerTypeFriend;
            message1.content[@"text"] = text;
            [self sendMessage:message1];
        }
    }
}
- (void)chatBarRecording:(WXChatBar *)chatBar{
    DLog(@"rec...");
}
- (void)chatBarWillCancelRecording:(WXChatBar *)chatBar{
    DLog(@"will cancel");
}
- (void)chatBarDidCancelRecording:(WXChatBar *)chatBar{
    DLog(@"cancel");
}
- (void)chatBarFinishedRecoding:(WXChatBar *)chatBar{
    DLog(@"finished");
}
#pragma mark - Public Methods -
- (void)addToShowMessage:(WXMessage *)message{
    message.showTime = [self p_needShowTime:message.date];
    [self.chatTableVC addMessage:message];
    [self.chatTableVC scrollToBottomWithAnimation:YES];
}
- (void)resetChatTVC{
    [self.chatTableVC reloadData];
    lastDateInterval = 0;
    msgAccumulate = 0;
}
#pragma mark - Delegate -
//MARK: WXChatTableViewControllerDelegate
// chatView 点击事件
- (void)chatTableViewControllerDidTouched:(WXChatTableViewController *)chatTVC{
    if ([self.chatBar isFirstResponder]) {
        [self.chatBar resignFirstResponder];
    }
}
// chatView 获取历史记录
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC getRecordsFromDate:(NSDate *)date count:(NSUInteger)count completed:(void (^)(NSDate *, NSArray *, BOOL))completed{
    [[WXMessageManager sharedInstance] messageRecordForPartner:[self.partner chat_userID] fromDate:date count:count complete:^(NSArray *array, BOOL hasMore) {
        if (array.count > 0) {
            int count = 0;
            NSTimeInterval tm = 0;
            for (WXMessage *message in array) {
                if (++count > 10 || tm == 0 || message.date.timeIntervalSince1970 - tm > 30) {
                    tm = message.date.timeIntervalSince1970;
                    count = 0;
                    message.showTime = YES;
                }
                if (message.ownerTyper == TLMessageOwnerTypeSelf) {
                    message.fromUser = self.user;
                }
                else {
                    if ([self.partner chat_userType] == TLChatUserTypeUser) {
                        message.fromUser = self.partner;
                    }
                    else if ([self.partner chat_userType] == TLChatUserTypeGroup){
                        if ([self.partner respondsToSelector:@selector(groupMemberByID:)]) {
                            message.fromUser = [self.partner groupMemberByID:message.friendID];
                        }
                    }
                }
            }
        }
        completed(date, array, hasMore);
    }];
}
- (BOOL)chatTableViewController:(WXChatTableViewController *)chatTVC deleteMessage:(WXMessage *)message{
    return [[WXMessageManager sharedInstance] deleteMessageByMsgID:message.messageID];
}
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC didClickUserAvatar:(WXUser *)user{
    if ([self respondsToSelector:@selector(didClickedUserAvatar:)]) {
        [self didClickedUserAvatar:user];
    }
}
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC didDoubleClickMessage:(WXMessage *)message{
    if (message.messageType == TLMessageTypeText) {
        WXTextDisplayView *displayView = [[WXTextDisplayView alloc] init];
        [displayView showInView:self.navigationController.view withAttrText:[(WXTextMessage *)message attrText] animation:YES];
    }
}
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC didClickMessage:(WXMessage *)message{
    if (message.messageType == TLMessageTypeImage && [self respondsToSelector:@selector(didClickedImageMessages:atIndex:)]) {
        [[WXMessageManager sharedInstance] chatImagesAndVideosForPartnerID:[self.partner chat_userID] completed:^(NSArray *imagesData) {
            NSInteger index = -1;
            for (int i = 0; i < imagesData.count; i ++) {
                if ([message.messageID isEqualToString:[imagesData[i] messageID]]) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                [self didClickedImageMessages:imagesData atIndex:index];
            }
        }];
    }
}
#pragma mark - Private Methods -
static NSTimeInterval lastDateInterval = 0;
static NSInteger msgAccumulate = 0;
- (BOOL)p_needShowTime:(NSDate *)date{
    if (++msgAccumulate > 10 || lastDateInterval == 0 || date.timeIntervalSince1970 - lastDateInterval > 30) {
        lastDateInterval = date.timeIntervalSince1970;
        msgAccumulate = 0;
        return YES;
    }
    return NO;
}
- (void)sendMessage:(WXMessage *)message{
    message.userID = [WXUserHelper sharedHelper].user.userID;
    if ([self.partner chat_userType] == TLChatUserTypeUser) {
        message.partnerType = TLPartnerTypeUser;
        message.friendID = [self.partner chat_userID];
    }else if ([self.partner chat_userType] == TLChatUserTypeGroup) {
        message.partnerType = TLPartnerTypeGroup;
        message.groupID = [self.partner chat_userID];
    }
    //    message.ownerTyper = TLMessageOwnerTypeSelf;
    //    message.fromUser = [WXUserHelper sharedHelper].user;
    message.date = [NSDate date];
    
    [self addToShowMessage:message];    // 添加到列表
    [[WXMessageManager sharedInstance] sendMessage:message progress:^(WXMessage * message, CGFloat pregress) {
        
    } success:^(WXMessage * message) {
        DLog(@"send success");
    } failure:^(WXMessage * message) {
        DLog(@"send failure");
    }];
}
//MARK: TLEmojiKeyboardDelegate
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didSelectedEmojiItem:(TLEmoji *)emoji{
    if (emoji.type == TLEmojiTypeEmoji || emoji.type == TLEmojiTypeFace) {
        [self.chatBar addEmojiString:emoji.emojiName];
    }else{
        WXExpressionMessage *message = [[WXExpressionMessage alloc] init];
        message.fromUser = self.user;
        message.messageType = TLMessageTypeExpression;
        message.ownerTyper = TLMessageOwnerTypeSelf;
        message.emoji = emoji;
        [self sendMessage:message];
        if ([self.partner chat_userType] == TLChatUserTypeUser) {
            WXExpressionMessage *message1 = [[WXExpressionMessage alloc] init];
            message1.fromUser = self.partner;
            message1.messageType = TLMessageTypeExpression;
            message1.ownerTyper = TLMessageOwnerTypeFriend;
            message1.emoji = emoji;;
            [self sendMessage:message1];
        }else{
            for (id<WXChatUserProtocol> user in [self.partner groupMembers]) {
                WXExpressionMessage *message1 = [[WXExpressionMessage alloc] init];
                message1.friendID = [user chat_userID];
                message1.fromUser = user;
                message1.messageType = TLMessageTypeExpression;
                message1.ownerTyper = TLMessageOwnerTypeFriend;
                message1.emoji = emoji;
                [self sendMessage:message1];
            }
        }
    }
}
- (void)emojiKeyboardSendButtonDown{
    [self.chatBar sendCurrentText];
}
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didTouchEmojiItem:(TLEmoji *)emoji atRect:(CGRect)rect{
    if (emoji.type == TLEmojiTypeEmoji || emoji.type == TLEmojiTypeFace) {
        if (self.emojiDisplayView.superview == nil) {
            [self.emojiKeyboard addSubview:self.emojiDisplayView];
        }
        [self.emojiDisplayView displayEmoji:emoji atRect:rect];
    }else{
        if (self.imageExpressionDisplayView.superview == nil) {
            [self.emojiKeyboard addSubview:self.imageExpressionDisplayView];
        }
        [self.imageExpressionDisplayView displayEmoji:emoji atRect:rect];
    }
}
- (void)emojiKeyboardCancelTouchEmojiItem:(TLEmojiKeyboard *)emojiKB{
    if (self.emojiDisplayView.superview != nil) {
        [self.emojiDisplayView removeFromSuperview];
    }else if (self.imageExpressionDisplayView.superview != nil) {
        [self.imageExpressionDisplayView removeFromSuperview];
    }
}
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB selectedEmojiGroupType:(TLEmojiType)type{
    if (type == TLEmojiTypeEmoji || type == TLEmojiTypeFace) {
        [self.chatBar setActivity:YES];
    }else{
        [self.chatBar setActivity:NO];
    }
}
- (BOOL)chatInputViewHasText{
    return self.chatBar.curText.length == 0 ? NO : YES;
}
#pragma mark Public Methods
- (void)keyboardWillHide:(NSNotification *)notification{
    if (curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}
- (void)keyboardFrameWillChange:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (lastStatus == TLChatBarStatusMore || lastStatus == TLChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= 215.0f) {
            return;
        }
    }else if (curStatus == TLChatBarStatusEmoji || curStatus == TLChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-keyboardFrame.size.height);
    }];
    [self.view layoutIfNeeded];
    [self.chatTableVC scrollToBottomWithAnimation:NO];
}
- (void)keyboardDidShow:(NSNotification *)notification{
    if (lastStatus == TLChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }else if (lastStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
}
#pragma mark - 
//MARK: TLKeyboardDelegate
- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height{
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-height);
    }];
    [self.view layoutIfNeeded];
    [self.chatTableVC scrollToBottomWithAnimation:NO];
}
- (void)chatKeyboardDidShow:(id)keyboard{
    if (curStatus == TLChatBarStatusMore && lastStatus == TLChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }else if (curStatus == TLChatBarStatusEmoji && lastStatus == TLChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
}
//MARK: TLChatBarDelegate
- (void)chatBar:(WXChatBar *)chatBar changeStatusFrom:(TLChatBarStatus)fromStatus to:(TLChatBarStatus)toStatus{
    if (curStatus == toStatus) {
        return;
    }
    lastStatus = fromStatus;
    curStatus = toStatus;
    if (toStatus == TLChatBarStatusInit) {
        if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }else if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }else if (toStatus == TLChatBarStatusKeyboard) {
        if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.chatBar.mas_bottom);
                make.left.and.right.mas_equalTo(self.view);
                make.height.mas_equalTo(215.0f);
            }];
        }else if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.chatBar.mas_bottom);
                make.left.and.right.mas_equalTo(self.view);
                make.height.mas_equalTo(215.0f);
            }];
        }
    }else if (toStatus == TLChatBarStatusVoice) {
        if (fromStatus == TLChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }else if (fromStatus == TLChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }else if (toStatus == TLChatBarStatusEmoji) {
        if (fromStatus == TLChatBarStatusKeyboard) {
            [self.emojiKeyboard showInView:self.view withAnimation:YES];
        }else{
            [self.emojiKeyboard showInView:self.view withAnimation:YES];
        }
    }else if (toStatus == TLChatBarStatusMore) {
        if (fromStatus == TLChatBarStatusKeyboard) {
            [self.moreKeyboard showInView:self.view withAnimation:YES];
        }else{
            [self.moreKeyboard showInView:self.view withAnimation:YES];
        }
    }
}
- (void)chatBar:(WXChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height{
    [self.chatTableVC scrollToBottomWithAnimation:NO];
}
@end
