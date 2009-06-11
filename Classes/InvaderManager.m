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

- (void)addInvaderWithStyle: (int)style andPosition:(CGPoint)position {
    Invader *invader = [Invader spriteWithRect:CGRectMake(style*16,0,16,16) spriteManager:self];
    invader.position = position;
    [self addChild:invader];
    [invaders addObject:invader];
    [invader runAction:[MoveBy actionWithDuration:8 position:ccp(500,0)]];
}

+ (CocosNode *)node {
    return [[[InvaderManager alloc] initWithFile:@"spaceinvaders.pvr" capacity:30] autorelease];
}

@end
