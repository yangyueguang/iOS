//
//  BookFriendsMode.h
//  Freedom
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*弹出视图*/
@interface WFHudView : UIView<CAAnimationDelegate>{
    UIFont *msgFont;
}
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, retain) UILabel  *labelText;
@property (nonatomic, assign) float leftMargin;
@property (nonatomic, assign) float topMargin;
@property (nonatomic, assign) float animationLeftScale;
@property (nonatomic, assign) float animationTopScale;
@property (nonatomic, assign) float totalDuration;
+(void)showMsg:(NSString *)msg inView:(UIView*)theView;
@end
@interface WFTextView : UIView
@property (nonatomic,strong) NSAttributedString *attrEmotionString;
@property (nonatomic,strong) NSArray *emotionNames;
@property (nonatomic,assign) BOOL isDraw;
@property (nonatomic,assign) BOOL isFold;//是否折叠
@property (nonatomic,strong) NSMutableArray *attributedData;
@property (nonatomic,assign) int textLine;
@property (nonatomic,strong) void (^didClickCoreText)(NSString *clickString,NSInteger index,BOOL isLong);
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@property (nonatomic,assign) BOOL canClickAll;//是否可点击整段文字
@property (nonatomic,assign) NSInteger replyIndex;
@property (nonatomic,strong) UIColor *textColor;
- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;
- (int)getTextLines;
- (float)getTextHeight;
@end
@interface WFMessageBody : NSObject
/*用户头像url 此处直接用图片名代替*/
@property (nonatomic,copy) NSString *posterImgstr;//
/*用户名*/
@property (nonatomic,copy) NSString *posterName;
/*用户简介*/
@property (nonatomic,copy) NSString *posterIntro;//
/*用户说说内容*/
@property (nonatomic,copy) NSString *posterContent;//
/*用户发送的图片数组*/
@property (nonatomic,strong) NSArray *posterPostImage;//
/*用户收到的赞 (该数组存点赞的人的昵称)*/
@property (nonatomic,strong) NSMutableArray *posterFavour;
/*用户说说的评论数组*/
@property (nonatomic,strong) NSMutableArray *posterReplies;//
/*admin是否赞过*/
@property (nonatomic,assign) BOOL isFavour;
@end
@interface WFReplyBody : NSObject
/*评论者*/
@property (nonatomic,copy) NSString *replyUser;
/*回复该评论者的人*/
@property (nonatomic,copy) NSString *repliedUser;
/*回复内容*/
@property (nonatomic,copy) NSString *replyInfo;
@end
@interface YMTextData : NSObject
@property (nonatomic,strong) WFMessageBody  *messageBody;
@property (nonatomic,strong) NSMutableArray *replyDataSource;//回复内容数据源（未处理）
@property (nonatomic,assign) float           replyHeight;//回复高度
@property (nonatomic,assign) float           shuoshuoHeight;//折叠说说高度
@property (nonatomic,assign) float           unFoldShuoHeight;//展开说说高度
@property (nonatomic,assign) float           favourHeight;//点赞的高度
@property (nonatomic,assign) float           showImageHeight;//展示图片的高度
@property (nonatomic,strong) NSMutableArray *completionReplySource;//回复内容数据源（处理）
@property (nonatomic,strong) NSMutableArray *attributedDataReply;//回复部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataShuoshuo;//说说部分附带的点击区域数组
@property (nonatomic,strong) NSMutableArray *attributedDataFavour;//点赞部分附带的点击区域数组
@property (nonatomic,strong) NSArray        *showImageArray;//图片数组
@property (nonatomic,strong) NSMutableArray *favourArray;//点赞昵称数组
@property (nonatomic,strong) NSMutableArray *defineAttrData;//自行添加 元素为每条回复中的自行添加的range组成的数组 如：第一条回复有（0，2）和（5，2） 第二条为（0，2）。。。。
@property (nonatomic,assign) BOOL hasFavour;//是否赞过
@property (nonatomic,assign) BOOL foldOrNot;//是否折叠
@property (nonatomic,copy) NSString *showShuoShuo;//说说部分
@property (nonatomic,copy) NSString       *completionShuoshuo;//说说部分（处理后）
@property (nonatomic,copy) NSString *showFavour;//点赞部分
@property (nonatomic,copy) NSString       *completionFavour;//点赞部分(处理后)
@property (nonatomic,assign) BOOL            islessLimit;//是否小于最低限制 宏定义最低限制是 limitline
/*计算高度  @return 返回高度*/
- (float) calculateReplyHeightWithWidth:(float)sizeWidth;
/*计算折叠还是展开的说说的高度 高度*/
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold;
/*点赞区域高度@return 高度*/
- (float)calculateFavourHeightWithWidth:(float)sizeWidth;
//- (id)initWithMessage:(WFMessageBody *)messageBody;
+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;
@end
