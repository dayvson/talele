/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameHelper : NSObject {
    
}
+ (NSMutableDictionary *) getPlist:(NSString*)plist;
+ (float)randomBetween:(float)smallNumber and:(float)bigNumber;
+ (BOOL) isRetinaIpad;
+ (NSString *)generateUUID;
+ (CCMenuItemSprite *) createMenuItemBySprite:(NSString *)name target:(id)target selector:(SEL)selector;
+ (CCLabelBMFont*) getLabelFontByLanguage:(NSArray*)labels andLanguage:(int)languageID;
+ (NSString*)getResourcePathByName:(NSString*)fileName;
+ (NSString*)getSystemLanguage;
@end
