//
//  WeiboWebViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/13.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "WeiboWebViewController.h"

@interface WeiboWebViewController ()

@end

@implementation WeiboWebViewController

-(instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    
    [self.view addSubview:web];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [web loadRequest:request];
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
