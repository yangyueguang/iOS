//  FreedomTableViewController.m
//  Freedom
// Created by Super
#import "TLChatTableViewController.h"
#import "MJRefresh.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#define     PAGE_MESSAGE_COUNT      15
#import "UIImage+GIF.h"
#import <MobClick.h>
#define     MSG_SPACE_TOP       2
#define     MSG_SPACE_TOP       14
#define     MSG_SPACE_BTM       20
#define     MSG_SPACE_LEFT      19
#define     MSG_SPACE_RIGHT     22
#import "UIButton+WebCache.h"
#import <XCategory/NSDate+expanded.h>
#define     TIMELABEL_HEIGHT    20.0f
#define     TIMELABEL_SPACE_Y   10.0f
#define     NAMELABEL_HEIGHT    14.0f
#define     NAMELABEL_SPACE_X   12.0f
#define     NAMELABEL_SPACE_Y   1.0f
#define     AVATAR_WIDTH        40.0f
#define     AVATAR_SPACE_X      8.0f
#define     AVATAR_SPACE_Y      12.0f
#define     MSGBG_SPACE_X       5.0f
#define     MSGBG_SPACE_Y       1.0f
@interface TLMessageBaseCell ()
@end
@implementation TLMessageBaseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.messageBackgroundView];
        [self p_addMasonry];
    }
    return self;
}
- (void)setMessage:(TLMessage *)message{
    if (_message && [_message.messageID isEqualToString:message.messageID]) {
        return;
    }
    [self.timeLabel setText:[NSString stringWithFormat:@"  %@  ", message.date.chatTimeInfo]];
    [self.usernameLabel setText:[message.fromUser chat_username]];
    if ([message.fromUser chat_avatarPath].length > 0) {
        NSString *path = [NSFileManager pathUserAvatar:[message.fromUser chat_avatarPath]];
        [self.avatarButton setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    }else{
        [self.avatarButton sd_setImageWithURL:TLURL([message.fromUser chat_avatarURL]) forState:UIControlStateNormal];
    }
    
    // 时间
    if (!_message || _message.showTime != message.showTime) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(message.showTime ? TIMELABEL_HEIGHT : 0);
            make.top.mas_equalTo(self.contentView).mas_offset(message.showTime ? TIMELABEL_SPACE_Y : 0);
        }];
    }
    
    if (!message || _message.ownerTyper != message.ownerTyper) {
        // 头像
        [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(AVATAR_WIDTH);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y);
            if(message.ownerTyper == TLMessageOwnerTypeSelf) {
                make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X);
            }else{
                make.left.mas_equalTo(self.contentView).mas_offset(AVATAR_SPACE_X);
            }
        }];
        
        // 用户名
        [self.usernameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
            if (message.ownerTyper == TLMessageOwnerTypeSelf) {
                make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(- NAMELABEL_SPACE_X);
            }else{
                make.left.mas_equalTo(self.avatarButton.mas_right).mas_equalTo(NAMELABEL_SPACE_X);
            }
        }];
        
        // 背景
        [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            message.ownerTyper == TLMessageOwnerTypeSelf ? make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X) : make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(MSGBG_SPACE_X);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(message.showName ? 0 : -MSGBG_SPACE_Y);
        }];
    }
    
    [self.usernameLabel setHidden:!message.showName];
    [self.usernameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(message.showName ? NAMELABEL_HEIGHT : 0);
    }];
    
    _message = message;
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(TIMELABEL_SPACE_Y);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
        make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(- NAMELABEL_SPACE_X);
    }];
    
    // Default - self
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X);
        make.width.and.height.mas_equalTo(AVATAR_WIDTH);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y);
    }];
    
    [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(-MSGBG_SPACE_Y);
    }];
}
#pragma mark - Event Response -
- (void)avatarButtonDown:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidClickAvatarForUser:)]) {
        [_delegate messageCellDidClickAvatarForUser:self.message.fromUser];
    }
}
- (void)longPressMsgBGView{
    [self.messageBackgroundView setHighlighted:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.messageBackgroundView.frame;
        rect.size.height -= 10;     // 北京图片底部空白区域
        [_delegate messageCellLongPress:self.message rect:rect];
    }
}
- (void)doubleTabpMsgBGView{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [_delegate messageCellDoubleClick:self.message];
    }
}
#pragma mark - Getter -
- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setBackgroundColor:[UIColor grayColor]];
        [_timeLabel setAlpha:0.7f];
        [_timeLabel.layer setMasksToBounds:YES];
        [_timeLabel.layer setCornerRadius:5.0f];
    }
    return _timeLabel;
}
- (UIButton *)avatarButton{
    if (_avatarButton == nil) {
        _avatarButton = [[UIButton alloc] init];
        [_avatarButton.layer setMasksToBounds:YES];
        [_avatarButton.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_avatarButton.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
        [_avatarButton addTarget:self action:@selector(avatarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}
- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setTextColor:[UIColor grayColor]];
        [_usernameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _usernameLabel;
}
- (UIImageView *)messageBackgroundView{
    if (_messageBackgroundView == nil) {
        _messageBackgroundView = [[UIImageView alloc] init];
        [_messageBackgroundView setUserInteractionEnabled:YES];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView)];
        [_messageBackgroundView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
        [doubleTapGR setNumberOfTapsRequired:2];
        [_messageBackgroundView addGestureRecognizer:doubleTapGR];
    }
    return _messageBackgroundView;
}
@end
@interface TLMessageImageView : UIImageView
@property (nonatomic, strong) UIImage *backgroundImage;
/*设置消息图片（规则：收到消息时，先下载缩略图到本地，再添加到列表显示，并自动下载大图）
 *
 *  @param imagePath    缩略图Path
 *  @param imageURL     高清图URL*/
- (void)setThumbnailPath:(NSString *)imagePath highDefinitionImageURL:(NSString *)imageURL;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CALayer *contentLayer;
@end
@implementation TLMessageImageView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.contentLayer];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.maskLayer setFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];
    [self.contentLayer setFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight)];
}
- (void)setThumbnailPath:(NSString *)imagePath highDefinitionImageURL:(NSString *)imageURL{
    if (imagePath == nil) {
        [self.contentLayer setContents:nil];
    }else{
        [self.contentLayer setContents:(id)[UIImage imageNamed:imagePath].CGImage];
    }
}
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self.maskLayer setContents:(id)backgroundImage.CGImage];
}
#pragma mark - Getter -
- (CAShapeLayer *)maskLayer{
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.contentsCenter = CGRectMake(0.5, 0.6, 0.1, 0.1);
        _maskLayer.contentsScale = [UIScreen mainScreen].scale;                 //非常关键设置自动拉伸的效果且不变形
    }
    return _maskLayer;
}
- (CALayer *)contentLayer{
    if (_contentLayer == nil) {
        _contentLayer = [[CALayer alloc] init];
        [_contentLayer setMask:self.maskLayer];
    }
    return _contentLayer;
}
@end
static UILabel *textLabel;
@implementation TLTextMessage
@synthesize text = _text;
- (id)init{
    if (self = [super init]) {
        textLabel = [[UILabel alloc] init];
        [textLabel setFont:[UIFont fontTextMessageText]];
        [textLabel setNumberOfLines:0];
    }
    return self;
}
- (NSString *)text{
    if (_text == nil) {
        _text = [self.content objectForKey:@"text"];
    }
    return _text;
}
- (void)setText:(NSString *)text{
    _text = text;
    [self.content setObject:text forKey:@"text"];
}
- (NSAttributedString *)attrText{
    if (_attrText == nil) {
        _attrText = [self.text toMessageString];
    }
    return _attrText;
}
- (TLMessageFrame *)messageFrame{
    if (kMessageFrame == nil) {
        kMessageFrame = [[TLMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        if (self.messageType == TLMessageTypeText) {
            kMessageFrame.height += 20;
            [textLabel setAttributedText:self.attrText];
            kMessageFrame.contentSize = [textLabel sizeThatFits:CGSizeMake(MAX_MESSAGE_WIDTH, MAXFLOAT)];
        }
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}
- (NSString *)conversationContent{
    return self.text;
}
- (NSString *)messageCopy{
    return self.text;
}
@end
@interface TLTextMessageCell ()
@property (nonatomic, strong) UILabel *messageLabel;
@end
@implementation TLTextMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}
- (void)setMessage:(TLTextMessage *)message{
    if (self.message && [self.message.messageID isEqualToString:message.messageID]) {
        return;
    }
    TLMessageOwnerType lastOwnType = self.message ? self.message.ownerTyper : -1;
    [super setMessage:message];
    [self.messageLabel setAttributedText:[message attrText]];
    
    [self.messageLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.messageBackgroundView setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    if (lastOwnType != message.ownerTyper) {
        if (message.ownerTyper == TLMessageOwnerTypeSelf) {
            [self.messageBackgroundView setImage:[UIImage imageNamed:@"message_sender_bg"]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageNamed:@"message_sender_bgHL"]];
            
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageLabel).mas_offset(-MSG_SPACE_LEFT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }else if (message.ownerTyper == TLMessageOwnerTypeFriend){
            [self.messageBackgroundView setImage:[UIImage imageNamed:@"message_receiver_bg"]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageNamed:@"message_receiver_bgHL"]];
            
            [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_RIGHT);
                make.bottom.mas_equalTo(self.messageLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
    }
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.messageFrame.contentSize);
    }];
}
#pragma mark - Getter -
- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setFont:[UIFont fontTextMessageText]];
        [_messageLabel setNumberOfLines:0];
    }
    return _messageLabel;
}
@end
@interface TLImageMessageCell ()
@property (nonatomic, strong) TLMessageImageView *msgImageView;
@end
@implementation TLImageMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgImageView];
    }
    return self;
}
- (void)setMessage:(TLImageMessage *)message{
    [self.msgImageView setAlpha:1.0];       // 取消长按效果
    if (self.message && [self.message.messageID isEqualToString:message.messageID]) {
        return;
    }
    TLMessageOwnerType lastOwnType = self.message ? self.message.ownerTyper : -1;
    [super setMessage:message];
    
    if ([message imagePath]) {
        NSString *imagePath = [NSFileManager pathUserChatImage:[message imagePath]];
        [self.msgImageView setThumbnailPath:imagePath highDefinitionImageURL:[message imagePath]];
    }else{
        [self.msgImageView setThumbnailPath:nil highDefinitionImageURL:[message imagePath]];
    }
    
    if (lastOwnType != message.ownerTyper) {
        if (message.ownerTyper == TLMessageOwnerTypeSelf) {
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"message_sender_bg"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.right.mas_equalTo(self.messageBackgroundView);
            }];
        }else if (message.ownerTyper == TLMessageOwnerTypeFriend){
            [self.msgImageView setBackgroundImage:[UIImage imageNamed:@"message_receiver_bg"]];
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.messageBackgroundView);
                make.left.mas_equalTo(self.messageBackgroundView);
            }];
        }
    }
    [self.msgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.messageFrame.contentSize);
    }];
}
#pragma mark - Event Response -
- (void)tapMessageView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellTap:)]) {
        [self.delegate messageCellTap:self.message];
    }
}
- (void)longPressMsgBGView{
    [self.msgImageView setAlpha:0.7];   // 比较low的选中效果
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.msgImageView.frame;
        rect.size.height -= 10;     // 北京图片底部空白区域
        [self.delegate messageCellLongPress:self.message rect:rect];
    }
}
- (void)doubleTabpMsgBGView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [self.delegate messageCellDoubleClick:self.message];
    }
}
#pragma mark - Getter -
- (TLMessageImageView *)msgImageView{
    if (_msgImageView == nil) {
        _msgImageView = [[TLMessageImageView alloc] init];
        [_msgImageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessageView)];
        [_msgImageView addGestureRecognizer:tapGR];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView)];
        [_msgImageView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
        [doubleTapGR setNumberOfTapsRequired:2];
        [_msgImageView addGestureRecognizer:doubleTapGR];
    }
    return _msgImageView;
}
@end
@implementation TLExpressionMessage
@synthesize emoji = _emoji;
- (void)setEmoji:(TLEmoji *)emoji{
    _emoji = emoji;
    [self.content setObject:emoji.groupID forKey:@"groupID"];
    [self.content setObject:emoji.emojiID forKey:@"emojiID"];
    CGSize imageSize = [UIImage imageNamed:self.path].size;
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"w"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"h"];
}
- (TLEmoji *)emoji{
    if (_emoji == nil) {
        _emoji = [[TLEmoji alloc] init];
        _emoji.groupID = self.content[@"groupID"];
        _emoji.emojiID = self.content[@"emojiID"];
    }
    return _emoji;
}
- (NSString *)path{
    return self.emoji.emojiPath;
}
- (NSString *)url{
    return [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",self.emoji.emojiID];
}
- (CGSize)emojiSize{
    CGFloat width = [self.content[@"w"] doubleValue];
    CGFloat height = [self.content[@"h"] doubleValue];
    return CGSizeMake(width, height);
}
#pragma mark -
- (TLMessageFrame *)messageFrame{
    if (kMessageFrame == nil) {
        kMessageFrame = [[TLMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        
        kMessageFrame.height += 5;
        
        CGSize emojiSize = self.emojiSize;
        if (CGSizeEqualToSize(emojiSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(80, 80);
        }else if (emojiSize.width > emojiSize.height) {
            CGFloat height = WIDTH_SCREEN * 0.35 * emojiSize.height / emojiSize.width;
            height = height < WIDTH_SCREEN * 0.2 ? WIDTH_SCREEN * 0.2 : height;
            kMessageFrame.contentSize = CGSizeMake(WIDTH_SCREEN * 0.35, height);
        }else{
            CGFloat width = WIDTH_SCREEN * 0.35 * emojiSize.width / emojiSize.height;
            width = width < WIDTH_SCREEN * 0.2 ? WIDTH_SCREEN * 0.2 : width;
            kMessageFrame.contentSize = CGSizeMake(width, WIDTH_SCREEN * 0.35);
        }
        
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}
- (NSString *)conversationContent{
    return @"[表情]";
}
- (NSString *)messageCopy{
    return [self.content mj_JSONString];
}
@end
@interface TLExpressionMessageCell ()
@property (nonatomic, strong) UIImageView *msgImageView;
@end
@implementation TLExpressionMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgImageView];
    }
    return self;
}
- (void)setMessage:(TLExpressionMessage *)message{
    [self.msgImageView setAlpha:1.0];       // 取消长按效果
    TLMessageOwnerType lastOwnType = self.message ? self.message.ownerTyper : -1;
    [super setMessage:message];
    
    NSData *data = [NSData dataWithContentsOfFile:message.path];
    if (data) {
        [self.msgImageView setImage:[UIImage imageNamed:message.path]];
        [self.msgImageView setImage:[UIImage sd_animatedGIFWithData:data]];
    }else{      // 表情组被删掉，先从缓存目录中查找，没有的话在下载并存入缓存目录
        NSString *MycachePath = [NSFileManager cacheForFile:[NSString stringWithFormat:@"%@_%@.gif", message.emoji.groupID, message.emoji.emojiID]];
        NSData *data = [NSData dataWithContentsOfFile:MycachePath];
        if (data) {
            [self.msgImageView setImage:[UIImage imageNamed:MycachePath]];
            [self.msgImageView setImage:[UIImage sd_animatedGIFWithData:data]];
        }else{
            __weak typeof(self) weakSelf = self;
            [self.msgImageView sd_setImageWithURL:TLURL(message.url) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if ([[imageURL description] isEqualToString:[(TLExpressionMessage *)weakSelf.message url]]) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                        [data writeToFile:cachePath atomically:NO];      // 再写入到缓存中
                        if ([[imageURL description] isEqualToString:[(TLExpressionMessage *)weakSelf.message url]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.msgImageView setImage:[UIImage sd_animatedGIFWithData:data]];
                            });
                        }
                    });
                }
            }];
        }
    }
    
    if (lastOwnType != message.ownerTyper) {
        if (message.ownerTyper == TLMessageOwnerTypeSelf) {
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5);
                make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-10);
            }];
        }else if (message.ownerTyper == TLMessageOwnerTypeFriend){
            [self.msgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(5);
                make.left.mas_equalTo(self.messageBackgroundView).mas_offset(10);
            }];
        }
    }
    [self.msgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(message.messageFrame.contentSize);
    }];
}
#pragma mark - Event Response -
- (void)longPressMsgBGView{
    [self.msgImageView setAlpha:0.7];   // 比较low的选中效果
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellLongPress:rect:)]) {
        CGRect rect = self.msgImageView.frame;
        [self.delegate messageCellLongPress:self.message rect:rect];
    }
}
- (void)doubleTabpMsgBGView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDoubleClick:)]) {
        [self.delegate messageCellDoubleClick:self.message];
    }
}
#pragma mark - Getter -
- (UIImageView *)msgImageView{
    if (_msgImageView == nil) {
        _msgImageView = [[UIImageView alloc] init];
        [_msgImageView setUserInteractionEnabled:YES];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMsgBGView)];
        [_msgImageView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTabpMsgBGView)];
        [doubleTapGR setNumberOfTapsRequired:2];
        [_msgImageView addGestureRecognizer:doubleTapGR];
    }
    return _msgImageView;
}
@end
@interface TLChatCellMenuView ()
@property (nonatomic, strong) UIMenuController *menuController;
@end
@implementation TLChatCellMenuView
+ (TLChatCellMenuView *)sharedMenuView{
    static TLChatCellMenuView *menuView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [[TLChatCellMenuView alloc] init];
    });
    return menuView;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.menuController = [UIMenuController sharedMenuController];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}
