//
//  FreepixelPlayer.m
//  Game
//
//  Created by Matt Biddulph on 07/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "FreepixelPlayer.h"

@implementation FreepixelPlayer
@synthesize manager;

-(void) setup {
    self.scale = 2;
    [manager.texture setAliasTexParameters];
    right = [[AtlasAnimation animationWithName:@"right" delay:0.15] retain];
    for(int i = 0; i<4; i++) {
        [right addFrameWithRect:CGRectMake(39+(i*33),112,32,32)];
    }
    up = [[AtlasAnimation animationWithName:@"up" delay:0.15] retain];
    for(int i = 0; i<4; i++) {
        [up addFrameWithRect:CGRectMake(395+(i*33),112,32,32)];
    }
    down = [[AtlasAnimation animationWithName:@"down" delay:0.15] retain];
    for(int i = 0; i<4; i++) {
        [down addFrameWithRect:CGRectMake(217+(i*33),112,32,32)];
    }
}

-(void) walkLeft {
    [self stopAllActions];
    [self runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:right]]];
    self.flipX = YES;
}

-(void) walkRight {
    [self stopAllActions];
    [self runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:right]]];
    self.flipX = NO;
}

-(void) walkUp {
    [self stopAllActions];
    [self runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:up]]];
    self.flipX = NO;
}

-(void) walkDown {
    [self stopAllActions];
    [self runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:down]]];
    self.flipX = NO;
}

+(id) nodeWithManager:(AtlasSpriteManager *)mgr {
    FreepixelPlayer *node = [super spriteWithRect:CGRectZero spriteManager:mgr];
    [mgr addChild:node];
    node.manager = mgr;
    [node setup];
    return node;
}

@end
