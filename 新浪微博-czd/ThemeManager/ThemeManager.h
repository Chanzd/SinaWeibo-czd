//
//  ThemeManager.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface ThemeManager : NSObject


@property(nonatomic,copy)NSString * currentThemeName;

@property(nonatomic,copy)NSDictionary * allThemes;

@property(nonatomic,copy)NSDictionary * colorConfigDic;
+(ThemeManager *)shardManager;

-(UIImage *)themeChangeWithImageName:(NSString *)imgName;

-(UIColor *)themeColorWithName:(NSString *)colorName;

-(void)loadColorConfigFile;
@end
