//  E_CursorView.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
/*光标类*/
typedef enum {
    CursorLeft = 0,
    CursorRight ,
    
} CursorType;
@interface E_CursorView : UIView{
    UIImageView *_dragDot;
}
@property (nonatomic,assign) CursorType direction;
@property (nonatomic,assign) float cursorHeight;
@property (nonatomic,retain) UIColor *cursorColor;
@property (nonatomic,assign) CGPoint setupPoint;
- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor;
@end
