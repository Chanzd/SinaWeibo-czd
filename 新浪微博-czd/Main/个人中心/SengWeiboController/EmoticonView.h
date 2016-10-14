//
//  EmoticonView.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>


//每一个表情视图，最多可以显示32个表情
//使用一个数组，来保存32个表情
//绘制当前数组中保存的表情，到视图中
//识别手指点击
@interface EmoticonView : UIView


@property (nonatomic, copy) NSArray *emoticonsArray;

@property(nonatomic,copy)NSString *text;

@end
