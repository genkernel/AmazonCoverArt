//
//  ImageUtils.h
//  iSign
//
//  Created by kernel on 2/06/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import <ImageIO/ImageIO.h>

@interface ImageUtils : NSObject
+ (UIImage *)thumbnailImageFromURL:(NSURL*)imageUrl downsampledToMaxPixelSize:(NSNumber *)maxPixelSize;
@end
