//
//  main.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"GameAppDelegate");
    [pool release];
    return retVal;
}
