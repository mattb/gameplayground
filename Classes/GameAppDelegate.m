//
//  GameAppDelegate.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import "GameAppDelegate.h"

// import cocos2d classes you'll need:
//#import "cocos2d.h"
//#import "Scene.h"


@implementation GameAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setUserInteractionEnabled:YES];
    [window setMultipleTouchEnabled:YES];
	
	// set up Director, probably something like this:
	/*
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    [[Director sharedDirector] attachInWindow:window];
	*/
	
    [window makeKeyAndVisible];	
	
	// make a scene, probably something like this:
	/*
	Scene *scene = [Scene node];
	[[Director sharedDirector] runWithScene:scene];
	*/
}


- (void)dealloc {
	[window release];
    [super dealloc];
}


@end
