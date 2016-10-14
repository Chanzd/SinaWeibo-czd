//
//  ThemeImageView.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView


@property(nonatomic,copy)NSString * imgName;

//拉伸系数
@property(nonatomic,assign)CGFloat leftWidth;
@property(nonatomic,assign)CGFloat topWidth;
@end
