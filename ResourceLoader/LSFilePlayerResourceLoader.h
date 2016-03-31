//
//  LSFilePlayerResourceLoader.h
//  ResourceLoader
//
//  Created by Artem Meleshko on 1/31/15.
//  Copyright (c) 2015 LeshkoApps ( http://leshkoapps.com ). All rights reserved.
//


#import <AVFoundation/AVFoundation.h>

@protocol LSFilePlayerResourceLoaderDelegate;
@protocol LSFilePlayerResourceLoaderDataSource;


@interface LSFilePlayerResourceLoader : NSObject

@property (nonatomic,readonly,strong)NSURL *resourceURL;

@property (nonatomic,readonly)NSArray *requests;

@property (nonatomic,weak, readonly)id<LSFilePlayerResourceLoaderDataSource> dataSource;

@property (nonatomic,readonly,assign)BOOL isCancelled;

@property (nonatomic,weak)id<LSFilePlayerResourceLoaderDelegate> delegate;


- (instancetype)initWithResourceURL:(NSURL *)url dataSourse:(id<LSFilePlayerResourceLoaderDataSource>)dataSource;

- (void)addRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

- (void)removeRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

- (void)cancel;

@end


@protocol LSResourceLoaderRequest <NSObject>

- (void)cancel;

@end

@protocol LSFilePlayerResourceLoaderDelegate <NSObject>

@optional

- (void)filePlayerResourceLoader:(LSFilePlayerResourceLoader *)resourceLoader didFailWithError:(NSError *)error;

- (void)filePlayerResourceLoader:(LSFilePlayerResourceLoader *)resourceLoader didLoadResource:(NSURL *)resourceURL;

@end

@protocol LSFilePlayerResourceLoaderDataSource <NSObject>

@required

- (id<LSResourceLoaderRequest>)partialContentForFileAtPath:(NSString *)srcRemotePath
																							withParams:(NSDictionary *)params
																										data:(void (^)(UInt64 receivedDataLength, UInt64 totalDataLength, NSData *data))data
																							completion:(void (^)(NSError *err))completion;

- (id<LSResourceLoaderRequest>)getStatusForPath:(NSString *)path completion:(void (^)(NSError *err, NSString*mimeType, unsigned long long size))block;


@end
