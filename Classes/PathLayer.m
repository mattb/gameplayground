//
//  PathLayer.m
//  Game
//
//  Created by Matt Biddulph on 01/06/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "PathLayer.h"


@implementation PathLayer
- (id) init {
    self = [super init];
    if(self != nil) {
        thing = [Sprite spriteWithFile:@"Star.png"];
        [self addChild:thing];
		self.isTouchEnabled = YES;
        ring_idx = 0;
        for(int i = 0; i<10; i++) {
            points[i] = ccp(0,0);
            times[i] = 0;
        }
        [self schedule:@selector(samplePath:) interval:0.1];
    }
    return self;
}

-(void) samplePath: (ccTime) delta {
    ccBezierConfig bezier;
    int last_ring_idx = ring_idx - 1;
    if(last_ring_idx == -1) {
        last_ring_idx = 9;
    }
    NSTimeInterval since = [NSDate timeIntervalSinceReferenceDate] - times[last_ring_idx];
    if(since < delta) {
        CGPoint target = points[last_ring_idx];
        bezier.startPosition = ccp(0,0);
        bezier.endPosition = ccpSub(target, thing.position);

        int cp2_idx = last_ring_idx - 1;
        if(cp2_idx == -1) {
            cp2_idx = 9;
        }
        if([NSDate timeIntervalSinceReferenceDate] - times[cp2_idx] < delta) {
            bezier.controlPoint_2 = ccpSub(points[cp2_idx], thing.position);
        } else {
            bezier.controlPoint_2 = bezier.endPosition;
        }
        
        int cp1_idx = cp2_idx - 1;
        if(cp1_idx == -1) {
            cp1_idx = 9;
        }
        if([NSDate timeIntervalSinceReferenceDate] - times[cp1_idx] < delta) {
            bezier.controlPoint_1 = ccpSub(points[cp1_idx], thing.position);
        } else {
            bezier.controlPoint_1 = bezier.startPosition;
        }
        
        id action = [BezierBy actionWithDuration:0.25 bezier: bezier];
        [thing runAction:action];
    }
}

- (void) recordTouch:(CGPoint)touch {
    points[ring_idx] = touch;
    times[ring_idx] = [NSDate timeIntervalSinceReferenceDate];
    ring_idx = (ring_idx + 1) % 10;
}

- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event {
    UITouch *touch = [touches anyObject];
    [self recordTouch:[[Director sharedDirector] convertCoordinate:[touch locationInView: [touch view]]]];
    return YES;
}
@end