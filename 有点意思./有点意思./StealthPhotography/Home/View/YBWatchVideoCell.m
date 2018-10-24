//
//  YBWatchVideoCell.m
//  有点意思.
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "YBWatchVideoCell.h"

@implementation YBWatchVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    self.memorySize = [[UILabel alloc]init];
    self.memorySize.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.memorySize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_memorySize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-25*UIScreenWidthScale);
        make.centerY.offset(0);
    }];
}







@end
