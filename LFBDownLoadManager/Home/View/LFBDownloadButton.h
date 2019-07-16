//
//  LFBDownloadButton.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBDownLoadFile.h"

@interface LFBDownloadButton : UIView

@property (nonatomic, strong) LFBDownLoadModel *model;  // 数据模型
@property (nonatomic, assign) LFBDownLoadState state;   // 下载状态
@property (nonatomic, assign) CGFloat progress;        // 下载进度

// 添加点击方法
- (void)addTarget:(id)target action:(SEL)action;

@end

