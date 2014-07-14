/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "GameManager.h"
#import "PuzzleSelectionLayer.h"
#import "LevelEasyLayer.h"
#import "LevelHardLayer.h"
#import "LevelNormalLayer.h"
#import "GameConstants.h"
#import "HomeScreen.h"
@implementation GameManager

static GameManager* _sharedGameManager = nil;
@synthesize isMusicON;
@synthesize currentPuzzle;
@synthesize currentPage;
@synthesize language;
+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_sharedGameManager){
            [[self alloc] init];    
        }
        return _sharedGameManager;
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([GameManager class])
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");                                          
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        CCLOG(@"Game Manager Singleton, init");
        isMusicON = YES;
        currentScene = kNoSceneUninitialized;
        audioInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
        currentPage = 0;
    }
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;

    switch (sceneID) {
        case kHomeScreen:
            sceneToRun = [CCTransitionFade transitionWithDuration:1 scene:[HomeScreen scene] ];
            break;
        case kPuzzleSelection:
            sceneToRun = [CCTransitionSlideInT transitionWithDuration:0.5 scene:[PuzzleSelectionLayer scene]];
            break;
        case kLevelEasy:
            sceneToRun = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[LevelEasyLayer scene]];
            break;
        case kLevelNormal:
            sceneToRun = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[LevelNormalLayer scene]];
            break;
        case kLevelHard:
            sceneToRun = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[LevelHardLayer scene]];
            break;
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
            break;
    }
    if (sceneToRun == nil) {
        currentScene = oldScene;
        return;
    }

    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
}

-(void)initAudioAsync {
    managerSoundState = kAudioManagerInitializing;
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"CocosDenshion is Ready");
    } 
    
}

-(void)setupAudioEngine {
    if (audioInitialized == YES) {
        CCLOG(@"AUDIO ENGINE WAS INIT");
        return;
    } else {
        audioInitialized = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

-(ALuint)playSoundEffect:(NSString*)soundEffectKey {
    ALuint soundID = 0;    
    if (managerSoundState == kAudioManagerReady) {
        soundID = [soundEngine playEffect:soundEffectKey];
    } else {
        CCLOG(@"GameMgr: Sound Manager is not ready, cannot play %@",
              soundEffectKey);
    }
    return soundID;
}

@end

