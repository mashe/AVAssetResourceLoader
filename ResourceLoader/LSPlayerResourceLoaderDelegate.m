//
//  LSPlayerResourceLoaderDelegate.m
//  ResourceLoader
//
//  Created by Mikhail Markin on 30/03/16.
//  Copyright © 2016 LeshkoApps. All rights reserved.
//

#import "LSPlayerResourceLoaderDelegate.h"
#import "LSFilePlayerResourceLoader.h"

NSString * const LSFileScheme = @"customscheme";

@interface LSPlayerResourceLoaderDelegate()<LSFilePlayerResourceLoaderDelegate>

@property (nonatomic,strong)id<LSFilePlayerResourceLoaderDataSource> dataSource;
@property (nonatomic,strong)NSMutableDictionary *resourceLoaders;

@end

@implementation LSPlayerResourceLoaderDelegate

- (id)initWithDataSource:(id<LSFilePlayerResourceLoaderDataSource>)dataSource {
	self = [super init];
	if (self) {
		self.dataSource = dataSource;
		self.resourceLoaders = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc {
	[self cancelAllResourceLoaders];
}

#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
	NSURL *resourceURL = [loadingRequest.request URL];
	if([resourceURL.scheme isEqualToString:LSFileScheme]){
		LSFilePlayerResourceLoader *loader = [self resourceLoaderForRequest:loadingRequest];
		if(loader==nil){
			loader = [[LSFilePlayerResourceLoader alloc] initWithResourceURL:resourceURL dataSourse:self.dataSource];
			loader.delegate = self;
			[self.resourceLoaders setObject:loader forKey:[self keyForResourceLoaderWithURL:resourceURL]];
		}
		[loader addRequest:loadingRequest];
		return YES;
	}
	return NO;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
	LSFilePlayerResourceLoader *loader = [self resourceLoaderForRequest:loadingRequest];
	[loader removeRequest:loadingRequest];
}

#pragma mark - LSFilePlayerResourceLoader

- (void)removeResourceLoader:(LSFilePlayerResourceLoader *)resourceLoader{
	id <NSCopying> requestKey = [self keyForResourceLoaderWithURL:resourceLoader.resourceURL];
	if(requestKey){
		[self.resourceLoaders removeObjectForKey:requestKey];
	}
}

- (void)cancelAndRemoveResourceLoaderForURL:(NSURL *)resourceURL{
	id <NSCopying> requestKey = [self keyForResourceLoaderWithURL:resourceURL];
	LSFilePlayerResourceLoader *loader = [self.resourceLoaders objectForKey:requestKey];
	[self removeResourceLoader:loader];
	[loader cancel];
}

- (void)cancelAllResourceLoaders{
	NSArray *items = [self.resourceLoaders allValues];
	[self.resourceLoaders removeAllObjects];
	for(LSFilePlayerResourceLoader *loader in items){
		[loader cancel];
	}
}

- (id<NSCopying>)keyForResourceLoaderWithURL:(NSURL *)requestURL{
	if([requestURL.scheme isEqualToString:LSFileScheme]){
		NSString *s = requestURL.absoluteString;
		return s;
	}
	return nil;
}

- (LSFilePlayerResourceLoader *)resourceLoaderForRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
	NSURL *interceptedURL = [loadingRequest.request URL];
	if([interceptedURL.scheme isEqualToString:LSFileScheme]){
		id <NSCopying> requestKey = [self keyForResourceLoaderWithURL:[loadingRequest.request URL]];
		LSFilePlayerResourceLoader *loader = [self.resourceLoaders objectForKey:requestKey];
		return loader;
	}
	return nil;
}

- (void)filePlayerResourceLoader:(LSFilePlayerResourceLoader *)resourceLoader didFailWithError:(NSError *)error{
	[self cancelAndRemoveResourceLoaderForURL:resourceLoader.resourceURL];
}


@end
