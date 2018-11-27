//  FreedomTableViewController.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import "TLMessageManager.h"
#import "TLEmojiKeyboard.h"
#import "TLActionSheet.h"
#import <Foundation/Foundation.h>
#import "NSString+expanded.h"
@protocol TLMessageCellDelegate;
typedef NS_ENUM(NSInteger, TLChatMenuItemType) {
    TLChatMenuItemTypeCancel,
    TLChatMenuItemTypeCopy,
    TLChatMenuItemTypeDelete,
};
@interface TLMessageBaseCell : UITableViewCell
@property (nonatomic, assign) id<TLMessageCellDelegate>delegate;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *messageBackgroundView;
@property (nonatomic, strong) TLMessage *message;
@end
@interface TLTextMessage : TLMessage
@property (nonatomic, strong) NSString *text;                       // 文字信息
@property (nonatomic, strong) NSAttributedString *attrText;         // 格式化的文字信息（仅展示用）
@end
@interface TLTextMessageCell : TLMessageBaseCell
@end
@interface TLImageMessageCell : TLMessageBaseCell
@end
@interface TLExpressionMessage : TLMessage
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, assign, readonly) CGSize emojiSize;
@end
@interface TLExpressionMessageCell : TLMessageBaseCell
@end
@interface TLChatCellMenuView : UIView
@property (nonatomic, assign, readonly) BOOL isShow;
@property (nonatomic, assign) TLMessageType messageType;
@property (nonatomic, copy) void (^actionBlcok)();
+ (TLChatCellMenuView *)sharedMenuView;
- (void)showInView:(UIView *)view withMessageType:(TLMessageType)messageType rect:(CGRect)rect actionBlock:(void (^)(TLChatMenuItemType))actionBlock;
- (void)dismiss;
@end
@protocol TLMessageCellDelegate <NSObject>
- (void)messageCellDidClickAvatarForUser:(id<TLChatUserProtocol>)user;
- (void)messageCellTap:(TLMessage *)message;
- (void)messageCellLongPress:(TLMessage *)message rect:(CGRect)rect;
- (void)messageCellDoubleClick:(TLMessage *)message;
@end
@class TLMessage;
@class TLChatTableViewController;
@protocol TLChatTableViewControllerDelegate <NSObject>
/*聊天界面点击事件，用于收键盘*/
- (void)chatTableViewControllerDidTouched:(TLChatTableViewController *)chatTVC;
/*下拉刷新，获取某个时间段的聊天记录（异步）
 *
 *  @param chatTVC   chatTVC
 *  @param date      开始时间
 *  @param count     条数
 *  @param completed 结果Blcok*/
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
             getRecordsFromDate:(NSDate *)date
                          count:(NSUInteger)count
                      completed:(void (^)(NSDate *, NSArray *, BOOL))completed;
@optional
/*消息长按删除
 *
 *  @return 删除是否成功*/
- (BOOL)chatTableViewController:(TLChatTableViewController *)chatTVC
                  deleteMessage:(TLMessage *)message;
/*用户头像点击事件*/
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
             didClickUserAvatar:(TLUser *)user;
/*Message点击事件*/
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
                didClickMessage:(TLMessage *)message;
/*Message双击事件*/
- (void)chatTableViewController:(TLChatTableViewController *)chatTVC
          didDoubleClickMessage:(TLMessage *)message;
@end
@interface UITableView (expanded)
- (void)scrollToBottomWithAnimation:(BOOL)animation;
@end
@interface TLChatTableViewController : UITableViewController<TLMessageCellDelegate, TLActionSheetDelegate>
- (void)registerCellClass;
@property (nonatomic, assign) id<TLChatTableViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *data;
/// 禁用下拉刷新
@property (nonatomic, assign) BOOL disablePullToRefresh;
/// 禁用长按菜单
@property (nonatomic, assign) BOOL disableLongPressMenu;
/*发送消息（在列表展示）*/
- (void)addMessage:(TLMessage *)message;
/*删除消息*/
- (void)deleteMessage:(TLMessage *)message;
/*滚动到底部
 *
 *  @param animation 是否执行动画*/
- (void)scrollToBottomWithAnimation:(BOOL)animation;
/*重新加载聊天信息*/
- (void)reloadData;
@end
