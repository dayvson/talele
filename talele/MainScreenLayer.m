/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "MainScreenLayer.h"
#import "GameConfig.h"
#import "GameManager.h"

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
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    CCSprite *playSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:@"btn-comecar.png"]];
    [playSprite.texture setAliasTexParameters];
    CCMenuItemSprite *playButton = [CCMenuItemSprite
                                    itemFromNormalSprite:playSprite
                                    selectedSprite:nil
                                    target:self
                                    selector:@selector(onClickPlay)];
    CCMenu *mainMenu = [CCMenu menuWithItems:playButton,nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f position:ccp(350.0f, screenSize.height/2.0f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    mainMenu.anchorPoint = ccp(0,0);
    
/*    UIAlertView* reviewAlert = [[UIAlertView alloc] initWithTitle:@"Avalie o Talele" message:@"Se você e/ou seu filho(a) gostaram do Talelê quebra-cabeça por favor dê 5(cinco) estrelas e escreva um comentário. O desenvolvedor agradece" delegate:self cancelButtonTitle:@"Avaliar depois" otherButtonTitles:@"Já avaliei", nil ];
    [reviewAlert show];
*/
    [self addChild:mainMenu];
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
