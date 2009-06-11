//
//  InvaderManager.m
//  Game
//
//  Created by Matt Biddulph on 11/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "InvaderManager.h"


@implementation InvaderManager

- (id) init
{
    self = [super init];
    if (self != nil) {
        invaders = [[NSMutableArray arrayWithCapacity:100] retain];
    }
    return self;
}

- (Invader *)addInvaderWithStyle: (int)style andPosition:(CGPoint)position {
    Invader *invader = [Invader spriteWithRect:CGRectMake(style*16,0,16,16) spriteManager:self];
    invader.position = position;
    [self addChild:invader];
    [invaders addObject:invader];
    MoveBy *left = [MoveBy actionWithDuration:2.5 position:ccp(220,0)];
    Action *leftright = [RepeatForever actionWithAction:[Sequence actions:left, [left reverse], nil]];
    [invader runAction:leftright];
    return invader;
}

+ (CocosNode *)node {
    return [[[InvaderManager alloc] initWithFile:@"spaceinvaders.pvr" capacity:30] autorelease];
}

@end
