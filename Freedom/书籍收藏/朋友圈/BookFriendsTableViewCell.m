//  YMTableViewCell.m
//  WFCoretext
//  Created by Super on 14/10/28. 2 3 2 2 2 3 1 3 2 1
#import "BookFriendsTableViewCell.h"

@implementation BookFriendsTableViewCell{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:10.0];
        [layer setBorderWidth:1];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:_userHeaderImage];
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + 50 + 20, 5, APPW - 120, 50/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:15.0];
        _userNameLbl.textColor = [UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:_userNameLbl];
        _userIntroLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + 50 + 20, 5 + 50/2 , APPW - 120, 50/2)];
        _userIntroLbl.numberOfLines = 1;
        _userIntroLbl.font = [UIFont systemFontOfSize:14.0];
        _userIntroLbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:_userIntroLbl];
        _imageArray = [[NSMutableArray alloc] init];
        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        replyImageView = [[UIImageView alloc] init];
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];
        _replyBtn = [UIButton buttonWithType:0];
        [_replyBtn setImage:[UIImage imageNamed:@"fw_r2_c2"] forState:0];
        [self.contentView addSubview:_replyBtn];
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan"];
        [self.contentView addSubview:_favourImage];
    }
    return self;
}
- (void)foldText{
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setYMViewWith:(YMTextData *)ymData{
    tempDate = ymData;
    _userHeaderImage.image = [UIImage imageNamed:tempDate.messageBody.posterImgstr];
    _userNameLbl.text = tempDate.messageBody.posterName;
    _userIntroLbl.text = tempDate.messageBody.posterIntro;
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_ymShuoshuoArray removeAllObjects];
    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(20, 15 + 50, APPW - 2 * 20, 0)];
    textView.didClickCoreText = ^(NSString *clickString, NSInteger index, BOOL isLong) {
        if(isLong){
            if (index == -1) {
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                pboard.string = clickString;
            }else{
                [_delegate longClickRichText:_stamp replyIndex:index];
            }
        }else{
            if ([clickString isEqualToString:@""] && index != -1) {
                //reply/DLog(@"reply");
                [_delegate clickRichText:_stamp replyIndex:index];
            }else{
                if ([clickString isEqualToString:@""]) {
                    //
                }else{
                    [WFHudView showMsg:clickString inView:nil];
                }
            }
        }
    };
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    textView.frame = CGRectMake(20, 15 + 50, APPW - 2 * 20, hhhh);
    [_ymShuoshuoArray addObject:textView];
    //按钮
    foldBtn.frame = CGRectMake(20 - 10, 15 + 50 + hhhh + 10 , 50, 20 );
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    if (tempDate.foldOrNot == YES) {
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        [foldBtn setTitle:@"收起" forState:0];
    }
    for (int i = 0; i < [_imageArray count]; i++) {
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_imageArray removeAllObjects];
    for (int  i = 0; i < [ymData.showImageArray count]; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(((APPW - 240)/4)*(i%3 + 1) + 80*(i%3), 50 + 10 * ((i/3) + 1) + (i/3) *  80 + hhhh + 20 + (ymData.islessLimit?0:30), 80, 80)];
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        image.backgroundColor = [UIColor clearColor];
        image.tag = 9999 + i;
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[ymData.showImageArray objectAtIndex:i]]];
        [self.contentView addSubview:image];
        [_imageArray addObject:image];
    }
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
        }
    }
    [_ymFavourArray removeAllObjects];
    float origin_Y = 10;
    NSUInteger scale_Y = ymData.showImageArray.count - 1;
    float balanceHeight = 0; //纯粹为了解决没图片高度的问题
    if (ymData.showImageArray.count == 0) {
        scale_Y = 0;
        balanceHeight = - 80 - 20 ;
    }
    float backView_Y = 0;
    float backView_H = 0;
    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(20 + 30, 50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30) + balanceHeight + 30, APPW - 2 * 20 - 30, 0)];
    favourView.didClickCoreText = ^(NSString *clickString, NSInteger index, BOOL isLong) {
        if(isLong){
            if (index == -1) {
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                pboard.string = clickString;
            }else{
                [_delegate longClickRichText:_stamp replyIndex:index];
            }
        }else{
            if ([clickString isEqualToString:@""] && index != -1) {
                //reply/DLog(@"reply");
                [_delegate clickRichText:_stamp replyIndex:index];
            }else{
                if ([clickString isEqualToString:@""]) {
                    //
                }else{
                    [WFHudView showMsg:clickString inView:nil];
                }
            }
        }
    };
    favourView.attributedData = ymData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.canClickAll = NO;
    favourView.textColor = [UIColor redColor];
    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
    favourView.frame = CGRectMake(20 + 30,50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30) + balanceHeight + 30, APPW - 20 * 2 - 30, ymData.favourHeight);
    [self.contentView addSubview:favourView];
    backView_H += ((ymData.favourHeight == 0)?(-8):ymData.favourHeight);
    [_ymFavourArray addObject:favourView];
