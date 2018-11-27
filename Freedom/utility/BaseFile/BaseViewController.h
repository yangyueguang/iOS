/*
 这里的tabaleview只需要创建之后调用fillTheTableDataWithHeadV最后设置代理即可，需要的话有些方法重写。*/
#import <UIKit/UIKit.h>
#import <BaseTableView/BaseTableView.h>
#import <BaseScrollView/BaseScrollView.h>
#import <BaseCollectionView/BaseCollectionView.h>
#import "NSDictionary+expanded.h"
#import "AppDelegate.h"
#import "CKRadialMenu.h"
@interface BaseViewController : UIViewController<CKRadialMenuDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) id  userInfo;
@property (nonatomic,strong) id  otherInfo;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) BaseCollectionView *collectionView;
@property (nonatomic,strong) NSString *collectionReuseId;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other;
- (BaseViewController*)pushController:(Class)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHidden:(BOOL)abool;
- (BaseViewController*)pushController:(BaseViewController*)controller withInfo:(id)info withTitle:(NSString*)title withOther:(id)other tabBarHid:(BOOL)abool;
- (void)goback;
- (void)backToHomeViewController;
- (void)popToControllerNamed:(NSString*)controller;
- (void)popToTheControllerNamed:(id)controller;
- (void)popToControllerNamed:(NSString*)controllerstr withSel:(SEL)sel withObj:(id)info;
- (void)fillTheTableDataWithHeadV:(UIView*)head footV:(UIView*)foot canMove:(BOOL)move canEdit:(BOOL)edit headH:(CGFloat)headH footH:(CGFloat)footH rowH:(CGFloat)rowH sectionN:(NSInteger)sectionN rowN:(NSInteger)rowN cellName:(NSString*)cell;
- (void)fillTheCollectionViewDataWithCanMove:(BOOL)move sectionN:(NSInteger)sectionN itemN:(NSInteger)itemN itemName:(NSString*)item;
#pragma mark UItableViewDelegagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
///子类重写
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
//子类重写
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
#pragma mark others
-(void)presentStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier;
-(void)showStoryboardWithStoryboardName:(NSString*)story andViewIdentifier:(NSString*)identifier;
- (void)addFloatView;
- (void)showRadialMenu;
- (void)readData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong)CKRadialMenu* radialView;
@end
