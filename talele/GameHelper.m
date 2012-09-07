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
@end
