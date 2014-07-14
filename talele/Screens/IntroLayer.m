/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "IntroLayer.h"
#import "GameConstants.h"
#import "GameManager.h"

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene=[CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
	CGSize size = [[CCDirector sharedDirector] winSize];
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	background.position = ccp(size.width/2, size.height/2);
	[self addChild: background];
	[self scheduleOnce:@selector(makeTransition:) delay:1];
    
}
-(void)onExit{
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [super dealloc];
}

-(void) makeTransition:(ccTime)dt
{
    [[GameManager sharedGameManager] runSceneWithID:kHomeScreen];
}
@end
