/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "LevelNormalLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "GameHelper.h"

@implementation LevelNormalLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LevelNormalLayer *layer = [LevelNormalLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-gameplay-normal.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];
}

-(void)onExit{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_6x4_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_6x4_bevel.png"];
    [self removeAllChildrenWithCleanup:TRUE];
}

-(void) onEnter
{
	[super onEnter];
    [self resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
    self.isTouchEnabled = YES;
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    [self loadLevelSprites:@"6x4"];
    zIndex = 400;
    [self initBackground];
    
}
-(void) onEnterTransitionDidFinish{
    int cols = 6;
    int rows = 4;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadPieces:@"levelNormal" withCols:cols andRols:rows];
    [self initMenu];
    
}
-(void)dealloc {
    [super dealloc];
}

@end