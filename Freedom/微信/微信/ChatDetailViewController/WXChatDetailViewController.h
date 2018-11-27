//  FreedomDetailViewController.h
//  Freedom
// Created by Super
#import "WXSettingViewController.h"
#import "WXUserHelper.h"
@interface WXChatDetailViewController : WXSettingViewController
@property (nonatomic, strong) WXUser *user;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
