//  FreedomBaseViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLChatTableViewController.h"
#import "TLImageExpressionDisplayView.h"
#import "TLMoreKeyboard.h"
#import "TLEmojiKeyboard.h"
#import "TLUserHelper.h"
@interface TLEmojiDisplayView : UIImageView
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, assign) CGRect rect;
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect;
@end
@class TLChatBar;
@protocol TLChatBarDelegate <NSObject>
/*chatBar状态改变*/
- (void)chatBar:(TLChatBar *)chatBar changeStatusFrom:(TLChatBarStatus)fromStatus to:(TLChatBarStatus)toStatus;
/*输入框高度改变*/
- (void)chatBar:(TLChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height;
@end
@protocol TLChatBarDataDelegate <NSObject>
/*发送文字*/
- (void)chatBar:(TLChatBar *)chatBar sendText:(NSString *)text;
// 录音控制
- (void)chatBarRecording:(TLChatBar *)chatBar;
- (void)chatBarWillCancelRecording:(TLChatBar *)chatBar;
- (void)chatBarDidCancelRecording:(TLChatBar *)chatBar;
- (void)chatBarFinishedRecoding:(TLChatBar *)chatBar;
@end
@interface TLChatBar : UIView
@property (nonatomic, assign) id<TLChatBarDelegate> delegate;
@property (nonatomic, assign) id<TLChatBarDataDelegate> dataDelegate;
@property (nonatomic, assign) TLChatBarStatus status;
@property (nonatomic, strong, readonly) NSString *curText;
@property (nonatomic, assign) BOOL activity;
- (void)addEmojiString:(NSString *)emojiString;
- (void)sendCurrentText;
@end
@class TLImageMessage;
@protocol TLChatViewControllerProxy <NSObject>
@optional;
- (void)didClickedUserAvatar:(TLUser *)user;
- (void)didClickedImageMessages:(NSArray *)imageMessages atIndex:(NSInteger)index;
@end
@interface TLChatBaseViewController : UIViewController <TLChatViewControllerProxy, TLMoreKeyboardDelegate,TLChatBarDelegate, TLKeyboardDelegate,TLEmojiKeyboardDelegate,TLChatBarDataDelegate,TLChatTableViewControllerDelegate>{
    TLChatBarStatus lastStatus;
    TLChatBarStatus curStatus;
}
/// 用户信息
@property (nonatomic, strong) id<TLChatUserProtocol> user;
/// 聊天对象
@property (nonatomic, strong) id<TLChatUserProtocol> partner;
/// 消息展示页面
@property (nonatomic, strong) TLChatTableViewController *chatTableVC;
/// 聊天输入栏
@property (nonatomic, strong) TLChatBar *chatBar;
/// 更多键盘
@property (nonatomic, strong) TLMoreKeyboard *moreKeyboard;
/// 表情键盘
@property (nonatomic, strong) TLEmojiKeyboard *emojiKeyboard;
/// emoji展示view
@property (nonatomic, strong) TLEmojiDisplayView *emojiDisplayView;
/// 图片表情展示view
@property (nonatomic, strong) TLImageExpressionDisplayView *imageExpressionDisplayView;
/*设置“更多”键盘元素*/
- (void)setChatMoreKeyboardData:(NSMutableArray *)moreKeyboardData;
/*设置“表情”键盘元素*/
- (void)setChatEmojiKeyboardData:(NSMutableArray *)emojiKeyboardData;
/*重置chatVC*/
- (void)resetChatVC;
/*发送图片信息*/
- (void)sendImageMessage:(UIImage *)image;
/*发送消息*/
- (void)sendMessage:(TLMessage *)message;
/*展示消息（添加到chatVC）*/
- (void)addToShowMessage:(TLMessage *)message;
/*1、处理各种键盘（系统、自定义表情、自定义更多）回调
 *  2、响应chatBar的按钮点击事件*/
- (void)resetChatTVC;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardFrameWillChange:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
@end
