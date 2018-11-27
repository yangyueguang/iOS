//  PlayAudioViewController.m
//  我的酷狗
//  Created by Super on 16/8/29.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "PlayAudioViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSData+KRCParse.h"
#import "Freedom-Swift.h"
@interface KRC : NSObject{
    //FileStream fs;
    //头部4字节
    NSMutableData * HeadBytes;
    //异或加密内容
    NSMutableData * EncodedBytes;
    //解异或加密后ZIP数据
    NSMutableData * ZipBytes;
    //UNZIP后数据
    NSData * UnzipBytes;
}
- (NSString *) Decode: (NSString * )filePath;
@end
@implementation KRC
//异或加密 密钥
- (NSString *) Decode: (NSString * )filePath{
    NSString * EncKey = @"@Gaw^2tGQ61-ÎÒni";
    //char EncKey[] = { '@', 'G', 'a', 'w', '^', '2', 't', 'G', 'Q', '6', '1', '-', 'Î', 'Ò', 'n', 'i' };
    NSData * totalBytes = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    //HeadBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(0, 4)]];
    EncodedBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(4, totalBytes.length - 4)]];
    ZipBytes = [[NSMutableData alloc] initWithCapacity:EncodedBytes.length];
    Byte * encodedBytes = EncodedBytes.mutableBytes;
    int EncodedBytesLength = EncodedBytes.length;
    for (int i = 0; i < EncodedBytesLength; i++){
        int l = i % 16;
        char c = [EncKey characterAtIndex:l];
        Byte b = (Byte)((encodedBytes[i]) ^ c);
        [ZipBytes appendBytes:&b length:1];
    }
    UnzipBytes = [NSData gtm_dataByInflatingData:ZipBytes];
    NSString *s = [[NSString alloc] initWithData:UnzipBytes encoding:NSUTF8StringEncoding];
    return s;
}
@end
@interface LyricsUtil : NSObject
//根据每行歌词得到相应行的给个字的时间点数组
+(NSMutableArray *)timeArrayWithLineLyric:(NSString *)lineLyric;
//得到每一行开始时间的数组
+(NSMutableArray *)startTimeArrayWithLineLyric:(NSString *)lineLyric;
//得到不带时间的歌词
+(NSMutableString *)getLyricStringWithLyric:(NSString *)lineLyric;
//得到歌词的总行
+(int)getLyricLineNumWithLyric:(NSString *)lineLyric;
//得到不带时间的歌词的数组
+(NSMutableArray *)getLyricSArrayWithLyric:(NSString *)lineLyric;
//得到每行歌词有多少个字的数组
+(NSMutableArray *)getLineLyricWordNmuWithLyric:(NSString *)lineLyric;
//得到最大行的字体个数
+(int)getMaxLineNumWithArray:(NSMutableArray *)lineNumArray;
@end
@implementation LyricsUtil
//拿到krc歌词，返回每句歌词的当个字time组成的数据，只针对krc
+(NSMutableArray *)timeArrayWithLineLyric:(NSString *)lineLyric{
    //去掉前面没用的歌词
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    //把krc歌词每个单词的time的最后一个,0 去掉。
    NSString * lineLyricd= [LyricBody stringByReplacingOccurrencesOfString:@",0>" withString:@">"];
    DLog(@"%@",lineLyricd);
    //最后返回的时间数组，包含每一行数组的数组
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //    //单个句歌词的时间数组
    //    NSMutableArray * oneLineArray = [[NSMutableArray alloc]init];
    //把歌词按行分成数组
    NSArray *lineArray = [lineLyricd componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        //单个句歌词的时间数组
        NSMutableArray * oneLineArray = [[NSMutableArray alloc]init];
        [oneLineArray removeAllObjects];
        //截取总时间以后的字符串，因为我要返回每个字的时间数组
        NSRange start = [lineArray[i] rangeOfString:@"]"];
        NSString *sub = [lineArray[i] substringFromIndex:start.location+1];
        DLog(@"%@", sub);
        //把sub按>分成数组
        NSArray * array = [sub componentsSeparatedByString:@">"];
        for (int y = 0; y<array.count-1; y++) {
            //取出每个单词的开始时间
            NSRange start = [array[y] rangeOfString:@"<"];
            NSRange end = [array[y] rangeOfString:@","];
            NSString *sub1 = [array[y] substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
            [oneLineArray addObject:sub1];
        }
        //因为最后一个时间没取到，在这里拿到最后一个单词的延长时间加上最后一个单词的开始时间为最终时间，加到oneLineArray数组的后面
        NSRange start1 = [array[array.count-2] rangeOfString:@","];
        NSString *sub2 = [array[array.count-2] substringFromIndex:start1.location+1];
        NSString * lastTime = oneLineArray[oneLineArray.count-1];
        int sub2N = [sub2 intValue];
        int lastTimeN = [lastTime intValue];
        int lastN = sub2N + lastTimeN;
        NSString * lastStr = [NSString stringWithFormat:@"%d",lastN];
        [oneLineArray addObject:lastStr];
        [timeArray addObject:oneLineArray];
    }
    DLog(@"%@",timeArray);
    return timeArray;
}
//得到每一行开始时间的数组,可根据时间判断换行
+(NSMutableArray *)startTimeArrayWithLineLyric:(NSString *)lineLyric{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    NSMutableArray * stratTimeArray = [[NSMutableArray alloc]init];
    NSArray *array = [LyricBody componentsSeparatedByString:@"\n"];
    for (int i = 1; i<array.count-1; i++) {
        //截取每行的开始时间
        NSRange start = [array[i] rangeOfString:@"["];
        NSRange end = [array[i] rangeOfString:@","];
        NSString *sub = [array[i] substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
        DLog(@"%@", sub);
        [stratTimeArray addObject:sub];
    }
    DLog(@"%@",stratTimeArray);
    return stratTimeArray;
}
//得到不带时间的歌词
+(NSMutableString *)getLyricStringWithLyric:(NSString *)lineLyric{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    NSMutableString * LyricStr = [[NSMutableString alloc]init];
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        DLog(@"%@",array);
        NSString * lineStr = [NSString string];
        for (int y=1; y<array.count; y++) {
            NSRange start = [array[y] rangeOfString:@">"];
            NSString *sub1 = [array[y] substringFromIndex:start.location+1];
            lineStr = [lineStr stringByAppendingString:sub1];
            DLog( @"%@",sub1);
        }
        [LyricStr appendString:lineStr];
        [LyricStr appendString:@"\n"];
        
    }
    return LyricStr;
}
//得到不带时间的歌词的数组
+(NSMutableArray *)getLyricSArrayWithLyric:(NSString *)lineLyric{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    NSMutableArray * lyricSArray = [[NSMutableArray alloc]init];
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        DLog(@"%@",array);
        NSString * lineStr = [NSString string];
        for (int y=1; y<array.count; y++) {
            NSRange start = [array[y] rangeOfString:@">"];
            NSString *sub1 = [array[y] substringFromIndex:start.location+1];
            lineStr = [lineStr stringByAppendingString:sub1];
            DLog( @"%@",sub1);
            
        }
        [lyricSArray addObject:lineStr];
    }
    return lyricSArray;
}
//得到歌词的总行
+(int)getLyricLineNumWithLyric:(NSString *)lineLyric{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    int lineNum;
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    lineNum = lineArray.count -2;
    return lineNum;
}
//得到每行歌词有多少个字的数组
+(NSMutableArray *)getLineLyricWordNmuWithLyric:(NSString *)lineLyric{
    NSMutableArray * wordNumArray = [[NSMutableArray alloc]init];
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        int num = array.count-1;
        NSString * sNum = [NSString stringWithFormat:@"%d",num];
        [wordNumArray addObject:sNum];
    }
    return wordNumArray;
}
//得到最大行的字体个数
+(int)getMaxLineNumWithArray:(NSMutableArray *)lineNumArray{
    int max;
    max = [[lineNumArray valueForKeyPath:@"@max.intValue"] intValue];
    return max;
}
@end
@interface LyricsAndTime : NSObject
@property NSString *lyric;
@property NSString *myTime;
- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time;
- (NSString *)description;
- (BOOL)islater:(LyricsAndTime *)obj;
@end
@interface KugouLyricsManage : NSObject
@property NSMutableArray *arr;
@property NSString *str;
@property NSString *path;
- (id)init;
- (void)readFile;
- (void)sort;
- (void)play;
@end
@implementation LyricsAndTime
- (id)initWithLyrics:(NSString *)lyric andTime:(NSString *)time{
    self = [super init];
    if (self) {
        _lyric = lyric;
        _myTime = time;
    }
    return self;
}
- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"%@  %@",_myTime,_lyric];
    return str;
}
- (BOOL)islater:(LyricsAndTime *)obj{
    return [self.myTime compare: obj.myTime]>0;
}
@end
@implementation KugouLyricsManage
- (id)init{
    self = [super init];
    if (self) {
        _arr = [[NSMutableArray alloc] init];
        _path = [[NSString alloc] init];
    }
    return self;
}
- (void)readFile{
    NSError *error;
    NSString *str = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        DLog(@"%@",error);
    }
    NSArray *arr = [[NSArray alloc] init];
    arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    NSString *song = [arr[1] substringFromIndex:[arr[1]rangeOfString:@":"].location+1];
    NSString *singer = [arr[3] substringFromIndex:[arr[3]rangeOfString:@":"].location+1];
    _str = [NSString stringWithFormat:@"%@%@",song,singer];
    
    for (NSUInteger i = 9; i < [arr count]; i+=2) {
        NSUInteger x = 1;
        while ([arr[i+x] isEqualToString:@""]) {
            x += 2;
        }
        LyricsAndTime *obj = [[LyricsAndTime alloc] initWithLyrics:arr[i+x] andTime:arr[i]];
        [_arr addObject:obj];
    }
}
- (void)sort{
    [_arr sortUsingSelector:@selector(islater:)];
}
- (void)play{
    DLog(@"%@",_str);
    float temp = 0;
    for (id obj in _arr) {
        DLog(@"%@",obj);
        float x = [[obj myTime] intValue]*60 + [[[obj myTime] substringFromIndex:3] floatValue];
        sleep(x-temp);
        temp = x;
    }
}
@end
@interface LyricsView : UIView
@property (strong, nonatomic)  UILabel *textLable;
@property (strong, nonatomic)  UILabel *maskLable;
@property (nonatomic, strong) CALayer *maskLayer;//用来控制maskLabel渲染的layer
- (void)setFont:(UIFont *)font;
- (void)setText:(NSString *)text;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
/*根据设置显示动画
 *
 *  @param timeArray     数组的内容是各个时间点，第一个必须是0，最后一个必须是总时间
 *  @param locationArray 对应各个时间点的位置，值从0~1，第一个必须是0，最后一个必须是1*/
- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray;
- (void)stopAnimation;
- (void)reAnimation;
- (void)setupDefault;
@end
@interface LyricsView ()
@end
@implementation LyricsView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLable];
        [self addSubview:self.maskLable];
        [self setupDefault];
    }
    return self;
}
- (void)setupDefault {
    //self.textLable.backgroundColor = [UIColor redColor];
    self.textLable.textColor = [UIColor whiteColor];
    self.maskLable.textColor = [UIColor greenColor];
    self.maskLable.backgroundColor = [UIColor clearColor];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.anchorPoint = CGPointZero;//注意，按默认的anchorPoint，width动画是同时像左右扩展的
    //每次变色的位置，换行一次这个也要变
    maskLayer.position = CGPointMake(0,0);
    maskLayer.bounds = CGRectMake(0, 0, 0, 25);
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.maskLable.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
}
- (void)setFont:(UIFont *)font {
    self.textLable.font = font;
    self.maskLable.font = font;
}
///定义两个lab的内容
- (void)setText:(NSString *)text {
    self.textLable.text = text;
    self.maskLable.text = text;
}
//定义lab的字体的位置
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.textLable.textAlignment = textAlignment;
    self.maskLable.textAlignment = textAlignment;
}
- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray {
    //每行歌词的时间总长
    CGFloat totalDuration = [timeArray.lastObject floatValue]*1.0/1000;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
    NSMutableArray *keyTimeArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    for (int i = 0 ; i < timeArray.count; i++) {
        CGFloat tempTime = [timeArray[i] floatValue] *1.0/1000/totalDuration;
        [keyTimeArray addObject:@(tempTime)];
        CGFloat tempWidth = [locationArray[i] floatValue] * CGRectGetWidth(self.maskLable.frame);
        [widthArray addObject:@(tempWidth)];
    }
    animation.values = widthArray;
    animation.keyTimes = keyTimeArray;
    animation.duration = totalDuration;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.maskLayer addAnimation:animation forKey:@"MaskAnimation"];
}
- (void)stopAnimation {
    //[self pauseLayer:self.maskLayer];
    [self.maskLayer removeAllAnimations];
    self.maskLayer=nil;
}
//暂停
-(void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
}
- (void)reAnimation{
    [self resumeLayer:self.maskLayer];
}
//恢复
-(void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
    layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
    layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}
