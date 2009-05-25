//
//  MenuScene.m
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "MenuScene.h"
#import "MainScene.h"

@implementation MenuScene
- (id) init
{
    self = [super init];
    if (self != nil) {
        MenuItem *menuItem1 = [MenuItemFont itemFromString:@"Main" target:self selector:@selector(onPlay:)];
        MenuItem *menuItem2 = [MenuItemFont itemFromString:@"About" target:self selector:@selector(onAbout:)];
        Menu *menu = [Menu menuWithItems:menuItem1, menuItem2, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}
- (void)onPlay:(id)sender
{
    NSLog(@"on play");
    [[Director sharedDirector] replaceScene:[MainScene node]];
}
- (void)onAbout:(id)sender
{
    NSLog(@"on about");
    // [[Director sharedDirector] replaceScene:[MainScene node]];
}    

@end
