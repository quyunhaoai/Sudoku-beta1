//
//  ViewController.h
//  FKTTTTT
//
//  Created by dengyulai on 14-10-13.
//  Copyright (c) 2014年 Dylai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"
#import "HomePageViewController.h"
#import "Music.h"


@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,AnimationsDelegate,HomePageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mistakesLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectonView;
@property (nonatomic, assign) CGPoint selectedPos;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *senderImage;
@property (nonatomic, strong) UIButton *selectdButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtons;
@property (assign, nonatomic) SudokuDifficulty difficult;


@property (nonatomic, assign) BOOL isRight;


- (IBAction)numberBtnTapped:(UIButton *)sender;
- (IBAction)redoButtonTapped:(UIButton *)sender;

@end