#pragma mark - property
- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _textLable;
}
- (UILabel *)maskLable {
    if (!_maskLable) {
        _maskLable = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _maskLable;
}
@end
@interface PlayAudioViewController()<AVAudioPlayerDelegate>{
    BOOL _isPlaying;
    //歌词
    NSString * _lyrics;
    CGSize size;
    int time;
    //每句的时间数组
    NSMutableArray * _timeArray;
    //换行时间数组
    NSMutableArray * _startTimeArray;
    //纯歌词
    NSMutableString * _lyricsStr;
    //纯歌词数组
    NSMutableArray * _lyricsSArray;
    //每行歌词单词个数的数组
    NSMutableArray * _wordNumArray;
    //最大行的歌词的个数
    int _maxNum;
    CGSize lineSize;
}
@property (nonatomic, strong) LyricsView *lyricsView;//歌词视图，里面是两个lab
@property (nonatomic,weak) UIScrollView * backScrollView;//歌词滑动的ScrollView
@end
@implementation PlayAudioViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _index = 0;
        _modelIndex = 0;
    }return self;
}
+(id)shared{
    static PlayAudioViewController* _sington=nil;
    if (_sington==nil) {
        _sington=[[PlayAudioViewController alloc] init];
        _sington.view.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_sington.view];
        _sington.view.frame = CGRectMake(0, 0, APPW, APPH);
        _sington.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
    }return _sington;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"bj"]];
    [self.view addSubview:imageBgV];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    //设置旋转中心锚点
    self.view.layer.anchorPoint = CGPointMake(0.5, 2);
    
    _backLeft = NO;
    
    _labelSong = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 210, 40)];
    _labelSong.textAlignment = NSTextAlignmentCenter;
    _labelSong.text = @"歌名";
    _labelSong.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_labelSong];
    
    _labelSinger = [[UILabel alloc] initWithFrame:CGRectMake(220, 25, 200, 40)];
    _labelSinger.textAlignment = NSTextAlignmentCenter;
    _labelSinger.text = @"歌手";
    _labelSinger.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_labelSinger];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 60, 40)];
    label1.text = @"音量:";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, APPH-80, 50, 30)];
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.font = [UIFont systemFontOfSize:14];
    _label2.text = @"00:00";
    [self.view addSubview:_label2];
    
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(120, 270, 80, 30)];
    _label3.textAlignment = NSTextAlignmentCenter;
    _label3.font = [UIFont systemFontOfSize:14];
    _label3.text = @"10";
    [self.view addSubview:_label3];
    
    _label4 = [[UILabel alloc] initWithFrame:CGRectMake(APPW-60, APPH-80, 50, 30)];
    _label4.textAlignment = NSTextAlignmentCenter;
    _label4.font = [UIFont systemFontOfSize:14];
    _label4.text = @"00:00";
    [self.view addSubview:_label4];
    
    _lyricsLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 100)];
    _lyricsLB.textAlignment = NSTextAlignmentCenter;
    _lyricsLB.font = [UIFont systemFontOfSize:26];
    _lyricsLB.numberOfLines = 0;
    [self.view addSubview:_lyricsLB];
    
    _sliderProgress = [[UISlider alloc] initWithFrame:CGRectMake(60, APPH-85, 250, 40)];
    // 回调与事件
    [_sliderProgress addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    [_sliderProgress addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_sliderProgress addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sliderProgress];
    
    _sliderVolume = [[UISlider alloc] initWithFrame:CGRectMake(60, 30, 250, 40)];
    [_sliderVolume addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    _sliderVolume.value = 1;
    [self.view addSubview:_sliderVolume];
    
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.frame = CGRectMake(0, APPH-44,APPW, 44);
    [self.view addSubview:_toolBar];
    
    _btnPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    
    _btnPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(play)];
    
    _btnStop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop)];
    
    _btnRewind = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewind)];
    
    _btnFastForward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(fastForward)];
    
    _arrayModels = [NSArray arrayWithObjects:@"列表循环",@"顺序播放",@"单曲循环",@"单曲播放",@"随机播放", nil];
    _btnModel = [[UIBarButtonItem alloc] initWithTitle:_arrayModels[_modelIndex] style:UIBarButtonItemStylePlain target:self action:@selector(modelChange)];
    
    _btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
    _toolBar.items = arrayItems;
    
    _isPlay = NO;
    _isRandom = NO;
    _isNext = YES;
    _haveMusic = NO;
    _haveLyrics = NO;
    
    //    [self readData];
