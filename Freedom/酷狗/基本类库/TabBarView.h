//  TabBarView.h
//  CLKuGou
//  Created by Darren on 16/7/30.
#import <UIKit/UIKit.h>
@interface TabBarView : UIView
+ (instancetype)show;
@property (weak, nonatomic) IBOutlet UIImageView *IconView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UILabel *songNameLable;
@property (weak, nonatomic) IBOutlet UILabel *singerLable;
@property (nonatomic,copy)  NSURL *assetUrl;
@end
