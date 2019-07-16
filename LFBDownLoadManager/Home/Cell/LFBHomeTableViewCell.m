//
//  LFBHomeTableViewCell.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBHomeTableViewCell.h"
#import "LFBDownloadButton.h"
#import "UIColor+Utils.h"
#import "UIView+Utils.h"

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES : NO)
@interface LFBHomeTableViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;            // 标题
@property (nonatomic, weak) UILabel *speedLabel;            // 进度标签
@property (nonatomic, weak) UILabel *fileSizeLabel;         // 文件大小标签
@property (nonatomic, weak) LFBDownloadButton *downloadBtn;  // 下载按钮
@end

@implementation LFBHomeTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tabelView
{
    static NSString *identifier = @"LFBHomeTableViewCellIdentifier";
    
    LFBHomeTableViewCell *cell = [tabelView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LFBHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        // 选中时cell背景色
        UIView *backgroundViews = [[UIView alloc] initWithFrame:cell.frame];
        backgroundViews.backgroundColor = [[UIColor colorFromString:@"#00CDCD"] colorWithAlphaComponent:0.5f];
        [cell setSelectedBackgroundView:backgroundViews];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 底图
        CGFloat margin = 10.f;
        CGFloat backViewH = 70.f;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, margin * 0.5, KMainW - margin * 2, backViewH)];
        backView.backgroundColor = [UIColor colorFromString:@"#00CDCD"];
        [self.contentView addSubview:backView];
        
        // 下载按钮
        CGFloat btnW = 50.f;
        LFBDownloadButton *downloadBtn = [[LFBDownloadButton alloc] initWithFrame:CGRectMake(backView.width - btnW - margin, (backViewH - btnW) * 0.5, btnW, btnW)];
        [downloadBtn addTarget:self action:@selector(downBtnOnClick:)];
        [backView addSubview:downloadBtn];
        _downloadBtn = downloadBtn;
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, backView.width - margin * 3 - btnW, backViewH * 0.6)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = backView.backgroundColor;
        titleLabel.layer.masksToBounds = YES;
        [backView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        // 进度标签
        UILabel *speedLable = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(titleLabel.frame), titleLabel.width * 0.36, backViewH * 0.4)];
        speedLable.font = [UIFont systemFontOfSize:14.f];
        speedLable.textColor = [UIColor whiteColor];
        speedLable.textAlignment = NSTextAlignmentRight;
        speedLable.backgroundColor = backView.backgroundColor;
        speedLable.layer.masksToBounds = YES;
        [backView addSubview:speedLable];
        _speedLabel = speedLable;
        
        // 文件大小标签
        UILabel *fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(speedLable.frame), CGRectGetMaxY(titleLabel.frame), titleLabel.width - speedLable.width, backViewH * 0.4)];
        fileSizeLabel.font = [UIFont systemFontOfSize:14.f];
        fileSizeLabel.textColor = [UIColor whiteColor];
        fileSizeLabel.textAlignment = NSTextAlignmentRight;
        fileSizeLabel.backgroundColor = backView.backgroundColor;
        fileSizeLabel.layer.masksToBounds = YES;
        [backView addSubview:fileSizeLabel];
        _fileSizeLabel = fileSizeLabel;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *subviews = ISIOS11 ? self.superview.subviews : self.subviews;
    NSString *classString = ISIOS11 ? @"UISwipeActionPullView" : @"UITableViewCellDeleteConfirmationView";
    for (UIView *view in subviews) {
        if ([view isKindOfClass:NSClassFromString(classString)]) {
            UIButton *deleteBtn = view.subviews.firstObject;
            view.backgroundColor = [UIColor clearColor];
            deleteBtn.top = 5;
            deleteBtn.height = 70;
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)setModel:(LFBDownLoadModel *)model
{
    _model = model;
    
    _downloadBtn.model = model;
    _titleLabel.text = model.fileName;
    [self updateViewWithModel:model];
}

// 更新视图
- (void)updateViewWithModel:(LFBDownLoadModel *)model
{
    _downloadBtn.progress = model.progress;
    
    [self reloadLabelWithModel:model];
}

// 刷新标签
- (void)reloadLabelWithModel:(LFBDownLoadModel *)model
{
    NSString *totalSize = [LFBDownLoadToolBox stringFromByteCount:model.totalFileSize];
    NSString *tmpSize = [LFBDownLoadToolBox stringFromByteCount:model.tmpFileSize];
    
    if (model.state == LFBDownLoadStateFinish) {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@", totalSize];
        
    }else {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@ / %@", tmpSize, totalSize];
    }
    _fileSizeLabel.hidden = model.totalFileSize == 0;
    
    if (model.speed > 0) {
        _speedLabel.text = [NSString stringWithFormat:@"%@ / s", [LFBDownLoadToolBox stringFromByteCount:model.speed]];
    }
    _speedLabel.hidden = !(model.state == LFBDownLoadStateDownLoading && model.totalFileSize > 0);
}

- (void)downBtnOnClick:(LFBDownloadButton *)btn
{
    // do something...
}

@end
