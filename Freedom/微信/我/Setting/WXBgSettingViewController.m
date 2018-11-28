//  FreedomBackgroundSettingViewController.m
//  Freedom
//  Created by Super on 16/3/19.
#import "WXBgSettingViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WXChatViewController.h"
#import "WXModes.h"
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
#import "WXCommonSettingViewController.h"
#import "WXBaseViewController.h"
#import "NSFileManager+expanded.h"
#define     SPACE_EDGE                      10
#define     WIDTH_COLLECTIONVIEW_CELL       (APPW - SPACE_EDGE * 2) / 3 * 0.98
#define     SPACE_COLLECTIONVIEW_CELL       (APPW - SPACE_EDGE * 2 - WIDTH_COLLECTIONVIEW_CELL * 3) / 2
@interface WXChatBackgroundSelectViewController : WXBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@interface WXChatBackgroundSelectViewController ()
@end
@implementation WXChatBackgroundSelectViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择背景图"];
    [self.collectionView setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.view addSubview:self.collectionView];
    
    [self p_addMasonry];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
#pragma mark - 
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setSectionHeadersPinToVisibleBounds:YES];
        [layout setItemSize:CGSizeMake(WIDTH_COLLECTIONVIEW_CELL, WIDTH_COLLECTIONVIEW_CELL)];
        [layout setMinimumInteritemSpacing:SPACE_COLLECTIONVIEW_CELL];
        [layout setMinimumLineSpacing:SPACE_COLLECTIONVIEW_CELL];
        [layout setSectionInset:UIEdgeInsetsMake(0, SPACE_EDGE, 0, SPACE_EDGE)];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setAlwaysBounceVertical:YES];
    }
    return _collectionView;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TLChatBackgroundSelectCell"];
}
#pragma mark - 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLChatBackgroundSelectCell" forIndexPath:indexPath];
    return cell;
}
@end
@interface WXBgSettingViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end
@implementation WXBgSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天背景"];
    
    self.data = [WXCommonSettingHelper chatBackgroundSettingData];
}
#pragma mark - Delegate
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data.count > 0) {
        return self.partnerID.length > 0 ? self.data.count - 1 : self.data.count;
    }
    return 0;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        [self p_setChatBackgroundImage:image];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self p_setChatBackgroundImage:image];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"选择背景图"]) {
        WXChatBackgroundSelectViewController *bgSelectVC = [[WXChatBackgroundSelectViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:bgSelectVC animated:YES];
    }else if ([item.title isEqualToString:@"从手机相册中选择"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else if ([item.title isEqualToString:@"拍一张"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [SVProgressHUD showErrorWithStatus:@"相机初始化失败"];
        }else{
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }else if ([item.title isEqualToString:@"将背景应用到所有聊天场景"]) {
        [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"将背景应用到所有聊天场景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (NSString *key in [NSUserDefaults standardUserDefaults].dictionaryRepresentation.allKeys) {
                    if ([key hasPrefix:@"CHAT_BG_"] && ![key isEqualToString:@"CHAT_BG_ALL"]) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                    }
                }
                [[WXChatViewController sharedChatVC] resetChatVC];
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            }];
        } ac3:nil completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - Private Methods -
- (void)p_setChatBackgroundImage:(UIImage *)image{
    
    NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
    NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
    NSString *imagePath = [NSFileManager pathUserChatBackgroundImage:imageName];;
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
    
    //TODO: 临时写法
    if (self.partnerID.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:[@"CHAT_BG_" stringByAppendingString:self.partnerID]];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"CHAT_BG_ALL"];
    }
    
    [[WXChatViewController sharedChatVC] resetChatVC];
}
@end
