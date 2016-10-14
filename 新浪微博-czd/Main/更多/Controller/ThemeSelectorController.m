//
//  ThemeSelectorController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "ThemeSelectorController.h"

@interface ThemeSelectorController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_table;
    UIColor * _textColor;
}

@end

@implementation ThemeSelectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    //创建表视图
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    //设置背景颜色
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.imgName = @"bg_detail.jpg";
    [_table insertSubview:bgImageView atIndex:0];
    _table.delegate = self;
    _table.dataSource = self;
    
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];
    [self themeChange];
    // Do any additional setup after loading the view.
}
-(void)themeChange{
    _textColor = [[ThemeManager shardManager]themeColorWithName:kMoreItemTextColor];
    [_table reloadData];
    _table.separatorColor = [[ThemeManager shardManager]themeColorWithName:kMoreItemLineColor];
}
#pragma  mark - 表视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ThemeManager shardManager].allThemes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeManager *manager = [ThemeManager shardManager];
    NSDictionary *allThemes = manager.allThemes;
    //获取所有主题的主题名
    NSArray *allNames = allThemes.allKeys;
    //创建单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *key = allNames[indexPath.row];
    cell.textLabel.text = key;
    cell.textLabel.textColor = _textColor;
    
    //图片
    //more_icon_theme.png
    NSString *imageName = [NSString stringWithFormat:@"%@/%@", allThemes[key], @"more_icon_theme.png"];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    
    //如果当前单元格，是被选中的主题，则打勾
    if ([key isEqualToString:manager.currentThemeName]) {
        //打勾
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置当前显示的主题为，点中的主题
    //1.获取所有的主题数组
    ThemeManager *manager = [ThemeManager shardManager];
    NSDictionary *allThemes = manager.allThemes;
    //获取所有主题的主题名
    NSArray *allNames = allThemes.allKeys;
    
    //2.从数组中，拿到所对应的主题名字
    NSString *selectTheme = allNames[indexPath.row];
    
    //3.设定
    manager.currentThemeName = selectTheme;
    
    //刷新表视图
    [_table reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
