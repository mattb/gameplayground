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
        AtlasSpriteManager *manager = [AtlasSpriteManager spriteManagerWithFile:@"muybridge.pvr"];
        [self addChild:manager];

        Sprite *video = [AtlasSprite spriteWithRect:CGRectMake(0,0,128,128) spriteManager:manager];
        AtlasAnimation *anim = [AtlasAnimation animationWithName:@"muybridge" delay:1/15.0f];
        for(int j = 0; j<4; j++) {
            for(int i = 0; i<4; i++) {
                [anim addFrameWithRect:CGRectMake(i*128, j*128, 128, 93)];
            }
        }
        
        // Make the animation sequence repeat forever
        id myAction = [Animate actionWithAnimation: anim];
        id repeating = [RepeatForever actionWithAction:myAction];
        
        [video runAction:repeating];
        
        video.position = ccp(200,150);
        [manager addChild:video];
    }
    return self;
}    
@end
