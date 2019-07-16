//
//  NSURLSession+CorrectedResumeData.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/11.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLSession (CorrectedResumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end

