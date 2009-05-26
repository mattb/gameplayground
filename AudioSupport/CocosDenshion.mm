/* CocosDenshion Sound Engine
 *
 * Copyright (C) 2009 Steve Oldmeadow
 *
 * For independent entities this program is free software; you can redistribute
 * it and/or modify it under the terms of the 'cocos2d for iPhone' license with
 * the additional proviso that 'cocos2D for iPhone' must be credited in a manner
 * that can be be observed by end users, for example, in the credits or during
 * start up. Failure to include such notice is deemed to be acceptance of a 
 * non independent license (see below).
 *
 * For the purpose of this software non independent entities are defined as 
 * those where the annual revenue of the entity employing, partnering, or 
 * affiliated in any way with the Licensee is greater than $250,000 USD annually.
 *
 * Non independent entities may license this software or a derivation of it
 * by a donation of $500 USD per application to the cocos2d for iPhone project. 
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

#import "CocosDenshion.h"
#import "MyOpenALSupport.h"
#import "ccMacros.h"

//Audio session interruption callback - used if sound engine is 
//handling audio session interruption automatically
extern void interruptionListenerCallback (void *inUserData, UInt32 interruptionState ) { 
	CDSoundEngine *controller = (CDSoundEngine *) inUserData; 
    if (interruptionState == kAudioSessionBeginInterruption) { 
        [controller audioSessionInterrupted]; 
    } else if (interruptionState == kAudioSessionEndInterruption) { 
        [controller audioSessionResumed]; 
    } 
} 

@implementation CDSoundEngine

@synthesize lastErrorCode, functioning;

/**
 * Internal method called during init
 */
- (BOOL) _initOpenAL
{
	ALenum			error;
	_context = NULL;
	ALCdevice		*newDevice = NULL;
	
	_buffers = new ALuint[CD_MAX_BUFFERS];
	_sources = new ALuint[CD_MAX_SOURCES];
	
	// Create a new OpenAL Device
	// Pass NULL to specify the system’s default output device
	newDevice = alcOpenDevice(NULL);
	if (newDevice != NULL)
	{
		// Create a new OpenAL Context
		// The new context will render to the OpenAL Device just created 
		_context = alcCreateContext(newDevice, 0);
		if (_context != NULL)
		{
			// Make the new context the Current OpenAL Context
			alcMakeContextCurrent(_context);
			
			//Don't want a distance model
			alDistanceModel(AL_NONE);
			
			// Create some OpenAL Buffer Objects
			alGenBuffers(CD_MAX_BUFFERS, _buffers);
			if((error = alGetError()) != AL_NO_ERROR) {
				CCLOG(@"Error Generating Buffers: %x", error);
				return FALSE;//No buffers
			}
			
			// Create some OpenAL Source Objects
			alGenSources(CD_MAX_SOURCES, _sources);
			if(error = alGetError() != AL_NO_ERROR) {
				CCLOG(@"Error generating sources! %x\n", error);
				return FALSE;//No sources
			} 
			
		}
	} else {
		return FALSE;//No device
	}	
	alGetError();//Clear error
	return TRUE;
}

- (void) dealloc {
	ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
	ALenum		error;

	CCLOG(@"Denshion: Deallocing sound engine.");
	delete _bufferStates;
	delete _channelGroups;
	delete _sourceBufferAttachments;
	
	// Delete the Sources
    alDeleteSources(CD_MAX_SOURCES, _sources);
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error deleting sources! %x\n", error);
	} 
	// Delete the Buffers
    alDeleteBuffers(CD_MAX_BUFFERS, _buffers);
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error deleting buffers! %x\n", error);
	} 
	
	//Get active context
    context = alcGetCurrentContext();
    //Get device for active context
    device = alcGetContextsDevice(context);
    //Release context
    alcDestroyContext(context);
    //Close device
    alcCloseDevice(device);
	
	delete _buffers;
	delete _sources;
	[super dealloc];
}	

/**
 * Call this initialiser if you want the sound engine to automatically handle audio session interruption.
 * If you are using the sound engine in conjunction with another audio api such as AVAudioPlayer or
 * AudioQueue then you probably do not want the sound engine to handle audio session interruption
 * for you.
 *
 * The audioSessionCategory should be one of the audio session category enumeration values such as
 * kAudioSessionCategory_AmbientSound. Your choice is dependent on how you want your audio to interact
 * with other audio on the device.
 *
 * Please note that audio session interruption is different to application interruption.  Known triggers are
 * alarm notification from clock, incoming phone call that is rejected and video playback ending.
 */
