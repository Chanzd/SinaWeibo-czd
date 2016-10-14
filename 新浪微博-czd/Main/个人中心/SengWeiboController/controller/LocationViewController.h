//
//  LocationViewController.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^LocationResultBlock)(NSDictionary *result);


@interface LocationViewController : BaseViewController

@property (nonatomic, copy) LocationResultBlock block;

- (void)addLocationResultBlock:(LocationResultBlock)block;


@end
