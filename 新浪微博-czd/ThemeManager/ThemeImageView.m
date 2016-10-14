//
//  ThemeImageView.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.leftWidth = 0;
        self.topWidth = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.leftWidth = 0;
    self.topWidth = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self themeChange];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)themeChange{
    ThemeManager *manager = [ThemeManager shardManager];
    
    UIImage *img = [manager themeChangeWithImageName:self.imgName];
    img = [img stretchableImageWithLeftCapWidth:_leftWidth topCapHeight:_topWidth];
    self.image = img;
    
}
//重新设置刷新点。刷新图片显示
-(void)setLeftWidth:(CGFloat)leftWidth{
    _leftWidth = leftWidth;
    [self themeChange];
}
-(void)setTopWidth:(CGFloat)topWidth{
    _topWidth = topWidth;
    [self themeChange];
}
@end
