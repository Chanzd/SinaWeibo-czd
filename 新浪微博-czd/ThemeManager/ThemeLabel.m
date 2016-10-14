//
//  ThemeLabel.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

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
    UIColor *color = [[ThemeManager shardManager]themeColorWithName:_colorName];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = color;
//    self.tintColor = color;
}

-(void)setColorName:(NSString *)colorName{
    _colorName = [colorName copy] ;
    [self themeChange];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
