//  JFLoginViewController.m
//  Freedom
//  Created by Freedom on 15/10/19.//  项目详解：
//  github:https://github.com/tubie/JFTudou
//  简书：http://www.jianshu.com/p/2156ec56c55b
#import "JFLoginViewController.h"
@protocol JFLoginBtnCellDelegate <NSObject>
@optional
-(void)loginBtnClick:(UIButton *)sender;
@end
@interface JFLoginBtnCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)loginBtnClick:(id)sender;
- (void)xinlanWeiboBtnClick:(id)sender;
@property(nonatomic, weak)id <JFLoginBtnCellDelegate>delegate;
@end
@implementation JFLoginBtnCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFLoginBtnCell";
    JFLoginBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[JFLoginBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor redColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)loginBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginBtnClick:)]) {
        [self.delegate loginBtnClick:sender];
    }
}
- (void)xinlanWeiboBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginBtnClick:)]) {
        [self.delegate loginBtnClick:sender];
    }
}
@end
@interface JFTextFieldCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
@implementation JFTextFieldCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"JFTextFieldCell";
    JFTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[JFTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor greenColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
@interface JFLoginViewController ()<UITableViewDataSource, UITableViewDelegate,JFLoginBtnCellDelegate>
@property (nonatomic, strong)UITableView *loginTableView;
@end
@implementation JFLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;//用push方法推出时，Tabbar隐藏
    [self initNav];
    [self initView];
    
}
-(void)initView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //将系统的Separator左边不留间隙
    tableView.separatorInset = UIEdgeInsetsZero;
    self.loginTableView = tableView;
    self.loginTableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.loginTableView];
    self.view.backgroundColor = RGBCOLOR(249, 249, 249);
}
-(void)initNav{
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"登陆";
    
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem initWithNormalImage:PcellLeft target:self action:@selector(leftBarButtonItemClick) width:35 height:35];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}
-(void)leftBarButtonItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  70;
    }else{
        return 180;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JFTextFieldCell *cell = [JFTextFieldCell cellWithTableView:tableView];
        return cell;
    }else{
        JFLoginBtnCell *cell = [JFLoginBtnCell cellWithTableView:tableView];
        cell.delegate  = self;
        return cell;
    }
}
-(void)loginBtnClick:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
