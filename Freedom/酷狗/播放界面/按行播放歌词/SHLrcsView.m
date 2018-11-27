
#import "SHLrcsView.h"
@interface SHLrcLine : NSObject
/**
 * 播放时间点*/
@property(nonatomic,strong) NSString *time;
/**
 * 歌词内容*/
@property(nonatomic,strong) NSString *words;
@end
@implementation SHLrcLine
@end
@interface SHMusicLrcCell : UITableViewCell
/**
 * */
@property(nonatomic,strong) SHLrcLine *message;
@property(nonatomic,strong) UILabel *lrcLabel;
- (void)settingCurrentTextColor;
- (void)settingLastTextColor;
@end
@implementation SHMusicLrcCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
//自定义cell，设置label属性
- (void)setMessage:(SHLrcLine *)message{
    self.lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.lrcLabel.font = [UIFont systemFontOfSize:17];
    self.lrcLabel.text = message.words;
    self.lrcLabel.textColor = [UIColor purpleColor];
    self.lrcLabel.textAlignment = NSTextAlignmentCenter;
    self.lrcLabel.textColor = [UIColor lightTextColor];
    [self.contentView addSubview:self.lrcLabel];
}
- (void)settingCurrentTextColor{
    self.lrcLabel.textColor = [UIColor redColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:25];
}
- (void)settingLastTextColor{
    self.lrcLabel.textColor = [UIColor lightTextColor];
    self.lrcLabel.font = [UIFont systemFontOfSize:17];
}
@end
@interface SHLrcsView ()<UITableViewDataSource,UITableViewDelegate>
/**
 * 显示歌词的tableView*/
@property(nonatomic,strong) UITableView *tableView;
/**
 * 保存歌词的数组，每个元素就是一行歌词*/
@property(nonatomic,strong) NSMutableArray *lrclines;
//当前正在播放的那一行歌词
@property(nonatomic)NSInteger currentIdx;
@end
@implementation SHLrcsView
-(NSMutableArray *)lrclines{
    if (!_lrclines) {
        _lrclines=[[NSMutableArray alloc]init];
    }
    return _lrclines;
}
//- (NSMutableArray *)lrclines{
//    if (!_lrclines) {
//        _lrclines = [NSMutableArray array];
//    }
//    return _lrclines;
//}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
}
-(void)layoutSubviews{
    self.tableView.frame = self.bounds;
    //设置歌词显示居中位置
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.frame.size.height * 0.5, 0, self.tableView.frame.size.height * 0.5, 0);
}
/**
 * 对lrc格式解析歌词*/
- (void)setLrcname:(NSString *)lrcname{
    _lrcname = lrcname;
    //读取歌词文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcname withExtension:nil];
    NSString *lrcString= [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcs = [lrcString componentsSeparatedByString:@"\n"];
    //把每一行歌词放入数组中
    for (NSString *lrcComp in lrcs) {
        SHLrcLine *line = [[SHLrcLine alloc] init];
        [self.lrclines addObject:line];
        if (![lrcComp hasPrefix:@"["]) continue;
        if ([lrcComp hasPrefix:@"[ti:"] || [lrcComp hasPrefix:@"[ar:"] || [lrcComp hasPrefix:@"[al:"] || [lrcComp hasPrefix:@"[t_time:"]) {
            NSString *words = [[lrcComp componentsSeparatedByString:@":"]lastObject];
            line.words = [words substringFromIndex:1];
        }else{
            NSArray *array = [lrcComp componentsSeparatedByString:@"]"];
            line.time = [[array firstObject] substringFromIndex:1];
            line.words = [array lastObject];
        }
    }
    if (!lrcs) {
        self.lrclines = nil;
    }
    [self.tableView reloadData];
}
/**
 * 滚动歌词，设置播放当前行属性*/
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    int min = currentTime / 60;
    int sec = (int)currentTime % 60;
    int msec = (currentTime - (int)currentTime % 60) * 100;
    //歌曲正在播放的时间
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",min,sec,msec];
    for (int idx = 0; idx < self.lrclines.count; idx++) {
        SHLrcLine *line = self.lrclines[idx];
        NSString *lineTime = line.time;
        NSString *nextLineTime = nil;
        NSInteger nextIdx = idx + 1;
        if (nextIdx < self.lrclines.count) {
            SHLrcLine *nextLine = self.lrclines[nextIdx];
            nextLineTime = nextLine.time;
        }
        NSString *lastLineTime = nil;
        NSInteger lastIdx = idx - 1;
        if (lastIdx > 0) {
            SHLrcLine *lastLine = self.lrclines[lastIdx];
            lastLineTime = lastLine.time;
        }
        NSIndexPath *p1 = [NSIndexPath indexPathForRow:idx inSection:0];
        NSIndexPath *p2 = [NSIndexPath indexPathForRow:nextIdx inSection:0];
        SHMusicLrcCell *cell = nil;
        //判断这一行是否是正在播放的那一行
        if ([currentTimeStr compare:lineTime] != NSOrderedAscending && [currentTimeStr compare:nextLineTime] == NSOrderedAscending && self.currentIdx != idx) {
            [self.tableView reloadRowsAtIndexPaths:@[p1,p2] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView scrollToRowAtIndexPath:p1 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            cell = (SHMusicLrcCell *)[self.tableView cellForRowAtIndexPath:p1];
            [cell settingCurrentTextColor];
            self.currentIdx = idx;
        }else if ([currentTimeStr compare:nextLineTime] == NSOrderedDescending && self.currentIdx != nextIdx){
            cell = (SHMusicLrcCell *)[self.tableView cellForRowAtIndexPath:p2];
            [cell settingLastTextColor];
        }
    }
}
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrclines.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHMusicLrcCell *cell = [[SHMusicLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.message = self.lrclines[indexPath.row];
    return cell;
}
@end
