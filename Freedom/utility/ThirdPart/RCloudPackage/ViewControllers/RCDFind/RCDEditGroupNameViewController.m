//
//  RCDEditGroupNameViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/28.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDEditGroupNameViewController.h"
#import "RCDHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDataBaseManager.h"
@interface RCDEditGroupNameViewController ()
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@end
@implementation RCDEditGroupNameViewController
+ (instancetype)editGroupNameViewController {
    return [[self alloc]init];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, APPW, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    CGFloat groupNameTextFieldWidth = APPW-8-8;
    self.groupNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 10, groupNameTextFieldWidth, 44)];
    self.groupNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.groupNameTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.groupNameTextField];
    _groupNameTextField.delegate = self;
    //自定义rightBarButtonItem
    self.rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone:)];
    self.rightBtn.customView.userInteractionEnabled = NO;
    NSArray<UIBarButtonItem *> *barButtonItems;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    barButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.rightBtn, nil];
    self.navigationItem.rightBarButtonItems = barButtonItems;
}
- (void)setGroupInfo:(RCDGroupInfo *)groupInfo {
    _groupInfo = groupInfo;
    self.groupNameTextField.text = groupInfo.groupName;
}
- (void)viewDidLoad {
  [super viewDidLoad];
}
- (void)clickDone:(id)sender {
    self.rightBtn.customView.userInteractionEnabled = NO;
  NSString *nameStr = [_groupNameTextField.text copy];
  nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  //群组名称需要大于2位
  if ([nameStr length] == 0) {
    [self Alert:@"群组名称不能为空"];
    return;
  }
  //群组名称需要大于2个字
  if ([nameStr length] < 2) {
    [self Alert:@"群组名称过短"];
    return;
  }
  //群组名称需要小于10个字
  if ([nameStr length] > 10) {
    [self Alert:@"群组名称不能超过10个字"];
    return;
  }
  [RCDHTTPTOOL renameGroupWithGoupId:_groupInfo.groupId groupName:nameStr complete:^(BOOL result) {
      if (result == YES) {
        RCGroup *groupInfo = [RCGroup new];
        groupInfo.groupId = _groupInfo.groupId;
        groupInfo.groupName = nameStr;
        groupInfo.portraitUri = _groupInfo.portraitUri;
        [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:_groupInfo.groupId];
        RCDGroupInfo *tempGroupInfo = [[RCDataBaseManager shareInstance] getGroupByGroupId:groupInfo.groupId];
        tempGroupInfo.groupName = nameStr;
        [[RCDataBaseManager shareInstance] insertGroupToDB:tempGroupInfo];
        [self.navigationController popViewControllerAnimated:YES];
      }
      if (result == NO) {
        [self Alert:@"群组名称修改失败"];
      }
    }];
}
- (void)Alert:(NSString *)alertContent {
    NSLog(alertContent);
}
#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.rightBtn.customView.userInteractionEnabled = YES;
  return YES;
}
@end
