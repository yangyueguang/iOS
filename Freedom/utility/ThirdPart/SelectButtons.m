//
//  SelectButtons.m
#import "SelectButtons.h"
#define SortButtonH 34.0f
#define WS(weakSelf)    __weak __typeof(self)weakSelf = self;
#import <Masonry/Masonry.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface UIView(fray)
@property(nonatomic)CGFloat frameY;
@end
@implementation UIView(fray)
- (CGFloat)frameY {
    return self.frame.origin.y;
}
- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,self.frame.size.width, self.frame.size.height);
}
@end
@implementation BaseType
@end
@interface UIScreenTouchRecognizer : UIGestureRecognizer
@end
@implementation UIScreenTouchRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}
@end
@implementation SBItem
-(NSMutableArray<BaseType *> *)selectedItems{
    if(!_selectedItems){
        if(self.types.count){
            _selectedItems = [NSMutableArray arrayWithObject:self.types.firstObject];
        }
    }
    return _selectedItems;
}
-(NSMutableArray<BaseType *> *)tempSItems{
    if(!_tempSItems){
        _tempSItems = [NSMutableArray array];
    }
    return _tempSItems;
}
-(NSMutableArray *)setionTitleArray{
    if(!_setionTitleArray){
        NSMutableArray *nameItems = [NSMutableArray array];
        for(int i=1;i<self.types.count;i++){
            BaseType *ty = self.types[i];
            [nameItems addObject:ty.value];
        }
//        _setionTitleArray = [ChineseToPinyin IndexArray:nameItems];
        if([self.key isEqualToString:@"noSort"]){
            [_setionTitleArray removeAllObjects];
        }
    }
    return _setionTitleArray;
}
-(NSMutableArray *)resultArr{
    if(!_resultArr){
        NSMutableArray *nameItems = [NSMutableArray array];
        int i= _isLimited?0:1;
        for(;i<self.types.count;i++){
            BaseType *ty = self.types[i];
            [nameItems addObject:ty.value];
        }
//        _resultArr = [ChineseToPinyin LetterSortArray:nameItems];
        if([self.key isEqualToString:@"noSort"]){
            _resultArr = [NSMutableArray arrayWithObject:nameItems];
        }
        NSMutableArray *temp = [NSMutableArray arrayWithArray:[_resultArr firstObject]];
        if(!_isLimited){
            [temp insertObject:@"不限" atIndex:0];
        }
        if(_resultArr.count>0){
        [_resultArr replaceObjectAtIndex:0 withObject:temp];
        }
    }return _resultArr;
}
-(NSMutableArray<BaseType *> *)types{
    if(!_types && self.typesBlock){
        _types = self.typesBlock(self.key);
        if(!_isLimited){
            BaseType *typ = [[BaseType alloc]init];
            typ.key = @"";
            typ.value = @"不限";
            typ.code = @"101010101010";
            [_types insertObject:typ atIndex:0];
        }
    }
    return _types;
}
-(instancetype)init{
    return [self initWithName:@"" key:@"" isCollectionType:YES];
}
-(instancetype)initWithName:(NSString *)name key:(NSString *)key isCollectionType:(BOOL)ctype{
    return [self initWithName:name key:key isCollectionType:ctype typesBlock:nil];
}
-(instancetype)initWithName:(NSString *)name key:(NSString *)key isCollectionType:(BOOL)ctype typesBlock:(NSMutableArray<BaseType *> *(^)(NSString *))typesBlock{
    self = [super init];
    self.sectionH = 0;
    self.columns = 4;
    self.name = name;
    self.key = key;
    if(!key)self.key = name;
    self.isCollectionType = ctype;
    self.typesBlock = typesBlock;
    return self;
}
-(instancetype)initWithName:(NSString *)name key:(NSString *)key isCollectionType:(BOOL)ctype netCompletBlock:(void (^)(NetCompletBlock))netBlock{
    self = [super init];
    self.sectionH = 0;
    self.columns = 4;
    self.name = name;
    self.key = key;
    if(!key)self.key = name;
    self.isCollectionType = ctype;
    self.netCompletblock = netBlock;
    return self;
}
@end
///FIXME:SelectCell
@interface SelectTCell:UITableViewCell
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *script;
@end
@implementation SelectTCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initUI];
    return self;
}
-(void)initUI{
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, [[UIScreen mainScreen]bounds].size.width-100, 20)];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textColor = [UIColor colorWithWhite:0.29 alpha:1];
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 25, 20)];
    self.icon.contentMode = UIViewContentModeCenter;
    self.icon.image = [UIImage imageNamed:@"勾"];
    self.accessoryView = self.icon;
    [self addSubview:self.title];
}
@end
@interface SelectCCell : UICollectionViewCell//appw-20)/3
@property(nonatomic,strong)BaseType *ty;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *script;
@end
@implementation SelectCCell//appw/5
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }return self;
}
-(void)initUI{
    self.title = [[UILabel alloc]init];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont systemFontOfSize:13];
    self.title.layer.cornerRadius = 3.5;
    self.title.layer.masksToBounds = YES;
    self.title.layer.borderWidth = 0.5;
    self.title.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
