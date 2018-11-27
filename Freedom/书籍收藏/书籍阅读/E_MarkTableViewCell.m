//  E_MarkTableViewCell.m
//  Freedom
//  Created by Super on 15/3/2.
#import "E_MarkTableViewCell.h"
#import "E_ContantFile.h"
@implementation E_MarkTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor redColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
       
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW*3/4 - 125, 5, 110, 20)];
        _timeLbl.textColor = [UIColor redColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, kScreenW*3/4 - 50, 60)];
        _contentLbl.numberOfLines = 3;
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
