//
//  LFBDownLoadModel.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/10.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBDownLoadModel.h"
#import "FMDB.h"

@implementation LFBDownLoadModel

- (NSString *)localPath {
    if (!_localPath) {
        NSString *fileName = [_url substringFromIndex:[_url rangeOfString:@"/" options:NSBackwardsSearch].location +1];
        NSString *str = [NSString stringWithFormat:@"%@_%@", _vid, fileName];
        _localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:str];
    }
    return _localPath;
}

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {
    if (!resultSet) return nil;
    
    _vid = [NSString stringWithFormat:@"%@",[resultSet objectForColumn:@"vid"]];
    _url = [NSString stringWithFormat:@"%@",[resultSet objectForColumn:@"url"]];
    _fileName = [NSString stringWithFormat:@"%@",[resultSet objectForColumn:@"fileName"]];
    _totalFileSize = [[resultSet objectForColumn:@"totalFileSize"] integerValue];
    _tmpFileSize = [[resultSet objectForColumn:@"tmpFileSize"] integerValue];
    _progress = [[resultSet objectForColumn:@"progress"] integerValue];
    _state = [[resultSet objectForColumn:@"state"] integerValue];
    _lastSpeedTime = [resultSet doubleForColumn:@"lastSpeedTime"];
    _intervalFileSize = [[resultSet objectForColumn:@"intervalFileSize"] integerValue];
    _lastStateTime = [[resultSet objectForColumn:@"lastStateTime"] integerValue];
    _resumeData = [resultSet dataForColumn:@"resumeData"];
    
    return self;
}

@end
