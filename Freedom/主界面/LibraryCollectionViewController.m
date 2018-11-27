//  LibraryCollectionViewController.m
//  Freedom
//  Created by Super on 16/6/24.
//  Copyright © 2016年 Super. All rights reserved.
#import "LibraryCollectionViewController.h"
#import "User.h"
@interface LibraryCollectionViewCell : BaseCollectionViewCell
@end
@implementation LibraryCollectionViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(0, 0, APPW/5, 80);
    self.icon.layer.cornerRadius = 40;
    self.icon.clipsToBounds = YES;
    self.title.frame = CGRectMake(0, YH(self.icon), W(self.icon), 20);
    self.title.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    [self addSubviews:self.icon,self.title,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = [dict valueForKey:@"title"];
    self.icon.image = [UIImage imageNamed:[dict valueForKey:@"icon"]];
}
@end
@interface LibraryCollectionViewController (){
    NSMutableArray *libraryBooks;
}
@end
@implementation LibraryCollectionViewController
@synthesize contentLength, dismissByBackgroundDrag, dismissByBackgroundTouch, dismissByForegroundDrag;
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentLength = APPW;
        self.dismissByBackgroundTouch   = YES;
        self.dismissByBackgroundDrag    = YES;
        self.dismissByForegroundDrag    = YES;
    }return self;
}
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(APPW/5, 100);
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 30;
    layout.sectionInset = UIEdgeInsetsMake(30, 10, 0, 10);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.backgroundColor = whitecolor;
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, APPW, APPH-100)];
    backView.image = [UIImage imageNamed:@""];
    self.collectionView.backgroundView = backView;
    ElasticTransition *ET = (ElasticTransition*)self.transitioningDelegate;
    DLog(@"\ntransition.edge = %@\ntransition.transformType = %@\ntransition.sticky = %@\ntransition.showShadow = %@", [HelperFunctions typeToStringOfEdge:ET.edge], [ET transformTypeToString], ET.sticky ? @"YES" : @"NO", ET.showShadow ? @"YES" : @"NO");
    
    libraryBooks = [NSMutableArray arrayWithArray:[User getControllerData]];
    [self.collectionView registerClass:[LibraryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return libraryBooks.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[LibraryCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, APPW/5, 100)];
    }
    [cell setCollectionDataWithDic:libraryBooks[indexPath.item]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *controlName = [libraryBooks[indexPath.row] valueForKey:@"control"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(![controlName isEqualToString:@"Sina"]){
        UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:controlName bundle:nil];
        [self showViewController:[StoryBoard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@TabBarController",controlName]] sender:self];
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
    [SVProgressHUD showSuccessWithStatus:[libraryBooks[indexPath.row] valueForKey:@"title"]];
}
#pragma mark <UICollectionViewDelegate>
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return NO;
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return NO;
//}
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(APPW/5, 80);
//}
@end
