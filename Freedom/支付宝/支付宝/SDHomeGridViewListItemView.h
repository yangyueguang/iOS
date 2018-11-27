//  SDHomeGridViewListItemView.h
//  GSD_ZHIFUBAO
//  Created by Super on 15-6-3.
@interface SDHomeGridItemModel : NSObject
@property (nonatomic, copy) NSString *imageResString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Class destinationClass;
@end
@interface SDHomeGridViewListItemView : UIView
@property (nonatomic, strong) SDHomeGridItemModel *itemModel;
@property (nonatomic, assign) BOOL hidenIcon;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) void (^itemLongPressedOperationBlock)(UILongPressGestureRecognizer *longPressed);
@property (nonatomic, copy) void (^buttonClickedOperationBlock)(SDHomeGridViewListItemView *item);
@property (nonatomic, copy) void (^iconViewClickedOperationBlock)(SDHomeGridViewListItemView *view);
@end