- (void)showInView:(UIView *)view withMessageType:(TLMessageType)messageType rect:(CGRect)rect actionBlock:(void (^)(TLChatMenuItemType))actionBlock{
    if (_isShow) {
        return;
    }
    _isShow = YES;
    [self setFrame:view.bounds];
    [view addSubview:self];
    [self setActionBlcok:actionBlock];
    [self setMessageType:messageType];
    
    [self.menuController setTargetRect:rect inView:self];
    [self becomeFirstResponder];
    [self.menuController setMenuVisible:YES animated:YES];
}
- (void)setMessageType:(TLMessageType)messageType{
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyButtonDown:)];
    UIMenuItem *transmit = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(transmitButtonDown:)];
    UIMenuItem *collect = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(collectButtonDown:)];
    UIMenuItem *del = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteButtonDown:)];
    [self.menuController setMenuItems:@[copy, transmit, collect, del]];
}
- (void)dismiss{
    _isShow = NO;
    if (self.actionBlcok) {
        self.actionBlcok(TLChatMenuItemTypeCancel);
    }
    [self.menuController setMenuVisible:NO animated:YES];
    [self removeFromSuperview];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
#pragma mark - Event Response -
- (void)copyButtonDown:(UIMenuController *)sender{
    [self p_clickedMenuItemType:TLChatMenuItemTypeCopy];
}
- (void)transmitButtonDown:(UIMenuController *)sender{
    [self p_clickedMenuItemType:TLChatMenuItemTypeCopy];
}
- (void)collectButtonDown:(UIMenuController *)sender{
    [self p_clickedMenuItemType:TLChatMenuItemTypeCopy];
}
- (void)deleteButtonDown:(UIMenuController *)sender{
    [self p_clickedMenuItemType:TLChatMenuItemTypeDelete];
}
#pragma mark - Private Methods -
- (void)p_clickedMenuItemType:(TLChatMenuItemType)type{
    _isShow = NO;
    [self removeFromSuperview];
    if (self.actionBlcok) {
        self.actionBlcok(type);
    }
}
@end
@implementation UITableView (expanded)
- (void)scrollToBottomWithAnimation:(BOOL)animation{
    NSUInteger section = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        section = [self.dataSource numberOfSectionsInTableView:self] - 1;
    }
    if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSUInteger row = [self.dataSource tableView:self numberOfRowsInSection:section];
        if (row > 0) {
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
        }
    }
}
@end
@interface TLChatTableViewController ()
@property (nonatomic, strong) MJRefreshNormalHeader *refresHeader;
/// 用户决定新消息是否显示时间
@property (nonatomic, strong) NSDate *curDate;
@end
@implementation TLChatTableViewController
@synthesize data = _data;
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 20)]];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refresHeader];
    }
    [self registerCellClass];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView)];
    [self.tableView addGestureRecognizer:tap];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([[TLChatCellMenuView sharedMenuView] isShow]) {
        [[TLChatCellMenuView sharedMenuView] dismiss];
    }
}
#pragma mark - Public Methods -
- (void)reloadData{
    [self.data removeAllObjects];
    [self.tableView reloadData];
    self.curDate = [NSDate date];
    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refresHeader];
    }
    [self p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
        if (!hasMore) {
            self.tableView.mj_header = nil;
        }
        if (count > 0) {
            [self.tableView reloadData];
            [self.tableView scrollToBottomWithAnimation:NO];
        }
    }];
}
- (void)addMessage:(TLMessage *)message{
    [self.data addObject:message];
    [self.tableView reloadData];
}
- (void)setData:(NSMutableArray *)data{
    _data = data;
    [self.tableView reloadData];
}
- (void)deleteMessage:(TLMessage *)message{
    NSInteger index = [self.data indexOfObject:message];
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewController:deleteMessage:)]) {
        BOOL ok = [_delegate chatTableViewController:self deleteMessage:message];
        if (ok) {
            [self.data removeObject:message];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [MobClick event:@"e_delete_message"];
        }else{
            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}
- (void)scrollToBottomWithAnimation:(BOOL)animation{
    [self.tableView scrollToBottomWithAnimation:animation];
}
- (void)setDisablePullToRefresh:(BOOL)disablePullToRefresh{
    if (disablePullToRefresh) {
        [self.tableView setMj_header:nil];
    }else{
        [self.tableView setMj_header:self.refresHeader];
    }
}
#pragma mark - Event Response -
- (void)didTouchTableView{
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewControllerDidTouched:)]) {
        [_delegate chatTableViewControllerDidTouched:self];
    }
}
#pragma mark - Private Methods -
/*获取聊天历史记录*/
- (void)p_tryToRefreshMoreRecord:(void (^)(NSInteger count, BOOL hasMore))complete{
    if (_delegate && [_delegate respondsToSelector:@selector(chatTableViewController:getRecordsFromDate:count:completed:)]) {
        [_delegate chatTableViewController:self
                        getRecordsFromDate:self.curDate
                                     count:PAGE_MESSAGE_COUNT
                                 completed:^(NSDate *date, NSArray *array, BOOL hasMore) {
                                     if (array.count > 0 && [date isEqualToDate:self.curDate]) {
                                         self.curDate = [array[0] date];
                                         [self.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                                         complete(array.count, hasMore);
                                     }
                                     else {
                                         complete(0, hasMore);
                                     }
                                 }];
    }
}
#pragma mark - Getter -
- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}
- (MJRefreshNormalHeader *)refresHeader{
    if (_refresHeader == nil) {
        _refresHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self p_tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
                [self.tableView.mj_header endRefreshing];
                if (!hasMore) {
                    self.tableView.mj_header = nil;
                }
                if (count > 0) {
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }];
        }];
        _refresHeader.lastUpdatedTimeLabel.hidden = YES;
        _refresHeader.stateLabel.hidden = YES;
    }
    return _refresHeader;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.tableView registerClass:[TLTextMessageCell class] forCellReuseIdentifier:@"TLTextMessageCell"];
    [self.tableView registerClass:[TLImageMessageCell class] forCellReuseIdentifier:@"TLImageMessageCell"];
    [self.tableView registerClass:[TLExpressionMessageCell class] forCellReuseIdentifier:@"TLExpressionMessageCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EmptyCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLMessage * message = self.data[indexPath.row];
    if (message.messageType == TLMessageTypeText) {
        TLTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLTextMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }else if (message.messageType == TLMessageTypeImage) {
        TLImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLImageMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }else if (message.messageType == TLMessageTypeExpression) {
        TLExpressionMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLExpressionMessageCell"];
        [cell setMessage:message];
        [cell setDelegate:self];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
}
//MARK: UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row >= self.data.count) {
        return 0.0f;
    }
    TLMessage * message = self.data[indexPath.row];
    return message.messageFrame.height;
}
//MARK: TLMessageCellDelegate
- (void)messageCellDidClickAvatarForUser:(TLUser *)user{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didClickUserAvatar:)]) {
        [self.delegate chatTableViewController:self didClickUserAvatar:user];
    }
}
- (void)messageCellTap:(TLMessage *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didClickMessage:)]) {
        [self.delegate chatTableViewController:self didClickMessage:message];
    }
}
/*双击Message Cell*/
- (void)messageCellDoubleClick:(TLMessage *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:didDoubleClickMessage:)]) {
        [self.delegate chatTableViewController:self didDoubleClickMessage:message];
    }
}
- (void)messageCellLongPress:(TLMessage *)message rect:(CGRect)rect{
    NSInteger row = [self.data indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (self.disableLongPressMenu) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if ([[TLChatCellMenuView sharedMenuView] isShow]) {
        return;
    }
    
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    __weak typeof(self)weakSelf = self;
    [[TLChatCellMenuView sharedMenuView] showInView:self.navigationController.view withMessageType:message.messageType rect:rect actionBlock:^(TLChatMenuItemType type) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (type == TLChatMenuItemTypeCopy) {
            NSString *str = [message messageCopy];
            [[UIPasteboard generalPasteboard] setString:str];
        }else if (type == TLChatMenuItemTypeDelete) {
            TLActionSheet *actionSheet = [[TLActionSheet alloc] initWithTitle:@"是否删除该条消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
            actionSheet.tag = [self.data indexOfObject:message];
            [actionSheet show];
        }
    }];
}
//MARK: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewControllerDidTouched:)]) {
        [self.delegate chatTableViewControllerDidTouched:self];
    }
}
//MARK: TLActionSheetDelegate
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        TLMessage * message = [self.data objectAtIndex:actionSheet.tag];
        [self p_deleteMessage:message];
    }
}
#pragma mark - Private Methods -
- (void)p_deleteMessage:(TLMessage *)message{
    NSInteger index = [self.data indexOfObject:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatTableViewController:deleteMessage:)]) {
        BOOL ok = [self.delegate chatTableViewController:self deleteMessage:message];
        if (ok) {
            [self.data removeObject:message];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [MobClick event:@"e_delete_message"];
        }else{
            [UIAlertView bk_alertViewWithTitle:@"错误" message:@"从数据库中删除消息失败。"];
        }
    }
}
@end
