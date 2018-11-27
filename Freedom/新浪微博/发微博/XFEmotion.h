//  XFEmotion.h
//  
//  Created by Fay on 15/10/18.
//
#import <Foundation/Foundation.h>
typedef enum {
    XFComposeToolbarButtonTypeCamera, // 拍照
    XFComposeToolbarButtonTypePicture, // 相册
    XFComposeToolbarButtonTypeMention, // @
    XFComposeToolbarButtonTypeTrend, // 
#
    XFComposeToolbarButtonTypeEmotion // 表情
} XFComposeToolbarButtonType;
typedef enum {
    XFEmotionTabBarButtonTypeRecent, // 最近
    XFEmotionTabBarButtonTypeDefault, // 默认
    XFEmotionTabBarButtonTypeEmoji, // emoji
    XFEmotionTabBarButtonTypeLxh, // 浪小花
    
} XFEmotionTabBarButtonType;
@interface XFEmotionKeyboard : UIView
@end
@interface XFComposePhotosView : UIView
-(void)addPhoto:(UIImage *)photo;
@property (nonatomic, strong,readonly) NSMutableArray *photos;
@end
@interface XFTextView : UITextView
/** 占位文字 */
@property (nonatomic,copy)NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic,strong)UIColor *placeholderColor;
@end
@class XFEmotion;
@interface XFEmotionTextView : XFTextView
-(void)insertEmotion:(XFEmotion *)emotion;
- (NSString *)fullText;
@end
@class XFEmotion;
@interface XFEmotionAttachment : NSTextAttachment
@property (nonatomic, strong) XFEmotion *emotion;
@end
@class XFComposeToolbar;
@protocol XFComposeToolbarDelegate <NSObject>
@optional
-(void)composeToolbar:(XFComposeToolbar *)toolbar didClickButton:(XFComposeToolbarButtonType)buttonType;
@end
@interface XFComposeToolbar : UIView
@property (nonatomic,weak) id<XFComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
@interface XFEmotion : NSObject
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
