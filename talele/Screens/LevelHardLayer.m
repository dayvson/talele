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

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:i5res(@"background-gameplay-hard.png")];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void)onExit{
    [super onExit];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_8x6.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_8x6.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_8x6_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_8x6_bevel.png"];
    [self removeAllChildrenWithCleanup:TRUE];    
}

-(void) onEnter
{
	[super onEnter];
    [self resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    [self initBackground];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];
    zIndex = 1100;

}
-(void) onEnterTransitionDidFinish{
    int cols = 8;
    int rows = 6;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadLevelSprites:@"8x6"];
    [self loadPieces:@"levelHard" withCols:cols andRols:rows];
    [self initMenu];
    [self scheduleOnce:@selector(enableTouch:) delay:0.5];

}
-(void)dealloc {
    [super dealloc];
}

@end