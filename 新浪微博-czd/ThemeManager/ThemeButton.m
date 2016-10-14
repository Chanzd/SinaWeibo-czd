//
//  ThemeButton.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)themeChange{
    UIImage *img = [[ThemeManager shardManager]themeChangeWithImageName:_imgName];
    UIImage *bgImg = [[ThemeManager shardManager]themeChangeWithImageName:_bgImgName];
    
    [self setImage:img forState:UIControlStateNormal];
    [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    
}
-(void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self themeChange];
}
-(void)setBgImgName:(NSString *)bgImgName{
    _bgImgName = bgImgName;
    [self themeChange];
}
@end
