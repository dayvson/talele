/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ImageHelper : NSObject {

}
+ (UIImage*) convertSpriteToImage:(CCSprite *)sprite;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*) cropImage:(UIImage*)image toSize:(CGSize)crop;
+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage withOffset:(CGPoint)offset;
+ (NSString*)saveImageFromLibraryIntoPuzzlePlist:(UIImage*)image;
+ (BOOL)removeImageFromPage:(NSString*)itemPath;

@end
