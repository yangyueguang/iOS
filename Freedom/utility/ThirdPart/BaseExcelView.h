#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeNone=0,//默认
    TableColumnSortTypeAsc,
    TableColumnSortTypeDesc
};
@interface ItemProperty:NSObject
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,assign)CGFloat xwidth;
@property(nonatomic,assign)CGFloat xheight;
@property(nonatomic,assign)CGFloat xstart;
-(instancetype)initWithBgColor:(UIColor*)bgColor textColor:(UIColor*)textColor width:(CGFloat)width height:(CGFloat)height;
+(instancetype)defaultProperty;
@end
@interface BaseExcelCell:UITableViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel     *title;
@property(nonatomic,strong)UILabel     *script;
+(id) getInstance;
+(NSString*)getTableCellIdentifier;
-(void)initUI;
@end
@interface ExcelLeftModel:NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSObject *item;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *subName;
-(instancetype)initWithItem:(NSObject*)item name:(NSString*)name;
-(instancetype)initWithItem:(NSObject*)item name:(NSString*)name subName:(NSString*)subName;;
-(instancetype)initWithItem:(NSObject*)item key:(NSString*)key;
@end
@interface BaseLeftCell:BaseExcelCell
@property(nonatomic,strong)ExcelLeftModel *model;
@property(nonatomic,strong)ItemProperty *proper;
@property(nonatomic,strong)UILabel *indexL;
@end
@interface BaseContentCell:BaseExcelCell
@property(nonatomic,strong)NSObject *value;
@property(nonatomic,strong)ItemProperty *proper;
@property(nonatomic,strong)void(^didSelectBlock)(void);
@end
@interface ExcelTitleModel:NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,assign)BOOL sortable;
@property(nonatomic,assign)TableColumnSortType sortType;
-(ExcelTitleModel*)nextType;
-(instancetype)initWithName:(NSString*)name key:(NSString*)key sortable:(BOOL)sortable sorttype:(TableColumnSortType)sortType;
-(instancetype)initWithName:(NSString*)name key:(NSString*)key sortable:(BOOL)sortable;
+(NSMutableArray<ExcelTitleModel*>*)arrayFromNames:(NSArray*)names keys:(NSArray*)keys sortableBlock:(BOOL(^)(NSInteger index))sortable;
@end
@interface BaseTitleCell:BaseExcelCell
@property(nonatomic,strong)UIButton *sortB;
@property(nonatomic,strong)ExcelTitleModel *model;
@property(nonatomic,strong)ItemProperty *proper;
@property(nonatomic,assign)BOOL shouqi;
@end
@interface BaseExcelHeadView : UITableViewHeaderFooterView
+(id) getInstance;
+(NSString*)getHeadIdentifier;
-(void)initUI;
@end
@class BaseExcelView;
@protocol BaseExcelViewDataSource <NSObject>
@required
- (NSArray<ExcelTitleModel*> *)arrayDataForTopHeaderInTableView:(BaseExcelView *)tableView;
- (NSArray<ExcelLeftModel*> *)arrayDataForLeftHeaderInTableView:(BaseExcelView *)tableView InSection:(NSInteger)section;
- (NSArray *)arrayDataForContentInTableView:(BaseExcelView *)tableView InSection:(NSInteger)section;
@optional
- (NSArray<ExcelTitleModel*> *)arrayDataForSectionHeaderInTableView:(BaseExcelView *)tableView InSection:(NSInteger)section;
///返回label对象的前景色、背景色、宽和高。参数头部标题：section=-1 左边标题 column=-1 分区标题 row=-1
- (ItemProperty*)tableView:(BaseExcelView*)tableView propertyInSection:(NSInteger)section row:(NSInteger)row column:(NSInteger)column;
- (void)tableView:(BaseExcelView*)tableView didSelectSection:(NSInteger)section inRow:(NSInteger)row inColumn:(NSInteger)column item:(NSObject*)mode key:(NSString*)key sortType:(TableColumnSortType)type;
- (void)refresh:(BOOL)refresh loadMorePage:(NSInteger)page completion:(void (^)(void))completion;//需要重写
@end
@interface BaseExcelView : UIScrollView{
    UIScrollView *topHeaderScrollView;
    UIScrollView *contentScrollView;
}
@property (nonatomic, strong) UILabel *excelNameL;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) BOOL leftHeaderEnable;
@property (nonatomic, assign) BOOL hidIndex;
@property (nonatomic, assign) BOOL showSection;
@property (nonatomic, weak) id<BaseExcelViewDataSource> datasource;
@property (nonatomic, assign) BOOL keepTopHead;//是否保持顶部标题不更新
@property (nonatomic, assign) CGPoint scrollOffset;
- (void)reloadData;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *footView;
@end


