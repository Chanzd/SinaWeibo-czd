//
//  WeiboCell.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
#import "RegexKitLite.h"
#import "WeiboWebViewController.h"
#import "WXPhotoBrowser.h"



@interface WeiboCell ()<WXLabelDelegate,PhotoBrowerDelegate>
@property(nonatomic,strong)WXLabel *weiboTextLabel;





@property(nonatomic,strong)ThemeImageView * reWeiboImgView;

@end

@implementation WeiboCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _userName.colorName =kHomeUserNameTextColor;
    _sourceLabel.colorName = kHomeTimeLabelTextColor;
    _timeLabel.colorName = kHomeTimeLabelTextColor;
    // Initialization code
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationKey object:nil];
    [self themeChange];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)themeChange{
    ThemeManager *manager =[ThemeManager shardManager];
    
    self.weiboTextLabel.textColor = [manager themeColorWithName:kHomeWeiboTextColor];
    self.reWeiboTextLabel.textColor = [manager themeColorWithName:kHomeReWeiboTextColor];
    
}
//懒加载 微博正文
-(WXLabel *) weiboTextLabel{
    if (!_weiboTextLabel) {
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _weiboTextLabel.numberOfLines = 0;
        _weiboTextLabel.font = kWeiboTextFont;
        _weiboTextLabel.linespace = LineSpace;
        _weiboTextLabel.wxLabelDelegate=self;
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}

#pragma mark - WXLabelDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@[\\w+]{2,30}";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#[^#]+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;

}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return [[ThemeManager shardManager]themeColorWithName:KLinkColor];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    NSString *regex = @"http(s)?://([a-zA-Z0-9.-_]+(/)?)+";
    if ([context isMatchedByRegex:regex]) {
        WeiboWebViewController *webVC =[[WeiboWebViewController alloc]initWithURL:[NSURL URLWithString:context]];
        webVC.hidesBottomBarWhenPushed = YES;
        //通过响应者连找到navigation
        UIResponder *nextResponder = self.nextResponder;
        while (nextResponder) {
            if ([nextResponder isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navi =(UINavigationController *)nextResponder;
                [navi pushViewController:webVC animated:YES];
            }
            nextResponder=nextResponder.nextResponder;
        }
    }
}

