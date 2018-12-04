//
//  RCDGroupAnnouncementViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/14.
//  Copyright © 2016年 RongCloud. All rights reserved.
#import "RCDGroupAnnouncementViewController.h"
#import "MBProgressHUD.h"
#import <RongIMKit/RongIMKit.h>
@interface UITextViewAndPlaceholder : UITextView
@property(nonatomic,copy) NSString *myPlaceholder;  //文字
@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色
@property (nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation UITextViewAndPlaceholder
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor= [UIColor clearColor];
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        placeholderLabel.backgroundColor= [UIColor clearColor];
        placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
        [self addSubview:placeholderLabel];
        self.placeholderLabel= placeholderLabel; //赋值保存
        self.myPlaceholderColor= [FreedomTools colorWithRGBHex:0x999999]; //设置占位文字默认颜色
        self.font= [UIFont systemFontOfSize:16]; //设置默认的字体
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
        //设置可以上下拖动
        [self setScrollEnabled:YES];
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = YES;
        CGSize size = CGSizeMake(0, 600.0f);
        [self setContentSize:size];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //根据文字计算高度
    CGSize maxSize =CGSizeMake(self.frame.size.width,MAXFLOAT);
    CGFloat height = [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    CGRect frame = CGRectMake(5, 8, self.frame.size.width, height);
    self.placeholderLabel.frame = frame;
}
- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    _myPlaceholder= [myPlaceholder copy];
    //设置文字
    self.placeholderLabel.text= myPlaceholder;
    //重新计算子控件frame
    [self setNeedsLayout];
}
- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    _myPlaceholderColor= myPlaceholderColor;
    //设置颜色
    self.placeholderLabel.textColor= myPlaceholderColor;
}
- (void)setText:(NSString*)text{
    [super setText:text];
    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
}
- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
}
@end
@interface RCDGroupAnnouncementViewController ()
@property (nonatomic, strong) UITextViewAndPlaceholder *AnnouncementContent;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) CGFloat heigh;
@end
@implementation RCDGroupAnnouncementViewController
- (instancetype)init {
  self = [super init];
  if (self) {
    self.AnnouncementContent = [[UITextViewAndPlaceholder alloc] initWithFrame:CGRectZero];
    self.AnnouncementContent.delegate = self;
    self.AnnouncementContent.font = [UIFont systemFontOfSize:16.f];
    self.AnnouncementContent.textColor = [FreedomTools colorWithRGBHex:0x000000];
    self.AnnouncementContent.myPlaceholder = @"请编辑群公告";
    self.AnnouncementContent.frame = CGRectMake(4.5, 8, self.view.frame.size.width - 5, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 90);
    self.heigh = self.AnnouncementContent.frame.size.height;
    [self.view addSubview:self.AnnouncementContent];
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
  self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.5, 0, 50, 34)];
  self.rightLabel.text = @"完成";
  [self.rightBtn addSubview:self.rightLabel];
  [self.rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn ];
  [self.rightLabel setTextColor:[FreedomTools colorWithRGBHex:0x9fcdfd]];
  self.rightBtn .userInteractionEnabled = NO;
  self.navigationItem.rightBarButtonItem = rightButton;
  self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 34)];
  UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(-6.5, 0, 50, 34)];
  leftLabel.text = @"取消";
  [self.leftBtn addSubview:leftLabel];
  [leftLabel setTextColor:[UIColor whiteColor]];
