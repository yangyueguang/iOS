
#import <UIKit/UIKit.h>
@interface SHLrcsView : UIView
/**
 * 歌词文件名*/
@property(nonatomic,strong) NSString *lrcname;
/**
 * 歌曲当前播放时间点*/
@property(nonatomic) NSTimeInterval currentTime;
@end