#pragma mark 以下是新增的逐词播放
    //拿到歌词
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lll.Krc" ofType:nil];
    
    KRC * krc = [KRC new];
    _lyrics = [krc Decode:path];
    
    //播放歌
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"vocal" withExtension:@"mp3"];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    _haveMusic=YES;
    _isPlaying = YES;
    //拿到歌词的所有数据
    [self getLyricsInfo];
    //创建ScrollView及其视图
    [self createBackScrollView];
}
//从本地读取全部歌曲
- (void)readData{
    _arraySongs = [[NSMutableArray alloc] init];
    _arraySingers = [[NSMutableArray alloc] init];
    //单例方法,创建管理文件的单例方法
    NSFileManager *fm = [NSFileManager defaultManager];
    //    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/GKMusic.app"];
    //深度遍历(会去遍历当前目录下的子目录里的文件)
    NSArray *array = [fm subpathsOfDirectoryAtPath:DOCUMENTS_FOLDER error:nil];
    //    DLog(@"%@",array);
    for (NSString *str in array) {
        if ([str hasSuffix:@"mp3"]) {
            NSString *str2 = [str substringToIndex:[str rangeOfString:@".mp3"].location];
            //            NSString *string = [str2 substringFromIndex:[str2 rangeOfString:@"/"].location+1];
            NSString *string = str2;
            NSString *singer = nil;
            NSString *song = nil;
            if ([string rangeOfString:@"-"].length>0) {
                singer = [string substringToIndex:[string rangeOfString:@"-"].location-1];
                song = [string substringFromIndex:[string rangeOfString:@"-"].location+2];
            }else {
                singer = @"unknown";
                song = string;
            }
            [_arraySingers addObject:singer];
            [_arraySongs addObject:song];
        }
    }
    _songsCount = [NSString stringWithFormat:@"(%ld首)",_arraySongs.count];
    if (_arraySongs.count > 0) {
        _haveMusic = YES;
        _index = 0;
        [self readMusic];
    }
}
//读取指定歌曲
- (void)readMusic{
    _labelSong.text = _arraySongs[_index];
    _labelSinger.text = _arraySingers[_index];
    [self loadLyrics];//读取歌词
    NSString *str = [NSString stringWithFormat:@"%@ - %@",_arraySingers[_index],_arraySongs[_index]];
    NSString *strPath = [NSString stringWithFormat:@"%@/%@.mp3",DOCUMENTS_FOLDER,str];
    NSData *data = [NSData dataWithContentsOfFile:strPath];
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _audioPlayer.delegate = self;
    float duration = _audioPlayer.duration;
    int min = duration/60;
    int sec = duration - min*60;
    _label4.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    BOOL isReady = [_audioPlayer prepareToPlay];
    DLog(@"isReady = %d",isReady);
    if (!isReady) {
        if (_isNext) {
            [self fastForward];
        }else {
            [self rewind];
        }
    }
    // 在锁屏界面显示歌曲信息
    [self showInfoInLockedScreen];
}
/*在锁屏界面显示歌曲信息*/
- (void)showInfoInLockedScreen{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 标题(音乐名称)
    info[MPMediaItemPropertyTitle] = _labelSong.text;
    // 作者
    info[MPMediaItemPropertyArtist] = _labelSinger.text;
    // 专辑
    info[MPMediaItemPropertyAlbumTitle] = _labelSinger.text;
    // 图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
        return [UIImage imageNamed:@"CollectDetailPage_NoBackground.jpg"];
    }];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}
