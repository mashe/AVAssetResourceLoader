//
//  ViewController.m
//  ResourceLoader
//
//  Created by Mikhail Markin on 31/03/16.
//  Copyright © 2016 LeshkoApps. All rights reserved.
//

#import "ViewController.h"
#import "LSPlayerResourceLoaderDelegate.h"
#import "HTTPManager.h"

@interface ViewController()

@property (nonatomic,strong)LSPlayerResourceLoaderDelegate *resourceLoaderDelegate;
@property (nonatomic,strong)AVPlayer* player;

@end

@implementation ViewController

- (void)dealloc {
	self.player = nil;
	self.resourceLoaderDelegate = nil;
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor whiteColor];
	[super viewDidLoad];
	
	// 2. create LSPlayerResourceLoaderDelegate instance using instance that confirms LSFilePlayerResourceLoaderDataSource protocol
	self.resourceLoaderDelegate = [[LSPlayerResourceLoaderDelegate alloc] initWithDataSource:[HTTPManager sharedManager]];
	
	// 3. use LSFileScheme while creating fileURL
	NSURL *fileURL = [[NSURL alloc] initWithScheme:LSFileScheme host:BaseHost path:@"/video/mp4/720/big_buck_bunny_720p_50mb.mp4"];
	
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
	
	// 4. use LSPlayerResourceLoaderDelegate instance as asset.resourceLoader delegate
	[asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
	
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	
	self.player = [[AVPlayer alloc] initWithPlayerItem:item];
	[self.player play];
}

@end
