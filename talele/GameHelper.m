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
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    }
    NSMutableDictionary *plistDictionary = [NSMutableDictionary
                                            dictionaryWithContentsOfFile:plistPath];
    return plistDictionary;
}
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber{
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
    [itemSpriteSel setScale:1.2];
    CCMenuItemSprite *itemMenu = [CCMenuItemSprite itemWithNormalSprite:itemSprite
                                                         selectedSprite:itemSpriteSel target:target selector:selector];
    return itemMenu;
}

+ (CCParticleFlower*) getParticles{
    CCParticleFlower* emitter = [[CCParticleFlower alloc] initWithTotalParticles:200];
    CGPoint p = emitter.position;
    emitter.position = ccp( p.x, p.y+200);
    emitter.life = 30;
    emitter.lifeVar = 20;
    // gravity
    emitter.gravity = ccp(10,10);
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
    return emitter;
}

@end
