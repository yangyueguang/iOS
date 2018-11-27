//  JuheDynamicViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "JuheDynamicViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface JuheDynamicCollectionViewCell : BaseCollectionViewCell{
    NSMutableDictionary *thumbnailCache;
}
@end
@implementation JuheDynamicCollectionViewCell
-(void)initUI{
    self.backgroundColor = whitecolor;
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, W(self)-20,H(self)-20)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, YH(self.icon), W(self)-20, 20)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = fontnomal;
    self.title.backgroundColor = redcolor;
    self.title.textColor = whitecolor;
    self.title.layer.cornerRadius = 5;
    self.title.clipsToBounds = YES;
    UILabel *labe = [UILabel labelWithFrame:CGRectMake(5, 5, 40, 20) font:fontnomal color:whitecolor text:@"VIP"];
    labe.numberOfLines = 0;
    [self addSubviews:self.icon,self.title,labe,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = dict[@"name"];
    NSString *imgURL = [dict valueForKey:@"pic"];
    __block UIImage *imageProduct = [thumbnailCache objectForKey:imgURL];
    if(imageProduct){
        self.icon.image = imageProduct;
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageNamed:imgURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.icon.image = image;
                [thumbnailCache setValue:image forKey:imgURL];
            });
        });
    }
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor redColor].CGColor);
    CGContextMoveToPoint(context, 40, 0);
    CGContextAddLineToPoint(context, 0, 40);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}
@end
@implementation JuheDynamicViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self buildUI];
}
#pragma mark 搭建UI界面
-(void)buildUI{
    self.title = @"聚合动态";
    UIImageView *backimagev = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backimagev.image = [UIImage imageNamed:@"backgroundImage.jpg"];
    backimagev.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backimagev];
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 110) groupInset:UIEdgeInsetsMake(10, 10, 0, 10) itemSpace:10 linespace:10];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, APPH-360, APPW, 300) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:
                                     @{@"name":@"身份证认证",@"pic":@"juheintopublic"},@{@"name":@"手机归属地",@"pic":@"juhelookhistory"},@{@"name":@"身份证查询",@"pic":@"juheaboutus"},@{@"name":@"常用快递",@"pic":PuserLogo},
                                     @{@"name":@"餐饮美食",@"pic":PuserLogo},@{@"name":@"菜谱大全",@"pic":PuserLogo},@{@"name":@"彩票开奖",@"pic":PuserLogo},@{@"name":@"邮编查询",@"pic":PuserLogo}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:1 itemN:8 itemName:@"JuheDynamicCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = clearcolor;
    self.collectionView.scrollEnabled = NO;
    [self.view addSubviews:self.collectionView,nil];
}
@end
