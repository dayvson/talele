//
//  Options.h
//  talele
//
//  Created by Maxwell Dayvson da Silva on 9/15/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Options : CCSprite {
    CCMenuItemFont *eng;
    CCMenuItemFont *pt;
    CCMenuItemFont *es;
    CCMenuItemFont *cn;
    CCLabelBMFont *languageLabel;
    CCLabelBMFont* btLabel;
    CCMenu *langMenu;
    CCMenu *creditMenu;
    CCSprite *credit;
    CCSprite *bgLanguage;
    NSArray* languages;
    NSArray* labelsButtonBack;
    id delegate;

}
-(void) configureOptions;
- (void)setDelegate:(id)delegate;
@end

@interface NSObject(OptionsDelegateMethods)
- (void)onCloseOptions;
@end
