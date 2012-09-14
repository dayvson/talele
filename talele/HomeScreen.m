/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "HomeScreen.h"
#import "GameManager.h"
#import "GameHelper.h"

@implementation HomeScreen
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HomeScreen *layer = [HomeScreen node];
	[scene addChild: layer];
	return scene;
}

-(void)initBackground{
    CCSprite *background;
    background = [CCSprite spriteWithFile:@"bg-stripe-home.png"];
    background.anchorPoint = ccp(0,0);
	[self addChild: background];
}
-(void) floorAnimation {
    CCSprite *floor;
    floor = [CCSprite spriteWithFile:@"floor.png"];
    floor.anchorPoint = ccp(0,0);
    floor.position = ccp(0, -floor.contentSize.height);
    [self addChild: floor];
    id moveAction = [CCMoveTo actionWithDuration:0.6f position:CGPointMake(0,0)];
    [floor runAction:[CCEaseIn actionWithAction:moveAction rate:0.7f]];
}

-(void) treeAnimation:(ccTime)dt{
    CCSprite *tree = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                             sharedSpriteFrameCache]
                                                            spriteFrameByName:@"tree_two.png"]];
    [tree setScale:0.1f];
    tree.anchorPoint = ccp(0,0);
    tree.position = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? ccp(60, 10): ccp(60, 20);

    [self addChild: tree];
    id action = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
    [tree runAction:[CCEaseOut actionWithAction:action rate:0.7f]];
}

-(void) mushroomAnimation:(ccTime)dt{
    CCSprite *mush = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                             sharedSpriteFrameCache]
                                                            spriteFrameByName:@"mushroom.png"]];
    [mush setScale:0.1f];
    mush.anchorPoint = ccp(1,0);
    
    mush.position = ccp(screenSize.width/2 - 40, 25);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        mush.position = ccp(screenSize.width-10, 10);
    }
    CCLOG(@"-_-----> %f", screenSize.width);
    [self addChild: mush];
    id action = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
    [mush runAction:[CCEaseOut actionWithAction:action rate:0.7f]];
}

-(void) megacloudAnimation:(ccTime)dt{
    CCSprite *megaCloud = [CCSprite spriteWithFile:@"mega-cloud.png"];
    megaCloud.anchorPoint = ccp(0.5f,0.5f);
    [megaCloud setScale:0.1f];
    megaCloud.position = ccp(screenSize.width/2 - 80, screenSize.height/2 );
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        megaCloud.position = ccp(screenSize.width/2, (screenSize.height/2) + 20);
    }
    [self addChild: megaCloud z:3 tag:3];
    id action = [CCScaleTo actionWithDuration:0.6f scale:1.0f];
    [megaCloud runAction:[CCEaseOut actionWithAction:action rate:0.5f] ];
}
-(void)piecesAroundAnimation:(ccTime)dt{
    CCSprite* piece1 = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                               sharedSpriteFrameCache]
                                                              spriteFrameByName:@"piece-white.png"]];

    piece1.position = ccp(screenSize.width+piece1.contentSize.width+10,
                          screenSize.height+piece1.contentSize.height);
    CGPoint p1position = ccp(900,550);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        p1position = ccp(420,250);
    }

    id p1Move = [CCMoveTo actionWithDuration:1.0f position:p1position];
    id p1Rotate = [CCRotateBy actionWithDuration:1.0f angle:360.0f];
    [piece1 runAction:[CCEaseOut actionWithAction:p1Move rate:0.7f]];
    [piece1 runAction:[CCEaseOut actionWithAction:p1Rotate rate:0.7f]];
    [self addChild: piece1 z:10 tag:10];
    CCSprite* piece2 = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                               sharedSpriteFrameCache]
                                                              spriteFrameByName:@"piece-white-1.png"]];
    id p2Rotate = [CCRotateBy actionWithDuration:1.2f angle:360.f];
    CGPoint p2position = ccp(158,312);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        p2position = ccp(112,146);
    }

    piece2.position = ccp(-(piece2.contentSize.width+10),
                          -(piece2.contentSize.height+10));
    [piece2 runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:1.2f
                                                                      position:p2position]
                                            rate:0.7f]];
    [piece2 runAction:[CCEaseOut actionWithAction:p2Rotate rate:0.7f]];
    [self addChild: piece2 z:20 tag:20];
    CCSprite* piece3 = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                               sharedSpriteFrameCache]
                                                              spriteFrameByName:@"piece-white-2.png"]];
    piece3.position = ccp(0, screenSize.height+piece3.contentSize.height+10);
    id p3Rotate = [CCRotateBy actionWithDuration:1.3f angle:360.f];
    CGPoint p3position = ccp(327,590);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        p3position = ccp(190,275);
    }

    [piece3 runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:1.3f
                                                                      position:p3position]
                                             rate:0.7f]];
    [piece3 runAction:[CCEaseOut actionWithAction:p3Rotate rate:0.7f]];
    [self addChild: piece3 z:30 tag:30];
    CCSprite* piece4 = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                               sharedSpriteFrameCache]
                                                              spriteFrameByName:@"piece-white-3.png"]];
    piece4.position = ccp(screenSize.width/2, -(piece4.contentSize.height+10));
    id p4Rotate = [CCRotateBy actionWithDuration:0.6f angle:180.f];
    CGPoint p4position = ccp(527,220);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        p4position = ccp(285,104);
    }
    [piece4 runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.6f
                                                                      position:p4position]
                                             rate:0.7f]];
    [piece4 runAction:[CCEaseOut actionWithAction:p4Rotate rate:0.7f]];
    [self addChild: piece4 z:40 tag:40];
}

