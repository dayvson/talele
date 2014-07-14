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
    [cn setColor:ccBLUE];
    
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
                             fntFile:i5res(@"john.fnt")];
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
    cn = [self createFontMenuItem:@"简体中文" target:self selector:@selector(selectLanguage:)];

    eng.userData = [NSNumber numberWithInt:kEnglish];
    pt.userData = [NSNumber numberWithInt:kPortuguese];
    es.userData = [NSNumber numberWithInt:kSpanish];
    cn.userData = [NSNumber numberWithInt:kChina];
    
    langMenu = [CCMenu menuWithItems:eng,pt,es,cn, nil];
    langMenu.anchorPoint = ccp(0,0);
    [eng setColor:ccBLUE];
    [pt setColor:ccBLUE];
    [es setColor:ccBLUE];
    [cn setColor:ccBLUE];
    
    langMenu.position = ccp(400,350);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        langMenu.position = ccp(240, 170.0f);
    }

    [langMenu alignItemsVerticallyWithPadding:10.0f];
    pt.position = ccp(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? 30:100, pt.position.y);
    cn.position = ccp(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? 30:100, cn.position.y);
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:eng,pt,es,cn,nil ];
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        menuBack.position = ccp(400.0f, 100.0f);
    }
    if (iPhone5) {
        menuBack.position = ccp(500.0f, 80.0f);
    }
    [self addChild:menuBack];
}

-(void)createStaticText{
    languageLabel = [CCLabelBMFont
             labelWithString:@"."
             fntFile:i5res(@"john.fnt")];
    languageLabel.position = ccp(350,350);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        languageLabel.position = ccp(220, 170.0f);
    }

    languageLabel.color = ccBLACK;
    languageLabel.anchorPoint = ccp(1,0);
    [self addChild:languageLabel];
    [languageLabel setString:[languages objectAtIndex:[GameManager sharedGameManager].language]];
}

-(void)onClickCredits{
    if(credit){
        credit.opacity = credit.opacity == 255 ? 0 : 255;
        bgLanguage.visible = languageLabel.visible =
        langMenu.visible = credit.opacity == 255 ? NO : YES;
        
        return;
    }
    bgLanguage.visible = languageLabel.visible = langMenu.visible = NO;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    credit = [[CCSprite alloc] initWithFile:@"credits.png"];
    credit.position = ccp(screenSize.width/2-credit.contentSize.width/6,
                          screenSize.height/2+credit.contentSize.height/5);

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        credit.position = ccp(screenSize.width/2,
                           screenSize.height/2+credit.contentSize.height/4);
    }
    [self addChild:credit z:100 tag:100];
}

-(void)creditsAnimation{
    CCMenuItemSprite *creditButton = [GameHelper createMenuItemBySprite:@"btn-credits.png"
                                                                 target:self
                                                               selector:@selector(onClickCredits)];
    creditMenu = [CCMenu menuWithItems:creditButton,nil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        creditMenu.position = ccp(creditButton.contentSize.width - 15, creditButton.contentSize.height + 40);
    } else {
        creditMenu.position = ccp(creditButton.contentSize.width, creditButton.contentSize.height + 50);
    }

    [self addChild:creditMenu z:60 tag:60];
}


-(void) configureOptions {
    languages = [[NSArray alloc] initWithObjects:@"LANGUAGES:",@"IDIOMAS:",@"IDIOMAS:",@"语言:",nil ];
    labelsButtonBack = [[NSArray alloc] initWithObjects:@"BACK",@"VOLTAR",@"VOLVER",@"后退",nil ];
    [self createStaticText];
    [self createLanguagesMenu];
    [self createBtnVoltar];
    [self creditsAnimation];
}

@end
