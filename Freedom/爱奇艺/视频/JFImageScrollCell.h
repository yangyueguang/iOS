//  JFImageScrollCell.h
//  Freedom
//  Created by Freedom on 15/8/22.
#import <UIKit/UIKit.h>
//  JFImageScrollView.h
//  Freedom
//  Created by Freedom on 15/8/22.
#import <UIKit/UIKit.h>
@protocol JFImageScrollViewDelegate <NSObject>
@optional
-(void)didSelectImageAtIndex:(NSInteger)index;
@end
@interface JFImageScrollView : UIView
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSArray *imgArray;
@property(nonatomic, weak) id <JFImageScrollViewDelegate>delegate;
-(void)setImageArray:(NSArray *)imageArray;
/*创建一个ScrollView
 *
 *  @param frame      供外界提供一个frame
 *  @param imageArray 供外界提供一个图片数组
 *
 *  @return 返回一个自定义的ScrollView*/
-(JFImageScrollView * )initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;
@end
@interface JFImageScrollCell : UITableViewCell
@property (nonatomic, strong)JFImageScrollView *imageScrollView;
@property(nonatomic, strong) NSArray *imageArr;
-(void)setImageArray:(NSArray *)imageArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView frame:(CGRect)frame;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
@end
