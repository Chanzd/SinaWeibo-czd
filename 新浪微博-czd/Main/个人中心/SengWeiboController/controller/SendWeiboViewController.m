//
//  SendWeiboViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "HomeViewController.h"
#import "LocationViewController.h"
#import "SinaWeibo+SendWeibo.h"
#import "EmoticonInputView.h"



#define kSendWeiboAPI @"statuses/update.json"
#define kSengWeiboWithImageAPI @"statuses/upload.json"
#define kToolViewHeight 40
#define kLocationViewHeight 20

@class EmoticonInputView;
@class MBProgressHUD;


@interface SendWeiboViewController () <SinaWeiboRequestDelegate>
{
    UITextView *_inputTextView; //输入框
    UIView *_toolView;          //工具视图
    
    //定位相关视图
    UIView *_locationView;
    UIImageView *_locationIconImageView;
    ThemeLabel *_locationNameLabel;
    ThemeButton *_locationCancelButton;
    
    //表情选择输入框
    EmoticonInputView *_emoticonView;
}

@property (nonatomic, strong) NSDictionary *locationData;

@end

@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写微博";
    //创建导航栏按钮
    [self createNavigationBarButton];
    [self creatrInputView];
    [self createToolView];
    [self createLocationViews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - create Views


- (void)creatrInputView {
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_inputTextView];
    
    //监听键盘的改变
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)createToolView {
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _inputTextView.bottom;
    _toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_toolView];
    //创建五个按钮
    NSArray *imageNames = @[@"compose_toolbar_1.png",
                            @"compose_toolbar_3.png",
                            @"compose_toolbar_4.png",
                            @"compose_toolbar_5.png",
                            @"compose_toolbar_6.png",
                            ];
    
    CGFloat buttonWidth = kScreenWidth / imageNames.count;
    for (int i = 0; i < 5; i++) {
        CGRect frame = CGRectMake(i * buttonWidth, 0, buttonWidth, kToolViewHeight);
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.imgName = imageNames[i];
        [_toolView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)createNavigationBarButton {
    //titlebar_button_9.png
    //取消
    ThemeButton *leftButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.bgImgName = @"titlebar_button_9.png";
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //发送
    ThemeButton *rightButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.bgImgName = @"titlebar_button_9.png";
    [rightButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)createLocationViews {
    
    //创建父视图
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 10, kLocationViewHeight)];
    //    _locationView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_locationView];
    _locationView.bottom = _toolView.top;
    
    //icon
    _locationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight)];
    //    _locationIconImageView.backgroundColor = [UIColor greenColor];
    [_locationView addSubview:_locationIconImageView];
    
    //Label
    _locationNameLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(kLocationViewHeight, 0, 200, kLocationViewHeight)];
    _locationNameLabel.colorName = kMoreItemTextColor;
    _locationNameLabel.text = @"杭州职业技术学院";
    [_locationView addSubview:_locationNameLabel];
    //Button
    _locationCancelButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    _locationCancelButton.frame = CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight);
    _locationCancelButton.left = _locationNameLabel.right;
    _locationCancelButton.bgImgName = @"compose_toolbar_clear.png";
    [_locationView addSubview:_locationCancelButton];
    //添加点击
    [_locationCancelButton addTarget:self action:@selector(locationCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //默认隐藏
    _locationView.hidden = YES;
    
}


#pragma mark - Action
//取消定位
- (void)locationCancelButtonAction {
    self.locationData = nil;
}

- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)sendAction {
    
    //除去文本中的空白字符
    NSString *text = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //判断输入框中是否有文字
    if (text.length == 0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"⚠️" message:@"没有输入微博正文信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    //显示HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
    //添加HUD 到Window中
    [self.view.window addSubview:hud];
    //设置显示的文本
    hud.labelText = @"正在发送";
    //设置背景颜色  变暗效果
    hud.dimBackground = YES;
    //显示HUD
    [hud show:YES];
    
    
    //获取微博对象
    SinaWeibo *wb = kSinaWeiboObject;
    NSMutableDictionary *params = [@{@"status" : text} mutableCopy];
    
    //判断当前是否有定位信息，如果有则添加
    if (self.locationData) {
        NSString *lon = self.locationData[@"lon"];
        NSString *lat = self.locationData[@"lat"];
        
        //添加数据
        [params setObject:lon forKey:@"long"];
        [params setObject:lat forKey:@"lat"];
        //        [params setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>];//KVC
    }
    //    [wb requestWithURL:kSendWeiboAPI params:params httpMethod:@"POST" delegate:self];
    
    [wb sendWeiboWithText:text image:nil params:params success:^(id result) {
        //收起键盘
        [_inputTextView resignFirstResponder];
        
        //返回前一页面
        [self dismissViewControllerAnimated:YES completion:^{
            //刷新微博
            UIApplication *app = [UIApplication sharedApplication];
            AppDelegate *delegate = (AppDelegate *)app.delegate;
            MMDrawerController *mmd = (MMDrawerController *)delegate.window.rootViewController;
            UITabBarController *tabbar = (UITabBarController *)mmd.centerViewController;
            UINavigationController *navi = (UINavigationController *)[tabbar.viewControllers firstObject];
            
            HomeViewController *home = (HomeViewController *)navi.topViewController;
            
            [home reloadNewWeibo];
            
            
            hud.labelText = @"发送成功";
            //隐藏HUD
            [hud hide:YES afterDelay:2];
            
        }];
        
        
        
    } fail:^(NSError *error) {
        NSLog(@"失败");
        
        hud.labelText = @"发送失败";
        //隐藏HUD
        [hud hide:YES afterDelay:2];
    }];
    
    
    
}
//工具栏按钮点击事件
- (void)toolBarButtonAction:(UIButton *)button {
    if (button.tag == 3) {
        //打开定位界面
        LocationViewController *locaiton = [[LocationViewController alloc] init];
        //设置获取定位数据的Block回调
        [locaiton addLocationResultBlock:^(NSDictionary *result) {
            
            //保存位置数据
            self.locationData = result;
        }];
        [self.navigationController pushViewController:locaiton animated:YES];
        
    } else if (button.tag == 4) {
        //表情界面
        //表情界面懒加载
        if (_emoticonView == nil) {
            _emoticonView = [[EmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            
        }
        
        //获取输入框,将输入视图设置为表情
        //        _inputTextView.inputView = _emoticonView;
        //        if (_inputTextView.inputView) {
        //            _inputTextView.inputView = nil;
        //        } else {
        //            _inputTextView.inputView = _emoticonView;
        //        }
        _inputTextView.inputView = _inputTextView.inputView ? nil : _emoticonView;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendEmoticon:) name:@"biaoqing" object:nil];
        
        //重新加载输入视图
        [_inputTextView reloadInputViews];
        //强制弹出键盘
        [_inputTextView becomeFirstResponder];
        
        
        
    }
}

-(void)sendEmoticon:(NSNotification*)noti{
    _inputTextView.text = [_inputTextView.text stringByAppendingString:noti.userInfo[@"chs"] ];
    
}
#pragma mark - 键盘改变监听
- (void)keyboardFrameChanged:(NSNotification *)notification {
    
    //获取键盘的状态
    //键盘改变后的结束值
    NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    
    //根据键盘的位置，来改变视图的位置
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight - keyboardFrame.size.height;
    //工具栏
    _toolView.top = _inputTextView.bottom;
    _locationView.bottom = _toolView.top;
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight;
    _toolView.top = _inputTextView.bottom;
    _locationView.bottom = _toolView.top;
    
}




#pragma mark - SinaWeiboRequestDelegate
//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response {
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
//    if (httpResponse.statusCode == 200) {
//        NSLog(@"发送成功");
//        //收起键盘
//        [_inputTextView resignFirstResponder];
//
//        //返回前一页面
//        [self dismissViewControllerAnimated:YES completion:^{
//            //刷新微博
//            UIApplication *app = [UIApplication sharedApplication];
//            AppDelegate *delegate = (AppDelegate *)app.delegate;
//            MMDrawerController *mmd = (MMDrawerController *)delegate.window.rootViewController;
//            UITabBarController *tabbar = (UITabBarController *)mmd.centerViewController;
//            UINavigationController *navi = (UINavigationController *)[tabbar.viewControllers firstObject];
//
//            HomeViewController *home = (HomeViewController *)navi.topViewController;
//
//            [home reloadNewWeibo];
//
//        }];
//    }
//}

#pragma mark - 位置信息填充
//在locationData的SET方法中 来设置显示的位置数据
- (void)setLocationData:(NSDictionary *)locationData {
    
    
    
    if (_locationData != locationData) {
        _locationData = [locationData copy];
        if (_locationData == nil) {
            //点击取消按钮  将LocationData设置为空
            _locationView.hidden = YES;
        } else {
            _locationView.hidden = NO;
            //设置数据
            _locationNameLabel.text = _locationData[@"title"];
            [_locationIconImageView sd_setImageWithURL:[NSURL URLWithString:_locationData[@"icon"]]];
            
            //改变Label宽度
            NSDictionary *attributes = @{NSFontAttributeName : _locationNameLabel.font};
            CGRect rect = [_locationNameLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 10 - kLocationViewHeight * 2, kLocationViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGFloat width = rect.size.width;
            
            _locationNameLabel.width = width;
            _locationCancelButton.left = _locationNameLabel.right;
        }
        
        
    }
}

@end