- (void)loadLyrics{
    NSString *path = [[NSBundle mainBundle] pathForResource:_labelSong.text ofType:@"lrc"];
    if (path) {
        _lrc = [[KugouLyricsManage alloc] init];
        _lrc.path = path;
        [_lrc readFile];
        [_lrc sort];
        _lyricsLB.text = _lrc.str;
        _lyricsLB.textColor = [UIColor greenColor];
        _haveLyrics = YES;
    } else {
        _lyricsLB.text = @"暂未找到歌词";
        _lyricsLB.textColor = [UIColor blackColor];
        _haveLyrics = NO;
    }
}
- (void)updateLyrics:(NSTimer *)timer{
    if (privateIndex < _lrc.arr.count) {
        float x = [[_lrc.arr[privateIndex] myTime] intValue]*60 + [[[_lrc.arr[privateIndex] myTime] substringFromIndex:3] floatValue];
        if (_audioPlayer.currentTime >= x) {
            _lyricsLB.text = [_lrc.arr[privateIndex] lyric];
            _lyricsLB.textColor = [UIColor greenColor];
            privateIndex++;
        }
    }
    if (privateIndex == _lrc.arr.count) {
        _lyricsLB.textColor = [UIColor redColor];
    }
}
- (void)lyricsPlay{
    if (_timer == nil) {
        privateIndex = 0;
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateLyrics:) userInfo:nil repeats:YES];
        NSRunLoop *runloop=[NSRunLoop currentRunLoop];
        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
        //开启定时器
        [_timer setFireDate:[NSDate distantPast]];
    }
}
-(void)lyricsPause{
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void)lyricsStop{
    [_timer invalidate];
    _timer = nil;
    _lyricsLB.text = _lrc.str;
    _lyricsLB.textColor = [UIColor greenColor];
}
//播放/暂停 按钮
- (void)play{
    if (!_haveMusic) {
        return;
    }
//    [[GKMainScrollViewController getMain] changeBarButton];
    
    if (!_isPlay) {
        if (_haveLyrics) {
            [self lyricsPlay];
        }
        [_audioPlayer play];
        _isPlay = YES;
        //设置监控 每秒刷新一次时间
        [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        if (self.lyricsView.maskLayer == nil) {
            [self.lyricsView setupDefault];
        }
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPause,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }else {
        if (_haveLyrics) {
            [self lyricsPause];
        }
        
        [_audioPlayer pause];
        
        [self.lyricsView stopAnimation];
        _isPlay = NO;
        NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
        _toolBar.items = arrayItems;
    }
}
//停止按钮
- (void)stop{
    if (!_haveMusic) {
        return;
    }
    if (_haveLyrics) {
        [self lyricsStop];
    }
    _isPlay = YES;
//    [[GKMainScrollViewController getMain] changeBarButton];
    NSArray *arrayItems = [NSArray arrayWithObjects:_btnModel,_btnSpace,_btnRewind,_btnSpace,_btnPlay,_btnSpace,_btnFastForward,_btnSpace,_btnStop,_btnSpace, nil];
    _toolBar.items = arrayItems;
    [_audioPlayer stop];
    _isPlay = NO;
    _label2.text = @"00:00";
    _audioPlayer.currentTime = 0;
    _sliderProgress.value = 0;
}
//上一曲
- (void)rewind{
    if (!_haveMusic) {
        return;
    }
    _isNext = NO;
    _index--;
    if (_index < 0) {
        _index = _arraySongs.count-1;
    }
    BOOL c = _isPlay;
    [self stop];
    [self readMusic];
    if (c) {
        [self play];
    }
}
//下一曲
- (void)fastForward{
    if (!_haveMusic) {
        return;
    }
    _isNext = YES;
    if (_isRandom) {
        _index = arc4random()%_arraySongs.count;
        BOOL c = _isPlay;
        [self stop];
        [self readMusic];
        if (c) {
            [self play];
        }
    }else{
        _index++;
        if (_index == _arraySongs.count) {
            _index = 0;
        }
        BOOL c = _isPlay;
        [self stop];
        [self readMusic];
        if (c) {
            [self play];
        }
    }
}
//刷新进度条
- (void)updateTimer:(NSTimer *)timer{
    if (!_isPlay) {
        [timer invalidate];
        timer = nil;
    }
    float progress = _audioPlayer.currentTime;
    float duration = _audioPlayer.duration;
    float value = progress/duration;
    _sliderProgress.value = value;
//    [GKMainScrollViewController getMain].progressView.progress = value;
    int min = progress/60;
    int sec = progress - min*60;
    _label2.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}
// 开始
- (void) startDrag:(UISlider *)slider{
    
}
//结束
- (void) endDrag:(UISlider *)slider{
    if (_haveLyrics) {
        for (int i = 0; i < _lrc.arr.count-1; i++) {
            float x = [[_lrc.arr[i] myTime] intValue]*60 + [[[_lrc.arr[i] myTime] substringFromIndex:3] floatValue];
            float y = [[_lrc.arr[i+1] myTime] intValue]*60 + [[[_lrc.arr[i+1] myTime] substringFromIndex:3] floatValue];
            if (_audioPlayer.currentTime >= x && _audioPlayer.currentTime < y) {
                privateIndex = i;
            }else if (_audioPlayer.currentTime >= y) {
                privateIndex = i + 1;
            }
        }
    }
}
//滑动进度条
- (void)progressChange:(UISlider *)slider{
    if (!_haveMusic) {
        return;
    }
    _audioPlayer.currentTime = slider.value*_audioPlayer.duration;
}
//滑动音量条
- (void)volumeChange:(UISlider *)slider{
    _audioPlayer.volume = slider.value;
    int value = 0;
    if (_audioPlayer.volume != 0) {
        if (_audioPlayer.volume != 1) {
            value = _audioPlayer.volume*10+1;
        }else {
            value = 10;
        }
    }
    _label3.text = [NSString stringWithFormat:@"%d",value];
}
//切换播放模式
- (void)modelChange{
    _modelIndex++;
    if (_modelIndex == _arrayModels.count) {
        _modelIndex = 0;
    }
    _isRandom = NO;
    if (_modelIndex == 4) {
        _isRandom = YES;
    }
    _btnModel.title = _arrayModels[_modelIndex];
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:_btnModel.title];
//    [MMProgressHUD dismissWithSuccess:nil];
}
//列表循环
- (void)model01{
    [self fastForward];
}
//顺序播放
- (void)model02{
    if (_index == _arraySongs.count-1) {
        [self stop];
    }else {
        [self fastForward];
    }
}
//单曲循环
- (void)model03{
    [self stop];
    [self play];
}
//单曲播放
- (void)model04{
    [self stop];
}
//随机播放
- (void)model05{
    [self fastForward];
}
#pragma mark - AVAudioPlayerDelegate
//一曲放完结束后
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
     DLog(@"播放结束");
    switch (_modelIndex) {
        case 0:[self model01];return;
        case 1:[self model02];return;
        case 2:[self model03];return;
        case 3:[self model04];return;
        case 4:[self model05];return;
    }
}
/*音乐播放器被打断(打\接电话)*/
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
      [_audioPlayer stop];//暂停而不是停止
    DLog(@"audioPlayerBeginInterruption---被打断");
}
/*音乐播放器停止打断(打\接电话)*/
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    DLog(@"audioPlayerEndInterruption---停止打断");
    if (_isPlaying) {
        [player play];//继续播放
    }
}
//直接收回页面
- (void)pressBack{
    [UIView animateWithDuration:0.3 animations:^{
         if (_backLeft) {
             self.view.transform = CGAffineTransformMakeRotation(-M_PI/5.5);
         }else {
             self.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
         }
     } completion:^(BOOL finished) {
     }];
}
- (void)pressList{
    
}
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recoginzer{
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (recoginzer.state == UIGestureRecognizerStateBegan){
        _isMoving = YES;
        _startTouch = touchPoint;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        //横向滑动速度
        CGFloat xVelocity = [recoginzer velocityInView: [[recoginzer view] superview]].x;
        if (touchPoint.x - _startTouch.x > 180||xVelocity > 1000){
            [UIView animateWithDuration:0.2 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI/5.5);
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backLeft = NO;
            }];
        }else if (touchPoint.x - _startTouch.x < -180||xVelocity < -1000){
            [UIView animateWithDuration:0.2 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI/5.5);
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backLeft = YES;
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                 self.view.transform = CGAffineTransformIdentity;
             } completion:^(BOOL finished) {
                 _isMoving = NO;
             }];
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _isMoving = NO;
        }];
        return;
    }
    if (_isMoving)
        [self moveViewWithX:touchPoint.x - _startTouch.x];
}
- (void)moveViewWithX:(float)x{
    double r = M_PI/6 * (x/320);
    self.view.transform = CGAffineTransformMakeRotation(r);
}
#pragma mark 以下是逐词播放
-(void)getLyricsInfo{
    //得到没句的时间
    _timeArray = [LyricsUtil timeArrayWithLineLyric:_lyrics];
    //得到换行时间
    _startTimeArray = [LyricsUtil startTimeArrayWithLineLyric:_lyrics];
    //得到纯歌词
    _lyricsStr = [LyricsUtil getLyricStringWithLyric:_lyrics];
    //得到纯歌词数组
    _lyricsSArray = [LyricsUtil getLyricSArrayWithLyric:_lyrics];
    //每行歌词单词个数的数组
    _wordNumArray = [LyricsUtil getLineLyricWordNmuWithLyric:_lyrics];
    _maxNum = [LyricsUtil getMaxLineNumWithArray:_wordNumArray];
}
-(void)createBackScrollView{
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    self.backScrollView = backScrollView;
    [self.view addSubview:backScrollView];
    backScrollView.frame = CGRectMake(0, 80, APPW, APPH-160);
    
    time = 0;
    LyricsView * lyricsView = [[LyricsView alloc] initWithFrame:CGRectMake(10, 100, 355, 60)];
    lyricsView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, 200);
    lyricsView.backgroundColor = [UIColor clearColor];
    //传过去两个lab的字体大小
    lyricsView.font = [UIFont systemFontOfSize:16];
    
    //把字符串传给两个lab
    lyricsView.text = _lyricsStr;
    //得到歌词的行数
    lyricsView.textLable.numberOfLines =[LyricsUtil getLyricLineNumWithLyric:_lyrics];
    lyricsView.maskLable.numberOfLines =[LyricsUtil getLyricLineNumWithLyric:_lyrics];
    
    //设置两个lab的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:lyricsView.textLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lyricsView.textLable.text length])];
    lyricsView.textLable.attributedText = attributedString;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:lyricsView.maskLable.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lyricsView.maskLable.text length])];
    lyricsView.maskLable.attributedText = attributedString1;
    lyricsView.textAlignment = NSTextAlignmentCenter;
    //正常步骤，知道歌词，知道lab字体大小算出歌词的
