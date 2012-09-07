/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "LevelEasyLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "ImageHelper.h"
#import "GameHelper.h"

@implementation LevelEasyLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelEasyLayer *layer = [LevelEasyLayer node];
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
    [self removeAllPieces];
    [self removeAllChildrenWithCleanup:TRUE];
    if(pieces){
        [pieces release];
    }
}

-(void)onExit{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3_bevel.png"];
}

-(void) onEnter
{
	[super onEnter];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    [self resetScreen];
    int cols = 4;
    int rows = 3;
    zIndex = 400;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self loadLevelSprites:@"4x3"];
    [self initBackground];
    [self initMenu];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadPieces:@"levelEasy" withCols:cols andRols:rows];
}

-(void)dealloc {
    [super dealloc];    
}

@end