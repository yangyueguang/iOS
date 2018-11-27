//  FreedomBaseViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WXChatTableViewController.h"
#import "WXImageExpressionDisplayView.h"
#import "TLMoreKeyboard.h"
#import "TLEmojiKeyboard.h"
#import "WXUserHelper.h"
#import "WXBaseViewController.h"
@interface WXEmojiDisplayView : UIImageView
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, assign) CGRect rect;
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect;
@end
@class WXChatBar;
@protocol WXChatBarDelegate <NSObject>
/*chatBar状态改变*/
- (void)chatBar:(WXChatBar *)chatBar changeStatusFrom:(TLChatBarStatus)fromStatus to:(TLChatBarStatus)toStatus;
/*输入框高度改变*/
- (void)chatBar:(WXChatBar *)chatBar didChangeTextViewHeight:(CGFloat)height;
@end
@protocol WXChatBarDataDelegate <NSObject>
/*发送文字*/
- (void)chatBar:(WXChatBar *)chatBar sendText:(NSString *)text;
// 录音控制
- (void)chatBarRecording:(WXChatBar *)chatBar;
- (void)chatBarWillCancelRecording:(WXChatBar *)chatBar;
- (void)chatBarDidCancelRecording:(WXChatBar *)chatBar;
- (void)chatBarFinishedRecoding:(WXChatBar *)chatBar;
@end
@interface WXChatBar : UIView
@property (nonatomic, assign) id<WXChatBarDelegate> delegate;
@property (nonatomic, assign) id<WXChatBarDataDelegate> dataDelegate;
@property (nonatomic, assign) TLChatBarStatus status;
@property (nonatomic, strong, readonly) NSString *curText;
@property (nonatomic, assign) BOOL activity;
- (void)addEmojiString:(NSString *)emojiString;
- (void)sendCurrentText;
@end
@class WXImageMessage;
@protocol WXChatViewControllerProxy <NSObject>
@optional;
- (void)didClickedUserAvatar:(WXUser *)user;
- (void)didClickedImageMessages:(NSArray *)imageMessages atIndex:(NSInteger)index;
@end
@interface WXChatBaseViewController : WXBaseViewController <WXChatViewControllerProxy, WXMoreKeyboardDelegate,WXChatBarDelegate, TLKeyboardDelegate,TLEmojiKeyboardDelegate,WXChatBarDataDelegate,WXChatTableViewControllerDelegate>{
    TLChatBarStatus lastStatus;
    TLChatBarStatus curStatus;
}
/// 用户信息
@property (nonatomic, strong) id<WXChatUserProtocol> user;
/// 聊天对象
@property (nonatomic, strong) id<WXChatUserProtocol> partner;
/// 消息展示页面
@property (nonatomic, strong) WXChatTableViewController *chatTableVC;
/// 聊天输入栏
@property (nonatomic, strong) WXChatBar *chatBar;
/// 更多键盘
@property (nonatomic, strong) TLMoreKeyboard *moreKeyboard;
/// 表情键盘
@property (nonatomic, strong) TLEmojiKeyboard *emojiKeyboard;
/// emoji展示view
@property (nonatomic, strong) WXEmojiDisplayView *emojiDisplayView;
/// 图片表情展示view
@property (nonatomic, strong) WXImageExpressionDisplayView *imageExpressionDisplayView;
/*设置“更多”键盘元素*/
- (void)setChatMoreKeyboardData:(NSMutableArray *)moreKeyboardData;
/*设置“表情”键盘元素*/
- (void)setChatEmojiKeyboardData:(NSMutableArray *)emojiKeyboardData;
/*重置chatVC*/
- (void)resetChatVC;
/*发送图片信息*/
- (void)sendImageMessage:(UIImage *)image;
/*发送消息*/
- (void)sendMessage:(WXMessage *)message;
/*展示消息（添加到chatVC）*/
- (void)addToShowMessage:(WXMessage *)message;
/*1、处理各种键盘（系统、自定义表情、自定义更多）回调
 *  2、响应chatBar的按钮点击事件*/
- (void)resetChatTVC;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardFrameWillChange:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
@end