//    size = [_lyricsStr sizeWithFont:lyricsView.textLable.font
//                  constrainedToSize:(CGSize){lyricsView.textLable.frame.size.width, NSIntegerMax}
//                      lineBreakMode:lyricsView.textLable.lineBreakMode];
    
    NSDictionary *attributes = @{ NSFontAttributeName:lyricsView.textLable.font, NSParagraphStyleAttributeName:[[NSMutableParagraphStyle alloc]init]};
    size = [_lyricsStr boundingRectWithSize:(CGSize){lyricsView.textLable.frame.size.width, NSIntegerMax} options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    [self.backScrollView addSubview:lyricsView];
    self.lyricsView = lyricsView;
//    lineSize = [_lyricsSArray[0] sizeWithFont:self.lyricsView.textLable.font constrainedToSize:CGSizeMake(self.lyricsView.textLable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    NSDictionary *attributes1 = @{ NSFontAttributeName:self.lyricsView.textLable.font, NSParagraphStyleAttributeName:[[NSMutableParagraphStyle alloc]init]};
    lineSize = [_lyricsSArray[0] boundingRectWithSize:CGSizeMake(self.lyricsView.textLable.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes1 context:nil].size;
    
    size.height =(lineSize.height-9) * _lyricsSArray.count;
    self.backScrollView.contentSize = (CGSize){size.width, size.height+300};
    lyricsView.frame = CGRectMake(10, 10, APPW-20, size.height);
    [lyricsView.maskLable setFrame:CGRectMake(APPW/2-size.width/2, 0, size.width, size.height)];
    [lyricsView.textLable setFrame:CGRectMake(APPW/2-size.width/2, 0, size.width, size.height)];
}
//判断换行
-(void)changeTime{
    for (int i=0; i<_startTimeArray.count; i++) {
        int startTime = [_startTimeArray[i] intValue];
        float currentTime = startTime*1.0/1000;
        if (currentTime - _audioPlayer.currentTime>=0 && currentTime - _audioPlayer.currentTime<=0.02) {
            [self changeLineWithNmu:i];
        }
    }
}
//改变变色mask位置和动画传值
-(void)changeLineWithNmu:(int)num{
    self.lyricsView.maskLayer.position = CGPointMake(0,(lineSize.height-9)*(num));
    self.lyricsView.maskLayer.bounds = CGRectMake(0, 0, 0, lineSize.height-9);
    if (num >= 8) {
        [self.backScrollView setContentOffset:CGPointMake(0,(num-7)*(lineSize.height-9)+5) animated:YES];
    }
    //timeArray每行歌词的每个单词的开始时间，必须以0开头，总时间结尾
    NSArray *timeArray = _timeArray[num];
    NSMutableArray * timeSumArray = [[NSMutableArray alloc]init];
    int wordNmu = [_wordNumArray[num]intValue];
    int start =(_maxNum-wordNmu)/2;
    int end = start+wordNmu;
    for (int y=0; y<=_maxNum; y++) {
        if (y<=start) {
            [timeSumArray addObject:@"0"];
        }else if(y>end){
            [timeSumArray addObject:timeArray[timeArray.count-1]];
        }else{
            [timeSumArray addObject:timeArray[y-start-1]];
        }
    }
    NSArray * timeEndArray = timeSumArray;
    //计算
    //locationArray每行歌词的每个单词在相应时间时对应的位置，假设为1总长，在歌词view里用比例乘宽度得到位置
    NSMutableArray * localArray =[[NSMutableArray alloc]init];
    for (int i=0; i<=_maxNum; i++) {
        float n = i*1.0/_maxNum;
        NSString * wordSNum = [NSString stringWithFormat:@"%lf",n];
        [localArray addObject:wordSNum];
    }
    NSArray *locationArray = localArray;
    [self.lyricsView startLyricsAnimationWithTimeArray:timeEndArray andLocationArray:locationArray];
}
@end
