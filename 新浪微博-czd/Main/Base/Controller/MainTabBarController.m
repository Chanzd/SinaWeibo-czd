//
//  MainTabBarController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()
{
    ThemeImageView * _arrowView;
}

@end

@implementation MainTabBarController

-(instancetype)init{
    self = [super init];
    if (self) {
        NSMutableArray * marr = [NSMutableArray array];
        NSArray * fileNames = @[@"HomeStoryboard",@"MessageStoryboard",@"ProfileStoryboard",@"DiscoverStoryboard",@"MoreStoryboard"];
        for (NSString * fileName in fileNames) {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:fileName bundle:[NSBundle mainBundle]];
            
            UIViewController *vc = [sb instantiateInitialViewController];
            if (vc != nil) {
                [marr addObject:vc];
            }
            
        }
        self.viewControllers = [marr copy];
        //创建子视图控件
        [self customTabBar];
    }
    return self;
}

-(void)customTabBar {
    
    //设置标签栏背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, -5, kScreenWidth, 54)];
    bgImageView.imgName = @"mask_navbar.png";
    [self.tabBar insertSubview:bgImageView atIndex:0];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    //移除系统按钮
    for (UIView * view in self.tabBar.subviews) {
        Class TabBarButton = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:TabBarButton]) {
            [view removeFromSuperview];
        }
        //按钮宽度
        CGFloat btnWidth = self.view.bounds.size.width / 5;
        //创建自定义按钮
        for (int i = 0; i < 5; i++) {
            ThemeButton * btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, 49);
            [self.tabBar addSubview:btn];
            
            
            NSString *imgName = [NSString stringWithFormat:@"home_tab_icon_%i@2x.png",i+1];
            btn.imgName = imgName;
            btn.tag = 100 + i;

            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
       
        
        //选中框
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
             _arrowView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, btnWidth, 49)];
        });
      _arrowView.imgName = @"home_bottom_tab_arrow@2x.png";
        [self.tabBar insertSubview:_arrowView atIndex:1];
        
    }
}
-(void) btnAction: (UIButton *)btn{
//    if (btn.tag >= 0 &&  )
    self.selectedIndex = btn.tag - 100;
    [UIView animateWithDuration:0.2 animations:^{
        _arrowView.center = btn.center;
    }];
}
//- ( void)viewWillAppear:(BOOL)animated{
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
