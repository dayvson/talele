//
//  AudioHelper.m
//  talele
//
//  Created by Maxwell Dayvson da Silva on 9/16/12.
//  Copyright 2012 Terra. All rights reserved.
//

#import "AudioHelper.h"
#import "GameManager.h"

@implementation AudioHelper

+(void) playOptions{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Opcoes.mp3" : @"Options.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playStart{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Comecar.mp3" : @"Start.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playEasy{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Facil.mp3" : @"Easy.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playNormal{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Normal.mp3" : @"Normal_english.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playHard{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Dificil.mp3" : @"Hard.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playBack{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Voltar.mp3" : @"Back.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playNewGame{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"NovoJogo.mp3" : @"NewGame.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playYouWin{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"ParabensVamosJogarDeNovo.mp3" : @"CongratulationsLetsPlayAgain.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playGreat{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"MuitoBom.mp3" : @"Great.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}
+(void) playCongratulations{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"Parabens.mp3" : @"Congratulations.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];
    
}
+(void) playSelectPicture{
    NSString* sound = [GameManager sharedGameManager].language == kPortuguese ? @"EscolhaUmaFoto.mp3" : @"SelectYourPicture.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];

}

+(void) playWoohoo{
    NSString* sound = @"Woohoo.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];    
}
+(void) playNotice{
    NSString* sound = @"tf_notification.wav";
    [[GameManager sharedGameManager] playSoundEffect:sound];
}

+(void) playBackground{
   [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_background_music.mp3"];
}

+(void) playClick{
    NSString* sound = @"Click.mp3";
    [[GameManager sharedGameManager] playSoundEffect:sound];

}
@end
