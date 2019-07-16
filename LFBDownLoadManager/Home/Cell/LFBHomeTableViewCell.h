//
//  LFBHomeTableViewCell.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBDownLoadFile.h"

@interface LFBHomeTableViewCell : UITableViewCell

@property (nonatomic, strong) LFBDownLoadModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tabelView;

// 更新视图
- (void)updateViewWithModel:(LFBDownLoadModel *)model;

@end


