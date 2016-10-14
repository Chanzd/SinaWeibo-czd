//
//  WeiboCell.h
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXLabel;
@class WeiboModel;

@interface WeiboCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImaeView;
@property (weak, nonatomic) IBOutlet ThemeLabel *userName;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;

@property(strong , nonatomic)NSArray *imgsArr;

@property(nonatomic,strong)WXLabel *reWeiboTextLabel;

@property(nonatomic,strong)WeiboModel *weiboModel;

@property(nonatomic,assign)BOOL isSelected;//是否被选中

@end
