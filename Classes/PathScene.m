//
//  PathScene.m
//  Game
//
//  Created by Matt Biddulph on 01/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "PathScene.h"
#import "GroundLayer.h"
#import "PathLayer.h"

@implementation PathScene
- (id) init {
    self = [super init];
    if (self != nil) {
        [self addChild:[GroundLayer node]];        
        [self addChild:[PathLayer node]];        
    }
    return self;
}
@end
