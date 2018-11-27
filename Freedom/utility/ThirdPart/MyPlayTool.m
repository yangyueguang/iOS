//
//  MyPlayTool.m
//  HappySing
//
//  Created by vochi on 16/7/25.
//  Copyright © 2016年 vochi. All rights reserved.
//

#import "MyPlayTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MyPlayTool ()
{
    NSDateFormatter *_dateFormatter;
}
@property (nonatomic ,strong) id playbackTimeObserver;

@property (nonatomic, assign) CGFloat currentPlayTime;
@property (nonatomic, assign) CGFloat cacheTime;

@property (nonatomic, strong) MPNowPlayingInfoCenter *infoCenter;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSTimer *timer;

@end

static MyPlayTool *instance;

@implementation MyPlayTool

//初始化单例
+(instancetype)sharePlayTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyPlayTool alloc]init];
        
        instance.isPlaying = NO;
        
    });
    return instance;
}

- (void)play
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self.player play];
    self.isPlaying = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateBackgoundMusicPlay) userInfo:nil repeats:YES];
}

- (void)pause
{
    [self.player pause];
    self.isPlaying = NO;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)stop
{
    self.player = nil;
    self.isPlaying = NO;
    
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)playAndRecord
{
    [self.player play];
    self.isPlaying = YES;
}

//播放本地音乐
-(void)loadLocalMusicUsePath:(NSString *)path {
    
    NSURL *musicUrl = [NSURL fileURLWithPath:path];
    
    self.playerItem = [[AVPlayerItem alloc] initWithURL:musicUrl];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem];
}

//播放网络音乐
- (void)loadNetworkMusicUseUrlStr:(NSString *)urlStr
{
    NSURL * url  = [NSURL URLWithString:urlStr];
    
    self.playerItem  = [[AVPlayerItem alloc]initWithURL:url];
    
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    else
    {
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    }
    
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem];
}

//播放网络视频
- (void)loadNetworkVideoUseUrlStr:(NSString *)urlStr
{

    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    else
    {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem];
}

//添加监听
- (void)addPlayObserver
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
}

//移除监听
- (void)removePlayObserver
{
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        [self.player removeTimeObserver:self.playbackTimeObserver];
    }
}

//改变视频进度
- (void)movePlayerToSliderValue:(CGFloat)currentSliderValue
{
    [self.player pause];
    
    CGFloat totalTime = CMTimeGetSeconds([self.player currentItem].duration);
    
    CGFloat currentSecond = totalTime * currentSliderValue;
    
    CMTime newCMTime = CMTimeMake(currentSecond, 1);

    [self.player seekToTime:newCMTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

#pragma mark - 播放结束时继续播放
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AVPlayerItem *playerItem = [self.player currentItem];
    [playerItem seekToTime: kCMTimeZero];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.player play];
    //监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerItemDidReachEnd:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerItem];
}

#pragma mark - 监听播放状态,卡顿继续播放
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            CMTime duration = self.playerItem.duration;// 获取视频总长度
//            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
//            NSLog(@"总进度:%lf", totalSecond);
            NSLog(@"movie 总进度:%f",CMTimeGetSeconds(duration));
            
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else if ([playerItem status] == AVPlayerStatusUnknown) {
            NSLog(@"AVPlayerStatusUnkown");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        self.cacheTime = timeInterval;
        
//        DebugLog(@"%lf^^^%lf", self.currentPlayTime, self.cacheTime);
        
        //如果卡住,等缓存大于播放进度0.5秒就继续播放
        if (self.cacheTime - self.currentPlayTime > 0.5) {
//            [self.player play];
        }
        else
        {
            NSLog(@"播放卡主了");
        }
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        weakSelf.currentPlayTime = currentSecond;

    }];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 刷新后台播放方法
- (void)updateBackgoundMusicPlay
{
    CGFloat currentTime = CMTimeGetSeconds([self.player currentItem].currentTime);
    CGFloat totalTime = CMTimeGetSeconds([self.player currentItem].duration);
    
    [self updateScreenMusicCurrentTime:currentTime AndTotalTime:totalTime];
}

//锁屏界面 显示歌曲基本信息
-(void)updateScreenMusicCurrentTime:(CGFloat)currentTime AndTotalTime:(CGFloat)totalTime
{
    
    self.infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    self.dict = [NSMutableDictionary dictionary];
    
    //设置当前时间
    self.dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(currentTime);
    
    //总时间
    self.dict[MPMediaItemPropertyPlaybackDuration]= @(totalTime);
    
//    DebugLog(@"歌手名:%@ 歌曲名:%@", self.singerName, self.songName);
    //歌手名称
    //    dict[MPMediaItemPropertyAlbumTitle]= @"歌曲名";
    self.dict[MPMediaItemPropertyArtist] = self.singerName;
    self.dict[MPMediaItemPropertyTitle] = self.songName;
    
//    // 开启上下文, 是否把图片重新裁切
//    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width - 20);
//    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
//    
//    UIImage *sourceImage = self.songImage;
//    
//    [sourceImage drawInRect:rect];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    self.dict[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithImage:newImage];
    
    if (self.songImage) {
        self.dict[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithImage:self.songImage];
    }
    
    self.infoCenter.nowPlayingInfo = self.dict;
}

@end
