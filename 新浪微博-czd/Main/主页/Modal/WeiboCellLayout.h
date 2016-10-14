//
//  WeiboCellLayout.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CellTopViewHeight 60
#define SpaceWidth 10
#define ImageViewWidth 200
#define ImageViewSpace 5
#define LineSpace 3
@class WeiboModel;

@interface WeiboCellLayout : NSObject

@property(nonatomic,strong)WeiboModel *weibo;

//微博正文和图片
@property(nonatomic,assign,readonly)CGRect weiboTextFrame;
//@property(nonatomic,assign,readonly)CGRect weiboImageFrame;
//转发的微博
@property(nonatomic,assign,readonly)CGRect reWeiboTextFrame;
@property(nonatomic,assign,readonly)CGRect reWeiboBGFrame;//转发微博背景

@property(nonatomic,strong,readonly)NSArray *imgViewArr;

+(instancetype)layoutWithWeiboModel:(WeiboModel *)weibo;

-(CGFloat)cellHeight;
@end
