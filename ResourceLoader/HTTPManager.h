//
//  HTTPManager.h
//  ResourceLoader
//
//  Created by Mikhail Markin on 31/03/16.
//  Copyright © 2016 LeshkoApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSFilePlayerResourceLoader.h"
#import <AFNetworking/AFNetworking.h>

extern NSString * const BaseHost;

@interface HTTPManager : AFHTTPSessionManager<LSFilePlayerResourceLoaderDataSource>

+ (instancetype)sharedManager;

@end
