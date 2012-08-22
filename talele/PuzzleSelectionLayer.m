/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "PuzzleSelectionLayer.h"
#import "GameConstants.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "SlidingPuzzleGrid.h"

@implementation PuzzleSelectionLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PuzzleSelectionLayer *layer = [PuzzleSelectionLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) loadPlistLevel {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttons.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"buttons.png"];    
    [self addChild:sceneSpriteBatchNode z:1];
    
}

-(void) onClickHard {
    [[GameManager sharedGameManager] runSceneWithID:kLevelHard];
}

-(void) onClickEasy {
    [[GameManager sharedGameManager] runSceneWithID:kLevelEasy];
}


-(void) onClickPrevPuzzle {

}

-(void) onClickNextPuzzle {

}

-(void) onClickPhotoSelection {
    
}

-(CCMenuItemSprite *) createItemBySprite:(NSString *)name andCallback:(SEL)callback{
    CCSprite *itemSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                         sharedSpriteFrameCache]
                                                                        spriteFrameByName:name]];
    
    [itemSprite.texture setAliasTexParameters];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemFromNormalSprite:itemSprite
                                selectedSprite:nil target:self selector:callback];
    return itemMenu;
}
-(void) initStartGameButtons {

    CCMenuItemSprite *easyButton = [self createItemBySprite:@"btn-facil.png" andCallback:@selector(onClickEasy)];
    CCMenuItemSprite *hardButton = [self createItemBySprite:@"btn-dificil.png" andCallback:@selector(onClickHard)];
    CCMenu *mainMenu = [CCMenu menuWithItems:easyButton,hardButton, nil];
    [mainMenu alignItemsHorizontallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(screenSize.height/2.0f + 140 ,
                                                      100)];
    
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    mainMenu.anchorPoint = ccp(0,0);
    [self addChild:mainMenu z:0 tag:100];
}

-(void) initNavigationButtons {
    
    CCMenuItemSprite *prevButton = [self createItemBySprite:@"btn-voltar.png" andCallback:@selector(onClickPrevPuzzle)];
    CCMenuItemSprite *nextButton = [self createItemBySprite:@"btn-proximo.png" andCallback:@selector(onClickNextPuzzle)];
    CCMenu *mainMenu = [CCMenu menuWithItems:prevButton,nextButton, nil];
    [mainMenu alignItemsHorizontallyWithPadding:680];
    [mainMenu setPosition: ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:0.5f 
                                        position:ccp(510 ,
                                        screenSize.height/2.0f )];
    
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    id sequenceAction = [CCSequence actions:moveEffect,nil];
    [mainMenu runAction:sequenceAction];
    mainMenu.anchorPoint = ccp(0,0);
    [self addChild:mainMenu z:0 tag:101];
}

-(void) initPhotoButton {
    CCMenuItemSprite *pickbutton = [self createItemBySprite:@"btn-foto.png" andCallback:@selector(onClickPhotoSelection)];
    [pickbutton setPosition:ccp(screenSize.width - 150 , screenSize.height - 100 )];
    [self addChild:pickbutton];
    
}

-(void) initBackground {
	CCSprite *background;
    background = [CCSprite spriteWithFile:@"background-puzzle-selection.png"];
	background.position = ccp(screenSize.width/2, screenSize.height/2);
    
	[self addChild: background];    
}
-(void) updateSelectedImage:(CCMenuItemSprite*)sender{
    [[GameManager sharedGameManager] setCurrentPuzzle:(NSString*)sender.userData];
}

-(void) loadPuzzleImages {
    NSDictionary* puzzlesInfo = [GameHelper getPlist:@"puzzles"];
    NSMutableArray *arrayNames = [[NSMutableArray alloc] initWithObjects:@"arthur.jpg",@"cars2.jpg",@"valente.jpg",@"tangled.jpg", nil];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:arrayNames.count];
    CCLOG(@"LOAD PUZZLE IMAGE %d", arrayNames.count);
    for (int i=0; i<arrayNames.count; i++) {
        CCSprite* bg = [CCSprite spriteWithFile:@"photobg.png"];
        CCSprite* img = [CCSprite spriteWithFile:[arrayNames objectAtIndex:i]];
        img.anchorPoint = ccp(0,0);
        img.position = ccp(23,22);
        [img setScale:0.8];

        [bg addChild:img];
        CCMenuItemSprite* item = [[CCMenuItemSprite alloc] initWithNormalSprite:bg selectedSprite:nil disabledSprite:nil target:self selector:@selector(updateSelectedImage:)];
        item.userData = [arrayNames objectAtIndex:i];
        [items addObject:item];
    }

    SlidingPuzzleGrid* menuGrid = [SlidingPuzzleGrid menuWithArray:items 
                                                          cols:1 rows:1
                                                      position:ccp(screenSize.width/2, screenSize.height/2)
                                                       padding:CGPointMake(10.f, 0) 
                                                ];
    [self addChild:menuGrid];

}

-(void) onEnter
{
	[super onEnter];
    screenSize = [[CCDirector sharedDirector] winSize];
    [CCSpriteFrameCache sharedSpriteFrameCache ];
    [self loadPlistLevel];
    [self initBackground];
    [self initStartGameButtons];
    [self initNavigationButtons];
    [self initPhotoButton];
    [self loadPuzzleImages];
}


-(void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    [super dealloc];
    
}

@end
