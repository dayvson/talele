#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameHelper : NSObject {
    
}
+(NSDictionary *) getPlist:(NSString*)plist;
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;
@end
