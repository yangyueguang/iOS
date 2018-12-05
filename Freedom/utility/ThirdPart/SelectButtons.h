//
//  SelectButtons.h
//  HTFProject
//
//  Created by htf on 2018/1/30.
//  Copyright © 2018年 htf. All rights reserved.
/*//使用范例
SBItem *item = [[SBItem alloc]initWithName:@"接触方式" key:@"接触方式" isCollectionType:YES netCompletBlock:^(NetCompletBlock block) {
    [[APIManager instance]getTypeWithTypeName:@"接触方式" htf:NO block:^(BaseTypes * types, StatusManager * status) {
         block([NSMutableArray array]);
    }];
}];
WS(weakSelf);
SelectButtons *sb = [[SelectButtons alloc]initWithFrame:CGRectMake(0, TopHeight, APPW, APPH) items:@[item]];
sb.sureBlock = ^(NSMutableArray<BaseType *> *types, NSString *key) {
};
*/
#import <UIKit/UIKit.h>
@interface BaseType : NSObject
@property (copy, nonatomic) NSString * _Nullable key;
@property (copy, nonatomic) NSString * _Nullable value;
@property (copy, nonatomic) NSString * _Nullable code;
@end

typedef void(^NetCompletBlock) (NSMutableArray<BaseType*>* result);
@interface SBItem:NSObject
@property(nonatomic,strong)NSString *name;//按钮显示的名字
@property(nonatomic,strong)NSString *key;//记录该对象存储的唯一标识||如果key=“noSort”则不使用自带的排序功能
@property(nonatomic,assign)NSInteger columns;//如果是集合视图，列数
@property(nonatomic,assign)CGFloat sectionH;//如果是列表视图，分区高度
@property(nonatomic,assign)BOOL isCollectionType;//是集合视图还是列表
@property(nonatomic,assign)BOOL isSingleSelect;//是单选还是多选
@property(nonatomic,assign)BOOL isLimited;//是否删除不限
@property(nonatomic,strong)NSMutableArray<BaseType*>* (^typesBlock)(NSString *key);//如果是本地数据可以直接赋值
//可选的  typesBlock和netCompletBlock二选一
@property(nonatomic,strong)void (^netCompletblock)(NetCompletBlock block);//网络传输语句写到这里
@property(nonatomic,strong)NSMutableArray<BaseType*> *types;//所有对象
@property(nonatomic,strong)NSMutableArray<BaseType*> *selectedItems;//被选择对象
@property(nonatomic,strong)NSMutableArray<BaseType*> *tempSItems;//操作时临时缓冲对象
@property(nonatomic,strong)NSMutableArray *setionTitleArray;//分区头部标题列表
@property(nonatomic,strong)NSMutableArray *resultArr;//列表分区内容集合
-(instancetype)initWithName:(NSString*)name key:(NSString*)key isCollectionType:(BOOL)ctype;
-(instancetype)initWithName:(NSString*)name key:(NSString*)key isCollectionType:(BOOL)ctype typesBlock:(NSMutableArray<BaseType*>* (^)(NSString *key))typesBlock;
-(instancetype)initWithName:(NSString*)name key:(NSString*)key isCollectionType:(BOOL)ctype netCompletBlock:(void(^) (NetCompletBlock block))netBlock;
@end
@interface SelectButtons : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray<SBItem*>*)items;
-(instancetype)initNavibarMenu:(CGRect)frame item:(SBItem*)item inVC:(UIViewController*)nvc;
-(instancetype)initSortView:(CGRect)frame item:(SBItem*)item inVC:(UIViewController*)nvc;
@property(nonatomic,strong)NSArray<SBItem*> *items;
@property(nonatomic,strong)void (^sureBlock)(NSMutableArray<BaseType*> *types,NSString *key);
///多余的
-(void)show;
-(void)hide;
-(void)showOrHid;
@property(nonatomic,strong)UIView *buttonView;
@end
