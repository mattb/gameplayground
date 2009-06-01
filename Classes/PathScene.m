//
//  PathScene.m
//  Game
//
//  Created by Matt Biddulph on 01/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "PathScene.h"
#import "GroundLayer.h"

@implementation PathScene
- (id) init {
    self = [super init];
    if (self != nil) {        
        GroundLayer *layer = [GroundLayer node];
        [self addChild:layer];        
    }
    return self;
}
@end