-(void)prepareForReuse{
    self.title.backgroundColor = [UIColor clearColor];
    self.title.textColor = [UIColor colorWithWhite:0.2 alpha:1];
}
-(void)setTy:(BaseType *)ty{
    _ty = ty;
    self.title.text = ty.value;
}
@end
///FIXME:正式的视图
@interface SelectButtons(){
    UIButton *cancelB;
    UIButton *sureB;
    UILabel *alertLabel;
    float Theight;
    float Cheight;
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)UIView *backGroundView;
@property(nonatomic,strong)SBItem *currentItem;
@property(nonatomic,strong)UIButton *currentEditButton;
@property(nonatomic,assign)UIViewController *fromNvc;
@end
//buttonView+alertLabel+backGroundView-->
//         showView-->
//               sureB+cancelB
//               collectionView-->SelectCCell
//               tableView-->SelectTCell
@implementation SelectButtons
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}
///FIXME:初始化
-(instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame items:nil];
}
-(instancetype)initNavibarMenu:(CGRect)frame item:(SBItem *)item inVC:(UIViewController *)nvc{
    self = [super initWithFrame:CGRectMake(0,frame.origin.y, [[UIScreen mainScreen]bounds].size.width, [UIScreen mainScreen].bounds.size.height-frame.origin.y)];
    item.isLimited = YES;
    item.isSingleSelect = YES;
    item.isCollectionType = YES;
    item.selectedItems = [NSMutableArray array];
    self.layout.itemSize = CGSizeMake(10, 40);
    long rows = (item.types.count/item.columns+(item.types.count%item.columns != 0));
    Cheight = rows * self.layout.itemSize.height;
    _fromNvc = nvc;
    self.buttonView = [[UIView alloc]init];
    _showView = [[UIView alloc]init];
    [_showView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0,0,0,0));
    }];
    self.collectionView.hidden = NO;
    [self.backGroundView addSubview:_showView];
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(frame.origin.x);
        make.width.mas_equalTo(frame.size.width);
        make.top.mas_offset(0);
        make.height.mas_equalTo(frame.size.height);
    }];
    [self addSubview:self.backGroundView];
    [_fromNvc.view insertSubview:self belowSubview:nvc.navigationController.navigationBar];
    self.items = @[item];
    return self;
}
-(instancetype)initSortView:(CGRect)frame item:(SBItem *)item inVC:(UIViewController *)nvc{
    self = [super initWithFrame:nvc.view.bounds];
    Theight = frame.size.height;
    item.isSingleSelect = YES;
    item.isCollectionType = NO;
    item.sectionH = 0;
    item.key = @"noSort";
    _fromNvc = nvc;
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, SortButtonH)];
    self.buttonView.layer.cornerRadius = 3;
    self.buttonView.layer.borderWidth = 1;
    self.buttonView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
    self.buttonView.backgroundColor = [UIColor whiteColor];
    _showView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x,SortButtonH+frame.origin.y, frame.size.width,MIN(frame.size.height,item.types.count*40.0))];
    [self addSubview:self.backGroundView];
    UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+SortButtonH, frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    tempV.clipsToBounds = YES;
    [tempV addSubview:_showView];
    [self.backGroundView addSubview:tempV];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_offset(0);
        make.height.mas_lessThanOrEqualTo(frame.size.height);
    }];
    [_showView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_buttonView];
    [_fromNvc.view insertSubview:self belowSubview:nvc.navigationController.navigationBar];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0,0,0,0));
    }];
    self.items = @[item];
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<SBItem *> *)items{
    self = [super initWithFrame:frame];
    Theight = [UIScreen mainScreen].bounds.size.height*0.7;
    Cheight = [UIScreen mainScreen].bounds.size.height*0.3;
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, SortButtonH)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.backGroundView.frame = CGRectMake(0, self.buttonView.bounds.size.height, frame.size.width, frame.size.height-self.buttonView.bounds.size.height);
    alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-50,frame.size.height/3-80, 100, 80)];
    alertLabel.backgroundColor = [UIColor colorWithRed:192/255.0 green:8/255.0 blue:34/255.0 alpha:0.8];
    alertLabel.font = [UIFont systemFontOfSize:26];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.layer.cornerRadius = 10;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.hidden = YES;
    [self.backGroundView addSubview:self.showView];
    [self addSubview:self.buttonView];
    [self addSubview:self.backGroundView];
    [self addSubview:alertLabel];
    self.items = items;
    [self configurationConstraints];
    return self;
}
///FIXME:布局约束
-(void)configurationConstraints{
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_offset(0);
        make.height.equalTo([NSNumber numberWithFloat:Theight]);
    }];
    [cancelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_offset(0);
        make.right.equalTo(sureB.mas_left);
        make.height.equalTo(@50);
    }];
    [sureB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_offset(0);
        make.left.equalTo(cancelB.mas_right);
        make.height.equalTo(cancelB);
        make.width.equalTo(cancelB);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_offset(0);
        make.bottom.mas_equalTo(cancelB.mas_top);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_offset(0);
        make.bottom.mas_equalTo(cancelB.mas_top);
    }];
}
///FIXME:懒加载
-(UIView *)showView{
    if(!_showView){
        _showView = [[UIView alloc]init];
        [_showView addSubview:self.collectionView];
        [_showView addSubview:self.tableView];
        cancelB = [[UIButton alloc]init];
        sureB  = [[UIButton alloc]init];
        cancelB.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        sureB.backgroundColor = [UIColor colorWithRed:192/255.0 green:8/255.0 blue:34/255.0 alpha:1];
        [cancelB setTitle:@"取消" forState:UIControlStateNormal];
        [sureB setTitle:@"确定" forState:UIControlStateNormal];
        cancelB.titleLabel.font = sureB.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancelB setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        [sureB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelB addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [sureB addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:cancelB];
        [_showView addSubview:sureB];
    }
    return _showView;
}
-(UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(10, 30);
        _layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _layout.minimumInteritemSpacing = 15;
        _layout.minimumLineSpacing = 15;
    }return _layout;
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [_collectionView registerClass:[SelectCCell class] forCellWithReuseIdentifier:@"SelectCCell"];
        _collectionView.hidden = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.hidden = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc]initWithFrame:self.bounds];
        _backGroundView.alpha = 0.0;
        _backGroundView.clipsToBounds = YES;
        _backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03];
    }return _backGroundView;
}
-(void)setItems:(NSArray<SBItem *> *)items{
    _items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    for(int i=0;i<items.count;i++){
        SBItem *item = items[i];
        UIButton *a = [[UIButton alloc]initWithFrame:CGRectMake(i*self.buttonView.frame.size.width/items.count, 0, self.buttonView.frame.size.width/items.count, self.buttonView.bounds.size.height)];
        [a setTitle:item.name forState:UIControlStateNormal];
        if(item.selectedItems.count && ![item.selectedItems.firstObject.value isEqualToString:@"不限"]){
            [a setTitle:item.selectedItems.firstObject.value forState:UIControlStateNormal];
        }
        [a setImage:[UIImage imageNamed:@"下灰"] forState:UIControlStateNormal];
        [a setImage:[UIImage imageNamed:@"上灰"] forState:UIControlStateSelected];
        a.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        a.titleLabel.font = [UIFont systemFontOfSize:12];
        a.tag = 10+i;
        [a setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        [a setTitleEdgeInsets:UIEdgeInsetsMake(0, -a.imageView.bounds.size.width-2, 0, a.imageView.bounds.size.width+2)];
        [a setImageEdgeInsets:UIEdgeInsetsMake(0, a.titleLabel.bounds.size.width+2, 0, -a.titleLabel.bounds.size.width-2)];
        [a addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:a];
        if(items.count==1 && !_fromNvc){
            a.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            a.frame = CGRectMake(a.frame.origin.x, a.frame.origin.y, a.frame.size.width-20, a.frame.size.height);
        }
    }
    });
}
///FIXME:内部方法
-(void)buttonSelect:(UIButton*)sender{
    sender.selected = !sender.selected;
    if(!sender.selected){
        [self hide];
        return;
    }
    self.currentItem = self.items[sender.tag-10];
    if(self.currentItem.columns<=1){
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.layout.minimumLineSpacing = 0;
    }
    self.currentItem.tempSItems = self.currentItem.selectedItems;
    if(self.currentEditButton != sender){
    self.currentEditButton.selected = NO;
    }
    self.currentEditButton = sender;
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(self.currentItem.isCollectionType){
            make.height.equalTo([NSNumber numberWithDouble:Cheight]);
        }else{
            double heigh = MIN(Theight, self.currentItem.types.count*40);
            make.height.equalTo([NSNumber numberWithDouble:heigh]);
        }
    }];
    if(self.currentItem.typesBlock || self.currentItem.types){
        [self refreshView];
    }else if(self.currentItem.netCompletblock){
        WS(weakSelf);
        self.showView.alpha = 0;
            self.backGroundView.alpha = 1;
            self.currentItem.types = nil;
            self.currentItem.selectedItems = nil;
            self.showView.frameY = -Theight;
        self.currentItem.netCompletblock(^(NSMutableArray<BaseType *> *result) {
            if(!result){
                weakSelf.currentItem.typesBlock = nil;
                weakSelf.currentItem.selectedItems = nil;
                [weakSelf hide];
//                weakSelf.showView.alpha = 1;
            }else{
                weakSelf.currentItem.typesBlock = ^NSMutableArray<BaseType *> *(NSString *key) {
                    return result;
                };
                if(!weakSelf.currentItem.isCollectionType){
                [weakSelf.showView mas_updateConstraints:^(MASConstraintMaker *make) {
                        double heigh = MIN(Theight, weakSelf.currentItem.types.count*40);
                        make.height.equalTo([NSNumber numberWithDouble:heigh]);
                }];
                }else if(_fromNvc){
                    long rows = (result.count/self.currentItem.columns+(result.count%self.currentItem.columns != 0));
                    Cheight = rows * self.layout.itemSize.height;
                }
                weakSelf.currentItem.tempSItems = weakSelf.currentItem.selectedItems;
                weakSelf.showView.alpha = 1;
                [weakSelf refreshView];
            }
        });
    }else{
        NSLog(@"请完善数据源");
    }
}
-(void)refreshView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.currentItem.isCollectionType){
            self.collectionView.hidden = NO;
            self.tableView.hidden = YES;
            [self show];
            [self.collectionView reloadData];
        }else{
            self.tableView.hidden = NO;
            self.collectionView.hidden = YES;
            [self show];
            [self.tableView reloadData];
        }
    });
}
-(void)sureAction:(UIButton*)sender{
    [self hide];
    _currentItem.selectedItems = _currentItem.tempSItems;
if((_fromNvc || _currentItem.isCollectionType)&&_currentItem.selectedItems.count>0){
        [self.currentEditButton setTitle:self.currentItem.selectedItems.firstObject.value forState:UIControlStateNormal];
        [self.currentEditButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.currentEditButton.imageView.bounds.size.width-2, 0, self.currentEditButton.imageView.bounds.size.width+2)];
        [self.currentEditButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.currentEditButton.titleLabel.bounds.size.width+2, 0, -self.currentEditButton.titleLabel.bounds.size.width-2)];
    }
    if(self.sureBlock){
        self.sureBlock(self.currentItem.selectedItems,self.currentItem.key);
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hide];
}
-(void)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.currentItem){
            UIButton *btn = [self.buttonView viewWithTag:10];
            if([btn isKindOfClass:[UIButton class]]){
                [self buttonSelect:btn];
            }
            return ;
        }
        self.showView.frameY = self.currentItem.isCollectionType?-Cheight:-Theight;
        self.backGroundView.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.showView.frameY = 0;
        } completion:^(BOOL finished) {
        }];
