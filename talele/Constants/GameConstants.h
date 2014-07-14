/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

typedef enum {
    kNoSceneUninitialized=0,
    kHomeScreen=1,
    kPuzzleSelection=2,
    kLevelEasy=3,
    kLevelNormal=4,
    kLevelHard=5
} SceneTypes;

typedef enum {
    kVAlignTOP=0,
    kVAlignCENTER=1,
    kVAlignBOTTOM=2,
    kHAlignLEFT=3,
    kHAlignCENTER=4,
    kHAlignRIGHT=5
} AlignPiece;

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
} GameManagerSoundState;

typedef enum {
    kEnglish=0,
    kPortuguese=1,
    kSpanish=2,
    kChina=3
}Language;

#define PLIN @"plin.wav"

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
