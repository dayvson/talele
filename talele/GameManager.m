/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "GameManager.h"
#import "MainScreenLayer.h"
#import "PuzzleSelectionLayer.h"
#import "LevelEasyLayer.h"
#import "LevelHardLayer.h"

@implementation GameManager

static GameManager* _sharedGameManager = nil;
@synthesize isMusicON;

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
    }
    return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    id sceneToRun = nil;

    switch (sceneID) {
        case kMainMenu: 
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0 scene:[MainScreenLayer scene] withColor:ccWHITE];
            break;
        case kPuzzleSelection:
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0 scene:[PuzzleSelectionLayer scene] withColor:ccWHITE];
            break;
        case kLevelEasy:
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0 scene:[LevelEasyLayer scene] withColor:ccWHITE];
            break;
        case kLevelHard: 
            sceneToRun = [CCTransitionFade transitionWithDuration:1.0 scene:[LevelHardLayer scene] withColor:ccWHITE];
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
@end

