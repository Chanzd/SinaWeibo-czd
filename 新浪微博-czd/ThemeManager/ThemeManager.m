//
//  ThemeManager.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "ThemeManager.h"

#define kCurrentThemeNameKey @"kCurrentThemeNameKey"


@implementation ThemeManager

#pragma  mark - 单例的实现
+(ThemeManager *)shardManager{
    static ThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:nil]init];
//            manager.currentThemeName = @"cat"; 触发 下面的set方法
        }
    });
    return manager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
      return [self shardManager];
}
-(id)copy{
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        //读取本地文件中的主题名
        _currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentThemeNameKey];
        
        if (_currentThemeName == nil) {
            _currentThemeName = @"猫爷";
        }

        //加载主题列表
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _allThemes = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        //加载文字颜色配置文件
        [self loadColorConfigFile];
    }
    return self;
}


#pragma mark - 主题改变发送通知

-(void)setCurrentThemeName:(NSString *)currentThemeName{
    
    //如果输入的主题名，不是已有主题
    if (!_allThemes[currentThemeName]) {
        return;
    }

    if (![_currentThemeName isEqualToString:currentThemeName]) {
        _currentThemeName = [currentThemeName copy];
        //每当切换主题  重新加载颜色配置 文件
        [self loadColorConfigFile];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeChangeNotificationKey object:nil userInfo:nil];
        
        //储存主题名，到本地文件
        [[NSUserDefaults standardUserDefaults] setObject:_currentThemeName forKey:kCurrentThemeNameKey];

    }
}

//加载颜色配置文件
-(void)loadColorConfigFile{
    NSString * bundlePath = [[NSBundle mainBundle]resourcePath];
    
    
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/config.plist",bundlePath,_allThemes[_currentThemeName]];
    
    _colorConfigDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
}


-(UIImage *)themeChangeWithImageName:(NSString *)imgName{
    NSString *name = [NSString stringWithFormat:@"%@/%@",_allThemes[_currentThemeName],imgName];
    UIImage *img= [UIImage imageNamed:name];
    
    return img;
}

-(UIColor *)themeColorWithName:(NSString *)colorName{
    NSDictionary *colorDic = _colorConfigDic[colorName];
    if (colorDic == nil) {
        return [UIColor blackColor];
    }
    
    CGFloat red = [colorDic[@"R"] doubleValue ];
    CGFloat green = [colorDic[@"G"] doubleValue];
    CGFloat blue = [colorDic[@"B"] doubleValue];
    
    UIColor *color = [UIColor colorWithRed:red /255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return color;
    
}











@end
