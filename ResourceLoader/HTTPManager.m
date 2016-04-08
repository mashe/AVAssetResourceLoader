//
//  HTTPManager.m
//  ResourceLoader
//
//  Created by Mikhail Markin on 31/03/16.
//  Copyright © 2016 LeshkoApps. All rights reserved.
//

#import "HTTPManager.h"
#import "LSFilePlayerResourceLoader.h"

NSString * const BaseHost = @"sample-videos.com";

//a subclass that adds Range param as HTTP header

@interface AFHTTPRangeRequestSerializer : AFHTTPRequestSerializer

@end

@implementation AFHTTPRangeRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
							   withParameters:(id)parameters
										error:(NSError *__autoreleasing *)error {
	NSMutableURLRequest *mutableRequest = [request mutableCopy];
	id params = nil;
	if ([parameters isKindOfClass:[NSDictionary class]]) {
		params = [NSMutableDictionary dictionaryWithDictionary:parameters];
		NSString *value = [params objectForKey:@"Range"];
		if (value) {
			[params removeObjectForKey:@"Range"];
			[mutableRequest setValue:value forHTTPHeaderField:@"Range"];
		}
	} else {
		params = parameters;
	}
	return [super requestBySerializingRequest:mutableRequest withParameters:params error:error];
}

@end

@interface HTTPManager()

@property (nonatomic, strong)NSMutableDictionary* receivedDataBlocks;

@end

@implementation HTTPManager

+ (instancetype)sharedManager {
	static HTTPManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[HTTPManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",BaseHost]]];
	});
	
	return _sharedManager;
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		AFHTTPRangeRequestSerializer *requestSerializer = [[AFHTTPRangeRequestSerializer alloc] init];
		//Don't forget to turn caching off
		requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		self.requestSerializer = requestSerializer;
		
		AFHTTPResponseSerializer *responseSerializer = [[AFHTTPResponseSerializer alloc] init];
		responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"video/mp4"];
		
		self.responseSerializer = responseSerializer;
		__weak HTTPManager *weakSelf = self;
		
		self.receivedDataBlocks = [NSMutableDictionary dictionary];
		[self setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
			void (^block)(UInt64, UInt64, NSData*) = [weakSelf.receivedDataBlocks objectForKey:dataTask];
			if (block) {
				block(dataTask.countOfBytesReceived, dataTask.countOfBytesExpectedToReceive, data);
			}
		}];
	}
	return self;
}

- (void)dealloc {
	self.receivedDataBlocks = nil;
}

- (id<LSResourceLoaderRequest>)partialContentForFileAtPath:(NSString *)srcRemotePath
												withParams:(NSDictionary *)params
													  data:(void (^)(UInt64 receivedDataLength, UInt64 totalDataLength, NSData *data))data
												completion:(void (^)(NSError *err))completion {
	__weak HTTPManager *weakSelf = self;
	NSURLSessionDataTask* task = [self GET:srcRemotePath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		completion(nil);
		[weakSelf.receivedDataBlocks removeObjectForKey:task];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		//canceled is not an error
		if (error.code == -999) {
			completion(nil);
		} else {
			completion(error);
		}
		[weakSelf.receivedDataBlocks removeObjectForKey:task];
	}];
	[self.receivedDataBlocks setObject:data forKey:task];
	return (id<LSResourceLoaderRequest>)task;
}

- (id<LSResourceLoaderRequest>)getStatusForPath:(NSString *)path completion:(void (^)(NSError *err, NSString*mimeType, unsigned long long size))block {
	
	return (id<LSResourceLoaderRequest>)[self HEAD:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
		block(nil, task.response.MIMEType, task.response.expectedContentLength);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		block(error, nil, 0);
	}];
}

@end
