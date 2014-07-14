/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "HomeScreen.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "Options.h"
#import "AudioHelper.h"
@implementation HomeScreen
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HomeScreen *layer = [HomeScreen node];
	[scene addChild: layer];
	return scene;
}

-(void)initBackground{
    CCSprite *background;
    background = [CCSprite spriteWithFile:i5res(@"bg-stripe-home.png")];
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
    
    mush.position = ccp(screenSize.width-10, 25);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        mush.position = ccp(screenSize.width-10, 10);
    }
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
    CCSprite* logo = [CCSprite spriteWithFile:i5res(@"talele-logo.png")];
    [logo setScale:0.1f];
    logo.anchorPoint = ccp(0.5f,0.5f);
    logo.position = ccp(screenSize.width/2 - 60.0f , screenSize.height/2);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        logo.position = ccp(screenSize.width/2 + 15, screenSize.height/2 + 15);
    }
    [logo runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.9f scale:1.0f]]];
    [self addChild: logo z:50 tag:50];
    
}

-(void)loadLanguage{
    NSString* lang = [GameHelper getSystemLanguage];
    if([lang isEqual:@"pt"]){
        [GameManager sharedGameManager].language = kPortuguese;
    }else if([lang isEqual:@"es"]){
        [GameManager sharedGameManager].language = kSpanish;
    }else if([lang isEqual:@"zh-Hans"]){
        [GameManager sharedGameManager].language = kChina;
    }else{
        [GameManager sharedGameManager].language = kEnglish;
    }
}

-(void) onEnter{
    [super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [self loadLanguage];
    [self loadPlistLevel];
    [self initBackground];
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:i5res(@"buttons.plist")];
    [CCSpriteBatchNode batchNodeWithFile:i5res(@"buttons.png")];
}

-(void) onClickPlay {
    [AudioHelper playStart];
    [[GameManager sharedGameManager] runSceneWithID:kPuzzleSelection];
}

-(void) initMenu :(ccTime)dt{
    CCMenuItemSprite *playButton = [GameHelper createMenuItemBySprite:@"btn-comecar.png"
                                                               target:self selector:@selector(onClickPlay)];
    startLabel = [CCLabelBMFont
                  labelWithString:[startLabels objectAtIndex:[GameManager sharedGameManager].language]
                  fntFile:i5res(@"john.fnt")];
    [playButton setScale:0.8f];
    startLabel.anchorPoint = ccp(0.5,0.5);
    startLabel.position = ccp(playButton.contentSize.width/2, playButton.contentSize.height/2);
    [playButton addChild:startLabel];
    CCMenu *mainMenu = [CCMenu menuWithItems:playButton,nil];
    CGPoint menuPosition = ccp(770.0f, 200.0f);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        menuPosition = ccp(400.0f, 80.0f);
    }
    if (iPhone5) {
        menuPosition = ccp(500.0f, 80.0f);
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
    emitter = [[CCParticleFlower alloc] initWithTotalParticles:200];
    CGPoint p = emitter.position;
    emitter.position = ccp( p.x-110, p.y-110);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        emitter.position = ccp( p.x, p.y);
    }
    emitter.life = 30;
    emitter.lifeVar = 20;
    // gravity
    emitter.gravity = ccp(20,10);
    // speed of particles
    emitter.speed = 150;
    emitter.speedVar = 120;
    ccColor4F startColor = emitter.startColor;
    startColor.r = 1.0f;
    startColor.g = 1.0f;
    startColor.b = 1.0f;
    emitter.startColor = startColor;
    ccColor4F startColorVar = emitter.startColorVar;
    startColorVar.b = 0.1f;
    emitter.startColorVar = startColorVar;
    emitter.emissionRate = emitter.totalParticles/emitter.life;
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow.png"];
    [self addChild: emitter];
}

-(void) configureOptions {
    [[self getChildByTag:50] setVisible:NO];
    [[self getChildByTag:8] setVisible:NO];
    [AudioHelper playOptions];
    Options* opt = [[Options alloc] init];
    [opt setDelegate:self];
    [opt configureOptions];
    [self addChild:opt z:100 tag:100];
    opt.opacity = 0;
    [opt runAction:[CCFadeIn actionWithDuration:1.5f]];
    
}

-(void)onClickOptions{
    [optMenu setEnabled:NO];
    [self configureOptions];
}

-(void)onCloseOptions{
    [[self getChildByTag:50] setVisible:YES];
    [[self getChildByTag:8] setVisible:YES];
    [optMenu setEnabled:YES];
    [startLabel setString:[startLabels objectAtIndex:[GameManager sharedGameManager].language]];
}


-(void)optionsAnimation:(ccTime)dt{
    CCMenuItemSprite *optButton = [GameHelper createMenuItemBySprite:@"btn-opcoes.png"
                                                              target:self
                                                            selector:@selector(onClickOptions)];
    optMenu = [CCMenu menuWithItems:optButton,nil];
    /**optMenu.position = ccp(optButton.contentSize.width, screenSize.height-optButton.contentSize.height);
     optButton.opacity = 0;
     [optMenu runAction:[CCFadeIn actionWithDuration:0.5]];
     [self addChild:optMenu z:90 tag:90];**/
    optMenu.anchorPoint = ccp(0,0);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        optMenu.position = ccp(80 , screenSize.height - 85 );
    }else{
        optMenu.position = ccp(30 , screenSize.height - 60 );
    }
    if (iPhone5) {
        optMenu.position = ccp(30 , screenSize.height - 60 );
    }
    [self addChild:optMenu z:90 tag:90];
    NSString* lang = [GameHelper getSystemLanguage];
    if([lang isEqual:@""]){
        [GameManager sharedGameManager].language = kEnglish;
    }
}

-(void)onEnterTransitionDidFinish{
    startLabels = [[NSArray alloc] initWithObjects:@"START",@"COMEÇAR",@"INICIAR",@"开始",nil ];
    [self floorAnimation];
    [self cloudTop];
    [self scheduleOnce:@selector(megacloudAnimation:) delay:0.3];
    [self scheduleOnce:@selector(initMenu:) delay:2.0f];
    [self scheduleOnce:@selector(treeAnimation:) delay:0.5];
    [self scheduleOnce:@selector(mushroomAnimation:) delay:0.3];
    [self scheduleOnce:@selector(taleleAnimation:) delay:1.5f];
    //[self scheduleOnce:@selector(piecesAroundAnimation:) delay:0.9];
    [self scheduleOnce:@selector(initParticles:) delay:0.9];
    [self scheduleOnce:@selector(optionsAnimation:) delay:1.5];
    //[self scheduleOnce:@selector(creditsAnimation:) delay:1.5];
    [AudioHelper playBackground];
}
-(void)onExit{
    [emitter resetSystem];
    [self removeAllChildrenWithCleanup:YES];
}
@end
