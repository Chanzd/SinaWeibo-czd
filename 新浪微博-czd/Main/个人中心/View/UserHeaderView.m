//
//  UserHeaderView.m
//  新浪微博-czd
//
//  Created by mac on 2016/10/14.
//  Copyright © 2016年 czd. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

@property (weak, nonatomic) IBOutlet ThemeLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImagView;
@property (weak, nonatomic) IBOutlet ThemeLabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;


@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *statusesLabel;





@end


@implementation UserHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.colorName = kHomeUserNameTextColor;
    _subtitleLabel.colorName = kHomeUserNameTextColor;
    _descriptionLabel.colorName = kHomeUserNameTextColor;
    _statusesLabel.colorName = kHomeUserNameTextColor;
    
}


- (void)setModel:(UserModel *)user {
    [_userImagView sd_setImageWithURL:user.profile_image_url];
    _nameLabel.text = user.name;
    _descriptionLabel.text = user.des;
    _followersLabel.text = [NSString stringWithFormat:@"%@", user.followers_count];
    _friendsLabel.text = [NSString stringWithFormat:@"%@", user.friends_count];
    _statusesLabel.text = [NSString stringWithFormat:@"微博数：%@", user.statuses_count];
    NSString *sex;
    if ([user.gender isEqualToString:@"m"]) {
        sex = @"男";
    } else if ([user.gender isEqualToString:@"f"]) {
        sex = @"女";
    } else {
        sex = @"未知";
    }
    _subtitleLabel.text = [NSString stringWithFormat:@"%@ %@", sex, user.location];
}

@end


