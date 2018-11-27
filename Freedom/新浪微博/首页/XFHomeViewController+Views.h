//  XFHomeViewController+Views.h
//  Freedom
//  Created by Super on 2017/11/3.
//  Copyright © 2017年 Super. All rights reserved.
#import "XFHomeViewController.h"
// 昵称字体
#define XFStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define XFStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define XFStatusCellSourceFont XFStatusCellTimeFont
// 正文字体
#define XFStatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define XFStatusCellRetweetContentFont [UIFont systemFontOfSize:13]
#define XFStatusPhotoWH 70
#define XFStatusPhotoMargin 10
#define XFStatusPhotoMaxCol(count) ((count==4)?2:3)
#define XFStatusCellBorderW 10
#define XFStatusCellBorderH 5
typedef enum {
    XFUserVerifiedTypeNone = -1, // 没有任何认证
    XFUserVerifiedPersonal = 0,  // 个人认证
    XFUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    XFUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    XFUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    XFUserVerifiedDaren = 220 // 微博达人
} XFUserVerifiedType;
@interface XFTitleButton : UIButton
@end
@interface XFUser : NSObject
/**    string    字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;
/**    string    友好显示名称*/
@property (nonatomic, copy) NSString *name;
/**    string    用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;
/** 认证类型 */
@property (nonatomic, assign) XFUserVerifiedType verified_type;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
@interface XFStatus : NSObject
/**    string    字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;
/**    string    微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**    object    微博作者的用户信息字段 详细*/
@property (nonatomic, strong) XFUser *user;
/**    string    微博创建时间*/
@property (nonatomic, copy) NSString *created_at;
/**    string    微博来源*/
@property (nonatomic, copy) NSString *source;
/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;
/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) XFStatus *retweeted_status;
/**    int    转发数*/
@property (nonatomic, assign) int reposts_count;
/**    int    评论数*/
@property (nonatomic, assign) int comments_count;
/**    int    表态数*/
@property (nonatomic, assign) int attitudes_count;
@end
@interface XFLoadMoreFooter : UIView
@end
@class XFDropdownView;
@protocol XFDropdownViewDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(XFDropdownView *)menu;
- (void)dropdownMenuDidShow:(XFDropdownView *)menu;
@end
@interface XFDropdownView : UIView
+(instancetype)menu;
// 显示
- (void)showFrom:(UIView *)from;
//销毁
- (void)dismiss;
// 内容
@property (nonatomic, strong) UIView *content;
// 内容控制器
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic,weak) id <XFDropdownViewDelegate> delegate;
@end
@interface XFStatusFrame : NSObject
@property (nonatomic, strong) XFStatus *status;
/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;
/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
@interface XFStatusViewCell : UITableViewCell
@property (nonatomic,strong) XFStatusFrame *statusFrame;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
@interface XFHomeViewController (Views)
@end
