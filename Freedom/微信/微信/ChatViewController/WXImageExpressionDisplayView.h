//  WXImageExpressionDisplayView.h
//  Freedom
//  Created by Super on 16/3/16.
#import <UIKit/UIKit.h>
#import "TLEmojiKeyboard.h"
@interface WXImageExpressionDisplayView : UIView
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, assign) CGRect rect;
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect;
@end