//        [UIView animateWithDuration:0.25 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.showView.frameY = 0;
//        } completion:^(BOOL finished) {
//        }];
    });
}
-(void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentEditButton.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.showView.frameY = self.currentItem.isCollectionType?-Cheight:-Theight;
        } completion:^(BOOL finished){
            self.backGroundView.alpha = 0;
        }];
    });
}
-(void)showOrHid{
    if(self.showView.frameY<0 || self.backGroundView.alpha == 0){
        [self show];
    }else{
        [self hide];
    }
}
#pragma mark collectionViewDelegate
///FIXME:集合视图代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.currentItem.types.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-15*self.currentItem.columns-15)/self.currentItem.columns,self.layout.itemSize.height);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.layout.minimumLineSpacing;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.layout.minimumInteritemSpacing;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.layout.sectionInset;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCCell" forIndexPath:indexPath];
    if(indexPath.item<self.currentItem.types.count){
        cell.ty = self.currentItem.types[indexPath.item];
    }
    if([self.currentItem.tempSItems containsObject:cell.ty]){
        cell.title.backgroundColor = [UIColor greenColor];
        cell.title.textColor = [UIColor whiteColor];
    }
    CGFloat frameWidth = ([UIScreen mainScreen].bounds.size.width-15*self.currentItem.columns-15)/self.currentItem.columns;
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, cell.title.frame.origin.y, frameWidth, cell.title.bounds.size.height);
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentItem.tempSItems.count>0){
        [self.currentItem.tempSItems replaceObjectAtIndex:0 withObject:self.currentItem.types[indexPath.item]];
    }else{
        [self.currentItem.tempSItems addObject:self.currentItem.types[indexPath.item]];
    }
    [collectionView reloadData];
    if(self.fromNvc != nil){
        [self sureAction:nil];
    }
}
///FIXME:表格视图模式代理 tableViewDelegate
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.currentItem.setionTitleArray;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.currentItem.setionTitleArray objectAtIndex:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.currentItem.resultArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp = [self.currentItem.resultArr objectAtIndex:section];
    return temp.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTCell"];
    if(!cell){
        cell = [[SelectTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectTCell"];
        if(_fromNvc){
            cell.icon.image = nil;
            [cell.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            cell.title.layer.borderWidth = 0.3;
            cell.title.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
            cell.title.textAlignment = NSTextAlignmentCenter;
        }
    }
    if(indexPath.section<self.currentItem.resultArr.count){
        NSArray *temp = self.currentItem.resultArr[indexPath.section];
        if(indexPath.row<temp.count){
            NSString *cellstr = temp[indexPath.row];
            cell.title.text = cellstr;
            cell.title.textColor = [UIColor colorWithWhite:0.29 alpha:1];
            cell.accessoryView.hidden = YES;
            for(BaseType *ty in self.currentItem.tempSItems){
                if([ty.value isEqualToString:cellstr]){
                    cell.title.textColor = [UIColor redColor];
                    cell.accessoryView.hidden = NO;
                }
            }
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    alertLabel.text = title;
    alertLabel.hidden = NO;
    [self performSelector:@selector(setHid) withObject:nil afterDelay:0.5];
    return index;
}
-(void)setHid{
    alertLabel.hidden = YES;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    head.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    UILabel *headL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, [UIScreen mainScreen].bounds.size.width, 20)];
    headL.text = [self.currentItem.setionTitleArray objectAtIndex:section];
    headL.font = [UIFont systemFontOfSize:16];
    headL.textColor =[UIColor colorWithWhite:0.4 alpha:1];
    [head addSubview:headL];
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.currentItem.sectionH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *value = self.currentItem.resultArr[indexPath.section][indexPath.row];
    BaseType *selctType;
    for(BaseType *ty in self.currentItem.types){
        if([ty.value isEqualToString:value]){
            selctType = ty;
        }
    }
    if(cell.accessoryView.hidden){
        if(self.currentItem.isSingleSelect||[value isEqualToString:@"不限"]){
            [self.currentItem.tempSItems removeAllObjects];
        }else{
            for(int i=0;i<self.currentItem.tempSItems.count;i++){
                BaseType *ty = self.currentItem.tempSItems[i];
                if([ty.value isEqualToString:@"不限"]){
                    [self.currentItem.tempSItems removeObject:ty];break;
                }
            }
        }
        if(selctType){
            [self.currentItem.tempSItems addObject:selctType];
        }
        [tableView reloadData];
        if(_fromNvc){
            [self sureAction:nil];
        }
    }else{
        for(int i=0;i<self.currentItem.tempSItems.count;i++){
            BaseType *ty = self.currentItem.tempSItems[i];
            if([ty.value isEqualToString:value]){
                [self.currentItem.tempSItems removeObject:ty];
            }
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end

