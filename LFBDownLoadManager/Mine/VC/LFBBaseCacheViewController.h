//
//  LFBBaseCacheViewController.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/16.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBBaseViewController.h"
#import "LFBDownLoadFile.h"

@interface LFBBaseCacheViewController : LFBBaseViewController
@property (nonatomic, strong) NSMutableArray<LFBDownLoadModel *> *dataSource;  // 数据源
@property (nonatomic, weak) UITableView *tableView;                           // 列表
@property (nonatomic, assign, readonly, getter=isNavEditing) BOOL navEditing; // 是否是编辑删除状态
@property (nonatomic, assign, readonly) CGFloat tabbarViewHeight;             // 底部工具栏视图高度

// 刷新列表
- (void)reloadTableView;

// 刷新一个cell
- (void)reloadRowWithModel:(LFBDownLoadModel *)model index:(NSInteger)index;

// 增加一条数据
- (void)insertModel:(LFBDownLoadModel *)model;

// 移除一条数据
- (void)deleteRowAtIndex:(NSInteger)index;

// 更新数据
- (void)updateViewWithModel:(LFBDownLoadModel *)model index:(NSInteger)index;


@end

