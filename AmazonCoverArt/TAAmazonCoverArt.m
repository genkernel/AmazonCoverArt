//
//  TAAmazonCoverArt.m
//  AmazonCoverArt
//
//  Created by kernel on 15/07/12.
//  Copyright (c) 2012 AAV. All rights reserved.
//

#import "TAAmazonCoverArt.h"

@interface TAAmazonCoverArt()
@property (strong, nonatomic) AmazonCredentials *credentials;
@end

@implementation TAAmazonCoverArt
@synthesize credentials;

- (id)initWithAmazonCredentials:(AmazonCredentials *)amazonCredentials {
	self = [self init];
	if (self) {
		self.credentials = amazonCredentials;
	}
	return self;
}

- (void)requestCovertArtWithKeywords:(NSString *)keywords completionHandler:(void(^)(NSData *payload, NSError *))handler {
	AmazonServiceRequest *request = [[AmazonServiceRequest alloc] init];
	request.credentials = self.credentials;
	request.endpoint = @"https://ecs.amazonaws.com/onca/xml";
	
	[request setParameterValue:@"AWSECommerceService" forKey:@"Service"];
	[request setParameterValue:@"ItemSearch" forKey:@"Operation"];
	[request setParameterValue:@"Music" forKey:@"SearchIndex"];
	[request setParameterValue:@"Images" forKey:@"ResponseGroup"];
	[request setParameterValue:keywords forKey:@"Keywords"];
	
	[request sign];
	
	NSMutableURLRequest *r = [request configureURLRequest];
	
	dispatch_queue_t currentQueue = dispatch_get_current_queue();
	dispatch_queue_t loadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
	dispatch_async(loadQueue, ^{
		NSURLResponse *response = nil;
		NSError *err = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:r returningResponse:&response error:&err];
		
		dispatch_async(currentQueue, ^{
			handler(data, err);
		});
	});
	
}

@end
