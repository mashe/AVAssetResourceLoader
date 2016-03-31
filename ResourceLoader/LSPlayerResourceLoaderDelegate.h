//
//  LSPlayerResourceLoaderDelegate.h
//  ResourceLoader
//
//  Created by Mikhail Markin on 30/03/16.
//  Copyright © 2016 LeshkoApps. All rights reserved.
//

#import "YDSession.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString * const LSFileScheme;

@protocol LSFilePlayerResourceLoaderDataSource;

@interface LSPlayerResourceLoaderDelegate : NSObject <AVAssetResourceLoaderDelegate>

@property (nonatomic,strong, readonly)id<LSFilePlayerResourceLoaderDataSource> dataSource;

- (id)initWithDataSource:(id<LSFilePlayerResourceLoaderDataSource>)dataSource;

@end
