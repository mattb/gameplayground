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

static int
playerHitsWall(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data) {
    CDSoundEngine *engine = (CDSoundEngine *)data;
    [engine playSound:1 channelGroupId:0 pitch:0.7f pan:0.0 gain:1.0 loop:NO];
    return 1;
}

static int
playerHitsRock(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data) {
    CDSoundEngine *engine = (CDSoundEngine *)data;
    [engine playSound:0 channelGroupId:0 pitch:1.3f pan:0.0 gain:1.0 loop:NO];
    return 1;
}

@implementation CharacterLayer
-(void) setUpSoundEngine {
    
	int channelGroupCount = 1;
	int channelGroups[1];
	channelGroups[0] = 8;
    
	soundEngine = [[CDSoundEngine alloc] init:channelGroups channelGroupTotal:channelGroupCount audioSessionCategory:kAudioSessionCategory_AmbientSound];
    [soundEngine loadBuffer:0 fileName:@"slap" fileType:@"wav"];
	[soundEngine loadBuffer:1 fileName:@"gloop" fileType:@"wav"];
}

- (id) init {
    self = [super init];
    if(self != nil) {
		self.isTouchEnabled = YES;
        [self setUpSoundEngine];
                
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
        shape->collision_type = 0;
        cpSpaceAddStaticShape(space, shape);
        
        // top
        shape = cpSegmentShapeNew(staticBody, ccp(0,wins.height), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        shape->collision_type = 0;
        cpSpaceAddStaticShape(space, shape);
        
        // left
        shape = cpSegmentShapeNew(staticBody, ccp(0,0), ccp(0,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        shape->collision_type = 0;
        cpSpaceAddStaticShape(space, shape);
        
        // right
        shape = cpSegmentShapeNew(staticBody, ccp(wins.width,0), ccp(wins.width,wins.height), 0.0f);
        shape->e = 1.0f; shape->u = 1.0f;
        shape->collision_type = 0;
        cpSpaceAddStaticShape(space, shape); 
        
        player = [Player node];
        player.position = ccp(200,120);
        [self addChild:player];
        
        cpBody *body = cpBodyNew(10.0f, 10.0f);
        body->p = player.position;
        player.body = body;
        
        cpSpaceAddBody(space, body);

        cpShape *playerShape = cpCircleShapeNew(body, 40.0f, CGPointZero);
        playerShape->e = 0.5f; 
        playerShape->u = 0.5f;
        playerShape->data = player;
        playerShape->collision_type = 1;
        cpSpaceAddShape(space, playerShape);    

        srand(time(NULL) / 2);
        for(int i = 0; i<6; i++) {
            Obstacle *rock = [Obstacle node];
            rock.scale = 0.5f;
            rock.position = ccp(rand() % 400,rand() % 400);
            [self addChild:rock];

            cpBody *rockbody = cpBodyNew(INFINITY, INFINITY);
            rockbody->p = rock.position;
        
            cpShape *rockShape = cpCircleShapeNew(rockbody, 22.0f, CGPointZero);
            rockShape->e = 1.0f; rockShape->u = 1.0f;
            rockShape->collision_type = 2;
            cpSpaceAddStaticShape(space, rockShape);
        }
        
        cpSpaceAddCollisionPairFunc(space, 1, 2, &playerHitsRock, soundEngine);
        cpSpaceAddCollisionPairFunc(space, 1, 0, &playerHitsWall, soundEngine);
        
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
	firstTouchPoint = [touch locationInView: [touch view]];	

    cpBodyResetForces(player.body);
    player.body->v = cpvzero;
    player.body->f = cpvzero;
    player.body->w = 0.0f;
    cpBodySetAngle(player.body, 0.0f);
    player.body->p = cpv(firstTouchPoint.y, firstTouchPoint.x);
    Scene *scene = (Scene *)[self parent];

    Action *action = [CameraZoomAction actionWithDuration:0.15f x:firstTouchPoint.y - 70.0f y:firstTouchPoint.x + 50.0f z:250.0f];
    [scene runAction:action];
    
	return YES;
}

- (BOOL) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *) event
{
	UITouch *touch = [touches anyObject];

    lastTouch = [touch timestamp];
	return YES;
}

- (BOOL) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
    Scene *scene = (Scene *)[self parent];
    [scene stopAllActions];
    [scene.camera restore];

	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];

    cpVect direction = cpv(point.y - firstTouchPoint.y, point.x - firstTouchPoint.x);
    cpBodyApplyImpulse(player.body, cpvmult(direction, 25.0f), cpvzero);
    
	return YES;
}

@end
