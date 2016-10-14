//
//  HomeViewController.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/10.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "UIScrollView+AJWaveRefresh.h"
#import <AVFoundation/AVFoundation.h>

#define kHomeTimeLineURL @"statuses/home_timeline.json"

@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource,AJWaveRefreshProtocol>{
    UITableView *_table;
    NSMutableArray *_weiboArr;
    SystemSoundID _msgComnID;
    ThemeImageView *_newWeiboCountView;
    UILabel *_newWeiboCountLabel;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeiboData];
    [self createTableView];
    //获取文件URL
    NSURL *fileURL =[[NSBundle mainBundle]URLForResource:@"msgcome" withExtension:@"wav"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_msgComnID);
    // Do any additional setup after loading the view.
}
-(void)dealloc{
   
    AudioServicesRemoveSystemSoundCompletion(_msgComnID);
}
//创建表视图
-(void)createTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
//    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
//    bgImageView.imgName = @"bg_detail.jpg";
//    [_table insertSubview:bgImageView atIndex:0];
    _table.backgroundColor = [UIColor clearColor];
    
    //注册单元格
    UINib * nib =[UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    [_table setupRefresh:self];
    
    _newWeiboCountView = [[ThemeImageView alloc]initWithFrame:CGRectMake(3, 3, kScreenWidth-6, 40)];
    _newWeiboCountView.imgName = @"timeline_notify";
    _newWeiboCountView.transform = CGAffineTransformMakeTranslation(0, -60);
    [self.view addSubview:_newWeiboCountView];
    
    _newWeiboCountLabel = [[UILabel alloc]initWithFrame:_newWeiboCountView.bounds];
    _newWeiboCountLabel.textColor = [UIColor blackColor];
    _newWeiboCountLabel.textAlignment =NSTextAlignmentCenter;
    _newWeiboCountLabel.text =@"8条新微博";
    [_newWeiboCountView addSubview:_newWeiboCountLabel];
}

#pragma mark - 提示视图显示微博数量
-(void)showWeiboCountWith:(NSInteger)count{
    if (count == 0) {
        _newWeiboCountLabel.text = @"没有新微博";
    }else{
        _newWeiboCountLabel.text =[NSString stringWithFormat:@"%li条新微博",count];
    }
    
    //播放动画
    [UIView animateWithDuration:0.3 animations:^{
        _newWeiboCountView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        AudioServicesPlaySystemSound(_msgComnID);
       [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _newWeiboCountView.transform = CGAffineTransformMakeTranslation(0, -60);
       } completion:nil];
    }];
}


#pragma  mark - AJWaveRefreshProtocol

- (void)headerRereshing {
    [self loadNewData];
}

- (void)footerRereshing {
    [self loadMoreData];
}


-(void)loadWeiboData{
    
    SinaWeibo * weibo = kSinaWeiboObject;
    //判断是否已登录
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return ;
    }
    //发起网络请求
    
    NSDictionary *dic = @{@"count":@"20"};
    
   SinaWeiboRequest *request= [weibo requestWithURL:kHomeTimeLineURL
                   params:[dic mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    
    request.tag = 0;
    
    //监听数据读取

}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSLog(@"数据读取完毕");
    NSArray *arr =result[@"statuses"];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        WeiboModel *weibo = [WeiboModel yy_modelWithJSON:dic];
        [mArr addObject:weibo];
    }
    //区分网络请求
    if (request.tag == 0) {
        _weiboArr = [mArr mutableCopy];
    }else if (request.tag == 1){
        if (mArr.count == 0) {
            [self showWeiboCountWith:mArr.count];
            return ;
        }
        NSIndexSet *set =[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, mArr.count)];
        [_weiboArr insertObjects:mArr atIndexes:set];
        [self showWeiboCountWith:mArr.count];
           }else{
               NSIndexSet *set =[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_weiboArr.count, mArr.count)];
               [_weiboArr insertObjects:mArr atIndexes:set];
               
    }
    
    [_table reloadData];
}
#pragma mark - 加载更多数据
-(void)loadNewData{
    WeiboModel *wei = [_weiboArr firstObject];
    NSString *idStr = wei.idStr;
    
    SinaWeibo * weibo = kSinaWeiboObject;
    //判断是否已登录
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return ;
    }
    //发起网络请求
    
    NSDictionary *dic = @{@"count":@"20",
                                        @"since_id":idStr};
    
     SinaWeiboRequest *request=[weibo requestWithURL:kHomeTimeLineURL
                   params:[dic mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    request.tag = 1;
    [_table reloadData];
    [_table endRefreshing];
    
}
-(void)loadMoreData{
    WeiboModel *wei = [_weiboArr lastObject];
    NSString *idStr = wei.idStr;
    
    SinaWeibo * weibo = kSinaWeiboObject;
    //判断是否已登录
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return ;
    }
    //发起网络请求
    
    NSDictionary *dic = @{@"count":@"20",
                          @"max_id":idStr};
    
    SinaWeiboRequest *request=[weibo requestWithURL:kHomeTimeLineURL
                                             params:[dic mutableCopy]
                                         httpMethod:@"GET"
                                           delegate:self];
    request.tag = 1;

    [_table reloadData];
    [_table endRefreshing];

    
}



#pragma mark - 表视图代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];

    
    WeiboModel *wb = _weiboArr[indexPath.row];
    [cell setWeiboModel:wb];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *model = _weiboArr[indexPath.row];
//    NSDictionary * dic = @{NSFontAttributeName : kWeiboTextFont};
//    CGRect rect = [model.text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 1000)
//                                                 options:NSStringDrawingUsesLineFragmentOrigin attributes:dic
//                                                 context:nil];
//    CGFloat height =rect.size.height;
//    
//    CGFloat imageHeight = model.bmiddleImage ? 210 : 0;
    WeiboCellLayout *layout =[WeiboCellLayout layoutWithWeiboModel:model];
    
    return layout.cellHeight;
}

#pragma mark - 刷新微博
- (void)reloadNewWeibo {
    NSLog(@"刷新微博");
    //播放下啦刷新动画
    [_table startHeaderRefreshing];
    
    //调用下啦刷新方法
    [self loadNewData];
}




@end
