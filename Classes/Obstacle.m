//
//  Obstacle.m
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "Obstacle.h"


@implementation Obstacle
- (id) init
{
    self = [super init];
    if (self != nil) {
        [self initWithFile:@"Rock.png"];
    }
    return self;
}
@end
