//
//  WeiboAnnotation.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


- (void)setWeiboModel:(WeiboModel *)weiboModel {
    
    
    _weiboModel = weiboModel;
    
    //从微薄对象中 获取地理位置信息  填充的coordinate中
    NSDictionary *geo = _weiboModel.geo;
    //    NSLog(@"%@", geo);
    //获取经纬度坐标点
    NSArray *coordinates = geo[@"coordinates"];
    if (coordinates.count == 2) {
        //纬度
        double lat = [[coordinates firstObject] doubleValue];
        //经度
        double lon = [[coordinates lastObject] doubleValue];
        
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
    
}



@end

