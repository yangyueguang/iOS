//  XFMessageViewController.m
//  Freedom
//  Created by Fay on 15/9/13.
#import "XFMessageViewController.h"
#import "XFMessageChartViewController.h"
@interface XFMessageViewController ()
@property(nonatomic,strong) UISearchBar *searchBar;
@end
@implementation XFMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (UISearchBar*)searchBar{
   UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.frameWidth = APPW;
    searchBar.frameHeight = 40;
    searchBar.placeholder = @"大家都在搜：男模遭趴光";
    return searchBar;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    if(indexPath.row==0){
        UITableViewCell *d = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [d.contentView addSubview:self.searchBar];
        return d;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"微博小秘书%ld",(long)indexPath.row];
    cell.detailTextLabel.text = @"今晚我想去你那里，等着我。详情请点击查看！";
    cell.imageView.image = [UIImage imageNamed:@"movie"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Sina" bundle:nil];
    [self presentViewController:[StoryBoard instantiateViewControllerWithIdentifier:@"XFMessageChartViewController"] animated:YES completion:nil];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