//微博图片懒加载
-(NSArray *)imgsArr{
    if (!_imgsArr) {
        NSMutableArray *mArr =[NSMutableArray array];
        for (int i=0; i<9; i++) {
            UIImageView *imgView =[[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.backgroundColor =[UIColor purpleColor];
            //添加点击手势
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imgView addGestureRecognizer:tap];
            imgView.userInteractionEnabled = YES;
            //imgView的tag设定 判定是哪个图片
            imgView.tag =i;
            [self.contentView addSubview:imgView];
            [mArr addObject:imgView];
        }
        _imgsArr = [mArr copy];
    }
    return _imgsArr;
}
//图片点击事件
-(void)imgAction:(UITapGestureRecognizer *)tap{
    
    UIImageView *imgView =(UIImageView *)tap.view;
    
    [WXPhotoBrowser showImageInView:self.window
                   selectImageIndex:imgView.tag
                           delegate:self];
    
}

#pragma mark - wxphotodelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    if (_weiboModel.retweeted_status.pic_urls.count>0) {
        return _weiboModel.retweeted_status.pic_urls.count;
    }else{
        return _weiboModel.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo =[[WXPhoto alloc]init];
    
    NSString *imgString =nil;
    
    if (_weiboModel.retweeted_status.pic_urls.count>0) {
       NSDictionary *dic = _weiboModel.retweeted_status.pic_urls[index];
        imgString = dic[@"thumbnail_pic"];
    }else{
       NSDictionary *dic = _weiboModel.pic_urls[index];
        imgString = dic[@"thumbnail_pic"];
    }
    //将缩略图地址转化为大图地址
    imgString = [imgString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    photo.url = [NSURL URLWithString:imgString];
//  原 imageView 用来做动画效果
    photo.srcImageView = _imgsArr[index];
    return photo;
}
//转发微博背景图片 懒加载
-(ThemeImageView *)reWeiboImgView{
    if (!_reWeiboImgView) {
        _reWeiboImgView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        _reWeiboImgView.imgName =@"timeline_rt_border_9@2x";
        _reWeiboImgView.leftWidth = 27;
        _reWeiboImgView.topWidth = 20;
        [self.contentView insertSubview:_reWeiboImgView atIndex:0];
    }
    return _reWeiboImgView;
}
//转发微博正文
-(WXLabel *)reWeiboTextLabel{
    if (!_reWeiboTextLabel) {
        _reWeiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _reWeiboTextLabel.font =kReWeiboTextFont;
        _reWeiboTextLabel.wxLabelDelegate=self;
        _reWeiboTextLabel.linespace =LineSpace;
        _reWeiboTextLabel.numberOfLines = 0;
        [self.contentView addSubview:_reWeiboTextLabel];
    }
    return _reWeiboTextLabel;
}


-(void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    [_userImaeView sd_setImageWithURL:_weiboModel.user.profile_image_url];
//    _timeLabel.text = _weiboModel.created_at;
//    _sourceLabel.text  =_weiboModel.source;
    _userName.text = _weiboModel.user.name;
   
    //微博来源
    if (_weiboModel.source.length != 0) {
        NSArray *arr1 = [_weiboModel.source componentsSeparatedByString:@">"];
        NSString *subStr = [arr1 objectAtIndex:1];
        NSArray *arr2 = [subStr componentsSeparatedByString:@"<"];
        NSString *source = [arr2 firstObject];
        _sourceLabel.text = [NSString stringWithFormat:@"来源于：%@",source];
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    
    //时间设置
    NSString *formatterStr = [NSString stringWithFormat:@"E M d HH:mm:ss Z yyyy"];
    NSDateFormatter *formatter =[[ NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    NSDate *date =[formatter dateFromString:_weiboModel.created_at];
    
    NSTimeInterval second = -[date timeIntervalSinceNow];
    NSTimeInterval minute = second / 60;
    NSTimeInterval hour = minute / 60;
    NSTimeInterval day = hour / 24;
    NSString *timeStr = nil;
    if (second < 60) {
        timeStr = @"刚刚";
    }else if (minute < 60){
        timeStr = [NSString stringWithFormat:@"%li分钟之前",(NSInteger)minute];
    }else if (hour < 24){
          timeStr = [NSString stringWithFormat:@"%li小时之前",(NSInteger)hour];
    }else if (day < 7){
          timeStr = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
    }else{
        [formatter setDateFormat:@"M月d日 HH:mm"];
        [formatter setLocale:[NSLocale currentLocale]];
        
        timeStr = [formatter stringFromDate:date];
    }
    
    //布局对象创建
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:_weiboModel];
    _timeLabel.text = timeStr;
    //微博正文
    self.weiboTextLabel.text = _weiboModel.text;
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    //微博图片
    if (_weiboModel.retweeted_status.bmiddle_pic) {
        for (int i = 0; i < 9; i ++) {
            UIImageView *iv = self.imgsArr[i];
            CGRect frame = [layout.imgViewArr[i] CGRectValue];
            iv.frame = frame;
            if (i<_weiboModel.retweeted_status.pic_urls.count) {
                NSURL *url = [NSURL URLWithString:_weiboModel.retweeted_status.pic_urls[i][@"thumbnail_pic"]];
                [iv sd_setImageWithURL:url];
            }
        }

    }else if (_weiboModel.bmiddle_pic){
        for (int i = 0; i < 9; i ++) {
            UIImageView *iv = self.imgsArr[i];
            CGRect frame = [layout.imgViewArr[i] CGRectValue];
            iv.frame = frame;
            if (i<_weiboModel.pic_urls.count) {
                NSURL *url = [NSURL URLWithString:_weiboModel.pic_urls[i][@"thumbnail_pic"]];
                [iv sd_setImageWithURL:url];
            }
        }
    }else{
        for (UIImageView *iv in _imgsArr) {
            iv.frame = CGRectZero;
        }
    }
    //转发微博
        self.reWeiboTextLabel.text = _weiboModel.retweeted_status.text;
        self.reWeiboTextLabel.frame = layout.reWeiboTextFrame;
    //转发微博背景
    self.reWeiboImgView.frame = layout.reWeiboBGFrame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