-(void) cloudTop{
    CCSprite* cloud = [CCSprite spriteWithFile:@"cloud.png"];
    cloud.anchorPoint = ccp(0,1);
    cloud.position = ccp(0, screenSize.height+cloud.contentSize.height);
    [cloud runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.5f
                                                                     position:ccp(0,screenSize.height)]
                                            rate:0.7f]];
    [self addChild: cloud];
}

-(void)taleleAnimation:(ccTime)dt{
    CCSprite* logo = [CCSprite spriteWithFile:@"talele-logo.png"];
    [logo setScale:0.1f];
    logo.anchorPoint = ccp(0.5f,0.5f);
    logo.position = ccp(screenSize.width/2 - 60.0f , screenSize.height/2);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        logo.position = ccp(screenSize.width/2 + 15, screenSize.height/2 + 15);
    }
    [logo runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.9f scale:1.0f]]];
    [self addChild: logo z:50 tag:50];
    
}
-(void) onEnter{
    [super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [self loadPlistLevel];
    [self initBackground];
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];
}

-(void) onClickPlay {
    [[GameManager sharedGameManager] playSoundEffect:@"Comecar.mp3"];
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) initMenu :(ccTime)dt{
    CCMenuItemSprite *playButton = [GameHelper createMenuItemBySprite:@"btn-comecar.png" target:self selector:@selector(onClickPlay)];
    [playButton setScale:0.8f];
    CCMenu *mainMenu = [CCMenu menuWithItems:playButton,nil];
    CGPoint menuPosition = ccp(770.0f, 200.0f);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        menuPosition = ccp(400.0f, 100.0f);
    }
    [mainMenu setPosition: menuPosition];
    [mainMenu setOpacity:0];
    mainMenu.anchorPoint = ccp(0,0);
    [mainMenu runAction:[CCFadeIn actionWithDuration:0.5f]];
    
    /*    UIAlertView* reviewAlert = [[UIAlertView alloc] initWithTitle:@"Avalie o Talele" message:@"Se você e/ou seu filho(a) gostaram do Talelê quebra-cabeça por favor dê 5(cinco) estrelas e escreva um comentário. O desenvolvedor agradece" delegate:self cancelButtonTitle:@"Avaliar depois" otherButtonTitles:@"Já avaliei", nil ];
     [reviewAlert show];
     */
    [self addChild:mainMenu z:8 tag:8];
}
-(void) initParticles:(ccTime)dt {
    CCParticleFlower* emitter_ = [GameHelper getParticles];
    [self addChild:emitter_];
}

-(void)onEnterTransitionDidFinish{
    [self floorAnimation];
    [self cloudTop];
    [self scheduleOnce:@selector(megacloudAnimation:) delay:0.3];
    [self scheduleOnce:@selector(initMenu:) delay:2.0f];
    [self scheduleOnce:@selector(treeAnimation:) delay:0.5];
    [self scheduleOnce:@selector(mushroomAnimation:) delay:0.3];
    [self scheduleOnce:@selector(taleleAnimation:) delay:1.5f];
    [self scheduleOnce:@selector(piecesAroundAnimation:) delay:0.9];
    [self scheduleOnce:@selector(initParticles:) delay:0.9];
}
-(void)onExit{
//    [self removeAllChildrenWithCleanup:YES];
}
@end
