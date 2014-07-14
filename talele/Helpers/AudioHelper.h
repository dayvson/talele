//
//  AudioHelper.h
//  talele
//
//  Created by Maxwell Dayvson da Silva on 9/16/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AudioHelper : NSObject {
    
}
+(void) playOptions;
+(void) playStart;
+(void) playEasy;
+(void) playNormal;
+(void) playHard;
+(void) playBack;
+(void) playNewGame;
+(void) playYouWin;
+(void) playGreat;
+(void) playSelectPicture;
+(void) playWoohoo;
+(void) playClick;
+(void) playCongratulations;
+(void) playNotice;
+(void) playBackground;

@end
