//
//  Player.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "Player.h"


@implementation Player
- (id) init
{
    self = [super init];
    if (self != nil) {
        [self initWithFile:@"Character Princess Girl.png"];
    }
    return self;
}
@end