- (id)init:(int[]) channelGroupDefinitions channelGroupTotal:(int) channelGroupTotal audioSessionCategory:(UInt32) audioSessionCategory 
{	
	if (self = [super init]) {
		
		_mute = FALSE;
		_audioSessionCategory = audioSessionCategory;
		_handleAudioSession = (_audioSessionCategory != CD_IGNORE_AUDIO_SESSION);
		if (_handleAudioSession) {
			CCLOG(@"Denshion: Sound engine will handle audio session interruption");
			//Set up audio session
			OSStatus result = AudioSessionInitialize(NULL, NULL,interruptionListenerCallback, self); 
			result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(_audioSessionCategory), &_audioSessionCategory); 
		}	
		
		//Set up channel groups
		_channelGroups = new channelGroup[channelGroupTotal];
		_channelGroupTotal = channelGroupTotal;
		int channelCount = 0;
		for (int i=0; i < channelGroupTotal; i++) {
			
			_channelGroups[i].startIndex = channelCount;
			_channelGroups[i].endIndex = _channelGroups[i].startIndex + channelGroupDefinitions[i] - 1;
			_channelGroups[i].currentIndex = _channelGroups[i].startIndex;
			channelCount += channelGroupDefinitions[i];
			CCLOG(@"Denshion: channel def %i %i %i %i",i,_channelGroups[i].startIndex, _channelGroups[i].endIndex, _channelGroups[i].currentIndex);
		}
		
		NSAssert(channelCount <= CD_MAX_SOURCES,@"requested total channels exceeds CD_MAX_SOURCES");
		_channelTotal = channelCount;
		
		//Set up buffer states
		_bufferStates = new int[CD_MAX_BUFFERS];
		for (int i=0; i < CD_MAX_BUFFERS; i++) {
			_bufferStates[i] = CD_BS_EMPTY;
		}	
		
		_sourceBufferAttachments = new ALuint[CD_MAX_SOURCES];
		
		// Initialize our OpenAL environment
		if ([self _initOpenAL]) {
			functioning = TRUE;
		} else {
			//Something went wrong with OpenAL
			functioning = FALSE;
		}
		
		
	}
	
	return self;
}

/**
 * If you call this initialiser the sound engine won't handle audio session interruption and resumption.
 */
- (id)init:(int[]) channelGroupDefinitions channelGroupTotal:(int) channelGroupTotal {
	return [self init:channelGroupDefinitions channelGroupTotal:channelGroupTotal audioSessionCategory:CD_IGNORE_AUDIO_SESSION];
}	



/**
 * Load sound data for later play back.
 * @return TRUE if buffer loaded okay for play back otherwise false
 */
