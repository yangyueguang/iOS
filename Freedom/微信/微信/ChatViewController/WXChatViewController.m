//  Freedom
// Created by Super
#import "WXChatViewController.h"
#import "WXChatDetailViewController.h"
#import "WXCGroupDetailViewController.h"
#import <UMMobClick/MobClick.h>
#import "WXRootViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WXExpressionViewController.h"
#import "WXMyExpressionViewController.h"
#import "WXFriendDetailViewController.h"
#import "MWPhotoBrowser.h"
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
#import "WXUserHelper.h"
#import <XCategory/NSFileManager+expanded.h>
@interface UIImagePickerController (Fixed)
@end
@implementation UIImagePickerController (Fixed)
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:colorGrayBG];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.5f]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
@end
@interface WXMoreKBHelper : NSObject
@property (nonatomic, strong) NSMutableArray *chatMoreKeyboardData;
@end
@implementation WXMoreKBHelper
- (id) init{
    if (self = [super init]) {
        self.chatMoreKeyboardData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    TLMoreKeyboardItem *imageItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeImage title:@"照片" imagePath:@"moreKB_image"];
    TLMoreKeyboardItem *cameraItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCamera title:@"拍摄" imagePath:@"moreKB_video"];
    TLMoreKeyboardItem *videoItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideo title:@"小视频" imagePath:@"moreKB_sight"];
    TLMoreKeyboardItem *videoCallItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVideoCall title:@"视频聊天" imagePath:@"moreKB_video_call"];
    TLMoreKeyboardItem *walletItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeWallet title:@"红包" imagePath:@"moreKB_wallet"];
    TLMoreKeyboardItem *transferItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeTransfer title:@"转账" imagePath:@"moreKB_pay"];
    TLMoreKeyboardItem *positionItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypePosition title:@"位置" imagePath:@"moreKB_location"];
    TLMoreKeyboardItem *favoriteItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeFavorite title:@"收藏" imagePath:@"moreKB_favorite"];
    TLMoreKeyboardItem *businessCardItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeBusinessCard title:@"个人名片" imagePath:@"moreKB_friendcard" ];
    TLMoreKeyboardItem *voiceItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeVoice title:@"语音输入" imagePath:@"moreKB_voice"];
    TLMoreKeyboardItem *cardsItem = [TLMoreKeyboardItem createByType:TLMoreKeyboardItemTypeCards title:@"卡券" imagePath:@"moreKB_wallet"];
    [self.chatMoreKeyboardData addObjectsFromArray:@[imageItem, cameraItem, videoItem, videoCallItem, walletItem, transferItem, positionItem, favoriteItem, businessCardItem, voiceItem, cardsItem]];
}
@end
static WXChatViewController *chatVC;
@interface WXChatViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) WXMoreKBHelper *moreKBhelper;
@property (nonatomic, strong) WXUserHelper *emojiKBHelper;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@end
@implementation WXChatViewController
+ (WXChatViewController *) sharedChatVC{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        chatVC = [[WXChatViewController alloc] init];
    });
    return chatVC;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
    
    self.user = (id<WXChatUserProtocol>)[WXUserHelper sharedHelper].user;
    self.moreKBhelper = [[WXMoreKBHelper alloc] init];
    [self setChatMoreKeyboardData:self.moreKBhelper.chatMoreKeyboardData];
    self.emojiKBHelper = [WXUserHelper sharedHelper];
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
- (void)setPartner:(id<WXChatUserProtocol>)partner{
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
        WXChatDetailViewController *chatDetailVC = [[WXChatDetailViewController alloc] init];
        [chatDetailVC setUser:(WXUser *)self.partner];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatDetailVC animated:YES];
    }else if ([self.partner chat_userType] == TLChatUserTypeGroup) {
        WXCGroupDetailViewController *chatGroupDetailVC = [[WXCGroupDetailViewController alloc] init];
        [chatGroupDetailVC setGroup:(WXGroup *)self.partner];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        [self sendImageMessage:image];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self sendImageMessage:image];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
     [picker dismissViewControllerAnimated:YES completion:nil];
}
//MARK: TLMoreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(TLMoreKeyboardItem *)funcItem{
    if (funcItem.type == TLMoreKeyboardItemTypeCamera || funcItem.type == TLMoreKeyboardItemTypeImage) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if (funcItem.type == TLMoreKeyboardItemTypeCamera) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            }else{
                [SVProgressHUD showErrorWithStatus:@"相机初始化失败"];
                return;
            }
        }else{
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"选中”%@“ 按钮", funcItem.title]];
    }
}
//MARK: TLEmojiKeyboardDelegate
- (void)emojiKeyboardEmojiEditButtonDown{
    WXExpressionViewController *expressionVC = [[WXExpressionViewController alloc] init];
    WXNavigationController *navC = [[WXNavigationController alloc] initWithRootViewController:expressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}
- (void)emojiKeyboardMyEmojiEditButtonDown{
    WXMyExpressionViewController *myExpressionVC = [[WXMyExpressionViewController alloc] init];
    WXNavigationController *navC = [[WXNavigationController alloc] initWithRootViewController:myExpressionVC];
    [self presentViewController:navC animated:YES completion:nil];
}
//MARK: WXChatViewControllerProxy
- (void)didClickedUserAvatar:(WXUser *)user{
    WXFriendDetailViewController *detailVC = [[WXFriendDetailViewController alloc] init];
    [detailVC setUser:user];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didClickedImageMessages:(NSArray *)imageMessages atIndex:(NSInteger)index{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (WXMessage *message in imageMessages) {
        NSURL *url;
        NSString *imagePath = message.content[@"path"];
        if (imagePath) {
            NSString *imagePatha = [NSFileManager pathUserChatImage:imagePath];
            url = [NSURL fileURLWithPath:imagePatha];
        }else{
            url = TLURL(message.content[@"url"]);
        }
        
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        [data addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:data];
    [browser setDisplayNavArrows:YES];
    [browser setCurrentPhotoIndex:index];
    WXNavigationController *broserNavC = [[WXNavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:broserNavC animated:NO completion:nil];
}
@end
