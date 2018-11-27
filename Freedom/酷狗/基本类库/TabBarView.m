//  TabBarView.m
//  CLKuGou
//  Created by Darren on 16/7/30.
#import "TabBarView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayAudioViewController.h"
#import "KugouTools.h"
@interface TabBarView()<AVAudioPlayerDelegate>
@property(nonatomic,strong) AVAudioPlayer *avPlayer;
@property(nonatomic,weak) NSTimer *timer;
@property(nonatomic,strong)PlayAudioViewController *playBoxVC;
@end
@implementation TabBarView
- (AVAudioPlayer *)avPlayer{
    if (_avPlayer == nil) {
        _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.assetUrl error:nil];
        _avPlayer.volume = 1; // 音量 0-1
        _avPlayer.pan = 0; // 音域  -1一边能听到  0两个耳机都能听到
        _avPlayer.enableRate = YES;// 允许设置速率
        _avPlayer.rate = 1;  // 设置速率
        //    self.avPlayer.duration  获得音频的时长
        //    self.avPlayer.currentTime = 100; // 从100秒的位置开始播放
        //    self.avPlayer.numberOfLoops = 2; // 循环2次
        //    self.avPlayer.numberOfChannels // 声道
        _avPlayer.delegate = self;
    }return _avPlayer;
}
+ (instancetype)show{
    return [[[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:nil options:nil] lastObject];
}
- (IBAction)clickStartBtn:(id)sender {
    self.starBtn.selected = !self.starBtn.selected;
    if (self.starBtn.selected) {  // 播放
        [self Play];
    } else {  // 暂停
        [self Pause];
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    RViewsBorder(self.IconView, self.IconView.frameWidth*0.5, 1,[UIColor grayColor]);
    [self.sliderView setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *myencode = [def valueForKey:@"currentMusicInfo"];
    KugouTools *tools = (KugouTools *)[NSKeyedUnarchiver unarchiveObjectWithData:myencode];
    if (myencode) {
        self.assetUrl = tools.mediaItem.assetURL;
        self.songNameLable.text = tools.mediaItem.title;
        self.singerLable.text = tools.mediaItem.albumArtist;
        if (tools.mediaItem.artwork) {
            UIImage *image = [tools.mediaItem.artwork imageWithSize:CGSizeMake(50, 50)];
            self.IconView.image = image;
        } else {
            self.IconView.image = [UIImage imageNamed:@"placeHoder-128"];
        }
        [self Pause];
        self.starBtn.selected = NO;
    } else {
        self.songNameLable.text = @"暂无播放歌曲";
    }
}
- (void)setAssetUrl:(NSURL *)assetUrl{
    // 每次传进数据之前，停止现在的一切操作
    self.sliderView.value = 0;
    [self Stop];
    _assetUrl = assetUrl;
    [self Play];
}
/**启动定时器*/
- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(music) userInfo:nil repeats:YES];
    [self.timer fire];
}
/**关闭定时器*/
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}
/**启动定时器后每隔一段时间来到这个方法*/
- (void)music{
    self.sliderView.value = self.avPlayer.currentTime/self.avPlayer.duration;
}
#pragma mark - 播放音乐
- (void)Play{
    [self.avPlayer play];
    [self startTimer];
    self.starBtn.selected = YES;
    // 转动头像
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.starBtn.selected) {
            [self stopIconRotion];
        } else {
            [self iconRotation];
        }
    });
}
#pragma mark - 停止音乐
- (void)Stop{
    [self.avPlayer stop];
    self.avPlayer = nil;
    [self stopIconRotion];
}
#pragma mark - 暂停音乐
- (void)Pause{
    [self.avPlayer pause];
    [self stopTimer];
    [self stopIconRotion];
}
#pragma  mark - 转动头像
- (void)iconRotation{
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.duration = 3;
    rotation.repeatCount = MAXFLOAT;
    rotation.keyPath = @"transform.rotation.z";
    rotation.toValue = @(M_PI*2);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];//设置动画节奏
    [self.IconView.layer addAnimation:rotation forKey:nil];
}
#pragma  mark - 停止转动头像
- (void)stopIconRotion{
    [self.IconView.layer removeAllAnimations];
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopIconRotion];
    self.avPlayer = player;
    self.starBtn.selected = NO;
}
- (IBAction)clickSliderView:(id)sender {
    self.avPlayer.currentTime = self.sliderView.value * self.avPlayer.duration;
}
//打开播放详情页
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _playBoxVC = [PlayAudioViewController shared];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         _playBoxVC.view.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {}];
}
@end
