//
//  Options.m
//  talele
//
//  Created by Maxwell Dayvson da Silva on 9/15/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "Options.h"
#import "GameManager.h"
#import "GameHelper.h"
#import "AudioHelper.h"

@implementation Options

-(void)selectLanguage:(CCMenuItemFont*)sender{
    bgLanguage.position = ccp(langMenu.position.x+sender.position.x-20,
                          langMenu.position.y+sender.position.y);
    [eng setColor:ccBLUE];
    [pt setColor:ccBLUE];
    [es setColor:ccBLUE];
    [sender setColor:ccWHITE];
    NSNumber* nlang = (NSNumber*)sender.userData;
    [GameManager sharedGameManager].language = [nlang intValue];
    [bgLanguage setScaleX:(sender.contentSize.width+40)/bgLanguage.contentSize.width];
    int language = [GameManager sharedGameManager].language;
    [languageLabel setString:[languages objectAtIndex:language]];
    [btLabel setString:[labelsButtonBack objectAtIndex:language]];
}

-(CCMenuItemFont*) createFontMenuItem:(NSString*)text target:(id)target selector:(SEL)selector{
    CCLabelBMFont* textBM = [CCLabelBMFont
                             labelWithString:text
                             fntFile:@"janda.fnt"];
    [CCMenuItemFont setFontSize:20];
    CCMenuItemFont *item = [CCMenuItemFont itemWithLabel:textBM
                                                  target:target selector:selector];
    item.anchorPoint = ccp(0,0);
    return item;
}

-(void)createLanguagesMenu{
    bgLanguage = [CCSprite spriteWithFile:@"active.png"];
    bgLanguage.anchorPoint = ccp(0,0);
    [self addChild:bgLanguage];
    eng = [self createFontMenuItem:@"ENGLISH" target:self selector:@selector(selectLanguage:)];
    pt = [self createFontMenuItem:@"PORTUGUÊS" target:self selector:@selector(selectLanguage:)];
    es = [self createFontMenuItem:@"ESPAÑOL" target:self selector:@selector(selectLanguage:)];
    eng.userData = [NSNumber numberWithInt:kEnglish];
    pt.userData = [NSNumber numberWithInt:kPortuguese];
    es.userData = [NSNumber numberWithInt:kSpanish];
    langMenu = [CCMenu menuWithItems:eng,pt,es, nil];
    langMenu.anchorPoint = ccp(0,0);
    [eng setColor:ccBLUE];
    [pt setColor:ccBLUE];
    [es setColor:ccBLUE];
    langMenu.position = ccp(400,350);
    [langMenu alignItemsVerticallyWithPadding:10.0f];
    pt.position = ccp(100, pt.position.y);

    NSArray *buttons = [[NSArray alloc] initWithObjects:eng,pt,es,nil ];
    [self selectLanguage:[buttons objectAtIndex:[GameManager sharedGameManager].language]];
    [self addChild:langMenu];
}

- (void)setDelegate:(id)aDelegate {
    delegate = aDelegate;
}

-(void)onClickBack{
    [AudioHelper playBack];
    [delegate onCloseOptions];
    [self removeFromParentAndCleanup:YES];
}

-(void)createBtnVoltar{
    btLabel = [GameHelper getLabelFontByLanguage:labelsButtonBack
                                                    andLanguage:[GameManager sharedGameManager].language];

    CCMenuItemSprite* btBack = [GameHelper createMenuItemBySprite:@"bt-voltar.png"
                                                           target:self
                                                         selector:@selector(onClickBack)];
    btLabel.position = ccp(btBack.contentSize.width/2, btBack.contentSize.height/2);
    [btBack addChild:btLabel];
    CCMenu* menuBack = [CCMenu menuWithItems: btBack, nil];
    menuBack.position = ccp(770.0f, 200.0f);
    [self addChild:menuBack];
}

-(void)createStaticText{
    languageLabel = [CCLabelBMFont
             labelWithString:@"."
             fntFile:@"janda.fnt"];
    languageLabel.position = ccp(350,350);
    languageLabel.color = ccBLACK;
    languageLabel.anchorPoint = ccp(1,0);
    [self addChild:languageLabel];
    [languageLabel setString:[languages objectAtIndex:[GameManager sharedGameManager].language]];
}
-(void) configureOptions {
    languages = [[NSArray alloc] initWithObjects:@"LANGUAGES:",@"IDIOMAS:",@"IDIOMAS:",nil ];
    labelsButtonBack = [[NSArray alloc] initWithObjects:@"BACK",@"VOLTAR",@"VOLVER",nil ];
    [self createStaticText];
    [self createLanguagesMenu];
    [self createBtnVoltar];
}

@end
