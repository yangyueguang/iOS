//  TLSearchController.m
//  Freedom
// Created by Super
#import "WXSearchController.h"
@implementation WXSearchController
- (id)initWithSearchResultsController:(UIViewController *)searchResultsController{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self.searchBar setFrame:CGRectMake(0, 0, APPW, HEIGHT_NAVBAR)];
//        [self.searchBar setBackgroundImage:[UIImage imageWithColor:colorGrayBG]];
        [self.searchBar setBarTintColor:colorGrayBG];
        [self.searchBar setTintColor:colorGreenDefault];
        UITextField *tf = [[[self.searchBar.subviews firstObject] subviews] lastObject];
        [tf.layer setMasksToBounds:YES];
        [tf.layer setBorderWidth:BORDER_WIDTH_1PX];
        [tf.layer setBorderColor:colorGrayLine.CGColor];
        [tf.layer setCornerRadius:5.0f];
        
        for (UIView *view in self.searchBar.subviews[0].subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                UIView *bg = [[UIView alloc] init];
                [bg setBackgroundColor:colorGrayBG];
                [view addSubview:bg];
                [bg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
                
                UIView *line = [[UIView alloc] init];
                [line setBackgroundColor:colorGrayLine];
                [view addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.and.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(BORDER_WIDTH_1PX);
                }];
                break;
            }
        }
    }
    return self;
}
- (void)setShowVoiceButton:(BOOL)showVoiceButton{
    _showVoiceButton = showVoiceButton;
    if (showVoiceButton) {
        [self.searchBar setShowsBookmarkButton:YES];
        [self.searchBar setImage:[UIImage imageNamed:@"searchBar_voice"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        [self.searchBar setImage:[UIImage imageNamed:@"searchBar_voice_HL"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    }else{
        [self.searchBar setShowsBookmarkButton:NO];
    }
}
@end