//点赞图片的位置
    _favourImage.frame = CGRectMake(20 + 8, favourView.frame.origin.y, (ymData.favourHeight == 0)?0:20,(ymData.favourHeight == 0)?0:20);
    for (int i = 0; i < [_ymTextArray count]; i++) {
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
            //  DLog(@"here");
        }
    }
    [_ymTextArray removeAllObjects];
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(20,50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30) + balanceHeight + 30 + ymData.favourHeight + (ymData.favourHeight == 0?0:8), APPW - 20 * 2, 0)];
        if (i == 0) {
            backView_Y = 50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30);
        }
        _ilcoreText.didClickCoreText = ^(NSString *clickString, NSInteger index, BOOL isLong) {
            if(isLong){
                if (index == -1) {
                    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                    pboard.string = clickString;
                }else{
                    [_delegate longClickRichText:_stamp replyIndex:index];
                }
            }else{
                if ([clickString isEqualToString:@""] && index != -1) {
                    //reply/DLog(@"reply");
                    [_delegate clickRichText:_stamp replyIndex:index];
                }else{
                    if ([clickString isEqualToString:@""]) {
                        //
                    }else{
                        [WFHudView showMsg:clickString inView:nil];
                    }
                }
            }
        };
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        NSString *matchString;
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
        }
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        _ilcoreText.frame = CGRectMake(20,50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30) + balanceHeight + 30 + ymData.favourHeight + (ymData.favourHeight == 0?0:8), APPW - 20 * 2, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        origin_Y += [_ilcoreText getTextHeight] + 5 ;
        backView_H += _ilcoreText.frame.size.height;
        [_ymTextArray addObject:_ilcoreText];
    }
    backView_H += (ymData.replyDataSource.count - 1)*5;
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        replyImageView.frame = CGRectMake(20, backView_Y - 10 + balanceHeight + 5 + 30, 0, 0);
        _replyBtn.frame = CGRectMake(APPW - 20 - 40 + 6,50 + 10 + 80 + (80 + 10)*(scale_Y/3) + origin_Y + hhhh + 20 + (ymData.islessLimit?0:30) + balanceHeight + 30 - 24, 40, 18);
    }else{
        replyImageView.frame = CGRectMake(20, backView_Y - 10 + balanceHeight + 5 + 30, APPW - 20 * 2, backView_H + 20 - 8);//微调
        _replyBtn.frame = CGRectMake(APPW - 20 - 40 + 6, replyImageView.frame.origin.y - 24, 40, 18);
    }
}
- (void)clickMyself:(NSString *)clickString{
    NSLog(@"%@",clickString);
}
- (void)tapImageView:(UITapGestureRecognizer *)tapGes{
    [_delegate showImageViewWithImageViews:self.imageArray byClickWhich:tapGes.view.tag];
}
@end
