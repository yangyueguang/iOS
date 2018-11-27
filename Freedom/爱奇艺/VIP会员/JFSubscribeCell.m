//  JFSubscribeCell.m
//  Freedom
//  Created by Freedom on 15/10/16.
#import "JFSubscribeCell.h"
@implementation JFSubItemModel
@end
@implementation JFSubscribeModel
@end
@class JFSubScribeCardView,JFSubItemModel;
@protocol JFSubImageScrollViewDelegate <NSObject>
@optional
-(void)didSelectSubScrollView:(JFSubScribeCardView *)subScrollView subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubImageScrollView : UIView
@property(nonatomic, weak) id <JFSubImageScrollViewDelegate>delegate;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *dataArray;
@end
@class JFSubItemModel,JFSubScribeCardView;
@protocol JFSubScribeCardViewDelegate <NSObject>
-(void)didSelectSubImageCard:(JFSubScribeCardView *)subImageCard subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubScribeCardView : UIView
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UILabel *cardLabel;
@property(nonatomic, strong) JFSubItemModel *subItem;
@property(nonatomic, weak) id<JFSubScribeCardViewDelegate>delegate;
@end
@implementation JFSubScribeCardView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.cardImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
        self.cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 20)];
        [self addSubviews:self.cardImageView,self.cardLabel,nil];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-5, frame.size.height-30)];
        [self addSubview:self.imageView];
        
        //
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-30, frame.size.width-5, 30)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        //        self.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:self.titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageCard:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)setSubItem:(JFSubItemModel *)subItem{
    _subItem = subItem;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:subItem.picurl] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    self.titleLabel.text = subItem.title;
    //    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:subItem.picurl]  placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    //    self.cardLabel .text = subItem.title;
}
-(void)TapImageCard:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(didSelectSubImageCard:subItem:)]) {
        [self.delegate didSelectSubImageCard:self subItem:self.subItem];
    }
}
@end
@interface JFSubImageScrollView ()<JFSubScribeCardViewDelegate>
@end
@implementation JFSubImageScrollView
-(JFSubImageScrollView*)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(2*APPW, frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        //card
        float cardWidth = (APPW*2-15)/3;
        
        for (int i = 0; i < 3; i++) {
            JFSubScribeCardView *card = [[JFSubScribeCardView alloc] initWithFrame:CGRectMake(cardWidth*i, 0, cardWidth, frame.size.height)];
            
            card.frame = CGRectMake((cardWidth+5)*i +5, 0, cardWidth, frame.size.height);
            card.tag = 20+i;
            [self.scrollView addSubview:card];
            card.delegate = self;
        }
    }
    return self;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (int i = 0; i < 3; i++) {
        JFSubItemModel *item = dataArray[i];
        JFSubScribeCardView *card = (JFSubScribeCardView *)[self.scrollView viewWithTag:20+i];
        [card setSubItem:item];
    }
}
-(void)didSelectSubImageCard:(JFSubScribeCardView *)subImageCard subItem:(JFSubItemModel *)subItem{
    if ([self.delegate respondsToSelector:@selector(didSelectSubScrollView:subItem:)]) {
        [self.delegate didSelectSubScrollView:subImageCard subItem:subItem];
    }
}
@end
@interface JFSubscribeCell ()<JFSubImageScrollViewDelegate>{
    NSMutableArray *_items;
    JFSubImageScrollView *_scrollV;
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_subedLabel;
    UIButton *_dingyueBtn;
}
@end
@implementation JFSubscribeCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        [self initViews];
    }
    return self;
}
-(void)initViews{
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPW, 210)];
    backview.backgroundColor = [UIColor whiteColor];
    [self addSubview:backview];
    
    //
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = YES;
    [backview addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 120, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [backview addSubview:_titleLabel];
    
    _subedLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 120, 25)];
    _subedLabel.font = [UIFont systemFontOfSize: 12];
    _subedLabel.textColor = [UIColor lightGrayColor];
    [backview addSubview:_subedLabel];
    
    _dingyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dingyueBtn.frame = CGRectMake(APPW-10-70, 10, 70, 29);
    [_dingyueBtn setImage:[UIImage imageNamed:@"search_channel_subscribe_noPlay"] forState:UIControlStateNormal];
    [_dingyueBtn setImage:[UIImage imageNamed:@"search_channel_subscribed"] forState:UIControlStateSelected];
    [backview addSubview:_dingyueBtn];
    
    //
    _scrollV = [[JFSubImageScrollView alloc] initWithFrame:CGRectMake(0, 55, APPW, 155)];
    _scrollV.delegate = self;
    [backview addSubview:_scrollV];
    
}
-(void)setSubscribeM:(JFSubscribeModel *)subscribeM{
    _subscribeM = subscribeM;
    [_items removeAllObjects];
    for (int i = 0; i < subscribeM.last_item.count; i++) {
        JFSubItemModel *item = [JFSubItemModel mj_objectWithKeyValues:subscribeM.last_item[i]];
        [_items addObject:item];
    }
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:subscribeM.image] placeholderImage:[UIImage imageNamed:@"rec_holder"]];
    _titleLabel.text = subscribeM.title;
    _subedLabel.text = [NSString stringWithFormat:@"订阅 %@", subscribeM.subed_count];
    [_scrollV setDataArray:_items];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)didSelectSubScrollView:(JFSubScribeCardView *)subScrollView subItem:(JFSubItemModel *)subItem{
    if ([self.delegate respondsToSelector:@selector(didSelectSubscribeCell:subItem:)]) {
        [self.delegate didSelectSubscribeCell:self subItem:subItem];
    }
    
}
@end
