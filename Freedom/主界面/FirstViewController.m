
#import "FirstViewController.h"
#import "ElasticTransition.h"
#import "SettingsViewController.h"
#import "LibraryCollectionViewController.h"
#import "UIColor+expanded.h"
#import "User.h"
@interface CollectionViewCell1 : UICollectionViewCell{
    UIView *view;
    UIImageView *imageView;
    UILabel *nameLabel;
    NSMutableDictionary *thumbnailCache;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color;
@end
@implementation CollectionViewCell1
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, (H(self)-80)*0.5, 80, 80)];
        view.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithFrame:view.frame];
        imageView.layer.borderWidth = 2;
        imageView.layer.cornerRadius = 40;
        [view addSubview:imageView];
        [self.contentView addSubview:view];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(XW(imageView),(H(self)-20)*0.5,200,20)];
        [self.contentView addSubview:nameLabel];
    }return self;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color{
    imageView.layer.borderColor = [color CGColor];
     nameLabel.text = [dic valueForKey:@"title"];
    NSString *imgURL = [dic valueForKey:@"icon"];
    [imageView setImage:nil];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        imageView.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
    imageView.clipsToBounds = YES;
}
@end
@interface CollectionViewCell2:UICollectionViewCell{
    UILabel *nameLabel;
}
-(void)setDataWithDic:(NSDictionary*)dic andColor:(UIColor *)color;
@end
@implementation CollectionViewCell2
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,0,200,40)];
        [self.contentView addSubview:nameLabel];
        nameLabel.font = Font(28);
    }return self;
}
-(void)setDataWithDic:(NSDictionary *)dic andColor:(UIColor *)color{
    nameLabel.text = [dic valueForKey:@"title"];
    nameLabel.textColor = color;
}
@end
//FIXME:Layout
@implementation XCollectionViewDialLayout
- (id)init{
    if ((self = [super init]) != NULL){
        [self setup];
    }return self;
}
-(id)initWithRadius: (CGFloat) radius andAngularSpacing: (CGFloat) spacing andCellSize: (CGSize) cell andAlignment:(WheelAlignmentType)alignment andItemHeight:(CGFloat)height andXOffset: (CGFloat) xOff{
    if ((self = [super init]) != NULL){
        self.dialRadius = radius;//420.0f;
        self.cellSize = cell;//(CGSize){ 220.0f, 80.0f };
        self.itemHeight = height;
        self.AngularSpacing = spacing;//8.0f;
        self.xOffset = xOff;
        self.wheelType = alignment;
        [self setup];
    }return self;
}
- (void)setup{
    self.offset = 0.0f;
}
- (void)prepareLayout{
    [super prepareLayout];
    self.cellCount = (int)[self.collectionView numberOfItemsInSection:0];
    self.offset = -self.collectionView.contentOffset.y / self.itemHeight;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    float minY = CGRectGetMinY(rect);
    float maxY = CGRectGetMaxY(rect);
    int firstIndex = floorf(minY / self.itemHeight);
    int lastIndex = floorf(maxY / self.itemHeight);
    int activeIndex = (int)(firstIndex + lastIndex)/2;
    int maxVisibleOnScreen = 180 / self.AngularSpacing + 2;
    int firstItem = fmax(0, activeIndex - (int)(maxVisibleOnScreen/2) );
    int lastItem = fmin( self.cellCount-1 , activeIndex + (int)(maxVisibleOnScreen/2) );
    for( int i = firstItem; i <= lastItem; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    return [theLayoutAttributes copy];
}
- (CGSize)collectionViewContentSize{
    const CGSize theSize = {
        .width = self.collectionView.bounds.size.width,
        .height = (self.cellCount-1) * self.itemHeight + self.collectionView.bounds.size.height,
    };
    return(theSize);
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    double newIndex = (indexPath.item + self.offset);
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttributes.size = self.cellSize;
    float scaleFactor;
    float deltaX;
    CGAffineTransform translationT;
    CGAffineTransform rotationT = CGAffineTransformMakeRotation(self.AngularSpacing* newIndex *M_PI/180);
    if(indexPath.item == 3){
    }
    if( self.wheelType == WHEELALIGNMENTLEFT){
        scaleFactor = fmax(0.6, 1 - fabs( newIndex *0.25));
        deltaX = self.cellSize.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset  , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius + (deltaX*scaleFactor) , 0);
    }else  {
        scaleFactor = fmax(0.4, 1 - fabs( newIndex *0.50));
        deltaX =  self.collectionView.bounds.size.width/2;
        theAttributes.center = CGPointMake(-self.dialRadius + self.xOffset , self.collectionView.bounds.size.height/2 + self.collectionView.contentOffset.y);
        translationT =CGAffineTransformMakeTranslation(self.dialRadius  + ((1 - scaleFactor) * -30) , 0);
    }
    CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    theAttributes.alpha = scaleFactor;
    theAttributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    theAttributes.zIndex = indexPath.item;
    return(theAttributes);
}
@end
#pragma mark ViewController
@interface FirstViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate>{
    __weak IBOutlet UICollectionView *homecollectionView;
//    UIButton *editBtn;
    ElasticTransition *transition;
    UIScreenEdgePanGestureRecognizer *LibraryGR;
    UIScreenEdgePanGestureRecognizer *SettingsGR;
    UISearchBar *searchBar;
    BOOL showingSettings;
    UIView *settingsView;
    UILabel *radiusLabel;
    UISlider *radiusSlider;
    UILabel *angularSpacingLabel;
    UISlider *angularSpacingSlider;
    UILabel *xOffsetLabel;
    UISlider *xOffsetSlider;
    UISwitch *exampleSwitch;
    XCollectionViewDialLayout *dialLayout;
    //定时器 下雪
    int count;
    NSTimer *timer;
    __weak IBOutlet UINavigationBar *firstNavigationBar;
}
@end
static NSString *cellId1 = @"cellId1";
static NSString *cellId2 = @"cellId2";
static FirstViewController *FVC = nil;
@implementation FirstViewController
@synthesize managedObjectContext = __managedObjectContext;
+ (FirstViewController *) sharedViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        FVC = [[FirstViewController alloc] init];
    });
    return FVC;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self readData];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 0, APPW-110, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    searchBar.barTintColor = gradcolor;
    UIBarButtonItem *leftNav = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone actionBlick:^{
        [self gotoSettingsView:nil];
    }];
    UIBarButtonItem *rightNav = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:Pseting] style:UIBarButtonItemStyleDone actionBlick:^{
        [self showSettingsView:nil];
    }];
    UINavigationItem * navigationItem = [[UINavigationItem alloc] initWithTitle:@"自由主义"];
