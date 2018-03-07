//
//  Music.m
//  Sudoku
//
//  Created by dengyulai on 14-10-22.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import "Music.h"


@interface Music ()

@property (nonatomic, strong)AVAudioPlayer *BGMPlayer;

@end

@implementation Music

static Music *musicManager;

+ (id)sharedMusicManager
{
    if (musicManager == nil) {
        musicManager = [[Music alloc] init];
    }
    return musicManager;
}

-(id)init{
    if (self = [super init]) {
        self.BGM_URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sudoku" ofType:@"m4a"]];
        self.matchURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tile-match" ofType:@"wav"]];
        self.allMatchURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"allmatch" ofType:@"wav"]];
        self.missMatchURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"mismatch" ofType:@"wav"]];
        self.touchURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tile-touched" ofType:@"wav"]];
    }
    return self;
}

-(void)BGMPlayerprepareToPlayWithURL:(NSURL *)url{
    self.BGMPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.BGMPlayer.numberOfLoops = -1;
    [self.BGMPlayer prepareToPlay];
}

-(void)BGMPlayerPlay
{
    [self.BGMPlayer play];
}

-(void)BGMPlayerPause
{
    [self.BGMPlayer pause];
}

@end
