//
//  TAAppDelegate.m
//  AmazonCoverArt
//
//  Created by kernel on 15/07/12.
//  Copyright (c) 2012 AAV. All rights reserved.
//

#import "TAAppDelegate.h"

#import "TAViewController.h"

@implementation TAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    // Override point for customization after application launch.
	self.viewController = [[TAViewController alloc] initWithNibName:@"TAViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
