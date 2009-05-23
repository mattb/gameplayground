//
//  CharacterLayer.m
//  Game
//
//  Created by Matt Biddulph on 20/05/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "CharacterLayer.h"

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	Sprite *sprite = shape->data;
    if(sprite) {
		cpBody *body = shape->body;
        [sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
    }
}

@implementation CharacterLayer
- (id) init {
    self = [super init];
    if(self != nil) {
		self.isTouchEnabled = YES;
        player = [Player node];
        player.position = ccp(120,120);
        [self addChild:player];
                
        CGSize wins = [[Director sharedDirector] winSize];
        cpInitChipmunk();
        
        cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);
        space = cpSpaceNew();
        cpSpaceResizeStaticHash(space, 400.0f, 40);
        cpSpaceResizeActiveHash(space, 100, 600);
        
        space->gravity = ccp(0, 0);
        space->elasticIterations = space->iterations;
        
        cpShape *shape;
        
        // bottom
        shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(wins.width,0), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        cpSpaceAddStaticShape(space, shape);
        
        // top
        shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        cpSpaceAddStaticShape(space, shape);
        
        // left
        shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        cpSpaceAddStaticShape(space, shape);
        
        // right
        shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        cpSpaceAddStaticShape(space, shape); 
        
        cpBody *body = cpBodyNew(1.0f, 1.0f);
        body->p = player.position;
        player.body = body;
        
        cpSpaceAddBody(space, body);
        
        cpShape *playerShape = cpCircleShapeNew(body, 50.0f, CGPointZero);
        playerShape->e = 0.5f; 
        playerShape->u = 0.5f;
        playerShape->data = player;
        cpSpaceAddShape(space, playerShape);        
        
        [self schedule: @selector(step:)];
    }
    return self;
}

-(void) step: (ccTime) delta
{
	int steps = 2;
	CGFloat dt = delta/(CGFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	cpSpaceHashEach(space->staticShapes, &eachShape, nil);
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// Touch Events ////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
    player.position = ccp(point.y, point.x);
    
	return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    player.position = ccp(point.y, point.x);
    NSLog(@"%f %f", point.x, point.y);
	return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    //player.position = ccp(point.y, point.x);
    cpBodyApplyForce(player.body, cpvforangle(1.0f), cpvzero);
    
	return YES;
}

@end
