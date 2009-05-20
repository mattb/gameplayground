//
//  MainScene.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "MainScene.h"
#import "GroundLayer.h"
#import "CharacterLayer.h"

@implementation MainScene

- (id) init {
    self = [super init];
    if (self != nil) {        
        GroundLayer *layer = [GroundLayer node];
        [self addChild:layer];
        CharacterLayer *clayer = [CharacterLayer node];
        [self addChild:clayer];

    }
    return self;
}

@end
