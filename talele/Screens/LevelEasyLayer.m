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

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:i5res(@"background-gameplay-easy.png")];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];    
}

-(void)onExit{
    [super onExit];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"pieces_4x3_bevel.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"pieces_4x3_bevel.png"];
}

-(void) onEnter
{
	[super onEnter];
    [self resetScreen];
    CCDirector * director_ = [CCDirector sharedDirector];
    screenSize = [director_ winSize];
    zIndex = 1100;
    [[director_ touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self initBackground];
    [self loadPuzzleImage:[GameManager sharedGameManager].currentPuzzle];

}
-(void)onEnterTransitionDidFinish{
    int cols = 4;
    int rows = 3;
    pieces = [[NSMutableArray alloc] initWithCapacity:cols*rows];
    [self loadLevelSprites:@"4x3"];
    [self loadPieces:@"levelEasy" withCols:cols andRols:rows];
    [self initMenu];
    [self scheduleOnce:@selector(enableTouch:) delay:0.5];

}

-(void)dealloc {
    [super dealloc];    
}

@end