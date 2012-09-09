/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "MainScreenLayer.h"
#import "GameConfig.h"
#import "GameManager.h"
#import "GameHelper.h"
@implementation MainScreenLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainScreenLayer *layer = [MainScreenLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];
}

-(void) onClickPlay {
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) initMenu {
    CCMenuItemSprite *playButton = [GameHelper createMenuItemBySprite:@"btn-comecar.png" target:self selector:@selector(onClickPlay)];
    CCMenu *mainMenu = [CCMenu menuWithItems:playButton,nil];
    [mainMenu setPosition: ccp(350.0f, screenSize.height/2.0f)];
    mainMenu.anchorPoint = ccp(0,0);
    
/*    UIAlertView* reviewAlert = [[UIAlertView alloc] initWithTitle:@"Avalie o Talele" message:@"Se você e/ou seu filho(a) gostaram do Talelê quebra-cabeça por favor dê 5(cinco) estrelas e escreva um comentário. O desenvolvedor agradece" delegate:self cancelButtonTitle:@"Avaliar depois" otherButtonTitles:@"Já avaliei", nil ];
    [reviewAlert show];
*/
    [self addChild:mainMenu];
}

-(void) onExit{
    [self removeAllChildrenWithCleanup:YES];
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-homescreen.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
	[self addChild: background];
}

-(void) onEnter
{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [self loadPlistLevel];
    [self initBackground];
    [self initMenu];
}


-(void)dealloc {
    [super dealloc];
}
@end