//    [firstNavigationBar pushNavigationItem:navigationBarTitle animated:YES];
    navigationItem.leftBarButtonItem = leftNav;
    navigationItem.titleView = searchBar;
    navigationItem.rightBarButtonItem = rightNav;
    [firstNavigationBar setItems:[NSArray arrayWithObject:navigationItem]];
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    transition = [[ElasticTransition alloc] init];
    transition.sticky           = YES;
    transition.showShadow       = YES;
    transition.panThreshold     = 0.55;
    transition.radiusFactor     = 0.3;
    transition.transformType    = ROTATE;
    transition.overlayColor     = [UIColor colorWithWhite:0 alpha:0.5];
    transition.shadowColor      = [UIColor colorWithWhite:0 alpha:0.5];
    // gesture recognizers
    SettingsGR = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [SettingsGR addTarget:self action:@selector(gotoSettings:)];
    SettingsGR.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:SettingsGR];
    
    LibraryGR = [[UIScreenEdgePanGestureRecognizer alloc] init];
    [LibraryGR addTarget:self action:@selector(gotoLibrary:)];
    LibraryGR.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:LibraryGR];
    showingSettings = NO;
    [self buildSettings];
    [homecollectionView registerClass:[CollectionViewCell1 class] forCellWithReuseIdentifier:cellId1];
    [homecollectionView registerClass:[CollectionViewCell2 class] forCellWithReuseIdentifier:cellId2];
    homecollectionView.delegate = self;
    homecollectionView.dataSource = self;
    homecollectionView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    //下雪 每隔1秒下一次
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(snowAnimat:) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:200]];
    [self switchExample];
}
#pragma mark 设置与收藏的跳转
-(void)gotoSettingsView:(UIButton*)sender{
    [timer setFireDate:[NSDate distantFuture]];
    transition.edge = LEFT;
    transition.translation    = CGPointMake(320, 15);
    transition.dragPoint = CGPointMake(230, 170);
    [self performSegueWithIdentifier:@"settings" sender:transition];
}
-(void)gotoSettings:(UIPanGestureRecognizer*)pan{
    if (pan.state != UIGestureRecognizerStateBegan){
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }else{
        transition.edge = LEFT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"settings" GestureRecognizer:pan];
    }
}
-(void)gotoLibrary:(UIPanGestureRecognizer*)pan{
    if (pan.state == UIGestureRecognizerStateBegan){
        transition.edge = RIGHT;
        [transition startInteractiveTransitionFromViewController:self SegueIdentifier:@"library" GestureRecognizer:pan];
    }else{
        [transition updateInteractiveTransitionWithGestureRecognizer:pan];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *vc = segue.destinationViewController;
    vc.transitioningDelegate = transition;
    vc.modalPresentationStyle = UIModalPresentationCustom;
}
#pragma mark 界面样式设置
-(void)buildSettings{
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height-44)];
    [settingsView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    exampleSwitch =  [[UISwitch alloc]initWithFrame:CGRectMake(30, 30, 200, 20)];
    [exampleSwitch addTarget:self action:@selector(switchExample) forControlEvents:UIControlEventValueChanged];
    exampleSwitch.on = true;
    radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(exampleSwitch)+20, APPW-60, 20)];
    radiusSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, YH(radiusLabel)+10, W(settingsView)-60, 20)];
    [radiusSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    angularSpacingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(radiusSlider)+20, 100, 20)];
    angularSpacingSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, YH(angularSpacingLabel)+10, W(settingsView)-60, 20)];
    [angularSpacingSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    xOffsetLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, YH(angularSpacingSlider)+20, 100, 20)];
    xOffsetSlider =  [[UISlider alloc]initWithFrame:CGRectMake(30, YH(xOffsetLabel)+10, W(settingsView)-60, 20)];;
    [xOffsetSlider addTarget:self action:@selector(updateDialSettings) forControlEvents:UIControlEventValueChanged];
    
    [settingsView addSubviews:exampleSwitch,radiusLabel,radiusSlider,angularSpacingLabel,angularSpacingSlider,xOffsetLabel,xOffsetSlider,nil];
    [self.view addSubview:settingsView];
    dialLayout = [[XCollectionViewDialLayout alloc] initWithRadius:radiusSlider.value * 1000 andAngularSpacing:angularSpacingSlider.value * 90 andCellSize:CGSizeMake(240, 100) andAlignment:WHEELALIGNMENTCENTER andItemHeight:100 andXOffset:xOffsetSlider.value * 320];
    [homecollectionView setCollectionViewLayout:dialLayout];
}
-(void)switchExample{
    radiusSlider.value = 0.3;
    angularSpacingSlider.value = 0.2;
    xOffsetSlider.value = 0.6;
    if(exampleSwitch.on){
        [dialLayout setCellSize:CGSizeMake(240, 100)];
        [dialLayout setWheelType:WHEELALIGNMENTLEFT];
    }else{
        [dialLayout setCellSize:CGSizeMake(260, 50)];
        [dialLayout setWheelType:WHEELALIGNMENTCENTER];
    }
    [self updateDialSettings];
    [homecollectionView reloadData];
}
-(void)updateDialSettings{
    CGFloat radius = radiusSlider.value * 1000;
    CGFloat angularSpacing = angularSpacingSlider.value * 90;
    CGFloat xOffset = xOffsetSlider.value * 320;
    [radiusLabel setText:[NSString stringWithFormat:@"弧度: %i", (int)radius]];
    [dialLayout setDialRadius:radius];
    [angularSpacingLabel setText:[NSString stringWithFormat:@"间距: %i", (int)angularSpacing]];
    [dialLayout setAngularSpacing:angularSpacing];
    [xOffsetLabel setText:[NSString stringWithFormat:@"偏移量: %i", (int)xOffset]];
    [dialLayout setXOffset:xOffset];
    [dialLayout invalidateLayout];
}
-(void)showSettingsView:(UIButton*)sender{
    CGRect frame = settingsView.frame;
    if(showingSettings){
        frame.origin.y = self.view.frame.size.height+100;
    }else{
        frame.origin.y = 44;
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transition.edge = BOTTOM;
        transition.startingPoint = CGPointMake(settingsView.frame.origin.x+settingsView.frame.size.width/2.0, settingsView.frame.origin.y);
        //[self performSegueWithIdentifier:@"navigation" sender:self];
        settingsView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    showingSettings = !showingSettings;
}
#pragma mark - UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *controlName = [self.items[indexPath.row] valueForKey:@"control"];
      [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(![controlName isEqualToString:@"Sina"]){
    [self showStoryboardWithStoryboardName:controlName andViewIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]];
        return;
    }
    NSString *s =[NSString stringWithFormat:@"%@TabBarController",controlName];
    UIViewController *con = [[NSClassFromString(s) alloc]init];
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:con animated:NO completion:^{
    }];
    [SVProgressHUD showSuccessWithStatus:[self.items[indexPath.row] valueForKey:@"title"]];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.items objectAtIndex:indexPath.item];
    UIColor *color =[UIColor randomColor];
    if(exampleSwitch.on){
        CollectionViewCell1 *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        [cell setDataWithDic:dic andColor:color];
        return cell;
    }else{
        CollectionViewCell2 *cell = [cv dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
        [cell setDataWithDic:dic andColor:color];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
   // DLog(@"didEndDisplayingCell:%i", (int)indexPath.item);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(240, 100);
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}
#pragma mark others
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText.length) {
        [self readData];
        return;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"title CONTAINS %@ OR icon CONTAINS[c] %@ OR icon MATCHES %@", searchText, searchText,@"[F-j]+"];
    NSArray *b = [[User getControllerData]filteredArrayUsingPredicate:pre];
    self.items = [[NSMutableArray alloc] initWithArray:b];
    [homecollectionView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBa{
    [searchBar resignFirstResponder];
}
#pragma mark - 键盘显示/隐藏
//  键盘显示
- (void)keyBoardWillShow:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        _tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    }completion:^(BOOL finished) {
    }];
}
// 键盘隐藏
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        _tableView.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-20);
    }];
}
#pragma mark 下雪相关内容
-(void)tingzhixiaxue{
    [timer setFireDate:[NSDate distantFuture]];
}
-(void)kaishixiaxue{
    [timer setFireDate:[NSDate distantPast]];
}
//下雪
#define MAX_SIZE 10 //雪花大小
#define MAX_DURATION 10 //时长
#define MAX_OFFSET 100
#define DISAPPEAR_DURATION 2 //雪花融化的时长
-(void)snowAnimat:(NSTimer *)timer{
    count++;
    //    DLog(@"create:%d",self.count);
    //    DLog(@"view counts:%d",[self.view.subviews count]);
    //1.创建雪花
    UIImageView *snow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow.png"]];
    snow.tag = count;//区分不同的视图
    //创建下雪的位置
    int width = self.view.frame.size.width;
    int x = arc4random()%width;
    //创建雪花的大小 10~20
    int size = arc4random()%MAX_SIZE+MAX_SIZE;
    snow.frame = CGRectMake(x, -20, size, size);
    //将雪花放入到父视图中
    [self.view addSubview:snow];
    //a.设置动画开始
    [UIView beginAnimations:[NSString stringWithFormat:@"%d",count] context:nil];
    //b.设置属性
    //时长
    [UIView setAnimationDuration:arc4random()%MAX_DURATION+2];
    //越来越快
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //c.动画结束
    //雪花落地的位置 偏屏幕上面一点
    int offset = arc4random()%MAX_OFFSET - 50;
    snow.center = CGPointMake(snow.center.x+offset, self.view.bounds.size.height-10);
    //动画之后 设置委托 早期语法没有协议
    [UIView setAnimationDelegate:self];
    //动画结束之后发送消息
    [UIView setAnimationDidStopSelector:@selector(snowDisappear:)];
    //提交动画
    [UIView commitAnimations];
}
//区分不同的雪花动画
-(void)snowDisappear:(NSString *)animatedID{
    //    DLog(@"动画结束 雪花:%@",animatedID);
    //创建雪花消失动画
    [UIView beginAnimations:animatedID context:nil];
    [UIView setAnimationDuration:arc4random()%DISAPPEAR_DURATION+2];//2秒~4秒
    //越来越快 融化速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //雪花消失 动画
    //得到一个视图中子视图或者本视图
    UIView *view = [self.view viewWithTag:[animatedID intValue]];
    UIImageView *imageView = (UIImageView*)view;
    imageView.alpha = 0.0f;
    //设置委托 解决动画结束后 删除父视图中的子视图
    [UIView setAnimationDelegate:self];
    //动画结束时 向被委托对象发送消息
    [UIView setAnimationDidStopSelector:@selector(snowRemove:)];
    //动画结束
    [UIView commitAnimations];
}
//动画结束后 删除视图
-(void)snowRemove:(NSString*)animatedID{
    UIView *snow = [self.view viewWithTag:[animatedID intValue]];
    //转换动画标识 刚好与 视图标识相符合
    //    DLog(@"remove:%d",[animatedID intValue]);
    //查看view视图中 有多少子视图
    //    DLog(@"Remove before view counts:%d",[self.view.subviews count]);
    //将某个视图从父视图删除
    [snow removeFromSuperview];
    //    DLog(@"Remove after view counts:%d",[self.view.subviews count]);
}
#pragma mark View生存周期
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer setFireDate:[NSDate distantFuture]];
    [timer invalidate];
    timer = nil;
}
@end
