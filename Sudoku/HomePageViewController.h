//
//  HomePageViewController.h
//  Sudoku
//
//  Created by whunf on 14-10-19.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"

@protocol HomePageViewControllerDelegate <NSObject>

@optional
- (void)difficultButtonDidTapped:(NSInteger)difficultNum;
@end
@interface HomePageViewController : UIViewController<AVAudioPlayerDelegate>

- (IBAction)presentToIntroVC:(UIButton *)sender;
- (IBAction)gameBegin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *gameCenterButton;


@property (strong, nonatomic) IBOutletCollection(id) NSArray *collectin1;

@property (strong, nonatomic) IBOutletCollection(id) NSArray *collectin2;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *subBackGroundImage;
@property (weak, nonatomic) IBOutlet UIView *beginView;
@property (weak, nonatomic) IBOutlet UIView *difficultView;
@property (assign, nonatomic) BOOL isInDifficultview;
@property (assign, nonatomic) NSInteger difficultNum;

@property (assign, nonatomic) id<HomePageViewControllerDelegate>delegate;

- (IBAction)difficultButtonTapped:(UIButton *)sender;

@end