- (BOOL) loadBuffer:(int) soundId fileName:(NSString*) fileName fileType:(NSString*) fileType
{
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALvoid* data;
	ALsizei size;
	ALsizei freq;
	
	CCLOG(@"Denshion: Loading openAL buffer %i %@",soundId,fileName);
	
#ifdef DEBUG
	//Sanity check parameters - only in DEBUG
	NSAssert(soundId >= 0, @"soundId can not be negative");
	NSAssert(soundId < CD_MAX_BUFFERS, @"soundId exceeds limit set by CD_MAX_BUFFERS");	
#endif

	if (!functioning) {
		//OpenAL initialisation has previously failed
		return FALSE;
	}	

	NSBundle*				bundle = [NSBundle mainBundle];
	
	// get some audio data from a wave file
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:fileName ofType:fileType]] retain];
	
	if (fileURL)
	{
		if (_bufferStates[soundId] != CD_BS_EMPTY) {
		
			CCLOG(@"Denshion: non empty buffer, regenerating");
			//Must first delete buffer but can only do so if it is not attached to any sources
			
			for (int i=0; i < _channelTotal; i++) {
				//Note: tried getting the AL_BUFFER attribute of the source instead but doesn't
				//appear to work on a device - just returned zero.
				if (_buffers[soundId] == _sourceBufferAttachments[i]) {
					
					CCLOG(@"Found attached source %i %i %i",i,_buffers[soundId],_sourceBufferAttachments[i]);
					
					//Stop source and detach
					alSourceStop(_sources[i]);	
					if((error = alGetError()) != AL_NO_ERROR) {
						CCLOG(@"error stopping source: %x\n", error);
					}	
					
					alSourcei(_sources[i], AL_BUFFER, 0);//Attach to "NULL" buffer to detach
					if((error = alGetError()) != AL_NO_ERROR) {
						CCLOG(@"error detaching buffer: %x\n", error);
					}
				}	
			}	
			
			alDeleteBuffers(1, &_buffers[soundId]);
			if((error = alGetError()) != AL_NO_ERROR) {
				CCLOG(@"error deleting buffer: %x\n", error);
				_bufferStates[soundId] = CD_BS_FAILED;
				return FALSE;
			} 
			alGenBuffers(1, &_buffers[soundId]);
			if((error = alGetError()) != AL_NO_ERROR) {
				CCLOG(@"error regenerating buffer: %x\n", error);
				_bufferStates[soundId] = CD_BS_FAILED;
				return FALSE;
			} 
		}	
		
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CCLOG(@"Denshion: size %i frequency %i format %i %i", size, freq, format, data);
		CFRelease(fileURL);
		
		if(data == NULL || (error = alGetError()) != AL_NO_ERROR) {
			CCLOG(@"error loading sound: %x\n", error);
			_bufferStates[soundId] = CD_BS_FAILED;
			if (data != NULL) {
				free(data);//Free memory, it was an OpenAL error so there is data to free
			}	
			return FALSE;
		}
		
		alBufferData(_buffers[soundId], format, data, size, freq);
		free(data);		
		if((error = alGetError()) != AL_NO_ERROR) {
			CCLOG(@"error attaching audio to buffer: %x\n", error);
			_bufferStates[soundId] = CD_BS_FAILED;
			return FALSE;
		} 
	} else {
		CCLOG(@"Could not find file!\n");
		//Don't change buffer state here as it will be the same as before method was called	
		return FALSE;
	}	
	
	_bufferStates[soundId] = CD_BS_LOADED;
	return TRUE;
}

- (ALfloat) masterGain {
	ALfloat gain;
	alGetListenerf(AL_GAIN, &gain);
	return gain;
}	

/**
 * Overall gain setting multiplier. e.g 0.5 is half the gain.
 */
- (void) setMasterGain:(ALfloat) newGainValue {
	alListenerf(AL_GAIN, newGainValue);
}

- (BOOL) mute {
	return _mute;
}	

/**
 * Setting mute to true stops all sounds and prevent further sounds being played.  If you do not want sounds to be stopped but just silenced
 * then set masterGain to 0 instead.
 */
- (void) setMute:(BOOL) newMuteValue {
	_mute = newMuteValue;
	if (_mute) {
		//Turn off all sounds
		for (int i=0; i < _channelGroupTotal; i++) {
			[self stopChannelGroup:i];
		}	
	}	
}

/**
 * Play a sound.
 * @param soundId the id of the sound to play (buffer id).
 * @param channelGroupId the channel group that will be used to play the sound.
 * @param pitch pitch multiplier. e.g 1.0 is unaltered, 0.5 is 1 octave lower. 
 * @param pan stereo position. -1 is fully left, 0 is centre and 1 is fully right.
 * @param gain gain multiplier. e.g. 1.0 is unaltered, 0.5 is half the gain
 * @param loop should the sound be looped or one shot.
 * @return the id of the source being used to play the sound or CD_MUTE if the sound engine is muted or non functioning 
 * or CD_NO_SOURCE if a problem occurs setting up the source
 * 
 */
