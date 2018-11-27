//  TLConversationViewController.h
//  Freedom
// Created by Super
#import "TLTableViewController.h"
#import "TLFriendSearchViewController.h"
#import "TLChatViewController.h"
#define     HEIGHT_CONVERSATION_CELL        64.0f
#import "TLMessageManager.h"
#import "WechartModes.h"
@class TLAddMenuView;
@protocol TLAddMenuViewDelegate <NSObject>
- (void)addMenuView:(TLAddMenuView *)addMenuView didSelectedItem:(TLAddMenuItem *)item;
@end
@interface TLAddMenuView : UIView
@property (nonatomic, assign) id<TLAddMenuViewDelegate>delegate;
/*显示AddMenu
 *
 *  @param view 父View*/
- (void)showInView:(UIView *)view;
/*是否正在显示*/
- (BOOL)isShow;
/*隐藏*/
- (void)dismiss;
@end
@interface TLConversationViewController : TLTableViewController<TLMessageManagerConvVCDelegate, UISearchBarDelegate, TLAddMenuViewDelegate>
@property (nonatomic, strong) TLFriendSearchViewController *searchVC;
@property (nonatomic, strong) NSMutableArray *data;
- (void)registerCellClass;
@end
