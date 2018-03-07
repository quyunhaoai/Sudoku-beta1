//
//  HomePageViewController.m
//  Sudoku
//
//  Created by whunf on 14-10-19.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import "HomePageViewController.h"
#import "Animations.h"
#import "ViewController.h"


@interface HomePageViewController ()

@property (nonatomic, strong)Music *musicManager;

@end

@implementation HomePageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    self.beginView.layer.cornerRadius = 10;
    self.beginView.layer.masksToBounds = YES;
    self.difficultView.layer.cornerRadius =10;
    self.difficultView.layer.masksToBounds = YES;
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(btnsBounces) userInfo:nil repeats:YES];
    
    //背景音乐
    self.musicManager = [Music sharedMusicManager];
    [self.musicManager BGMPlayerprepareToPlayWithURL:self.musicManager.BGM_URL];
    [self.musicManager BGMPlayerPlay];
    
    //背景音效
  
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.matchURL), &matchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.allMatchURL), &allmatchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.missMatchURL), &missmatchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.touchURL), &touchID);
}

//- (void)buttonsBounce
//{
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(btnsBounces) userInfo:nil repeats:YES];
//}
//
- (void)btnsBounces
{
    Animations *animation = [[Animations alloc] init];
    for (id obj in self.collectin1) {
        [animation addBounceAnimatioWithItem:obj duration:2.0 height:5];
    }
    [self performSelector:@selector(lowerBounce) withObject:self afterDelay:0.1];
}


- (void)lowerBounce
{
    Animations *animation = [[Animations alloc] init];
    for (id obj in self.collectin2) {
        [animation addBounceAnimatioWithItem:obj duration:2.0 height:5];
    }

}

- (IBAction)presentToIntroVC:(UIButton *)sender {
    [self performSegueWithIdentifier:@"intro" sender:sender];
}

- (IBAction)gameBegin:(UIButton *)sender {
//    Animations *animation = [[Animations alloc] init];
//    //添加过渡动画
//    [animation transitionAnimationWithType:@"moveIn" subType:@"fromRight" onLayer:self.difficultView.layer];
    
    AudioServicesPlaySystemSound(touchID);
    CGRect frame = self.beginView.frame;
    frame.origin.x += frame.size.width;
    CGRect frame1 = self.difficultView.frame;
    frame1.origin.x -= frame1.size.width;
    [UIView animateWithDuration:0.8f animations:^{
        self.beginView.frame = frame;
        self.difficultView.frame = frame1;
    } completion:^(BOOL finished) {
        if (finished) {
            self.isInDifficultview = YES;
            self.gameCenterButton.hidden = YES;
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isInDifficultview) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPos = [touch locationInView:self.view];
        if (!(touchPos.x >self.difficultView.frame.origin.x
            && touchPos.x < 320 && touchPos.y > self.difficultView.frame.origin.y
            && touchPos.y < self.difficultView.frame.origin.y + self.difficultView.frame.size.height)) {
            CGRect frame = self.beginView.frame;
            frame.origin.x -= frame.size.width;
            CGRect frame1 = self.difficultView.frame;
            frame1.origin.x += frame1.size.width;
            
            [UIView animateWithDuration:0.8f animations:^{
                self.beginView.frame = frame;
                self.difficultView.frame = frame1;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isInDifficultview = NO;
                }
            }];
        }
    }
}
- (IBAction)difficultButtonTapped:(UIButton *)sender {
    AudioServicesPlaySystemSound(touchID);
    //[self.musicManager BGMPlayerPause];
    NSInteger difficultNum = sender.tag - 200;
    MyLog(@"difficulty: %d",sender.tag);
//    [self.delegate difficultButtonDidTapped:difficultNum];
    self.difficultNum = difficultNum;
    Animations *animation = [[Animations alloc] init];
    [animation transitionAnimationWithType:@"pageCurl" subType:nil onLayer:self.navigationController.view.layer];
    [self performSegueWithIdentifier:@"pushAlloc" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"pushAlloc"]) {
        ViewController *deController = segue.destinationViewController;
        deController.difficult = self.difficultNum;
    }
}

#pragma mark - audioPlayer delegate


@end
