//  TLShakeSettingViewController.m
//  Freedom
//  Created by Super on 16/3/3.
#import "WXModes.h"
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
#import "WXShakeSettingViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <XCategory/NSFileManager+expanded.h>
@interface WXShakeHelper : NSObject
@property (nonatomic, strong) NSMutableArray *shakeSettingData;
@end
@implementation WXShakeHelper
- (id) init{
    if (self = [super init]) {
        self.shakeSettingData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
- (void) p_initTestData{
    WXSettingItem *item1 = TLCreateSettingItem(@"使用默认背景图片");
    item1.showDisclosureIndicator = NO;
    WXSettingItem *item2 = TLCreateSettingItem(@"换张背景图片");
    WXSettingItem *item3 = TLCreateSettingItem(@"音效");
    item3.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[item1, item2, item3]));
    
    WXSettingItem *item5 = TLCreateSettingItem(@"打招呼的人");
    WXSettingItem *item6 = TLCreateSettingItem(@"摇到的历史");
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[item5, item6]));
    
    WXSettingItem *item7 = TLCreateSettingItem(@"摇一摇消息");
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, (@[item7]));
    
    [self.shakeSettingData addObjectsFromArray:@[group1, group2, group3]];
}
@end
@interface WXShakeSettingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) WXShakeHelper *helper;
@end
@implementation WXShakeSettingViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"摇一摇设置"];
    
    self.helper = [[WXShakeHelper alloc] init];
    self.data = self.helper.shakeSettingData;
}
#pragma mark - Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        }
        NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
        NSString *imagePath = [NSFileManager pathUserSettingImage:imageName];
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"Shake_Image_Path"];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        NSString *imageName = [NSString stringWithFormat:@"%lf.jpg", [NSDate date].timeIntervalSince1970];
        NSString *imagePath = [NSFileManager pathUserSettingImage:imageName];
        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
        [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"Shake_Image_Path"];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"使用默认背景图片"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Shake_Image_Path"];
        [SVProgressHUD showInfoWithStatus:@"已恢复默认背景图"];
    }else if ([item.title isEqualToString:@"换张背景图片"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setAllowsEditing:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
        imagePickerController.delegate = self;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
