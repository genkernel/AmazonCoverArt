//
//  ImageUtils.m
//  iSign
//
//  Created by kernel on 2/06/12.
//  Copyright (c) 2012 Apple. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)thumbnailImageFromURL:(NSURL*)imageUrl downsampledToMaxPixelSize:(NSNumber *)maxPixelSize {
	NSDictionary *opts = @{
		(id)kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
		(id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue,
		(id)kCGImageSourceCreateThumbnailFromImageIfAbsent: (id)kCFBooleanTrue
	};
	CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)imageUrl, NULL);
	CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, (__bridge CFDictionaryRef)opts);
	
	UIImage *img = [UIImage imageWithCGImage:thumbnail];
	
	CGImageRelease(thumbnail);
	CFRelease(src);
	
	return img;
}

@end
