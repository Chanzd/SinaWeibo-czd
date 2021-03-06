//
//  WeiboModel.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface WeiboModel : NSObject

@property(nonatomic,copy)NSString *created_at;//发布时间
@property(nonatomic,copy)NSString *text;//微博文本
@property(nonatomic,copy)NSString *idStr;//微博编号
@property(nonatomic,assign)NSInteger reposts_count;//转发数
@property(nonatomic,assign)NSInteger comments_count;//评论数
@property(nonatomic,assign)NSInteger attitudes_count;//点赞数
@property(nonatomic,strong)UserModel *user;//发微博的用户
@property(nonatomic,strong)WeiboModel *retweeted_status;//被转发的微博
@property(nonatomic,copy)NSURL *thumbnail_pic;//缩略图
@property(nonatomic,copy)NSURL *bmiddle_pic;//中等图
@property(nonatomic,copy)NSURL *original_pic;//原始图
@property(nonatomic,copy)NSArray *pic_urls;//多图地址
@property(nonatomic,copy)NSString *source;//来源
@property (copy, nonatomic)     NSDictionary *geo;              //位置信息

@end