- (ALuint)playSound:(int) soundId channelGroupId:(int)channelGroupId pitch:(float) pitch pan:(float) pan gain:(float) gain loop:(BOOL) loop {

#ifdef DEBUG
	//Sanity check parameters - only in DEBUG
	NSAssert(soundId >= 0, @"soundId can not be negative");
	NSAssert(soundId < CD_MAX_BUFFERS, @"soundId exceeds limit");
	NSAssert(channelGroupId >= 0, @"channelGroupId can not be negative");
	NSAssert(channelGroupId < _channelGroupTotal, @"channelGroupId exceeds limit");
	NSAssert(pitch > 0, @"pitch must be greater than zero");
	NSAssert(pan >= -1 && pan <= 1, @"pan must be between -1 and 1");
	NSAssert(gain >= 0, @"gain not not be negative");
#endif
	
	//If mute or initialisation has failed then do nothing
	if (_mute || !functioning) {
		return CD_MUTE;
	}	
	
	//Work out which channel we can use
	int channel = _channelGroups[channelGroupId].currentIndex;
	if (_channelGroups[channelGroupId].startIndex != _channelGroups[channelGroupId].endIndex) {
		_channelGroups[channelGroupId].currentIndex++;
		if(_channelGroups[channelGroupId].currentIndex > _channelGroups[channelGroupId].endIndex) {
			_channelGroups[channelGroupId].currentIndex = _channelGroups[channelGroupId].startIndex; 
		}	
	}	
	return [self _startSound:soundId channelId:channel pitchVal:pitch panVal:pan gainVal:gain looping:loop];
}	

/**
 * Internal method - use playSound instead.
 */
- (ALuint)_startSound:(int) soundId channelId:(int) channelId pitchVal:(float) pitchVal panVal:(float) panVal gainVal:(float) gainVal looping:(BOOL) looping
{
	ALenum error;
	ALint state;
	ALuint source = _sources[channelId];
	ALuint buffer = _buffers[soundId];
	
	alGetSourcei(source, AL_SOURCE_STATE, &state);
	if (state == AL_PLAYING) {
		alSourceStop(source);
	}	
	
	alSourcei(source, AL_BUFFER, buffer);//Attach to sound
	alSourcef(source, AL_PITCH, pitchVal);//Set pitch
	alSourcei(source, AL_LOOPING, looping);//Set looping
	alSourcef(source, AL_GAIN, gainVal);//Set gain/volume
	float sourcePosAL[] = {panVal, 0.0f, 0.0f};//Set position - just using left and right panning
	alSourcefv(source, AL_POSITION, sourcePosAL);

	alSourcePlay(source);
	if((error = alGetError()) == AL_NO_ERROR) {
		//Everything was okay
		_sourceBufferAttachments[channelId] = buffer;//Keep track of which buffer source is attached to as alGetSourcei on AL_BUFFER does not seem to work
		return source;
	} else {
		//Something went wrong - set error code and return failure code
		lastErrorCode = error;
		return CD_NO_SOURCE;
	}	
}

/**
 * Stop all sounds playing within a channel group
 */
- (void) stopChannelGroup:(int) channelGroupId {
	if (!functioning) {
		return;
	}	
	for (int i=_channelGroups[channelGroupId].startIndex; i <= _channelGroups[channelGroupId].endIndex; i++) {
		alSourceStop(_sources[i]);
	}	
}	

/**
 * Stop a sound playing.
 * @param sourceId an OpenGL source identifier i.e. the return value of playSound
 */
- (void)stopSound:(int) sourceId {
	if (!functioning) {
		return;
	}	
	alSourceStop(sourceId);
}

//Code to handle audio session interruption.  Thanks to Andy Fitter and Ben Britten.
-(void)audioSessionInterrupted 
{ 
    CCLOG(@"Denshion: Audio session interrupted"); 
	ALenum  error = AL_NO_ERROR;
    // Deactivate the current audio session 
    OSStatus result = AudioSessionSetActive(NO); 
    // set the current context to NULL will 'shutdown' openAL 
    alcMakeContextCurrent(NULL); 
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error making context current %x\n", error);
	} 
    // now suspend your context to 'pause' your sound world 
    alcSuspendContext(_context); 
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error suspending context %x\n", error);
	} 
} 

//Code to handle audio session resumption.  Thanks to Andy Fitter and Ben Britten.
-(void)audioSessionResumed 
{ 
    ALenum  error = AL_NO_ERROR;
	CCLOG(@"Denshion: Audio session resumed"); 
    // Reset audio session 
    OSStatus result = AudioSessionSetProperty ( kAudioSessionProperty_AudioCategory, sizeof(_audioSessionCategory), &_audioSessionCategory ); 
	
	// Reactivate the current audio session 
    result = AudioSessionSetActive(YES); 
	
    // Restore open al context 
    alcMakeContextCurrent(_context); 
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error making context current%x\n", error);
	} 
    // 'unpause' my context 
    alcProcessContext(_context); 
	if(error = alGetError() != AL_NO_ERROR) {
		CCLOG(@"Denshion: Error processing context%x\n", error);
	} 
} 

@end
