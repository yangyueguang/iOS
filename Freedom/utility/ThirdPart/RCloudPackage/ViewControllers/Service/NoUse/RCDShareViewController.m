//
//  RCDShareViewController.m
//  SealTalkShareExtension
//
//  Created by 张改红 on 16/8/4.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDShareViewController.h"
#import "TFHpple.h"

#import <Social/Social.h>
@interface RCDShareChatListController : UITableViewController
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *contentString;
@property (nonatomic,copy)NSString *imageString;
@property (nonatomic,copy)NSString *url;
- (void)enableSendMessage:(BOOL)sender;
@end
@interface RCDShareChatListCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UILabel *nameLabel;
- (void)setDataDic:(NSDictionary *)dataDic;
@end
@interface RCDShareChatListCell()
@property (nonatomic,strong)UIImageView *selectImageView;
@end
@implementation RCDShareChatListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,self.contentView.frame.size.height/2-30/2,30,30)];
    self.headerImageView.layer.cornerRadius = 4;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+5,self.contentView.frame.size.height/2-20/2, 120, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-52, (self.contentView.frame.size.height-10)/2, 13, 10)];
    self.selectImageView.image = [UIImage imageNamed:@"check"];
    [self.contentView addSubview:self.selectImageView];
}
- (void)setDataDic:(NSDictionary *)dataDic{
    if (dataDic) {
        //    NSURL *url = [NSURL URLWithString:dataDic[@"portraitUri"]];
        //    NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image;
        if (1) {//todo
            UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            defaultPortrait.backgroundColor = [UIColor greenColor];
            NSString *firstLetter = [dataDic[@"name"] pinyinFirstLetter];
            UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
            firstCharacterLabel.text = firstLetter;
            firstCharacterLabel.textColor = [UIColor whiteColor];
            firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
            firstCharacterLabel.font = [UIFont systemFontOfSize:50];
            [defaultPortrait addSubview:firstCharacterLabel];
            image = [defaultPortrait imageFromView];
        }
        self.headerImageView.image = image;
        NSString *str =  dataDic[@"name"];
        if (!str) {
            str = dataDic[@"targetId"];
        }
        self.nameLabel.text =str;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectImageView.hidden = NO;
    }else{
        self.selectImageView.hidden = YES;
    }
}
@end
@interface RCDShareChatListController ()
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, strong) NSIndexPath *selectIndexPath;
@property(nonatomic, strong) UIBarButtonItem *rightBarButton;
@end
#define ReuseIdentifier @"cellReuseIdentifier"
#define DemoServer @"http://api.sealtalk.im/" //线上正式环境
//#define DemoServer @"http://api.hitalk.im/" //测试环境
@implementation RCDShareChatListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择";
    self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageTofriend:)];
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    if (self.titleString != nil && self.contentString != nil && self.imageString != nil && self.url!= nil) {
        self.rightBarButton.enabled = YES;
    }else{
        self.rightBarButton.enabled = NO;
    }
    self.tableView.tableFooterView = [UIView new];
    NSURL *groupURL = [[NSFileManager defaultManager]containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [groupURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    self.dataArray = [NSArray arrayWithContentsOfURL:fileURL];
    [self.tableView registerClass:[RCDShareChatListCell class] forCellReuseIdentifier:ReuseIdentifier];
}
- (void)enableSendMessage:(BOOL)sender{
    if (sender && self.selectIndexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rightBarButton.enabled = YES;
        });
    }
}
- (void)sendMessageTofriend:(id)sender {
    NSDictionary *dic = self.dataArray[self.selectIndexPath.row];
    // 1.创建URL
    NSString *urlStr = [NSString stringWithFormat:@"%@misc/send_message", DemoServer];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2.准备请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    NSString *cookie = [userDefaults valueForKey:@"Cookie"];
    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    request.HTTPShouldHandleCookies = YES;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 3.准备参数
    NSString *objectName = @"RC:ImgTextMsg";
    NSDictionary *messageContentDict = @{@"title" :self.titleString,@"content" : self.contentString,@"imageUri" : self.imageString,@"url" : self.url,};
    NSString *conversationType = nil;
    if ([dic[@"conversationType"] intValue] == 1) {
        conversationType = @"PRIVATE";
    }else{
        conversationType = @"GROUP";
    }
    NSDictionary *sendMessageDict = @{@"conversationType" : conversationType,@"targetId" : dic[@"targetId"],@"objectName" : objectName,@"content" : messageContentDict};
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000];
    NSDictionary *insertMessageDict = @{
                                        @"conversationType" :dic[@"conversationType"],
                                        @"targetId" : dic[@"targetId"],
                                        @"title" : self.titleString,
                                        @"content" :self.contentString,
                                        @"imageURL" :self.imageString,
                                        @"url" : self.url,
                                        @"objectName" : @"RC:ImgTextMsg",
                                        @"sharedTime" :time
                                        };
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:sendMessageDict options:0 error:nil]];
    [request setTimeoutInterval:10.0];
    self.rightBarButton.title = @"发送中";
    self.rightBarButton.enabled = NO;
    // 4.建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError) {
         NSString *notify = nil;
         if (!connectionError) {
             NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
             NSMutableArray *array = [NSMutableArray arrayWithArray:[shareUserDefaults valueForKey:@"sharedMessages"]];
             [array addObject:insertMessageDict];
             [shareUserDefaults setValue:array forKey:@"sharedMessages"];
             [shareUserDefaults synchronize];
             notify = @"发送成功";
         }else{
             notify = @"发送失败";
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:notify preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:alertController animated:YES completion:nil];
             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(creatAlert:) userInfo:alertController repeats:NO];
         });
     }];
}
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDShareChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[RCDShareChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell setDataDic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDShareChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    self.selectIndexPath = indexPath;
    if (self.titleString != nil && self.contentString != nil && self.imageString != nil && self.url!= nil) {
        self.rightBarButton.enabled = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
@end
@interface RCDShareViewController ()
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *contentString;
@property (nonatomic,copy)NSString *imageString;
@property (nonatomic,copy)NSString *url;
@end
@implementation RCDShareViewController
- (void)viewDidLoad{
  [super viewDidLoad];
  self.title = @"SealTalk";
}
- (BOOL)isContentValid {
//  NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
//  if(!imageItem) {
//    return NO;
//  }
//  NSItemProvider *imageItemProvider = [[imageItem attachments] firstObject];
//  if(!imageItemProvider) {
//    return NO;
//  }
//  if([imageItemProvider hasItemConformingToTypeIdentifier:@"public.url"] && self.contentText.length > 0) {
//    return YES;
//  }
  return NO;
}
- (void)didSelectPost {
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}
- (NSArray *)configurationItems {
  SLComposeSheetConfigurationItem *item = [[SLComposeSheetConfigurationItem alloc] init];
  item.title = @"分享给朋友";
  __weak typeof(self) weakSelf = self;
  item.tapHandler = ^{
    RCDShareChatListController *tableView = [[RCDShareChatListController alloc] init];
    NSExtensionItem *imageItem = self.extensionContext.inputItems.firstObject;
    for (NSItemProvider *imageItemProvider in imageItem.attachments) {
      if ([imageItemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
        [imageItemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL *url, NSError *error) {
           __strong typeof(weakSelf) strongSelf = weakSelf;
           strongSelf.url = url.absoluteString;
           NSData *data = [NSData dataWithContentsOfURL:url];
           TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
           if (strongSelf.contentText.length > 0) {
             strongSelf.titleString = strongSelf.contentText;
           } else {
             NSArray *titleElements = [xpathParser searchWithXPathQuery:@"//title"];
             if (titleElements.count > 0) {
               TFHppleElement *element = [titleElements objectAtIndex:0];
               strongSelf.titleString = element.content;
             }
           }
           NSArray *contentElements = [xpathParser searchWithXPathQuery:@"//meta"];
           if (contentElements.count > 0) {
             for (TFHppleElement *element in contentElements) {
               if ([[element objectForKey:@"name"] isEqualToString:@"description"]) {
                 strongSelf.contentString = [element objectForKey:@"content"];
                 break;
               } else {
                 strongSelf.contentString = url.absoluteString;
               }
             }
           } else {
             strongSelf.contentString = url.absoluteString;
           }
           NSArray *imageElements = [xpathParser searchWithXPathQuery:@"//img"];
           if (imageElements && contentElements.count > 0) {
             for (TFHppleElement *element in imageElements) {
               NSString *string = [element objectForKey:@"src"];
               if ([string containsString:@"http"]) {
                 strongSelf.imageString = string;
                 break;
               }
             }
           }
           if (!strongSelf.imageString) {
             strongSelf.imageString = @"";
           }
           tableView.titleString = strongSelf.titleString;
           tableView.contentString = strongSelf.contentString;
           tableView.url = strongSelf.url;
           tableView.imageString = strongSelf.imageString;
           [tableView enableSendMessage:YES];
         }];
        break;
      }
    }
    [weakSelf pushConfigurationViewController:tableView];
  };
  return @[ item ];
}
@end
