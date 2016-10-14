//
//  AppDelegate.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/9.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)SinaWeibo * sina;

-(void)logOutWeibo;

@end

