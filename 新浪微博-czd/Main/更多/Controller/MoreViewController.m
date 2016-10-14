//
//  MoreViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet ThemeImageView *icon1;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon2;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon3;

@property (weak, nonatomic) IBOutlet ThemeImageView *icon4;
@property (strong, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet ThemeLabel *currentThemeName;
@property (weak, nonatomic) IBOutlet ThemeLabel *label1;
@property (weak, nonatomic) IBOutlet ThemeLabel *label2;
@property (weak, nonatomic) IBOutlet ThemeLabel *label3;
@property (weak, nonatomic) IBOutlet ThemeLabel *label4;
@property (weak, nonatomic) IBOutlet ThemeLabel *label5;



@end

@implementation MoreViewController

//界面即将显示时
- (void)viewWillAppear:(BOOL)animated {
    ThemeManager *manager = [ThemeManager shardManager];
    
    _currentThemeName.text = manager.currentThemeName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.icon1.imgName = @"more_icon_theme@2x.png";
    self.icon2.imgName = @"more_icon_account@2x.png";
    self.icon3.imgName = @"more_icon_draft@2x.png";
    self.icon4.imgName = @"more_icon_feedback@2x.png";
    
    self.label1.colorName = kMoreItemTextColor;
    self.label2.colorName = kMoreItemTextColor;
    self.label3.colorName = kMoreItemTextColor;
    self.label4.colorName = kMoreItemTextColor;
    self.label5.colorName = kMoreItemTextColor;
    self.currentThemeName.colorName = kMoreItemTextColor;
    
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.imgName = @"bg_detail.jpg";
    [_tabView insertSubview:bgImageView atIndex:0];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        SinaWeibo *weibo = kSinaWeiboObject;
        [weibo logOut];
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
