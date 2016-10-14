//
//  WeiboCellLayout.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/11.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WeiboModel.h"
#import "WXLabel.h"





@interface WeiboCellLayout (){
    CGFloat _cellHeight;
}

@end

@implementation WeiboCellLayout


+(instancetype)layoutWithWeiboModel:(WeiboModel *)weibo{
    WeiboCellLayout *layout = [[WeiboCellLayout alloc]init];
    if (layout) {
        layout.weibo = weibo;
    }
    return layout;
}

-(void)setWeibo:(WeiboModel *)weibo{
    if (_weibo == weibo) {
        return ;
    }
    _weibo = weibo;
    _cellHeight = 0;
    _cellHeight +=CellTopViewHeight;
    
    _cellHeight += SpaceWidth;
//    
//    NSDictionary * dic = @{NSFontAttributeName : kWeiboTextFont};
//    CGRect rect = [_weibo.text boundingRectWithSize:CGSizeMake(kScreenWidth-2*SpaceWidth, 1000)
//                                                 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic
//                                                 context:nil];
    //微博正文高度
    CGFloat weiboTextHeight =[WXLabel getTextHeight:kWeiboTextFont.pointSize
                                              width:kScreenWidth-2*SpaceWidth
                                               text:_weibo.text
                                          lineSpace:LineSpace];
    
    _weiboTextFrame = CGRectMake(SpaceWidth, CellTopViewHeight+SpaceWidth, kScreenWidth-2*SpaceWidth, weiboTextHeight);
    
    _cellHeight += weiboTextHeight;
    
    _cellHeight += SpaceWidth;
    
    
    //转发的微博正文和背景
    if (_weibo.retweeted_status) {
//        NSDictionary * dic = @{NSFontAttributeName : kReWeiboTextFont};
//        CGRect rect = [_weibo.retweeted_status.text boundingRectWithSize:CGSizeMake(kScreenWidth-4*SpaceWidth, 1000)
//                                                options:NSStringDrawingUsesLineFragmentOrigin attributes:dic
//                                                context:nil];
        //转发微博正文高度
        CGFloat reWeiboTextHeight =[WXLabel getTextHeight:kReWeiboTextFont.pointSize
                                                    width:kScreenWidth-4*SpaceWidth
                                                     text:_weibo.retweeted_status.text
                                                    lineSpace:LineSpace];
        _reWeiboTextFrame = CGRectMake(SpaceWidth*2, _cellHeight+SpaceWidth, kScreenWidth-4*SpaceWidth, reWeiboTextHeight);
        _cellHeight += reWeiboTextHeight;
        _cellHeight += SpaceWidth*3;
        
        
        CGFloat imageHeight;
        if (_weibo.retweeted_status.pic_urls.count>0) {
            imageHeight = [self layoutNineImageViewWith:_weibo.retweeted_status.pic_urls.count  viewWidth:(kScreenWidth-2*SpaceWidth-2*ImageViewSpace) topViewY:CGRectGetMaxY(_reWeiboTextFrame)+SpaceWidth];
            _cellHeight += imageHeight;
            _cellHeight += SpaceWidth;

        }else{
             _imgViewArr = nil;
        }
        //转发微博背景
        _reWeiboBGFrame = CGRectMake(SpaceWidth , _reWeiboTextFrame.origin.y-SpaceWidth, kScreenWidth-2*SpaceWidth, 3*SpaceWidth+reWeiboTextHeight+imageHeight);
        
        
    }else{
        _reWeiboTextFrame = CGRectZero;
        _reWeiboBGFrame = CGRectZero;
        
        //图片高度
        if (_weibo.pic_urls.count > 0) {
            CGFloat imageHeight = [self layoutNineImageViewWith:_weibo.pic_urls.count viewWidth:(kScreenWidth-2*SpaceWidth) topViewY:CGRectGetMaxY(_weiboTextFrame)+SpaceWidth];
            _cellHeight +=imageHeight;
            _cellHeight +=SpaceWidth;
        }else{
            _imgViewArr = nil;
        }
        

        
    }
    
    
}


-(CGFloat)cellHeight{
    return _cellHeight;
}

#pragma mark - 九宫格布局
//第一个参数 视图数量 第二个参数  视图总宽度  第三个参数  总视图的起始 宽度
-(CGFloat)layoutNineImageViewWith:(NSInteger)imageCount
                        viewWidth:(CGFloat)width
                         topViewY:(CGFloat)y{
    if (imageCount >9 || imageCount <= 0) {
        _imgViewArr = nil;
        return 0;
    }
    
    //视图总高度
    CGFloat viewHeight;
    CGFloat imageWidth;
    NSInteger numberOfColumn = 2;
    
    if (imageCount == 1) {
        //一行一列
        imageWidth = width-2*ImageViewSpace;
        numberOfColumn = 1;
        viewHeight = width;
    } else if (imageCount == 2){
        //一行两列
        imageWidth = (width - ImageViewSpace*3) / 2;
        viewHeight = imageWidth;
    }else if (imageCount == 4){
        //两行两列
        imageWidth = (width - ImageViewSpace*3 ) / 2;
        viewHeight = width;
    }else{
        //三列
        imageWidth = (width - 4* ImageViewSpace) / 3;
        numberOfColumn = 3;
        if (imageCount == 3) {
            //一行
            viewHeight = imageWidth;
        }else if (imageCount <= 6){
            //两行
            viewHeight = 2*imageWidth+ImageViewSpace;
        }else{
            //三行
            viewHeight = width;
        }
    }
    //初始化可变数组
    NSMutableArray *_mArr = [NSMutableArray array];
    
    for (int i = 0; i< 9; i++) {
        //没有图片  没有frame
        if (i>= imageCount) {
            CGRect frame = CGRectZero;
            [_mArr addObject:[NSValue valueWithCGRect:frame]];
        }else{
        //判断当前视图是第几行 第几列
        NSInteger row = i /numberOfColumn;
        NSInteger column = i % numberOfColumn;
        
        //计算视图frame
        CGFloat imgWidth = imageWidth+ImageViewSpace;
        CGFloat left = (kScreenWidth - width ) / 2;
        CGRect frame = CGRectMake(left+imgWidth*column+ImageViewSpace, y+row*imgWidth, imageWidth, imageWidth);
        
        [_mArr addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    
    _imgViewArr = [_mArr copy];
    
    return viewHeight;
}




@end
