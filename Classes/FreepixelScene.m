//
//  FreepixelScene.m
//  Game
//
//  Created by Matt Biddulph on 07/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "FreepixelScene.h"


@implementation FreepixelScene
- (id) init {
    self = [super init];
    if (self != nil) {        
        GroundLayer *layer = [GroundLayer node];
        [self addChild:layer];
        FreepixelLayer *clayer = [FreepixelLayer node];
        [self addChild:clayer];
        
    }
    return self;
}
@end
