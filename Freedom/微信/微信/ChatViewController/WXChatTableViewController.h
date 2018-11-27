//  FreedomTableViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "WXMessageManager.h"
#import "TLEmojiKeyboard.h"
#import <Foundation/Foundation.h>
@protocol WXMessageCellDelegate;
typedef NS_ENUM(NSInteger, TLChatMenuItemType) {
    TLChatMenuItemTypeCancel,
    TLChatMenuItemTypeCopy,
    TLChatMenuItemTypeDelete,
};
@interface WXMessageBaseCell : UITableViewCell
@property (nonatomic, assign) id<WXMessageCellDelegate>delegate;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *messageBackgroundView;
@property (nonatomic, strong) WXMessage *message;
@end
@interface WXTextMessage : WXMessage
//@property (nonatomic, strong) NSString *text;                       // 文字信息
@property (nonatomic, strong) NSAttributedString *attrText;         // 格式化的文字信息（仅展示用）
@end
@interface WXTextMessageCell : WXMessageBaseCell
@end
@interface WXImageMessageCell : WXMessageBaseCell
@end
@interface WXExpressionMessage : WXMessage
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, assign, readonly) CGSize emojiSize;
@end
@interface WXExpressionMessageCell : WXMessageBaseCell
@end
@interface WXChatCellMenuView : UIView
@property (nonatomic, assign, readonly) BOOL isShow;
@property (nonatomic, assign) TLMessageType messageType;
@property (nonatomic, copy) void (^actionBlcok)();
+ (WXChatCellMenuView *)sharedMenuView;
- (void)showInView:(UIView *)view withMessageType:(TLMessageType)messageType rect:(CGRect)rect actionBlock:(void (^)(TLChatMenuItemType))actionBlock;
- (void)dismiss;
@end
@protocol WXMessageCellDelegate <NSObject>
- (void)messageCellDidClickAvatarForUser:(id<WXChatUserProtocol>)user;
- (void)messageCellTap:(WXMessage *)message;
- (void)messageCellLongPress:(WXMessage *)message rect:(CGRect)rect;
- (void)messageCellDoubleClick:(WXMessage *)message;
@end
@class WXMessage;
@class WXChatTableViewController;
@protocol WXChatTableViewControllerDelegate <NSObject>
/*聊天界面点击事件，用于收键盘*/
- (void)chatTableViewControllerDidTouched:(WXChatTableViewController *)chatTVC;
/*下拉刷新，获取某个时间段的聊天记录（异步）
 *
 *  @param chatTVC   chatTVC
 *  @param date      开始时间
 *  @param count     条数
 *  @param completed 结果Blcok*/
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC
             getRecordsFromDate:(NSDate *)date
                          count:(NSUInteger)count
                      completed:(void (^)(NSDate *, NSArray *, BOOL))completed;
@optional
/*消息长按删除
 *
 *  @return 删除是否成功*/
- (BOOL)chatTableViewController:(WXChatTableViewController *)chatTVC
                  deleteMessage:(WXMessage *)message;
/*用户头像点击事件*/
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC
             didClickUserAvatar:(WXUser *)user;
/*Message点击事件*/
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC
                didClickMessage:(WXMessage *)message;
/*Message双击事件*/
- (void)chatTableViewController:(WXChatTableViewController *)chatTVC
          didDoubleClickMessage:(WXMessage *)message;
@end
@interface UITableView (expanded)
- (void)scrollToBottomWithAnimation:(BOOL)animation;
@end
@interface WXChatTableViewController : UITableViewController<WXMessageCellDelegate>
- (void)registerCellClass;
@property (nonatomic, assign) id<WXChatTableViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *data;
/// 禁用下拉刷新
@property (nonatomic, assign) BOOL disablePullToRefresh;
/// 禁用长按菜单
@property (nonatomic, assign) BOOL disableLongPressMenu;
/*发送消息（在列表展示）*/
- (void)addMessage:(WXMessage *)message;
/*删除消息*/
- (void)deleteMessage:(WXMessage *)message;
/*滚动到底部
 *
 *  @param animation 是否执行动画*/
- (void)scrollToBottomWithAnimation:(BOOL)animation;
/*重新加载聊天信息*/
- (void)reloadData;
@end
