//
//  RCDSearchResultViewCell.m
//  RCloudMessage
//
//  Created by 张改红 on 16/9/8.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDSearchResultViewCell.h"
#import "UIImageView+WebCache.h"
#import "RCloudModel.h"
#import "RCDataBaseManager.h"
#import <RongIMKit/RongIMKit.h>
@implementation RCDLabel
- (void)attributedText:(NSString *)textString byHighlightedText:(NSString *)highlightedText{
    NSRange range = [self getRange:highlightedText inText:textString];
    NSString *string = [self isBeyond:textString range:range];
    if (![string isEqualToString:textString]) {
        range = [self getRange:highlightedText inText:string];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x0099ff] range:range];
    self.attributedText = attributedString.copy;
}
- (NSRange)getRange:(NSString *)searchText inText:(NSString *)text{
    NSRange range = NSMakeRange(0, 0);
    NSString *twoStr = [[searchText stringByReplacingOccurrencesOfString:@" "  withString:@""] lowercaseString];
    if ([[text lowercaseString] containsString:[searchText lowercaseString]]) {
        range = [[text lowercaseString] rangeOfString:[searchText lowercaseString]];
    }else if ([[text lowercaseString] containsString:twoStr]){
        range = [[text lowercaseString] rangeOfString:twoStr];
    }else if( [[[FreedomTools hanZiToPinYinWithString:text] lowercaseString] containsString:twoStr]){
        NSString * str = [FreedomTools hanZiToPinYinWithString:text];
        range = [str rangeOfString:[searchText uppercaseString]];
    }
    return range;
}
- (NSString *)isBeyond:(NSString *)text range:(NSRange)range{
    NSString *string = nil;
    if (range.location + range.length < 16) {
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        string = text;
    }else if(text.length - range.location < 16){
        self.lineBreakMode = NSLineBreakByTruncatingHead;
        string = text;
    }else{
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        if (range.length > 16) {
            string = [self relaceEnterBySpace:[NSString stringWithFormat:@"...%@",[text substringWithRange:NSMakeRange(range.location,range.length)]]];
        }else{
            string = [self relaceEnterBySpace:[NSString stringWithFormat:@"...%@",[text substringWithRange:NSMakeRange(range.location - (16-range.length)/2,text.length-(range.location - (16-range.length)/2))]]];
        }
    }
    return string;
}
-(NSString *)relaceEnterBySpace:(NSString *)originalString{
    NSString *string = [originalString stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    return string;
}
@end
@interface RCDSearchResultViewCell()
@property (nonatomic,strong)UILabel *otherLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@end
@implementation RCDSearchResultViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self loadView];
  }
  return self;
}
- (void)setDataModel:(RCDSearchResultModel *)model{
  float namelLabelWidth = APPW-20-48-9.5;
  if (model.time) {
    self.timeLabel.hidden = NO;
    namelLabelWidth -= 100;
  }else{
    self.timeLabel.hidden = YES;
  }
  if (!(model.otherInformation.length > 0) || !(model.name.length > 0)) {
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerView.frame)+9.5, (65-17)/2, namelLabelWidth, 17);
    self.additionalLabel.hidden = YES;
    self.otherLabel.hidden = YES;
    NSString *str = nil;
    if (model.otherInformation.length > 0) {
      str = model.otherInformation;
    }else{
      str = model.name;
    }
    [self.nameLabel attributedText:str byHighlightedText:self.searchString];
  }else{
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerView.frame)+9.5, CGRectGetMinY(self.headerView.frame)+3,namelLabelWidth, 17);
    self.additionalLabel.hidden = NO;
    self.otherLabel.hidden = NO;
    CGFloat height= CGRectGetMaxY(self.headerView.frame)-20;
    CGFloat width = CGRectGetMaxX(self.headerView.frame)+9.5;
    CGFloat additionalLabelWidth = APPW-20-48-9.5;
    if(model.searchType == RCDSearchGroup){
      self.otherLabel.frame = CGRectMake(width,height, 35,16);
      self.additionalLabel.frame = CGRectMake(width+35,height, additionalLabelWidth-CGRectGetWidth(self.otherLabel.frame), 16);
      self.otherLabel.text = @"包含:";
      [self.additionalLabel attributedText:model.otherInformation byHighlightedText:self.searchString];
      self.nameLabel.text = model.name;
    }else if(model.searchType == RCDSearchFriend){
      self.otherLabel.frame = CGRectMake(width, height, 35,16);
      self.additionalLabel.frame = CGRectMake(width+35,height, additionalLabelWidth-CGRectGetWidth(self.otherLabel.frame), 16);
      self.otherLabel.text = @"昵称:";
      [self.additionalLabel attributedText:model.name byHighlightedText:self.searchString];
      self.nameLabel.text = model.otherInformation;
    }else{
      self.otherLabel.frame = CGRectMake(width, height, 40,16);
      self.additionalLabel.frame = CGRectMake(width+40,height, additionalLabelWidth-CGRectGetWidth(self.otherLabel.frame), 16);
      if ([model.objectName isEqualToString:@"RC:FileMsg"]) {
        self.otherLabel.text = @"[文件]";
      }else if([model.objectName isEqualToString:@"RC:ImgTextMsg"]){
        self.otherLabel.text = @"[链接]";
      }else{
        self.otherLabel.frame = CGRectZero;
        CGRect rect = self.additionalLabel.frame;
        rect.origin.x = width;
        rect.size.width = additionalLabelWidth;
        self.additionalLabel.frame = rect;
      }
      if (model.time) {
        self.timeLabel.text = [RCKitUtility ConvertMessageTime:model.time/1000];
      }
      self.nameLabel.text = model.name;
      if (model.count > 1) {
        self.additionalLabel.text = model.otherInformation;
      }else{
       [self.additionalLabel attributedText:model.otherInformation byHighlightedText:self.searchString];
      }
    }
  }
  if (!(model.portraitUri.length>0)) {
    UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
      defaultPortrait.backgroundColor = [UIColor randomColor];
      NSString *firstLetter = [ChineseToPinyin firstPinyinFromChinise:self.nameLabel.text];
      UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
      firstCharacterLabel.text = firstLetter;
      firstCharacterLabel.textColor = [UIColor whiteColor];
      firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
      firstCharacterLabel.font = [UIFont systemFontOfSize:50];
      [defaultPortrait addSubview:firstCharacterLabel];
    UIImage *portrait = [defaultPortrait imageFromView];
    self.headerView.image = portrait;
  } else {
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.portraitUri] placeholderImage:[FreedomTools imageNamed:@"default_portrait_msg" ofBundle:@"RongCloud.bundle"]];
  }
}
- (void)loadView{
  self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (65-48)/2, 48, 48)];
  self.headerView.layer.cornerRadius = 4;
  self.headerView.layer.masksToBounds = YES;
  [self.contentView addSubview:self.headerView];
  self.nameLabel = [[RCDLabel alloc] initWithFrame:CGRectZero];
  self.nameLabel.font = [UIFont systemFontOfSize:15.f];
  self.nameLabel.textColor = [UIColor colorWithRGBHex:0x000000];
  [self.contentView addSubview:self.nameLabel];
  self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPW-100-10, (65-48)/2, 100,17)];
  self.timeLabel.textColor = [UIColor colorWithRGBHex:0x999999];
  self.timeLabel.font = [UIFont systemFontOfSize:15.f];
  self.timeLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:self.timeLabel];
  self.otherLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.otherLabel.textColor = [UIColor colorWithRGBHex:0x999999];
  self.otherLabel.font = [UIFont systemFontOfSize:14.f];
  self.additionalLabel = [[RCDLabel alloc] initWithFrame:CGRectZero];
  self.additionalLabel.font = [UIFont systemFontOfSize:14.f];
  self.additionalLabel.textColor = [UIColor colorWithRGBHex:0x999999];
  [self.contentView addSubview:self.otherLabel];
  [self.contentView addSubview:self.additionalLabel];
}
@end
