//
//  MyPlayTool.h
//  HappySing
//
//  Created by vochi on 16/7/25.
//  Copyright © 2016年 vochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MyPlayTool : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVURLAsset *urlAsset;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) NSString *playID;
@property (nonatomic, copy) NSString *playImageUrlStr;
@property (nonatomic, copy) NSString *musicUrlStr;
@property (nonatomic, copy) NSString *isVideo;

@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, strong) UIImage *songImage;

+(instancetype)sharePlayTool;

- (void)play;

- (void)pause;

- (void)stop;

- (void)playAndRecord;

-(void)loadLocalMusicUsePath:(NSString *)path;
- (void)loadNetworkMusicUseUrlStr:(NSString *)urlStr;
- (void)loadNetworkVideoUseUrlStr:(NSString *)urlStr;
- (void)movePlayerToSliderValue:(CGFloat)currentSliderValue;

@end
