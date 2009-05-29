//
//  VideoSprite.m
//  Game
//
//  Created by Matt Biddulph on 25/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "VideoSprite.h"


@implementation VideoSprite
- (id) init
{
    self = [super init];
    if (self != nil) {
        self.scale = 2.0f;
        // [self initWithFile:@"image1.jpg"];
        Animation *anim = [[[Animation alloc] initWithName:@"video" delay:1/30.0] autorelease];
        for(int i = 1 ; i<=192; i++) {
            [anim addFrameWithFilename:[NSString stringWithFormat:@"%08d.jpg-0.png.pvr", i]];
        }
        
        // Make the animation sequence repeat forever
        id myAction = [Animate actionWithAnimation: anim];
        id repeating = [RepeatForever actionWithAction:myAction];
        
        [self runAction:repeating];
    }
    return self;
}

@end
