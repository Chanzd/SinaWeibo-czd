//
//  RightViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "RightViewController.h"
#import "BaseNavigationController.h"
#import "SendWeiboViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.imgName = @"mask_bg.jpg";
    
    [self.view insertSubview:bgImageView atIndex:0];
    [self createButtons];
    // Do any additional setup after loading the view.
}

-(void)createButtons{
    CGFloat btnWidth = 50;
    CGFloat space = 15;
    for (int i = 0; i<5; i++) {
        CGRect frame =CGRectMake(space, i*(space+btnWidth)+space, btnWidth, btnWidth);
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.frame =frame;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        NSString *imgName =[NSString stringWithFormat:@"newbar_icon_%i.png",i+1];
        btn.imgName = imgName;
        
            }
    //地图按钮
    UIButton *mapBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame =CGRectMake(space, 0, btnWidth, btnWidth);
    [mapBtn setImage:[UIImage imageNamed:@"btn_map_location@2x.jpg"] forState:UIControlStateNormal];
    
    [self.view addSubview:mapBtn];
    //二维码扫描按钮
    UIButton *scanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanbtn.frame = CGRectMake(space, 0, btnWidth, btnWidth);
    [scanbtn setImage:[UIImage imageNamed:@"qr_btn@2x.jpg"] forState:UIControlStateNormal];
    
    [self.view addSubview:scanbtn];
    //设置按钮底部距离
    scanbtn.bottom = kScreenHeight - 64 - space;
    mapBtn.bottom = scanbtn.top;

    
}
-(void)btnAction:(UIButton *)btn{
    if (btn.tag == 0) {
        SendWeiboViewController *send = [[SendWeiboViewController alloc]init];
        BaseNavigationController *navi =[[BaseNavigationController alloc]initWithRootViewController:send];
        [self presentViewController:navi animated:YES completion:^{
            MMDrawerController *mmd =self.mm_drawerController;
            [mmd closeDrawerAnimated:YES completion:nil];
        }];
    }
    
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
