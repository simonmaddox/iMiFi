//
//  MifiAppDelegate.m
//  Mifi
//
//  Created by Simon Maddox on 24/10/2009.
//  Copyright Simon Maddox 2009. All rights reserved.
//

#import "MifiAppDelegate.h"
#import "RootViewController.h"
#import "FlurryAPI.h"

@implementation MifiAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[FlurryAPI startSession:@"JRPTIY3RU6M4LPCCN61N"];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

