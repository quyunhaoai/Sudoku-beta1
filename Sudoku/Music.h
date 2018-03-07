//
//  Music.h
//  Sudoku
//
//  Created by dengyulai on 14-10-22.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Music : NSObject

@property (nonatomic, strong) NSURL *BGM_URL;
@property (nonatomic, strong) NSURL *matchURL;
@property (nonatomic, strong) NSURL *allMatchURL;
@property (nonatomic, strong) NSURL *missMatchURL;
@property (nonatomic, strong) NSURL *touchURL;

+ (id)sharedMusicManager;

- (void)BGMPlayerprepareToPlayWithURL:(NSURL *)url;

- (void)BGMPlayerPlay;

- (void)BGMPlayerPause;

@end
