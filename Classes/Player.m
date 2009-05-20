//
//  Player.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "Player.h"
#import "cocos2d.h"

@implementation Player
- (id) init
{
    self = [super init];
    if (self != nil) {
        [self initWithFile:@"Character Princess Girl.png"];
        [self schedule:@selector(bounce:) interval: 2];
    }
    return self;
}

- (void)bounce:(ccTime)dt {
    id actionBy = [JumpBy actionWithDuration:0.25f position:ccp(0,0) height:25 jumps:1];
	
	[self runAction:actionBy];    
}

@end
