/*
 * Copyright (c) Maxwell Dayvson <dayvson@gmail.com>
 * Copyright (c) Luiz Adolpho <luiz.adolpho@gmail.com>
 * Created 08/2012
 * All rights reserved.
 */

typedef enum {
    kNoSceneUninitialized=0,
    kMainMenu=1,
    kPuzzleSelection=2,
    kLevelEasy=3,
    kLevelHard=4
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


#define PLIN @"plin.wav"
#define MATCH1 @"match1.wav"
#define MATCH2 @"match2.wav"
#define MATCH3 @"match3.wav"

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
