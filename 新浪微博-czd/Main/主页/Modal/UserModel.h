//
//  UserModel.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,copy)NSString *idstr; //字符串型用户ID
@property(nonatomic,copy)NSString *screen_name;//用户昵称
@property(nonatomic,copy)NSString *name;//显示名称
@property(nonatomic,copy)NSString *location;//用户所在地
@property(nonatomic,copy)NSString *des;//个人描述
@property(nonatomic,copy)NSURL *url;//用户微博地址

@property(nonatomic,copy)NSURL *profile_image_url;//头像地址

@property(nonatomic,copy)NSURL *avatar_large;//大头像
@property(nonatomic,copy)NSString *gender;//性别

@property(nonatomic,strong)NSNumber *followers_count;//粉丝数
@property(nonatomic,strong)NSNumber *friends_count;//关注数
@property(nonatomic,strong)NSNumber *statuses_count;//微博数
@property(nonatomic,strong)NSNumber *favourites_count;//收藏数
@property(nonatomic,strong)NSNumber *verified;//是否认证


@end
