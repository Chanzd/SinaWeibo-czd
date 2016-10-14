//
//  AppDelegate.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "SinaWeibo.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "BaseNavigationController.h"

#define kAccessTokenKey @"kAccessTokenKey"
#define kUserIDKey @"kUserIDKey"
#define kExpirationDate @"kExpirationDate"
#define kAuthInfo @"kAuthInfo"

@interface AppDelegate ()<SinaWeiboDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    MainTabBarController *mbc = [[MainTabBarController alloc]init];
    
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    RightViewController *rightVC = [[RightViewController alloc]init];
    
    BaseNavigationController *leftNavi = [[BaseNavigationController alloc]initWithRootViewController:leftVC];
    BaseNavigationController *rightNavi = [[BaseNavigationController alloc]initWithRootViewController:rightVC];
    
    MMDrawerController *mmd =[[ MMDrawerController alloc]initWithCenterViewController:mbc leftDrawerViewController:leftNavi rightDrawerViewController:rightNavi];
    
    mmd.maximumLeftDrawerWidth = 180;
    mmd.maximumRightDrawerWidth = 80;
    
    [mmd setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmd setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    [mmd setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
        MMExampleDrawerVisualStateManager *manager =[MMExampleDrawerVisualStateManager sharedManager];
        MMDrawerControllerDrawerVisualStateBlock block =[manager drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
    }];
    
    
    
    self.window.rootViewController = mmd;
    
    [self initSinaWeibo];
    
    BOOL isLogIn = [self readAuthInfo];
    if (isLogIn == NO) {
        [self.sina logIn];
    }else{
        NSLog(@"已经登陆过微博,无须重复登录");
    }
    return YES;
}
//App Key：622730547
//App Secret：07a6058e99260572acf4f72dc58cc9bb
-(void) initSinaWeibo{
    _sina = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURL andDelegate:self];
}

-(void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    [self saveAuthInfo];
    NSLog(@"登录成功 ，信息已经保存");
    
}

-(void)saveAuthInfo{
    NSString *accessToKen = _sina.accessToken;
    NSString *uid = _sina.userID;
    NSDate *date = _sina.expirationDate;
    
    NSMutableDictionary * authInfoDic = [NSMutableDictionary dictionary];
    [authInfoDic setObject:accessToKen forKey:kAccessTokenKey];
    [authInfoDic setObject:uid forKey:kUserIDKey];
    [authInfoDic setObject:date forKey:kExpirationDate];
    
    NSUserDefaults *authInfo = [NSUserDefaults standardUserDefaults];
    
    [authInfo setObject:[authInfoDic copy] forKey:kAuthInfo];
    
    [authInfo synchronize];
    

    
}

-(BOOL)readAuthInfo {
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [userDef objectForKey:kAuthInfo];
    if (dic == nil) {
        return NO;
    }
    NSString * accessToken = dic[kAccessTokenKey];
    NSString *uid = dic[kUserIDKey];
    NSDate *date = dic[kExpirationDate];
    NSLog(@"%@",accessToken);
    
    if (accessToken == nil || uid == nil || date == nil) {
        return NO;
    }
    
    self.sina.accessToken = accessToken;
    self.sina.userID = uid;
    self.sina.expirationDate = date;
    
    return YES;
}




-(void)logOutWeibo{
    [self.sina logOut];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAuthInfo];
    [self.sina logIn];
}
-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    NSLog(@"注销成功");
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAuthInfo];
}

-(void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    NSLog(@"登录被取消");
}
-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    NSLog(@"登录失败");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
