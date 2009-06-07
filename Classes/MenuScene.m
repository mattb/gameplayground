//
//  MenuScene.m
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "MenuScene.h"
#import "MainScene.h"
#import "PathScene.h"
#import "FreepixelScene.h"

@implementation MenuScene
- (id) init
{
    self = [super init];
    if (self != nil) {
        MenuItem *menuItem1 = [MenuItemFont itemFromString:@"Main" target:self selector:@selector(onPlay:)];
        MenuItem *menuItem2 = [MenuItemFont itemFromString:@"Control Path" target:self selector:@selector(onPath:)];
        MenuItem *menuItem3 = [MenuItemFont itemFromString:@"Freepixel Sprites" target:self selector:@selector(onFreepixel:)];
        Menu *menu = [Menu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}
- (void)onPlay:(id)sender
{
    [[Director sharedDirector] replaceScene:[MainScene node]];
}
- (void)onPath:(id)sender
{
    [[Director sharedDirector] replaceScene:[PathScene node]];
}    
- (void)onFreepixel:(id)sender
{
    [[Director sharedDirector] replaceScene:[FreepixelScene node]];
}    

@end
