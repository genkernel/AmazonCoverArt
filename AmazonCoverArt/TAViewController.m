//
//  TAViewController.m
//  AmazonCoverArt
//
//  Created by kernel on 15/07/12.
//  Copyright (c) 2012 AAV. All rights reserved.
//

#import "TAViewController.h"

@implementation TAViewController
@synthesize covertArtImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	__weak TAViewController *ctrl = self;
	
	NSString *keywords = @"Avril Lavigne The Best Damn Thing";
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Amazon" ofType:@"plist"];
	NSDictionary *options = [NSDictionary dictionaryWithContentsOfFile:path];
	assert(nil!=options);
	NSString *key = options[@"Key"];
	NSString *secret = options[@"Secret"];
	AmazonCredentials *credentials = [[AmazonCredentials alloc] initWithAccessKey:key withSecretKey:secret];
	
	TAAmazonCoverArt *coverArtManager = [[TAAmazonCoverArt alloc] initWithAmazonCredentials:credentials];
	[coverArtManager requestCovertArtWithKeywords:keywords completionHandler:^(NSData *xmlData, NSError *err){
		if (err) {
			NSLog(@"ERR. Failed to fetch album cover. Err: %@", err.localizedDescription);
			return;
		}
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			// Parse response xml.
			NSDictionary *payload = nil;
			if (!err) {
				payload = [XMLReader dictionaryForXMLData:xmlData error:nil];
			}
			
			// Grep images from Amazon's xml response.
			NSInteger totalResults = [payload[@"ItemSearchResponse"][@"Items"][@"TotalResults"][@"text"] intValue];
			if (0 == totalResults) {
				NSLog(@"WARN. Empty cover art response received.");
				return;
			}
			
			//SmallImage, MediumImage, LargeImage.
			NSString *imageUrl = nil;
			NSUInteger width = 0, height = 0;
			id item = payload[@"ItemSearchResponse"][@"Items"][@"Item"];
			if ([item isKindOfClass:[NSDictionary class]]) {
				imageUrl = item[@"MediumImage"][@"URL"][@"text"];
				width = [item[@"MediumImage"][@"Width"][@"text"] intValue];
				height = [item[@"MediumImage"][@"Height"][@"text"] intValue];
			} else if ([item isKindOfClass:[NSArray class]]) {
				imageUrl = item[0][@"MediumImage"][@"URL"][@"text"];
				width = [item[0][@"MediumImage"][@"Width"][@"text"] intValue];
				height = [item[0][@"MediumImage"][@"Height"][@"text"] intValue];
			} else {
				NSLog(@"ERR. Cannot parse response data. Unknown format specified.");
				return;
			}
			
			int maxPixelSize = MAX(width, height);
			
			NSURL *url = [NSURL URLWithString:imageUrl];
			NSLog(@"INFO. CovertArt image url: %@", imageUrl);
			
			// Fetch cover art image.
			UIImage *img = [ImageUtils thumbnailImageFromURL:url downsampledToMaxPixelSize:[NSNumber numberWithInt:maxPixelSize]];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				//ctrl.covertArtImageView.bounds = CGRectMake(.0, .0, width, height);
				ctrl.covertArtImageView.image = img;
			});
		});
	}];
}



@end
