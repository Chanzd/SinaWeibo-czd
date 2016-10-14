//
//  EmoticonInputView.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEmoticonWidth (kScreenWidth / 8)   //单个表情宽度
#define kPageControllerHeight 20            //页码显示器高度
#define kScrollViewHeight (kEmoticonWidth * 4)
#define kEmoticonInputViewHeight (kScrollViewHeight + kPageControllerHeight) //视图总高度



@interface EmoticonInputView : UIView
{
    NSArray *_emoticonsArray;
    UIScrollView *_scrollView;
}
@end
