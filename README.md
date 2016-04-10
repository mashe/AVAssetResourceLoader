# AVAssetResourceLoader
This is a fork from AVAssetResourceLoader.
Why? Big thanks to [LeshkoApps](http://leshkoapps.com), they have made a great job and provided mechanism to cache playable content of AVPlayer. But it was limited to [Yandex.Disk](https://disk.yandex.com) cloud service only. So I decided to make it more universal to use with any service/http client.

There are two sample applications:

 1. It uses [Yandex.Disk](https://disk.yandex.com) cloud service for streaming and caching audio files.
 2. It uses [AFNetworking](https://github.com/AFNetworking/AFNetworking) framework and video from http://www.sample-videos.com .

# Tutorial

0. Import next files to you project:
LSContentInformation.h
LSContentInformation.m
LSDataResonse.h
LSDataResonse.m
LSFilePlayerResourceLoader.h
LSFilePlayerResourceLoader.m
LSPlayerResourceLoaderDelegate.h
LSPlayerResourceLoaderDelegate.m
1. Implement an datasource that confirms `LSFilePlayerResourceLoaderDataSource` protocol. (`HTTPManager` and `YDSession+LSFilePlayerResourceLoaderDataSource` in samples)
2. create `LSPlayerResourceLoaderDelegate` instance using instance datasource
3. use `LSFileScheme` while creating fileURL
4. use `LSPlayerResourceLoaderDelegate` instance as `asset.resourceLoader delegate`

here is the code:
```
	// create LSPlayerResourceLoaderDelegate instance using instance that confirms LSFilePlayerResourceLoaderDataSource protocol
	self.resourceLoaderDelegate = [[LSPlayerResourceLoaderDelegate alloc] initWithDataSource:[HTTPManager sharedManager]];
	
	// use LSFileScheme while creating fileURL
	NSURL *fileURL = [[NSURL alloc] initWithScheme:LSFileScheme host:BaseHost path:@"/video/mp4/720/big_buck_bunny_720p_50mb.mp4"];
	
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
	
	// use LSPlayerResourceLoaderDelegate instance as asset.resourceLoader delegate
	[asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
	
	AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
	
	self.player = [[AVPlayer alloc] initWithPlayerItem:item];
	[self.player play];
```

The full tutorial about how audio streaming was implemented in the sample project I forked from is available here:
http://leshkoapps.com/wordpress/audio-streaming-and-caching-in-ios-using-avassetresourceloader-and-avplayer/

# Contacts
 
 For additional information please contact: 
 
 shire8bit@gmail.com
 
# License

```
The MIT License (MIT)

Copyright (c) 2015 Artem Meleshko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
