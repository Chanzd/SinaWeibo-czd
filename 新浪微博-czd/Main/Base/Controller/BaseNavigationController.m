//
//  BaseNavigationController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changedTheme];
    //监听通知，切换主题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedTheme) name:kThemeChangeNotificationKey object:nil];
    

    
    //设置标题字体/颜色
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:25],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = attributes;
    //将导航栏设置为不透明  会影响每一个视图的布局
    self.navigationBar.translucent = NO;

    // Do any additional setup after loading the view.
}

- (void)changedTheme {
    
    //获取背景图片
    NSString *imageName;
    if (kSystemVersion >= 7) {
        imageName = @"mask_titlebar64.png";
    } else {
        imageName = @"mask_titlebar.png";
    }
    
    UIImage *image = [[ThemeManager shardManager] themeChangeWithImageName:imageName];
    
    //设置导航栏背景
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
