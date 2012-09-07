/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "LevelHardLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "ImageHelper.h"
#import "GameHelper.h"

@implementation LevelHardLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelHardLayer *layer = [LevelHardLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onClickBack {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}



-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void) resetScreen {
    [self removeAllChildrenWithCleanup:TRUE];
    if(pieces){
        [pieces release];
    }
    CCDirector * director_ = [CCDirector sharedDirector];
    [director_ purgeCachedData];
    screenSize = [director_ winSize];
    if(puzzleImage){
        [puzzleImage removeAllChildrenWithCleanup:YES];
        [puzzleImage release];
        puzzleImage = nil;
    }
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

}

-(void)onExit{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4_bevel.png"];
    
}

-(void) onEnter
{
	[super onEnter];
    int cols = 6;
    int rows = 4;
    [self resetScreen];
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    zIndex = 400;
    
    [self loadLevelSprites:@"6x4"];
    [self initBackground];
    [self initMenu];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadPieces:@"levelHard" withCols:cols andRols:rows];
}

-(void)dealloc {
    [super dealloc];
}

@end