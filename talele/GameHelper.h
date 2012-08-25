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
+(NSDictionary *) getPlist:(NSString*)plist;
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;
@end
