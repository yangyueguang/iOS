#import "BaseExcelView.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#define Color6 [UIColor colorWithWhite:0.25 alpha:1]
#define Color9 [UIColor colorWithWhite:0.375 alpha:1]
#define WS(weakSelf)    __weak __typeof(self)weakSelf = self;
@interface UIControl (expanded)
typedef void (^ActionBlock)(id sender);
- (void)removeAllTargets;
- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents;
- (void)callActionHandler;
@end
static char UIButtonHandlerKey;
@implementation UIControl (expanded)
- (void)removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}
- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents{
    objc_setAssociatedObject(self, &UIButtonHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionHandler) forControlEvents:controlEvents];
}
- (void)callActionHandler{
    ActionBlock handler = (ActionBlock)objc_getAssociatedObject(self, &UIButtonHandlerKey);
    if (handler) {
        handler(self);
    }
}
@end


@interface SortItem:NSObject
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,assign)NSInteger column;
@property(nonatomic,assign)TableColumnSortType sortType;
@property(nonatomic,strong)NSString *key;
-(void)changeSortWithSection:(NSInteger)section column:(NSInteger)column sortType:(TableColumnSortType)sortType;
@end
@implementation SortItem
-(void)changeSortWithSection:(NSInteger)section column:(NSInteger)column sortType:(TableColumnSortType)sortType{
    self.section = section;
    self.column = column;
    self.sortType = sortType;
}
@end
@implementation ItemProperty
-(instancetype)initWithBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor width:(CGFloat)width height:(CGFloat)height{
    self = [super init];
    self.bgColor = bgColor;
    self.textColor = textColor;
    self.xwidth = width;
    self.xheight = height;
    return self;
}
+(instancetype)defaultProperty{
    ItemProperty *property = [[ItemProperty alloc]initWithBgColor:[UIColor clearColor] textColor:[UIColor grayColor] width:100 height:50];
    return property;
}
-(UIColor *)bgColor{
    if(!_bgColor)return [UIColor clearColor];
    return _bgColor;
}
-(UIColor *)textColor{
    if(!_textColor)return [UIColor colorWithWhite:0.6 alpha:1];
    return _textColor;
}
@end
@implementation BaseExcelCell
+(id) getInstance {
    BaseExcelCell *instance = nil;
    @try {
        NSString *nibFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib",NSStringFromClass(self)]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:nibFilePath]) {
            id o = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            if ([o isKindOfClass:self]) {
                instance = o;
            } else {
                instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
            }
        } else {
            instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
        }
    }
    @catch (NSException *exception) {
        instance = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getTableCellIdentifier]];
    }
    return instance;
}
+(NSString*) getTableCellIdentifier {
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(id)init {
    self = [super init];
    if (self) {
        [self loadBaseTableCellSubviews];
    }return self;
}
-(void)loadBaseTableCellSubviews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initUI];
    if (self.contentView) {
        [self setUserInteractionEnabled:YES];
        [self.contentView setUserInteractionEnabled:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}
-(void)initUI{
//    NSLog(@"请子类重写这个方法");
}
-(void)prepareForReuse {
    [super prepareForReuse];
}
@end
@implementation ExcelLeftModel
-(instancetype)initWithItem:(NSObject *)item name:(NSString *)name{
    return [self initWithItem:item name:name subName:nil];
}
-(instancetype)initWithItem:(NSObject *)item name:(NSString *)name subName:(NSString *)subName{
    self = [super init];
    self.item = item;
    self.name = name;
    self.subName = subName;
    return self;
}
-(instancetype)initWithItem:(NSObject *)item key:(NSString *)key{
    self = [super init];
    self.item = item;
    self.key =  key;
    self.name = [item valueForKeyPath:key];
    return self;
}
@end
@implementation BaseLeftCell
-(void)initUI{
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.title =  [[UILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:13];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = [UIFont systemFontOfSize:11];
    self.script.textAlignment = NSTextAlignmentCenter;
    self.script.textColor = Color6;
    self.indexL = [[UILabel alloc]init];
    self.indexL.layer.borderWidth = 0.5;
    self.indexL.layer.borderColor = Color9.CGColor;
    self.indexL.layer.masksToBounds = YES;
    self.indexL.layer.cornerRadius = 3;
    self.indexL.layer.shouldRasterize = YES;
    self.indexL.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.indexL.textAlignment = NSTextAlignmentCenter;
    self.indexL.font = [UIFont systemFontOfSize:13];
    self.indexL.textColor = Color9;
//    self.script.clipsToBounds = YES;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.script];
    [self.contentView addSubview:self.indexL];
    WS(weakSelf);
    
    [self.indexL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@25);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_offset(0);
        make.left.mas_equalTo(weakSelf.indexL.mas_right);
        make.bottom.mas_equalTo(weakSelf.script.mas_top);
    }];
    [self.script mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_offset(0);
        make.left.mas_equalTo(weakSelf.indexL.mas_right);
        make.height.mas_equalTo(@0);
    }];
}
-(void)setModel:(ExcelLeftModel *)model{
    _model = model;
    self.title.text = model.name;
    if(model.subName){
        self.script.text = model.subName;
    }
    [self.script mas_updateConstraints:^(MASConstraintMaker *make) {
        if(model.subName){
            make.height.mas_equalTo(@15);
            make.bottom.mas_offset(-5);
        }else{
            make.height.mas_equalTo(@0);
            make.bottom.mas_offset(0);
        }
    }];
}
-(void)setProper:(ItemProperty *)proper{
    _proper = proper;
    self.backgroundColor = proper.bgColor;
    self.title.textColor = proper.textColor;
}
@end
@implementation BaseContentCell
-(void)initUI{
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.title =  [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 100, 100-6)];
    self.title.font = [UIFont systemFontOfSize:13];
    self.title.adjustsFontSizeToFitWidth = YES;
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.numberOfLines = 0;
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellDidSelct)]];
}
-(void)cellDidSelct{
    if(self.didSelectBlock){
        self.didSelectBlock();
    }else{
        self.userInteractionEnabled = NO;
    }
}
-(void)setValue:(NSObject *)value{
    _value = value;
    if([value isKindOfClass:[NSDate class]]){
        NSDate *date = (NSDate*)value;
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-DD"];
        self.title.text = [format stringFromDate:date];
    }else if([value isKindOfClass:[NSNumber class]]){
        if(sizeof(value)>4){//float
            NSNumber *num = (NSNumber*)value;
            NSDecimalNumber *decemal = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",[num doubleValue]]];
            self.title.text = [decemal stringValue];
        }else{
            NSNumber *num = (NSNumber*)value;
            self.title.text = num.stringValue;
        }
    }else{
        self.title.text = [NSString stringWithFormat:@"%@",value];
    }
}
-(void)setProper:(ItemProperty *)proper{
    _proper = proper;
    self.frame = CGRectMake(proper.xstart, 0, proper.xwidth, proper.xheight);
    self.backgroundColor = proper.bgColor;
    self.title.textColor = proper.textColor;
}
-(void)prepareForReuse{
    [super prepareForReuse];
//    self.title.text = nil;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
@end
@implementation ExcelTitleModel
-(instancetype)initWithName:(NSString *)name key:(NSString *)key sortable:(BOOL)sortable sorttype:(TableColumnSortType)sortType{
    self = [self initWithName:name key:key sortable:sortable];
    self.sortType = sortType;
    return self;
}
-(ExcelTitleModel*)nextType{
    if(self.sortType==TableColumnSortTypeNone){
        self.sortType = TableColumnSortTypeAsc;
    }else if(self.sortType==TableColumnSortTypeAsc){
        self.sortType = TableColumnSortTypeDesc;
    }else{
        self.sortType = TableColumnSortTypeNone;
    }
    return self;
}
-(instancetype)initWithName:(NSString *)name key:(NSString *)key sortable:(BOOL)sortable{
    self = [super init];
    self.name = name;
    self.key = key;
    self.sortable = sortable;
    self.sortType = TableColumnSortTypeNone;
    return self;
}
+(NSMutableArray<ExcelTitleModel *> *)arrayFromNames:(NSArray *)names keys:(NSArray *)keys sortableBlock:(BOOL (^)(NSInteger))sortable{
    NSMutableArray *modes = [NSMutableArray array];
    for(int i=0;i<names.count;i++){
        ExcelTitleModel *mode = [[ExcelTitleModel alloc]initWithName:names[i] key:keys[i] sortable:sortable(i)];
        [modes addObject:mode];
    }
    return modes;
}
@end
@implementation BaseTitleCell
-(void)initUI{
    self.clipsToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.sortB = [[UIButton alloc]init];
    _sortB.titleLabel.font = [UIFont systemFontOfSize:12];
    _sortB.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_sortB setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
    _sortB.titleLabel.numberOfLines = 0;
    _sortB.clipsToBounds = YES;
    [self.contentView addSubview:_sortB];
    [self.sortB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)setShouqi:(BOOL)shouqi{
    _shouqi = shouqi;
}
-(void)setModel:(ExcelTitleModel *)model{
    _model = model;
    [_sortB setTitle:model.name forState:UIControlStateNormal];
    if(self.shouqi){
        [_sortB setImage:[UIImage imageNamed:@"下灰"] forState:UIControlStateSelected];
        [_sortB setImage:[UIImage imageNamed:@"上灰"] forState:UIControlStateNormal];
        [_sortB setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortB.imageView.bounds.size.width-2, 0, _sortB.imageView.bounds.size.width+2)];
        [_sortB setImageEdgeInsets:UIEdgeInsetsMake(0, _sortB.titleLabel.bounds.size.width+2, 0, -_sortB.titleLabel.bounds.size.width-2)];
        return;
    }
    if(!model.sortable){
        [_sortB setImage:nil forState:UIControlStateNormal];
        [_sortB setImage:nil forState:UIControlStateSelected];
        [_sortB setTitleEdgeInsets:UIEdgeInsetsZero];
        return;
    }
    if(model.sortType==TableColumnSortTypeAsc){
        [_sortB setImage:[UIImage imageNamed:@"sort2"] forState:UIControlStateNormal];
    }else if(model.sortType==TableColumnSortTypeDesc){
        [_sortB setImage:[UIImage imageNamed:@"sort1"] forState:UIControlStateNormal];
    }else{
        [_sortB setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    }
    [_sortB setTitleEdgeInsets:UIEdgeInsetsMake(0, -_sortB.imageView.bounds.size.width-2, 0, _sortB.imageView.bounds.size.width+2)];
    [_sortB setImageEdgeInsets:UIEdgeInsetsMake(0, _sortB.titleLabel.bounds.size.width+2, 0, -_sortB.titleLabel.bounds.size.width-2)];
}
-(void)setProper:(ItemProperty *)proper{
    _proper = proper;
    [self.sortB setTitleColor:proper.textColor forState:UIControlStateNormal];
//    [_sortB setTitleColor:proper.textColor forState:UIControlStateNormal];
    self.frame = CGRectMake(proper.xstart, 0, proper.xwidth, proper.xheight);
    self.backgroundColor = proper.bgColor;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    for (id target in [self.sortB allTargets]) {
        [self.sortB removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}
@end
@implementation BaseExcelHeadView
+(id)getInstance{
    BaseExcelHeadView *instance = nil;
    instance = [[self alloc]initWithReuseIdentifier:[self getHeadIdentifier]];
    [instance initUI];
    return instance;
}
+(NSString *)getHeadIdentifier{
    return [[NSString alloc] initWithFormat:@"%@Identifier",NSStringFromClass(self)];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
}
@end
///FIXME:正式的excel
@interface BaseExcelView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
    NSMutableDictionary *sectionFoldedStatus;
    NSArray *columnPointCollection;
    NSMutableArray *leftHeaderDataArray;
    NSMutableArray *sectionDataArray;
    NSMutableArray *contentDataArray;
    BOOL responseNumberofContentColumns;
    BOOL responseItemProperty;
    BOOL responseSectionArray;
    CGFloat _boldSeperatorLineWidth;
    CGFloat _topHeaderHeight;
    CGFloat _leftHeaderWidth;
    UIView *_emptyView;
    NSString *excelContentCellIdentifier;
}
@property(nonatomic,strong)UITableView *leftHeaderTableView;
@property(nonatomic,strong)UITableView *contentTableView;
@property(nonatomic,strong)SortItem *sortItem;
- (void)reset;
- (void)adjustView;
- (void)setUpTopHeaderScrollView;
- (void)buildSectionFoledStatus:(NSInteger)section;
@end

@implementation BaseExcelView
@synthesize datasource;
-(void)privateRefresh{
    [self.mj_footer endRefreshing];
    [self.leftHeaderTableView.mj_footer endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
    if([datasource respondsToSelector:@selector(refresh:loadMorePage:completion:)]){
        WS(weakSelf);
        self.page = 0;
        [datasource refresh:YES loadMorePage:self.page completion:^{
            [weakSelf.mj_header endRefreshing];
            [weakSelf.leftHeaderTableView.mj_header endRefreshing];
            [weakSelf.contentTableView.mj_header endRefreshing];
        }];
    }else{
        [self.mj_header endRefreshing];
        [self.leftHeaderTableView.mj_header endRefreshing];
        [self.contentTableView.mj_header endRefreshing];
    }
}
-(void)privateLoadMore{
    [self.mj_header endRefreshing];
    [self.leftHeaderTableView.mj_header endRefreshing];
    [self.contentTableView.mj_header endRefreshing];
    if([datasource respondsToSelector:@selector(refresh:loadMorePage:completion:)]){
        WS(weakSelf);
        [datasource refresh:NO loadMorePage:++self.page completion:^{
            [weakSelf.mj_footer endRefreshing];
            [weakSelf.leftHeaderTableView.mj_footer endRefreshing];
            [weakSelf.contentTableView.mj_footer endRefreshing];
        }];
    }else{
        [self.mj_footer endRefreshing];
        [self.leftHeaderTableView.mj_footer endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
    }
}
-(void)setLeftHeaderEnable:(BOOL)leftHeaderEnable{
    _leftHeaderEnable = leftHeaderEnable;
    if(leftHeaderEnable){
        self.leftHeaderTableView.mj_footer = self.contentTableView.mj_footer;
    }
}
///FIXME:初始化
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 0;
        self.sectionCount = 1;
        _leftHeaderEnable = YES;
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.layer.cornerRadius = 1;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _boldSeperatorLineWidth = 0.5;
        _excelNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        _excelNameL.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _excelNameL.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        _excelNameL.textAlignment = NSTextAlignmentCenter;
        _excelNameL.layer.borderWidth = 0.5;
        _excelNameL.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        _excelNameL.font = [UIFont systemFontOfSize:12];
        [self addSubview:_excelNameL];
        
        topHeaderScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        topHeaderScrollView.backgroundColor = [UIColor clearColor];
        topHeaderScrollView.delegate = self;
        topHeaderScrollView.showsHorizontalScrollIndicator = NO;
        topHeaderScrollView.showsVerticalScrollIndicator = NO;
        topHeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:topHeaderScrollView];
        
        self.leftHeaderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _leftHeaderTableView.dataSource = self;
        _leftHeaderTableView.delegate = self;
        _leftHeaderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _leftHeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftHeaderTableView.backgroundColor = [UIColor clearColor];
        _leftHeaderTableView.showsVerticalScrollIndicator = NO;
        _leftHeaderTableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_leftHeaderTableView];
        
        contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        contentScrollView.backgroundColor = [UIColor clearColor];
        contentScrollView.delegate = self;
        contentScrollView.bounces = NO;
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentScrollView];
        
        self.contentTableView = [[UITableView alloc] initWithFrame:contentScrollView.bounds];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = [UIColor clearColor];
        [contentScrollView addSubview:_contentTableView];
        WS(weakSelf);
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf privateRefresh];
        }];
        self.mj_header = header;
        self.leftHeaderTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.leftHeaderTableView.mj_header endRefreshing];
            [weakSelf.mj_header beginRefreshing];
        }];
        self.contentTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.contentTableView.mj_header endRefreshing];
            [weakSelf.mj_header beginRefreshing];
        }];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf privateLoadMore];
        }];
        footer.mj_h = 5;
        footer.stateLabel.font = [UIFont systemFontOfSize:15];
        footer.stateLabel.textColor = [UIColor clearColor];
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.triggerAutomaticallyRefreshPercent = 2.0;
        self.contentTableView.mj_footer = footer;
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height/2-100, [[UIScreen mainScreen]bounds].size.width, 100)];
        UILabel *emptyL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _emptyView.bounds.size.width, _emptyView.bounds.size.height)];
        emptyL.font = [UIFont systemFontOfSize:20];
        emptyL.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        emptyL.textAlignment = NSTextAlignmentCenter;
        emptyL.text = @"暂无数据";_emptyView.hidden = YES;
        [_emptyView addSubview:emptyL];
        [self addSubview:_emptyView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    if (_leftHeaderEnable) {
        _excelNameL.frame = CGRectMake(0, 0, _leftHeaderWidth, _topHeaderHeight);
        topHeaderScrollView.frame = CGRectMake(_leftHeaderWidth + _boldSeperatorLineWidth, 0, superWidth - _leftHeaderWidth - _boldSeperatorLineWidth, _topHeaderHeight);
        _leftHeaderTableView.frame = CGRectMake(0, _topHeaderHeight + _boldSeperatorLineWidth, _leftHeaderWidth, superHeight - _topHeaderHeight - _boldSeperatorLineWidth);
        contentScrollView.frame = CGRectMake(_leftHeaderWidth + _boldSeperatorLineWidth, _topHeaderHeight + _boldSeperatorLineWidth, superWidth - _leftHeaderWidth - _boldSeperatorLineWidth, superHeight - _topHeaderHeight - _boldSeperatorLineWidth);
    }else {
        if(self.headView){
            [topHeaderScrollView removeFromSuperview];
            topHeaderScrollView.frame = CGRectMake(0, self.headView.bounds.size.height-_topHeaderHeight, superWidth, _topHeaderHeight);
            [self.headView addSubview:topHeaderScrollView];
            contentScrollView.frame = CGRectMake(0, 0, superWidth, superHeight);
//        }else if(self.footView){
        }else{
            topHeaderScrollView.frame = CGRectMake(0, 0, superWidth, _topHeaderHeight);
            contentScrollView.frame = CGRectMake(0, _topHeaderHeight + _boldSeperatorLineWidth, superWidth, superHeight - _topHeaderHeight - _boldSeperatorLineWidth);
        }
    }
    [self adjustView];
}
- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reset];
        _emptyView.hidden = YES;
        for(NSArray *temp in leftHeaderDataArray){
            if(temp.count==0)_emptyView.hidden = NO;
        }
        [_leftHeaderTableView reloadData];
        [_contentTableView reloadData];
        [self performSelectorOnMainThread:@selector(tongbu) withObject:nil waitUntilDone:NO];
