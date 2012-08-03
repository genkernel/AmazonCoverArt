//
//  TAAmazonCoverArt.h
//  AmazonCoverArt
//
//  Created by kernel on 15/07/12.
//  Copyright (c) 2012 AAV. All rights reserved.
//

#import "AmazonServiceRequest.h"

@interface TAAmazonCoverArt : NSObject
- (id)initWithAmazonCredentials:(AmazonCredentials *)credentials;
- (void)requestCovertArtWithKeywords:(NSString *)keywords completionHandler:(void(^)(NSData *payload, NSError *))handler;
@end
