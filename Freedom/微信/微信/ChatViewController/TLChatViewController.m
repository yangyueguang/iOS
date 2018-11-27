//  FreedomViewController.m
//  Freedom
// Created by Super
#import "TLChatViewController.h"
#import "TLChatDetailViewController.h"
#import "TLChatGroupDetailViewController.h"
#import <MobClick.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "TLExpressionViewController.h"
#import "TLMyExpressionViewController.h"
#import "TLFriendDetailViewController.h"
#import "MWPhotoBrowser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TLUserHelper.h"
@interface TLMoreKBHelper : NSObject
@property (nonatomic, strong) NSMutableArray *chatMoreKeyboardData;
@end
@implementation TLMoreKBHelper
- (id) init{
    if (self = [super init]) {
        self.chatMoreKeyboardData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLMoreKeyboardItem *imageItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeImage
                                                               title:@"照片"
                                                           imagePath:@"moreKB_image"];
    TLMoreKeyboardItem *cameraItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCamera
                                                                title:@"拍摄"
                                                            imagePath:@"moreKB_video"];
    TLMoreKeyboardItem *videoItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideo
                                                               title:@"小视频"
                                                           imagePath:@"moreKB_sight"];
    TLMoreKeyboardItem *videoCallItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideoCall
                                                                   title:@"视频聊天"
                                                               imagePath:@"moreKB_video_call"];
    TLMoreKeyboardItem *walletItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeWallet
                                                                title:@"红包"
                                                            imagePath:@"moreKB_wallet"];
    TLMoreKeyboardItem *transferItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeTransfer
                                                                  title:@"转账"
                                                              imagePath:@"moreKB_pay"];
    TLMoreKeyboardItem *positionItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypePosition
                                                                  title:@"位置"
                                                              imagePath:@"moreKB_location"];
    TLMoreKeyboardItem *favoriteItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeFavorite
                                                                  title:@"收藏"
                                                              imagePath:@"moreKB_favorite"];
    TLMoreKeyboardItem *businessCardItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeBusinessCard
                                                                      title:@"个人名片"
                                                                  imagePath:@"moreKB_friendcard" ];
    TLMoreKeyboardItem *voiceItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVoice
                                                               title:@"语音输入"
                                                           imagePath:@"moreKB_voice"];
    TLMoreKeyboardItem *cardsItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCards
                                                               title:@"卡券"
                                                           imagePath:@"moreKB_wallet"];
    [self.chatMoreKeyboardData addObjectsFromArray:@[imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem]];
}
@end
static TLChatViewController *chatVC;
@interface TLChatViewController()
@property (nonatomic, strong) TLMoreKBHelper *moreKBhelper;
@property (nonatomic, strong) TLUserHelper *emojiKBHelper;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@end
@implementation TLChatViewController
+ (TLChatViewController *) sharedChatVC{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        chatVC = [[TLChatViewController alloc] init];
    });
    return chatVC;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    
    self.user = (id<TLChatUserProtocol>)[TLUserHelper sharedHelper].user;
    self.moreKBhelper = [[TLMoreKBHelper alloc] init];
    [self setChatMoreKeyboardData:self.moreKBhelper.chatMoreKeyboardData];
    self.emojiKBHelper = [TLUserHelper sharedHelper];
    [self.emojiKBHelper emojiGroupDataComplete:^(NSMutableArray *emojiGroups) {
        [self setChatEmojiKeyboardData:emojiGroups];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChatVC"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChatVC"];
}
- (void)dealloc{
#ifdef DEBUG_MEMERY
    DLog(@"dealloc ChatVC");
#endif
}
#pragma mark Public Methods
- (void)setPartner:(id<TLChatUserProtocol>)partner{
    [super setPartner:partner];
    if ([partner chat_userType] == TLChatUserTypeUser) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_single"]];
    }else if ([partner chat_userType] == TLChatUserTypeGroup) {
        [self.rightBarButton setImage:[UIImage imageNamed:@"nav_chat_multi"]];
    }
}
#pragma mark - Event Response
- (void)rightBarButtonDown:(UINavigationBar *)sender{
    if ([self.partner chat_userType] == TLChatUserTypeUser) {
        TLChatDetailViewController *chatDetailVC = [[TLChatDetailViewController alloc] init];
        [chatDetailVC setUser:(TLUser *)self.partner];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatDetailVC animated:YES];
    }else if ([self.partner chat_userType] == TLChatUserTypeGroup) {
        TLChatGroupDetailViewController *chatGroupDetailVC = [[TLChatGroupDetailViewController alloc] init];
        [chatGroupDetailVC setGroup:(TLGroup *)self.partner];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatGroupDetailVC animated:YES];
    }
}
#pragma mark - 
- (UIBarButtonItem *)rightBarButton{
    if (_rightBarButton == nil) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    }
    return _rightBarButton;
}
#pragma mark - Delegate -
//MARK: TLMoreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(TLMoreKeyboardItem *)funcItem{
    if (funcItem.type == TLMoreKeyboardItemTypeCamera || funcItem.type == TLMoreKeyboardItemTypeImage) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if (funcItem.type == TLMoreKeyboardItemTypeCamera) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }else{
                [UIAlertView bk_alertViewWithTitle:@"错误" message:@"相机初始化失败"];
                return;
            }
        }else{
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imagePickerController animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        [imagePickerController.rac_imageSelectedSignal subscribeNext:^(id x) {
            [imagePickerController dismissViewControllerAnimated:YES completion:^{
                UIImage *image = [x objectForKey:UIImagePickerControllerOriginalImage];
                [weakSelf sendImageMessage:image];
            }];
        } completed:^{
            [imagePickerController dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"选中”%@“ 按钮", funcItem.title] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
//MARK: TLEmojiKeyboardDelegate
- (void)emojiKeyboardEmojiEditButtonDown{
    TLExpressionViewController *expressionVC = [[TLExpressionViewController alloc] init];
    TLNavigationController *navC = [[TLNavigationController alloc] initWithRootViewController:expressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}
- (void)emojiKeyboardMyEmojiEditButtonDown{
    TLMyExpressionViewController *myExpressionVC = [[TLMyExpressionViewController alloc] init];
    TLNavigationController *navC = [[TLNavigationController alloc] initWithRootViewController:myExpressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}
//MARK: TLChatViewControllerProxy
- (void)didClickedUserAvatar:(TLUser *)user{
    TLFriendDetailViewController *detailVC = [[TLFriendDetailViewController alloc] init];
    [detailVC setUser:user];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didClickedImageMessages:(NSArray *)imageMessages atIndex:(NSInteger)index{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (TLMessage *message in imageMessages) {
        NSURL *url;
        if ([(TLImageMessage *)message imagePath]) {
            NSString *imagePath = [NSFileManager pathUserChatImage:[(TLImageMessage *)message imagePath]];
            url = [NSURL fileURLWithPath:imagePath];
        }else{
            url = TLURL([(TLImageMessage *)message imageURL]);
        }
        
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    TLNavigationController *broserNavC = [[TLNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}
@end