[self.leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
  [self.leftBtn setTintColor:[UIColor whiteColor]];
  self.navigationItem.leftBarButtonItem = leftButton;
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = @"群公告";
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 类的私有方法
//键盘将要弹出
- (void)keyboardWillShow:(NSNotification *)aNotification{
  CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
  NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect frame = self.AnnouncementContent.frame;
  frame.origin.y = 8;
  if (frame.size.height == self.heigh) {
    frame.size.height -= keyboardRect.size.height;
    if (frame.size.height != self.heigh) {
      frame.size.height -= 60;
    }
  }
  [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
  [UIView setAnimationDuration:animationDuration];
  self.AnnouncementContent.frame = frame;
  [UIView commitAnimations];
}
//键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)aNotification{
//  CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
  NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect frame = self.AnnouncementContent.frame;
  frame.size.height = self.heigh;
  [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
  [UIView setAnimationDuration:animationDuration];
  self.AnnouncementContent.frame = frame;
  [UIView commitAnimations];
}
-(void) navigationButtonIsCanClick:(BOOL)isCanClick{
    self.leftBtn.userInteractionEnabled = isCanClick;
    self.rightBtn.userInteractionEnabled = isCanClick;
}
-(void)clickLeftBtn:(id)sender{
  [self navigationButtonIsCanClick:NO];
  if (self.AnnouncementContent.text.length > 0) {
      [self showAlerWithtitle:nil message:@"退出本次编辑" style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
          return [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              self.leftBtn.userInteractionEnabled = YES;
              self.rightBtn.userInteractionEnabled = YES;
              _AnnouncementContent.editable = NO;
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
          }];
      } ac2:^UIAlertAction *{
          return [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
              self.leftBtn.userInteractionEnabled = YES;
              self.rightBtn.userInteractionEnabled = YES;
          }];
      } ac3:nil completion:nil];
  }else{
    [self.navigationController popViewControllerAnimated:YES];
  }
}
-(void)clickRightBtn:(id)sender{
  [self navigationButtonIsCanClick:NO];
  BOOL isEmpty = [self isEmpty:self.AnnouncementContent.text];
  if (isEmpty == YES) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
    WS(weakSelf);
    [self showAlerWithtitle:nil message:@"该公告会通知全部群成员，是否发布？" style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf publicIt];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    } ac3:nil completion:^{
        self.leftBtn.userInteractionEnabled = YES;
        self.rightBtn.userInteractionEnabled = YES;
    }];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
  NSInteger number = [textView.text length];
  if (number == 0) {
    self.rightBtn.userInteractionEnabled = NO;
    [self.rightLabel setTextColor:[FreedomTools colorWithRGBHex:0x9fcdfd]];
  }
  if (number > 0) {
    self.rightBtn.userInteractionEnabled = YES;
    [self.rightLabel setTextColor:[UIColor whiteColor]];
    CGRect frame = self.AnnouncementContent.frame;
    CGSize maxSize =CGSizeMake(frame.size.width,MAXFLOAT);
    CGFloat height = [self.AnnouncementContent.text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.AnnouncementContent.font} context:nil].size.height;
    frame.size.height = height;
  }
  if (number > 500) {
    textView.text = [textView.text substringToIndex:500];
  }
}
- (void)publicIt{
    self.AnnouncementContent.editable = NO;
    //发布中的时候显示转圈的进度
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.yOffset = -46.f;
    self.hud.minSize = CGSizeMake(120, 120);
    self.hud.color = [FreedomTools colorWithRGBHex:0x343637];
    self.hud.margin = 0;
    [self.hud show:YES];
    //发布成功后，使用自定义图片
    NSString *txt = [NSString stringWithFormat: @"@所有人\n%@",self.AnnouncementContent.text];
    //去除收尾的空格
    txt = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去除收尾的换行
    txt = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RCTextMessage *announcementMsg = [RCTextMessage messageWithContent:txt];
    announcementMsg.mentionedInfo = [[RCMentionedInfo alloc] initWithMentionedType:RC_Mentioned_All userIdList:nil mentionedContent:nil];
    [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:self.GroupId content:announcementMsg pushContent:nil pushData:nil success:^(long messageId) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
          self.hud.mode = MBProgressHUDModeCustomView;
          UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Complete"]];
          customView.frame = CGRectMake(0, 0, 80, 80);
          self.hud.customView = customView;
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
             //显示成功的图片后返回
             [self.navigationController popViewControllerAnimated:YES];
         });
      });
    }error:^(RCErrorCode nErrorCode, long messageId) {
       [self.hud hide:YES];
       [SVProgressHUD showErrorWithStatus:@"群公告发送失败"];
   }];
}
//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isEmpty:(NSString *) str {
  if (!str) {
    return YES;
  } else {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
      return YES;
    } else {
      return NO;
    }
  }
}
@end
