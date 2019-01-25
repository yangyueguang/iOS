//
//  BookSubViews.h
//  Freedom
//
//  Created by Super on 2018/4/27.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "BookSubViews.h"
#import "BookReadMode.h"
/*光标类*/
typedef enum {
    CursorLeft = 0,
    CursorRight ,
    
} CursorType;
//  ILSlider.h
//  ILSlider
//  Created by Super on 14-10-17.
#import <UIKit/UIKit.h>
typedef void(^TouchStateEnd) (CGFloat);
typedef void(^TouchStateChanged) (CGFloat);
typedef enum {
    ILSliderDirectionHorizonal  =   0,
    ILSliderDirectionVertical   =   1
} ILSliderDirection;
@interface ILSlider : UIControl
@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat ratioNum;//滑动的比值
@property (nonatomic, assign) ILSliderDirection direction;//方向
@property (nonatomic, copy) TouchStateChanged StateChanged;
@property (nonatomic, copy) TouchStateEnd StateEnd;
- (id)initWithFrame:(CGRect)frame direction:(ILSliderDirection)direction;
- (void)sliderChangeBlock:(TouchStateChanged)didChangeBlock;
- (void)sliderTouchEndBlock:(TouchStateEnd)touchEndBlock;
@end
//  E_SettingBar.h
//  Freedom
//  Created by Super on 15/2/13.
#import <UIKit/UIKit.h>
/*顶部设置条*/
@protocol E_SettingTopBarDelegate <NSObject>
- (void)goBack;//退出
- (void)showMultifunctionButton;
@end
@interface E_SettingTopBar : UIView
@property(nonatomic,assign)id<E_SettingTopBarDelegate>delegate;
- (void)showToolBar;
- (void)hideToolBar;
@end
//  E_SettingBottomBar.h
//  Freedom
//  Created by Super on 15/2/13.
#import <UIKit/UIKit.h>
/*底部设置条*/
@protocol E_SettingBottomBarDelegate <NSObject>
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)fontSizeChanged:(int)fontSize;//改变字号
- (void)callDrawerView;//侧边栏
- (void)turnToNextChapter;//下一章
- (void)turnToPreChapter;//上一章
- (void)sliderToChapterPage:(NSInteger)chapterIndex;
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
- (void)callCommentView;
@end
@interface E_SettingBottomBar : UIView
@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,assign) id<E_SettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;
- (void)changeSliderRatioNum:(float)percentNum;
- (void)showToolBar;
- (void)hideToolBar;
@end
@interface E_CursorView : UIView{
    UIImageView *_dragDot;
}
@property (nonatomic,assign) CursorType direction;
@property (nonatomic,assign) float cursorHeight;
@property (nonatomic,retain) UIColor *cursorColor;
@property (nonatomic,assign) CGPoint setupPoint;
- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor;
@end
@protocol E_DrawerViewDelegate <NSObject>
- (void)openTapGes;
- (void)turnToClickChapter:(NSInteger)chapterIndex;
- (void)turnToClickMark:(E_Mark *)eMark;
@end
@protocol E_ListViewDelegate <NSObject>
- (void)clickMark:(E_Mark *)eMark;
- (void)clickChapter:(NSInteger)chaperIndex;
- (void)removeE_ListView;
@end
@interface E_ListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    UISegmentedControl *_segmentControl;
    NSInteger dataCount;
    NSMutableArray *_dataSource;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    BOOL    _isNote;
}
@property (nonatomic,assign)id<E_ListViewDelegate>delegate;
@property (nonatomic,strong)UITableView *listView;
@end
@interface E_DrawerView : UIView<UIGestureRecognizerDelegate,E_ListViewDelegate>{
    
    E_ListView *_listView;
}
@property(nonatomic, strong) UIView *parent;
@property(nonatomic, assign) id<E_DrawerViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p;
@end
@interface E_HUDView : UIView<CAAnimationDelegate>{
    UIFont *msgFont;
}
@property (nonatomic, copy)   NSString *msg;
@property (nonatomic, retain) UILabel  *labelText;
@property (nonatomic, assign) float leftMargin;
@property (nonatomic, assign) float topMargin;
@property (nonatomic, assign) float animationLeftScale;
@property (nonatomic, assign) float animationTopScale;
@property (nonatomic, assign) float totalDuration;
+ (void)showMsg:(NSString *)msg inView:(UIView*)theView;
@end
/*放大镜类*/
@interface E_MagnifiterView : UIView
@property (weak, nonatomic) UIView *viewToMagnify;
@property (nonatomic) CGPoint touchPoint;
@end
/*显示文本类*/
@protocol E_ReaderViewDelegate <NSObject>
- (void)shutOffGesture:(BOOL)yesOrNo;
- (void)hideSettingToolBar;
- (void)ciBa:(NSString *)ciBasString;
@end
@interface E_ReaderView : UIView
@property(unsafe_unretained, nonatomic)NSUInteger font;
@property(copy, nonatomic)NSString *text;
@property (strong, nonatomic) E_CursorView *leftCursor;
@property (strong, nonatomic) E_CursorView *rightCursor;
@property (strong, nonatomic) E_MagnifiterView *magnifierView;
@property (assign, nonatomic) id<E_ReaderViewDelegate>delegate;
@property (strong, nonatomic) UIImage  *magnifiterImage;
@property (copy  , nonatomic) NSString *keyWord;
- (void)render;
@end
//  E_SearchTableViewCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
//  E_MarkTableViewCell.h
//  Freedom
//  Created by Super on 15/3/2.
#import <UIKit/UIKit.h>
@interface E_MarkTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *chapterLbl;
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UILabel *contentLbl;
@end
@interface E_SearchTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *chapterLbl;
@property (nonatomic,strong) UILabel *contentLbl;
@end
@interface BookSubViews : UIView
@end
