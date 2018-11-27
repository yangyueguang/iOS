//  FreedomBackgroundSettingViewController.m
//  Freedom
//  Created by Super on 16/3/19.
#import "TLChatBackgroundSettingViewController.h"
#import "UIImage+expanded.h"
#import "TLActionSheet.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "TLChatViewController.h"
#import "WechartModes.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TLCommonSettingViewController.h"
#define     SPACE_EDGE                      10
#define     WIDTH_COLLECTIONVIEW_CELL       (WIDTH_SCREEN - SPACE_EDGE * 2) / 3 * 0.98
#define     SPACE_COLLECTIONVIEW_CELL       (WIDTH_SCREEN - SPACE_EDGE * 2 - WIDTH_COLLECTIONVIEW_CELL * 3) / 2
@interface TLChatBackgroundSelectViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@interface TLChatBackgroundSelectViewController ()
@end
@implementation TLChatBackgroundSelectViewController
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
@interface TLChatBackgroundSettingViewController () <TLActionSheetDelegate>
@end
@implementation TLChatBackgroundSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天背景"];
    
    self.data = [TLCommonSettingHelper chatBackgroundSettingData];
}
#pragma mark - Delegate
//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data.count > 0) {
        return self.partnerID.length > 0 ? self.data.count - 1 : self.data.count;
    }
    return 0;
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"选择背景图"]) {
        TLChatBackgroundSelectViewController *bgSelectVC = [[TLChatBackgroundSelectViewController alloc] init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:bgSelectVC animated:YES];
    }else if ([item.title isEqualToString:@"从手机相册中选择"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
        [imagePickerController.rac_imageSelectedSignal subscribeNext:^(id x) {
            [imagePickerController dismissViewControllerAnimated:YES completion:^{
                UIImage *image = [x objectForKey:UIImagePickerControllerOriginalImage];
                [self p_setChatBackgroundImage:image];
            }];
        } completed:^{
            [imagePickerController dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if ([item.title isEqualToString:@"拍一张"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"相机初始化失败"];
        }else{
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePickerController animated:YES completion:nil];
            [imagePickerController.rac_imageSelectedSignal subscribeNext:^(id x) {
                [imagePickerController dismissViewControllerAnimated:YES completion:^{
                    UIImage *image = [x objectForKey:UIImagePickerControllerOriginalImage];
                    [self p_setChatBackgroundImage:image];
                }];
            } completed:^{
                [imagePickerController dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }else if ([item.title isEqualToString:@"将背景应用到所有聊天场景"]) {
        TLActionSheet *actionSheet = [[TLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"将背景应用到所有聊天场景" otherButtonTitles:nil];
        [actionSheet show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: TLActionSheetDelegate
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        for (NSString *key in [NSUserDefaults standardUserDefaults].dictionaryRepresentation.allKeys) {
            if ([key hasPrefix:@"CHAT_BG_"] && ![key isEqualToString:@"CHAT_BG_ALL"]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
        }
        [[TLChatViewController sharedChatVC] resetChatVC];
    }
}
#pragma mark - Private Methods -
- (void)p_setChatBackgroundImage:(UIImage *)image{
    image = [image scalingToSize:self.view.frameSize];
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
    
    [[TLChatViewController sharedChatVC] resetChatVC];
}
@end
