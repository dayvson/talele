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
    [[GameManager sharedGameManager] playSoundEffect:@"Voltar.mp3"];
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay-easy.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void)onExit{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3_bevel.png"];
    [self removeAllChildrenWithCleanup:YES];
}

-(void) onEnter
{
	[super onEnter];
    [self resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    zIndex = 400;
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self initBackground];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadLevelSprites:@"4x3"];
}
-(void)onEnterTransitionDidFinish{
    int cols = 4;
    int rows = 3;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadPieces:@"levelEasy" withCols:cols andRols:rows];
    [self initMenu];
}
-(void)dealloc {
    [super dealloc];    
}

@end