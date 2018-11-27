//
//  RCDChangePasswordViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/2/29.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDChangePasswordViewController.h"
#import "AFHttpTool.h"
@interface RCDChangePasswordViewController ()
@property(nonatomic, strong) UILabel *oldPwdLabel;
@property(nonatomic, strong) UILabel *newsPwdLabel;
@property(nonatomic, strong) UILabel *confirmPwdLabel;
@property(nonatomic, strong) UITextField *oldPwdTextField;
@property(nonatomic, strong) UITextField *newsPwdTextField;
@property(nonatomic, strong) UITextField *confirmPwdTextField;
@property(nonatomic, strong) UIView *oldPwdView;
@property(nonatomic, strong) UIView *newsPwdView;
@property(nonatomic, strong) UIView *confirmPwdView;
@property(nonatomic, strong) NSDictionary *subViews;
@end
@implementation RCDChangePasswordViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"密码修改";
  [self initialize];
  [self setNavigationButton];
  self.view.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
}
- (void)initialize{
  self.oldPwdLabel = [self setLabel:@"原密码"];
  self.oldPwdView = [self setSubView];
  self.oldPwdTextField = [self setTextField:nil];
  [self.view addSubview:self.oldPwdLabel];
  [self.view addSubview:self.oldPwdView];
  [self.oldPwdView addSubview:self.oldPwdTextField];
  self.newsPwdLabel = [self setLabel:@"新密码"];
  self.newsPwdView = [self setSubView];
  self.newsPwdTextField = [self setTextField:@"6-16位字符，区分大小写"];
  [self.view addSubview:self.newsPwdLabel];
  [self.view addSubview:self.newsPwdView];
  [self.newsPwdView addSubview:self.newsPwdTextField];
  
  self.confirmPwdLabel = [self setLabel:@"确认密码"];
  self.confirmPwdView = [self setSubView];
  self.confirmPwdTextField = [self setTextField:@"6-16位字符，区分大小写"];
  [self.view addSubview:self.confirmPwdLabel];
  [self.view addSubview:self.confirmPwdView];
  [self.confirmPwdView addSubview:self.confirmPwdTextField];
  [self setAutoLayout];
}
- (void)setNavigationButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackBtn)];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveNewPassword:)];
    rightBtn.customView.userInteractionEnabled = NO;
    NSArray<UIBarButtonItem *> *barButtonItems;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    barButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBtn, nil];
  self.navigationItem.rightBarButtonItems = barButtonItems;
}
- (UILabel *)setLabel:(NSString *)labelName {
  UILabel *label = [[UILabel alloc] init];
  label.text = labelName;
  label.font = [UIFont systemFontOfSize:14.f];
  label.textColor = [UIColor colorWithRGBHex:0x999999];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  return label;
}
- (UIView *)setSubView {
  UIView *subView = [[UIView alloc] init];
  subView.backgroundColor = [UIColor whiteColor];
  subView.layer.borderWidth = 0.5;
  subView.layer.borderColor = [[UIColor colorWithRGBHex:0xdfdfdd] CGColor];
  subView.translatesAutoresizingMaskIntoConstraints = NO;
  return subView;
}
- (UITextField *)setTextField:(NSString *)placeholder {
  UITextField *subTextField = [[UITextField alloc] init];
  subTextField.borderStyle = UITextBorderStyleNone;
  subTextField.clearButtonMode = UITextFieldViewModeAlways;
  subTextField.secureTextEntry = YES;
  subTextField.font = [UIFont systemFontOfSize:14.f];
  subTextField.textColor = [UIColor colorWithRGBHex:0x000000];
  if (placeholder != nil) {
    subTextField.placeholder = placeholder;
  }
  subTextField.delegate = self;
  subTextField.translatesAutoresizingMaskIntoConstraints = NO;
  return subTextField;
}
- (void)setAutoLayout {
  self.subViews = NSDictionaryOfVariableBindings(_oldPwdLabel, _oldPwdView, _oldPwdTextField, _newsPwdLabel, _newsPwdView, _newsPwdTextField, _confirmPwdLabel, _confirmPwdView, _confirmPwdTextField);
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"V:|-9-[_oldPwdLabel]-8-[_oldPwdView(44)]-9-[_newsPwdLabel]-8-[_newsPwdView(44)]-9-[_confirmPwdLabel]-8-[_confirmPwdView(44)]"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-10-[_oldPwdLabel]"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|[_oldPwdView]|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-10-[_newsPwdLabel]"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|[_newsPwdView]|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-10-[_confirmPwdLabel]"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.view
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|[_confirmPwdView]|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.oldPwdView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-9-[_oldPwdTextField]-3-|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.oldPwdView
   addConstraint:[NSLayoutConstraint constraintWithItem:_oldPwdTextField
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.oldPwdView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
  
  [self.newsPwdView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-9-[_newsPwdTextField]-3-|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.newsPwdView
   addConstraint:[NSLayoutConstraint constraintWithItem:_newsPwdTextField
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.newsPwdView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
  
  [self.confirmPwdView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-9-[_confirmPwdTextField]-3-|"
                   options:0
                   metrics:nil
                   views:self.subViews]];
  
  [self.confirmPwdView
   addConstraint:[NSLayoutConstraint constraintWithItem:_confirmPwdTextField
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.confirmPwdView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
}
- (void)saveNewPassword:(id)sender {
  __weak __typeof(&*self) weakSelf = self;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *userPwd = [defaults objectForKey:@"userPwd"];
  if ([userPwd isEqualToString:self.oldPwdTextField.text]) {
    NSInteger newPwdLength = self.newsPwdTextField.text.length;
    if (newPwdLength <6 || newPwdLength > 20) {
      [self AlertShow:@"密码必须为6-16位字符，区分大小写"];
    }else {
      if ([self.newsPwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
        [AFHttpTool changePassword:self.oldPwdTextField.text newPwd:self.newsPwdTextField.text success:^(id response) {
              if ([response[@"code"] intValue] == 200) {
                [defaults setObject:self.newsPwdTextField.text forKey:@"userPwd"];
                [defaults synchronize];
                [weakSelf.navigationController popViewControllerAnimated:YES];
              }
            }failure:^(NSError *err){
            }];
      } else {
        [self AlertShow:@"填写的确认密码与新密码不一致"];
      }
    }
  } else {
    [self AlertShow:@"原密码填写错误"];
  }
}
- (void)AlertShow:(NSString *)content {
    [SVProgressHUD showInfoWithStatus:content];
}
- (void) clickBackBtn {
  [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldEditChanged:(NSNotification *)obj{
  if (self.oldPwdTextField.text.length > 0 || self.newsPwdTextField.text.length > 0 || self.confirmPwdTextField.text.length > 0) {
  } else {
  }
}
@end
