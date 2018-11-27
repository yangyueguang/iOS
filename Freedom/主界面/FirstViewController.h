//  ViewController.h
//  Freedom
//  Created by Freedomon 14.03.14.
#import <UIKit/UIKit.h>
@interface XCollectionViewDialLayout : UICollectionViewLayout
typedef enum {
    WHEELALIGNMENTLEFT,
    WHEELALIGNMENTCENTER
}WheelAlignmentType;
@property (readwrite, nonatomic, assign) int cellCount;
@property (readwrite, nonatomic, assign) int wheelType;
@property (readwrite, nonatomic, assign) CGPoint center;
@property (readwrite, nonatomic, assign) CGFloat offset;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat xOffset;
@property (readwrite, nonatomic, assign) CGSize cellSize;
@property (readwrite, nonatomic, assign) CGFloat AngularSpacing;
@property (readwrite, nonatomic, assign) CGFloat dialRadius;
@property (readonly, nonatomic, strong) NSIndexPath *currentIndexPath;
-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andAlignment:(WheelAlignmentType)alignment andItemHeight:(CGFloat)height andXOffset: (CGFloat) xOffset;
@end
@interface FirstViewController : BaseViewController
+ (FirstViewController *) sharedViewController;
@end
