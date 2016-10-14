//
//  WeiboModel.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "WeiboModel.h"
#import "YYModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"idStr":@"id"
             };
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *weiboText =[self.text copy];
    //使用正则表达式 查找表情字符串
    NSString *regex =@"\\[\\w+\\]";
    NSArray *array = [weiboText componentsMatchedByRegex:regex];
    
    //读取plist文件
    NSString *filePath =[[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [[NSArray alloc]initWithContentsOfFile:filePath];
    for (NSString *str in array) {
        NSString *s =[NSString stringWithFormat:@"chs='%@'",str];
        NSPredicate *pre =[NSPredicate predicateWithFormat:s];
        //谓词过滤
        NSArray *result = [emoticons filteredArrayUsingPredicate:pre];
        NSDictionary *dic =[result firstObject];
        
        if (dic == nil) {
            continue; //如果表情没找到 则忽略此表情
        }
        
        //如果找到 则替换
        NSString *imgName =dic[@"png"];
        NSString *imgString =[NSString stringWithFormat:@"<image url = '%@'>",imgName];
        
        weiboText =[weiboText stringByReplacingOccurrencesOfString:str withString:imgString];
        
    }
    
    
    self.text =[weiboText copy];
    return YES;
}



@end
