//
//  LanguageTableViewController.h
//  RCloudTest
//
//  Created by Super on 2017/5/27.
//  Copyright © 2017年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectedLanguage)(NSIndexPath *index,NSString *name,NSString *code);
@interface LanguageTableViewController : UITableViewController
@property (nonatomic,strong)selectedLanguage theLanguage;
@property (nonatomic,strong)NSArray *dataArray;
@end
