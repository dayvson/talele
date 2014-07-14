/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import "GameHelper.h"

@implementation GameHelper
+(NSMutableDictionary *) getPlist:(NSString*)plist{
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",plist];
    NSString *plistPath;
    plistPath = [GameHelper getResourcePathByName:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    }

    NSMutableDictionary *plistDictionary = [NSMutableDictionary
                                            dictionaryWithContentsOfFile:plistPath];
    return plistDictionary;
}
+(NSString*)getResourcePathByName:(NSString*)fileName{
    NSString *resourcePath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    resourcePath = [rootPath stringByAppendingPathComponent:fileName];
    return resourcePath;
}
+ (float)randomBetween:(float)smallNumber and:(float)bigNumber{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

+ (BOOL) isRetinaIpad {
    return CC_CONTENT_SCALE_FACTOR() == 2;
}

+ (NSString *)generateUUID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return [uuidStr autorelease];
}

+(CCMenuItemSprite *) createMenuItemBySprite:(NSString *)name target:(id)target selector:(SEL)selector{
    CCSprite *itemSprite = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:name]];
    CCSprite *itemSpriteSel = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache
                                                                   sharedSpriteFrameCache]
                                                                  spriteFrameByName:name]];
    [itemSpriteSel setColor:ccBLACK];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite
                                                         selectedSprite:itemSpriteSel
                                                                 target:target
                                                               selector:selector];
    return itemMenu;
}

+(CCLabelBMFont*) getLabelFontByLanguage:(NSArray*)labels andLanguage:(int)languageID{
    CCLabelBMFont* labelFont = [CCLabelBMFont
                                labelWithString:[labels objectAtIndex:languageID]
                                fntFile:i5res(@"john.fnt")];
    return labelFont;
}

+(NSString*)getSystemLanguage{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return language;
}

@end
