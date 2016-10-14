//
//  UserModel.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
                    @"des":@"description"
             };
}
@end
