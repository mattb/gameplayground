/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2008,2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import <UIKit/UIKit.h>

#import "CocosNode.h"
#import "ccTypes.h"

enum {
	kParticleStartSizeEqualToEndSize = -1,
	kParticleDurationInfinity = -1,
};

typedef enum {
	kPositionTypeLocal,
	kPositionTypeWorld,
	kPositionTypeCenterOfGravity,
} tPositionType;

/** Structure that contains the values of each particle
 */
typedef struct sParticle
{
	CGPoint	pos;
	CGPoint startPos;
	CGPoint	dir;
	float	radialAccel;
	float	tangentialAccel;
	ccColor4F	color;
	ccColor4F	deltaColor;
	float	size;
	float	deltaSize;
	float	angle;
	float	deltaAngle;
	float	life;
} Particle;

@class Texture2D;

/** Particle System base class
 Attributes of a Particle System:
  * duration
  * gravity
  * emmision rate
  * total max particles
  * angle +- variance
  * speed +-  variance
  * tangential acceleration +- variance
  * radial acceleration +- variance
  * start size +- variance
  * end size +- variance
  * start color +- variance
  * end color +- variance
  * life +- variance
  * blend additive or not
  * one texture
 
 Limitations:
  * size can't be bigger than 64
  * the system can't be scaled since the particles are rendered using GL_POINT_SPRITE
 */
@interface ParticleSystem : CocosNode
{
	int id;
	
	// is the particle system active ?
	BOOL active;
	// duration in seconds of the system. -1 is infinity
	float duration;
	// time elapsed since the start of the system (in seconds)
	float elapsed;
	
	/// Gravity of the particles
	CGPoint gravity;

	// position is from "superclass" CocosNode
	// Emitter source position
	CGPoint source;
	// Position variance
	CGPoint posVar;
	
	// The angle (direction) of the particles measured in degrees
	float angle;
	// Angle variance measured in degrees;
	float angleVar;
	
	// The speed the particles will have.
	float speed;
	// The speed variance
	float speedVar;
	
	// Tangential acceleration
	float tangentialAccel;
	// Tangential acceleration variance
	float tangentialAccelVar;

	// Radial acceleration
	float radialAccel;
	// Radial acceleration variance
	float radialAccelVar;
	
	// start ize of the particles
	float startSize;
	// start Size variance
	float startSizeVar;
	// End size of the particle
	float endSize;
	// end size of variance
	float endSizeVar;
	
	// How many seconds will the particle live
	float life;
	// Life variance
	float lifeVar;
	
	// Start color of the particles
	ccColor4F startColor;
	// Start color variance
	ccColor4F startColorVar;
	// End color of the particles
	ccColor4F endColor;
	// End color variance
	ccColor4F endColorVar;
	
	// start angle of the particles
	float startSpin;
	// start angle variance
	float startSpinVar;
	// End angle of the particle
	float endSpin;
	// end angle ariance
	float endSpinVar;	
	
	// Array of particles
	Particle *particles;
	// Maximum particles
	int totalParticles;
	// Count of active particles
	int particleCount;
	
	// additive color or blend
	BOOL blendAdditive;
	// color modulate
	BOOL colorModulate;
	
	// How many particles can be emitted per second
	float emissionRate;
	float emitCounter;
	
	// Texture of the particles
	Texture2D *texture;

	// position type: world, local, center of gravity
	tPositionType	positionType_;

	//  particle idx
	int particleIdx;
}

/** Is the emitter active */
@property (readonly) BOOL active;
/** Quantity of particles that are being simulated at the moment */
@property (readonly) int	particleCount;
/** Gravity value */
@property (readwrite,assign) CGPoint gravity;
/** How many seconds the emitter wil run. -1 means 'forever' */
@property (readwrite,assign) float duration;
/** Source location of particles respective to emitter location */
@property (readwrite,assign) CGPoint source;
/** Position variance of the emitter */
@property (readwrite,assign) CGPoint posVar;
/** life, and life variation of each particle */
@property (readwrite,assign) float life;
/** life variance of each particle */
@property (readwrite,assign) float lifeVar;
/** angle and angle variation of each particle */
@property (readwrite,assign) float angle;
/** angle variance of each particle */
@property (readwrite,assign) float angleVar;
/** speed of each particle */
@property (readwrite,assign) float speed;
/** speed variance of each particle */
@property (readwrite,assign) float speedVar;
/** tangential acceleration of each particle */
@property (readwrite,assign) float tangentialAccel;
/** tangential acceleration variance of each particle */
@property (readwrite,assign) float tangentialAccelVar;
/** radial acceleration of each particle */
@property (readwrite,assign) float radialAccel;
/** radial acceleration variance of each particle */
@property (readwrite,assign) float radialAccelVar;
/** start size in pixels of each particle */
@property (readwrite,assign) float startSize;
/** size variance in pixels of each particle */
@property (readwrite,assign) float startSizeVar;
/** end size in pixels of each particle */
@property (readwrite,assign) float endSize;
/** end size variance in pixels of each particle */
@property (readwrite,assign) float endSizeVar;
/** start color of each particle */
@property (readwrite,assign) ccColor4F startColor;
/** start color variance of each particle */
@property (readwrite,assign) ccColor4F startColorVar;
/** end color and end color variation of each particle */
@property (readwrite,assign) ccColor4F endColor;
/** end color variance of each particle */
@property (readwrite,assign) ccColor4F endColorVar;
//* initial angle of each particle
@property (readwrite,assign) float startSpin;
//* initial angle of each particle
@property (readwrite,assign) float startSpinVar;
//* initial angle of each particle
@property (readwrite,assign) float endSpin;
//* initial angle of each particle
@property (readwrite,assign) float endSpinVar;
/** emission rate of the particles */
@property (readwrite,assign) float emissionRate;
/** maximum particles of the system */
@property (readwrite,assign) int totalParticles;
/** texture used to render the particles */
@property (readwrite, retain) Texture2D * texture;
/** whether or not the particles are using "blend additive */
@property (readwrite) BOOL blendAdditive;
/** position type */
@property (readwrite) tPositionType positionType;

//! Initializes a system with a fixed number of particles
-(id) initWithTotalParticles:(int) numberOfParticles;
//! Add a particle to the emitter
-(BOOL) addParticle;
//! Initializes a particle
-(void) initParticle: (Particle*) particle;
//! stop emitting particles. Running particles will continue to run until they die
-(void) stopSystem;
//! Kill all living particles.
-(void) resetSystem;
//! whether or not the system is full
-(BOOL) isFull;
@end

