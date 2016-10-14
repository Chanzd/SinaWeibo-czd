//
//  WeiboWebViewController.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/13.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboWebViewController : UIViewController


@property(nonatomic,strong)NSURL *url;

-(instancetype)initWithURL:(NSURL* )url;
@end
