//
//  Block.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "Block.h"
#import "cocos2d.h"

@implementation Block

- (id) init
{
    self = [super init];
    if (self != nil) {
//        NSLog(@"O HAI");
        NSString *kind = @"Wood";
        [self initWithFile:[NSString stringWithFormat:@"%@ Block.png", kind]];
        self.anchorPoint = ccp(0,0);
    }
    return self;
}
@end