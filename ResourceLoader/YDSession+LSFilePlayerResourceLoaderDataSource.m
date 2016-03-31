//
//  YDSession+LSFilePlayerResourceLoaderDataSource.m
//  ResourceLoader
//
//  Created by Mikhail Markin on 31/03/16.
//  Copyright © 2016 Mikhail Markin. All rights reserved.
//

#import "YDSession+LSFilePlayerResourceLoaderDataSource.h"
#import "LSFilePlayerResourceLoader.h"
#import "NSString+LSAdditions.h"

@implementation YDSession (LSFilePlayerResourceLoaderDataSource)

- (id<LSResourceLoaderRequest>)partialContentForFileAtPath:(NSString *)srcRemotePath
												withParams:(NSDictionary *)params
													  data:(void (^)(UInt64 receivedDataLength, UInt64 totalDataLength, NSData *data))data
												completion:(void (^)(NSError *err))completion {
	return (id<LSResourceLoaderRequest>)[self partialContentForFileAtPath:srcRemotePath withParams:params response:nil data:data completion:completion];
}

- (id<LSResourceLoaderRequest>)getStatusForPath:(NSString *)path completion:(void (^)(NSError *err, NSString*mimeType, unsigned long long size))block {
	return (id<LSResourceLoaderRequest>)[self fetchStatusForPath:path completion:^(NSError *err, YDItemStat *item) {
		NSString *mimeType = item.path.mimeTypeForPathExtension;
		unsigned long long contentLength = item.size;
		block(err, mimeType, contentLength);
	}];
}

@end
