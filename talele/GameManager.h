/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "GameConstants.h"

@interface GameManager : NSObject {
    BOOL isMusicON;
    SceneTypes currentScene;
    NSString* currentPuzzle;
}
@property (readwrite) BOOL isMusicON;
@property (readwrite,retain) NSString* currentPuzzle;
-(void)runSceneWithID:(SceneTypes)sceneID;
+(GameManager*)sharedGameManager;                                  

@end

