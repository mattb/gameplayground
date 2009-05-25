//
//  GroundLayer.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "GroundLayer.h"
#import "Block.h"
#import "cocos2d.h"
#import "VideoSprite.h"

@implementation GroundLayer
- (id) init {
    self = [super init];
    if(self != nil) {
        for(int i = 4 ; i>=0 ; i--) {
            for(int j = 2; j>=0 ; j--) {
                //NSLog(@"KTHXBYE");
                Block *block = [Block node];
                block.position = ccp(i * 100, j * 100);
                [self addChild:block];
            }
        }
        VideoSprite *video = [VideoSprite node];
        video.position = ccp(200,150);
        [self addChild:video];
    }
    return self;
}    
@end
