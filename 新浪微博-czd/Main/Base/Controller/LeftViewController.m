//
//  LeftViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_table;
    NSArray *_data;
    NSInteger _selectIndex;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.imgName = @"mask_bg.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
    _data=@[@"无",@"滑动",@"滑动&缩放",@"3D旋转",@"视差滑动"];
    [self createTableView];
    _selectIndex = 1;
    
    // Do any additional setup after loading the view.
}

-(void)createTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, kScreenHeight-64) style:UITableViewStylePlain];
    _table.backgroundColor =[UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
}
#pragma mark - 表视图代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor =[UIColor clearColor];
    }
    cell.textLabel.text =_data[indexPath.row];
    if (indexPath.row == _selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
//单元格点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       _selectIndex = indexPath.row;
        [_table reloadData];
    MMExampleDrawerVisualStateManager *manager =[MMExampleDrawerVisualStateManager sharedManager];
    manager.leftDrawerAnimationType = indexPath.row;
    manager.rightDrawerAnimationType = indexPath.row;
    
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