//        if (@available(iOS 11.0, *)) {
//            [leftHeaderTableView performBatchUpdates:^{
//            } completion:^(BOOL finished) {
//                [contentTableView performBatchUpdates:^{
//                } completion:^(BOOL finished) {
//                    contentTableView.contentOffset = leftHeaderTableView.contentOffset;
//                }];
//            }];
//        } else {
//            [self performSelectorOnMainThread:@selector(tongbu) withObject:nil waitUntilDone:NO];
//        }
    });
}
-(void)tongbu{
    contentScrollView.contentOffset = CGPointMake(contentScrollView.contentOffset.x, 0);
    _contentTableView.contentOffset = _leftHeaderTableView.contentOffset;
}
//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, _boldSeperatorLineWidth);
//    CGContextSetAllowsAntialiasing(context, false);
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
//    CGFloat y = _topHeaderHeight + _boldSeperatorLineWidth / 2.0f;
//    CGContextMoveToPoint(context, 0.0f, y);
//    CGContextAddLineToPoint(context, self.bounds.size.width, y);
//    CGContextStrokePath(context);
//}

- (void)dealloc {
    topHeaderScrollView = nil;
    contentScrollView = nil;
    _leftHeaderTableView = nil;
    _contentTableView = nil;
    _excelNameL = nil;
    columnPointCollection = nil;
}
///FIXME:设置代理
- (void)setDatasource:(id<BaseExcelViewDataSource>)datasource_ {
    if (datasource != datasource_) {
        datasource = datasource_;
        responseNumberofContentColumns = [datasource_ respondsToSelector:@selector(arrayDataForTopHeaderInTableView:)];
        responseItemProperty = [datasource_ respondsToSelector:@selector(tableView:propertyInSection:row:column:)];
        responseSectionArray = [datasource_ respondsToSelector:@selector(arrayDataForSectionHeaderInTableView:InSection:)];
        [self reset];
    }
}
///FIXME:点击左侧收起
- (void)leftHeaderTap:(UIButton *)sender {
    @synchronized(self) {
        sender.selected = !sender.selected;
        NSInteger section = sender.tag;
        [self buildSectionFoledStatus:section];
        [_leftHeaderTableView beginUpdates];
        [_contentTableView beginUpdates];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < [self rowsInSection:section]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        if ([self foldedInSection:section]) {
            [_leftHeaderTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [_contentTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [_leftHeaderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [_contentTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        [_leftHeaderTableView endUpdates];
        [_contentTableView endUpdates];
    }
}

///FIXME: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self foldedInSection:section]) {
        return [self rowsInSection:section];
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!_showSection)return 0;
    return [self itemPropertyWithSection:section row:-1 column:0].xheight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemPropertyWithSection:indexPath.section row:indexPath.row column:0].xheight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BaseExcelHeadView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[BaseExcelHeadView getHeadIdentifier]];
    if(!sectionHeadView){
        sectionHeadView = [BaseExcelHeadView getInstance];
    }
    if(!responseSectionArray)return sectionHeadView;
    [[sectionHeadView.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    sectionHeadView.frame = CGRectMake(0, 0, tableView.bounds.size.width, [tableView rectForHeaderInSection:section].size.height);
    NSArray *sectionArray = [sectionDataArray objectAtIndex:section];
    if (tableView == _leftHeaderTableView) {
        BaseTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseTitleCell getTableCellIdentifier]];
        if(!cell){
            cell = [BaseTitleCell getInstance];
        }
        cell.frame = sectionHeadView.bounds;
        ItemProperty *proper = [self itemPropertyWithSection:section row:-1 column:-1];
        cell.proper = proper;
        ExcelTitleModel *model = [sectionArray objectAtIndex:0];
        cell.shouqi = YES;
        cell.model = model;
        cell.sortB.tag = section;
        cell.sortB.selected = [self foldedInSection:section];
        [cell.sortB addTarget:self action:@selector(leftHeaderTap:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeadView.contentView addSubview:cell];
    }else {
        NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
        for (int i = 0; i < count; i++) {
            BaseTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseTitleCell getTableCellIdentifier]];
            if(!cell){
                cell = [BaseTitleCell getInstance];
            }
            ItemProperty *proper = [self itemPropertyWithSection:section row:-1 column:i];
            proper.xstart = [[columnPointCollection objectAtIndex:i] floatValue];
            cell.proper = proper;
            ExcelTitleModel *model = [sectionArray objectAtIndex:i+1];
            if(_sortItem.section==section&&_sortItem.column==i){
                model.sortType = self.sortItem.sortType;
            }
            if(model.sortable){
                WS(weakSelf);
                __weak __typeof(BaseTitleCell)*weakCell = cell;
                [cell.sortB addEventHandler:^(UIButton *sender) {
                    sender.selected = !sender.selected;
                    weakCell.model = [weakCell.model nextType];
                    [weakSelf.sortItem changeSortWithSection:section column:i sortType:weakCell.model.sortType];
                    [weakSelf singleHeaderClick:[NSIndexPath indexPathForRow:i inSection:section]];
                    [weakSelf.leftHeaderTableView reloadData];
                    [weakSelf.contentTableView reloadData];
                } forControlEvents:UIControlEventTouchUpInside];
            }
            cell.model = model;
            [sectionHeadView.contentView addSubview:cell];
        }
    }
    return sectionHeadView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftHeaderTableView) {
        BaseLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseLeftCell getTableCellIdentifier]];
        if (!cell) {
            cell = [BaseLeftCell getInstance];
            if(self.hidIndex){
                [cell.indexL mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(-25);
                }];
            }
        }
        ExcelLeftModel *mode = [[leftHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        ItemProperty *proper = [self itemPropertyWithSection:indexPath.section row:indexPath.row column:-1];
        cell.model = mode;
        cell.proper= proper;
        cell.indexL.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
//        NSNumber *indexLenth = [NSNumber numberWithFloat:cell.indexL.text.length*10+10];
//        [cell.indexL mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(indexLenth);
//        }];
        return cell;
    }else {
        NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
        NSString *identifier = [NSString stringWithFormat:@"%@%ld%@Identifier",NSStringFromClass([BaseExcelCell class]),count,excelContentCellIdentifier];
        BaseExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BaseExcelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            for (int i = 0; i < count; i++) {
                BaseContentCell *miniCell = [tableView dequeueReusableCellWithIdentifier:[BaseContentCell getTableCellIdentifier]];
                if(!miniCell){
                    miniCell = [BaseContentCell getInstance];
                }
                ItemProperty *proper = [self itemPropertyWithSection:indexPath.section row:indexPath.row column:i];
                proper.xstart = i<columnPointCollection.count?[columnPointCollection[i] floatValue]:0.0f;
                miniCell.proper = proper;
                miniCell.tag = i+10;
                [cell.contentView addSubview:miniCell];
            }
        }
     
        
        for (int i = 0; i < count; i++) {
            BaseContentCell *miniCell = [cell.contentView viewWithTag:i+10];
            miniCell.didSelectBlock = ^{
                ExcelLeftModel *mode = leftHeaderDataArray[indexPath.section][indexPath.row];
                if([datasource respondsToSelector:@selector(tableView:didSelectSection:inRow:inColumn:item:key:sortType:)]){
                    [datasource tableView:self didSelectSection:indexPath.section inRow:indexPath.row inColumn:i item:mode.item key:nil sortType:TableColumnSortTypeNone];
                }
            };
            ItemProperty *proper = [self itemPropertyWithSection:indexPath.section row:indexPath.row column:i];
            proper.xstart = i<columnPointCollection.count?[columnPointCollection[i] floatValue]:0.0f;
            if(self.showSection){
                miniCell.proper = proper;
            }else{
                miniCell.title.textColor = proper.textColor;
            }
            NSMutableArray *ary = [[contentDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if(i<ary.count){
                miniCell.value = ary[i];
            }else{
                miniCell.value = nil;
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger column = -1;
    UITableView *target = nil;
    if (tableView == _leftHeaderTableView) {
        target = _contentTableView;
    }else if (tableView == _contentTableView) {
        target = _leftHeaderTableView;
    }else {
        target = nil;
    }
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
ExcelLeftModel *mode = leftHeaderDataArray[indexPath.section][indexPath.row];
    if([datasource respondsToSelector:@selector(tableView:didSelectSection:inRow:inColumn:item:key:sortType:)]){
        [datasource tableView:self didSelectSection:section inRow:row inColumn:column item:mode.item key:nil sortType:TableColumnSortTypeNone];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    if (scrollView == _leftHeaderTableView) {
        target = _contentTableView;
    }else if (scrollView == _contentTableView) {
        target = _leftHeaderTableView;
    }else if (scrollView == contentScrollView) {
        target = topHeaderScrollView;
    }else if (scrollView == topHeaderScrollView) {
        target = contentScrollView;
    }
    target.contentOffset = scrollView.contentOffset;
}
///FIXME: - private method
- (void)reset {
    [self accessDataSourceData];
    [self accessColumnPointCollection];
    [self buildSectionFoledStatus:-1];
    [self setUpTopHeaderScrollView];
}
- (void)accessDataSourceData {
    leftHeaderDataArray = [NSMutableArray array];
    contentDataArray = [NSMutableArray array];
    sectionDataArray = [NSMutableArray array];
    _topHeaderHeight = [self itemPropertyWithSection:-1 row:0 column:0].xheight;
    _leftHeaderWidth = [self itemPropertyWithSection:0 row:0 column:-1].xwidth;
    for (int i = 0; i < self.sectionCount; i++) {
        NSArray<ExcelLeftModel*> *tempL = [datasource arrayDataForLeftHeaderInTableView:self InSection:i];
        NSArray *tempC = [datasource arrayDataForContentInTableView:self InSection:i];
        if(responseSectionArray){
            NSArray *tempS = [datasource arrayDataForSectionHeaderInTableView:self InSection:i];
            [sectionDataArray addObject:tempS];
        }
        [leftHeaderDataArray addObject:tempL];
        [contentDataArray addObject:tempC];
    }
}
- (void)accessColumnPointCollection {
    NSUInteger columns = responseNumberofContentColumns ? [datasource arrayDataForTopHeaderInTableView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:@"columns<0" reason:@"列数必须大于0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray arrayWithObject:@0];
    CGFloat widthColumn = 0.0f;
    for (int i = 0; i < columns; i++) {
        ItemProperty *proper = [self itemPropertyWithSection:0 row:0 column:i];
        widthColumn += proper.xwidth;
        [tmpAry addObject:[NSNumber numberWithFloat:widthColumn]];
    }
    columnPointCollection = [tmpAry copy];
}
- (void)adjustView {
    CGFloat width = 0.0f;
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 0; i < count; i++) {
        width += [self itemPropertyWithSection:0 row:0 column:i].xwidth;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        topHeaderScrollView.contentSize = CGSizeMake(width, _topHeaderHeight);
        contentScrollView.contentSize = CGSizeMake(width, self.bounds.size.height - _topHeaderHeight - _boldSeperatorLineWidth);
        _contentTableView.frame =
        CGRectMake(0.0f, 0.0f, width, self.bounds.size.height - _topHeaderHeight - _boldSeperatorLineWidth);
    });
}
- (void)buildSectionFoledStatus:(NSInteger)section {
    if (sectionFoldedStatus == nil) sectionFoldedStatus = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.sectionCount; i++) {
        if (section == -1) {
            if(!self.showSection){
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:i]];
            }else{
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:YES] forKey:[self sectionToString:i]];
            }
        }else if (i == section) {
            if ([self foldedInSection:section]) {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:section]];
            }else{
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:YES] forKey:[self sectionToString:section]];
            }break;
        }
    }
}
#pragma mark  --右侧的表头
- (void)setUpTopHeaderScrollView {
    [self adjustView];
    _excelNameL.backgroundColor = [self itemPropertyWithSection:-1 row:0 column:-1].bgColor;
    if(self.keepTopHead)return;
    self.keepTopHead = YES;
    [topHeaderScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    NSMutableString *forCellIdentifier = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        ItemProperty *proper = [self itemPropertyWithSection:-1 row:0 column:i];
        proper.xstart = [[columnPointCollection objectAtIndex:i] floatValue];
        BaseTitleCell *cell = [_leftHeaderTableView dequeueReusableCellWithIdentifier:[BaseTitleCell getTableCellIdentifier]];
        if(!cell){
            cell = [BaseTitleCell getInstance];
        }
        cell.proper = proper;
        [cell.sortB setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        cell.sortB.tag = i;
        ExcelTitleModel *model = [[self.datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i];
        cell.model = model;
        [forCellIdentifier appendString:model.name];
        __weak __typeof(UIScrollView)*weakTopHeadSV = topHeaderScrollView;
        __weak __typeof(BaseTitleCell)*weakCell = cell;
        WS(weakSelf);
        if(model.sortable){
        [cell.sortB addEventHandler:^(UIButton *sender) {
            for(UIView *v in weakTopHeadSV.subviews){
                if([v isKindOfClass:[BaseTitleCell class]]){
                    BaseTitleCell *vb = (BaseTitleCell*)v;
                    ExcelTitleModel *vm = vb.model;
                    if(vb.sortB.tag == sender.tag){
                        [vm nextType];
                    }else if(vm.sortable){
                        vm.sortType = TableColumnSortTypeNone;
                    }
                    vb.model = vm;
                }
            }
            if([weakSelf.datasource respondsToSelector:@selector(tableView:didSelectSection:inRow:inColumn:item:key:sortType:)]){
                weakSelf.contentTableView.contentOffset = weakSelf.leftHeaderTableView.contentOffset = CGPointZero;
                [weakSelf.datasource tableView:weakSelf didSelectSection:-1 inRow:0 inColumn:i item:nil key:weakCell.model.key sortType:weakCell.model.sortType];
            }else{
                [weakSelf.sortItem changeSortWithSection:-1 column:i sortType:weakCell.model.sortType];
                for (int j = 0; j < weakSelf.sectionCount; j++) {
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:i inSection:j];
                    [weakSelf singleHeaderClick:iPath];
                }
                [weakSelf.leftHeaderTableView reloadData];
                [weakSelf.contentTableView reloadData];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        }
        [topHeaderScrollView addSubview:cell];
    }
    excelContentCellIdentifier = forCellIdentifier;
}

- (void)singleHeaderClick:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger column = indexPath.row;
    TableColumnSortType columnFlag = (_sortItem.column==column)?_sortItem.sortType: TableColumnSortTypeNone;
    NSArray<ExcelLeftModel*> *leftHeaderDataInSection = [leftHeaderDataArray objectAtIndex:section];
    NSArray *contentDataInSection = [contentDataArray objectAtIndex:section];
    NSArray *sortContentData = [contentDataInSection sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result =  [[obj1 objectAtIndex:column] compare:[obj2 objectAtIndex:column]];
        return result;
    }];
    NSMutableArray *sortIndexAry = [NSMutableArray array];
    for (int i = 0; i < sortContentData.count; i++) {
        id objI = [sortContentData objectAtIndex:i];
        for (int j = 0; j < contentDataInSection.count; j++) {
            id objJ = [contentDataInSection objectAtIndex:j];
            if (objI == objJ) {
                [sortIndexAry addObject:[NSNumber numberWithInt:j]];
                break;
            }
        }
    }
    NSMutableArray<ExcelLeftModel*> *sortLeftHeaderData = [NSMutableArray array];
    for (id index in sortIndexAry) {
        int i = [index intValue];
        [sortLeftHeaderData addObject:[leftHeaderDataInSection objectAtIndex:i]];
    }
    if(columnFlag == TableColumnSortTypeDesc){
        NSEnumerator *leftReverseEnumerator = [sortLeftHeaderData reverseObjectEnumerator];
        NSEnumerator *contentReverseEvumerator = [sortContentData reverseObjectEnumerator];
        sortLeftHeaderData = [NSMutableArray<ExcelLeftModel*> arrayWithArray:[leftReverseEnumerator allObjects]];
        sortContentData = [NSArray arrayWithArray:[contentReverseEvumerator allObjects]];
    }
    [leftHeaderDataArray replaceObjectAtIndex:section withObject:sortLeftHeaderData];
    [contentDataArray replaceObjectAtIndex:section withObject:sortContentData];
}

///FIXME: other method
- (ItemProperty*)itemPropertyWithSection:(NSInteger)section row:(NSInteger)row column:(NSInteger)column{
    return responseItemProperty?[datasource tableView:self propertyInSection:section row:row column:column]:[ItemProperty defaultProperty];
}
- (NSInteger)rowsInSection:(NSInteger)section {
    if(section>=leftHeaderDataArray.count){
        self.sectionCount = 1;
        return 0;
    }
    NSArray *temp = [leftHeaderDataArray objectAtIndex:section];
    return [temp count];
}
- (NSString *)sectionToString:(NSInteger)section {
    return [NSString stringWithFormat:@"%ld", section];
}
- (BOOL)foldedInSection:(NSInteger)section {
    return [[sectionFoldedStatus objectForKey:[self sectionToString:section]] boolValue];
}
-(void)setScrollOffset:(CGPoint)scrollOffset{
//    _scrollOffset = scrollOffset;
    dispatch_async(dispatch_get_main_queue(), ^{
      
    _contentTableView.contentOffset = CGPointMake(0, scrollOffset.y);
    _leftHeaderTableView.contentOffset = CGPointMake(0, scrollOffset.y);
    topHeaderScrollView.contentOffset =  CGPointMake(scrollOffset.x, 0);
    contentScrollView.contentOffset = CGPointMake(scrollOffset.x, 0);
        
    });
}
-(CGPoint)scrollOffset{
    CGFloat thex = contentScrollView.contentOffset.x;
    CGFloat they = _leftHeaderTableView.contentOffset.y;
    return CGPointMake(thex, they);
//    return CGPointMake(contentScrollView.contentOffset.x, _leftHeaderTableView.contentOffset.y);
}
-(void)setHeadView:(UIView *)headView{
    headView.frame = CGRectMake(headView.frame.origin.x, headView.frame.origin.y, headView.bounds.size.width, headView.bounds.size.height + _topHeaderHeight);
    _headView = headView;
    _contentTableView.tableHeaderView = headView;
}
-(void)setFootView:(UIView *)footView{
    _footView = footView;
    _contentTableView.tableFooterView = footView;
}
@end
