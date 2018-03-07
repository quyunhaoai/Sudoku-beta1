//
//  ViewController.m
//  FKTTTTT
//
//  Created by dengyulai on 14-10-13.
//  Copyright (c) 2014年 Dylai. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Sudoku.h"




@interface ViewController ()

@property (nonatomic, strong)Sudoku *sudoku;
@property (nonatomic, assign)NSInteger time;
@property (nonatomic, assign)NSInteger min;
@property (nonatomic, assign)NSInteger mistakes;
@property (nonatomic, strong)Animations *animations;
@property (nonatomic, strong)Music *musicManager;


@end

@implementation ViewController


#pragma mark - 初始化

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //查看有无需要隐藏的按钮
    [self checkEveryNumberButtonForCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[Music sharedMusicManager] BGMPlayerPause];
    
    //根据所选难度创建棋盘
    self.sudoku = [[Sudoku alloc] initWithDifficulty:self.difficult];
    self.minLabel.text = @"00";
    self.secondLabel.text = @"00";
    self.mistakesLabel.text = @"0";
    self.mistakes = 0;
    self.time = 0;
   
    //初始化悔棋栈
    self.redoButton.userInteractionEnabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeLabel:) userInfo:nil repeats:YES];
    self.animations = [[Animations alloc] init];
    self.animations.delegate = self;
    
    //自定义返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popToHomePage)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    
    self.musicManager = [Music sharedMusicManager];
    
//    //音频
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.matchURL), &matchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.allMatchURL), &allmatchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.missMatchURL), &missmatchID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(self.musicManager.touchURL), &touchID);
        
    

}

#pragma mark - 遍历所有，查看使用次数

- (void)checkEveryNumberButtonForCount{
    int count1 = 0;
    int count2= 0;
    int count3 = 0;
    int count4 = 0;
    int count5 = 0;
    int count6 = 0;
    int count7 = 0;
    int count8 = 0;
    int count9 = 0;
    for (int i = 0; i < 81; i++) {
        NSInteger row = i/9;
        NSInteger column = i%9;
        SudoNumber *judgeNum = self.sudoku.numbers[row][column];
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
#warning
        UICollectionViewCell *tmpCell = [self.collectonView cellForItemAtIndexPath:tmpIndexPath];
        tmpCell.selected = NO;
        switch (judgeNum.sudokuNumber.number)
        {
            case 1:
                count1++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:1];
                button.hidden = count1 == 9 ? YES : NO;
            }
                break;
            case 2:
                count2++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:2];
                button.hidden = count2 == 9 ? YES : NO;
            }
                break;
            case 3:
                count3++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:3];
                button.hidden = count3 == 9 ? YES : NO;
            }
                break;
            case 4:
                count4++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:4];
                button.hidden = count4 == 9 ? YES : NO;
            }
                break;
            case 5:
                count5++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:5];
                button.hidden = count5 == 9 ? YES : NO;
            }
                break;
            case 6:
                count6++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:6];
                button.hidden = count6 == 9 ? YES : NO;
            }
                break;
            case 7:
                count7++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:7];
                button.hidden = count7 == 9 ? YES : NO;
            }
                break;
            case 8:
                count8++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:8];
                button.hidden = count8 == 9 ? YES : NO;
            }
                break;
            case 9:
                count9++;
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:9];
                button.hidden = count9 == 9 ? YES : NO;
            }
                break;
        }
    }

}


#pragma mark - HomePageViewController Delegate

- (void)difficultButtonDidTapped:(NSInteger)difficultNum
{
    self.difficult = difficultNum;
}

#pragma mark - 自定义导航栏返回按钮
- (void)popToHomePage
{
    AudioServicesPlaySystemSound(touchID);
    [self.musicManager BGMPlayerPlay];
    [self.animations transitionAnimationWithType:@"pageUnCurl" subType:nil onLayer:self.navigationController.view.layer];
    [self.navigationController popViewControllerAnimated:YES];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark 更改计时显示
- (void)changeTimeLabel:(NSTimer *)timer
{
    self.time++;
    if (self.time < 60) {
        if (self.time < 10) {
            self.secondLabel.text = [NSString stringWithFormat:@"0%d",self.time];
        }
        else{
            self.secondLabel.text = [NSString stringWithFormat:@"%d",self.time];
        }
        
    }
    else{
        self.time = 0;
        self.min++;
        if (self.min < 10) {
            self.minLabel.text = [NSString stringWithFormat:@"0%d",self.min];
        }
        else{
            self.minLabel.text = [NSString stringWithFormat:@"%d",self.min];
        }
    }
}

#pragma mark - collection view datasource
#pragma mark datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 81;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    //行号
    NSInteger row = indexPath.row / 9;
    NSInteger column = indexPath.row % 9;
    SudoNumber *tmpSudo = self.sudoku.numbers[row][column];
    if (tmpSudo.sudokuNumber.number) {
        NSInteger index = tmpSudo.sudokuNumber.number;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"q%d",index]];
    }
    else
    {
        imageView.image = nil;
    }
   
    return cell;
}

#pragma mark delegate
//选中某个单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudioServicesPlaySystemSound(touchID);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.indexPath = indexPath;
    //MyLog(@"(%.0f,%.0f)",cell.center.x,cell.center.y);
    self.selectedPos = cell.center;
    //处理选中效果
    NSInteger row = indexPath.row / 9;
    NSInteger column = indexPath.row % 9;
    SudoNumber *tmpSudo = self.sudoku.numbers[row][column];
    if (!tmpSudo.sudokuNumber.number) {
        UIImageView *image = (UIImageView *)[cell viewWithTag:101];
        image.image = [UIImage imageNamed:@"selected0"];
    }else{
        for (int i = 0; i < 81; i++) {
            NSInteger row = i / 9;
            NSInteger column = i % 9;
            SudoNumber *cellSudo = self.sudoku.numbers[row][column];
            if (cellSudo.sudokuNumber.number == tmpSudo.sudokuNumber.number) {
                NSIndexPath *indexPah = [NSIndexPath indexPathForRow:i inSection:0];
                UICollectionViewCell *cell1 = [collectionView cellForItemAtIndexPath:indexPah];
                UIImageView *imageView = (UIImageView *)[cell1 viewWithTag:101];
                imageView.image = [UIImage imageNamed:@"selected1"];
            }
        }
    }
}

//取消选中某个单元格
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //处理选中效果
    NSInteger row = indexPath.row / 9;
    NSInteger column = indexPath.row % 9;
    SudoNumber *tmpSudo = self.sudoku.numbers[row][column];
    if (!tmpSudo.sudokuNumber.number) {
        UIImageView *image = (UIImageView *)[cell viewWithTag:101];
        image.image = nil;
    }else{
        for (int i = 0; i < 81; i++) {
            NSInteger row = i / 9;
            NSInteger column = i % 9;
            SudoNumber *cellSudo = self.sudoku.numbers[row][column];
            if (cellSudo.sudokuNumber.number == tmpSudo.sudokuNumber.number) {
                NSIndexPath *indexPah = [NSIndexPath indexPathForRow:i inSection:0];
                UICollectionViewCell *cell1 = [collectionView cellForItemAtIndexPath:indexPah];
                UIImageView *imageView = (UIImageView *)[cell1 viewWithTag:101];
                imageView.image = nil;
            }
        }
    }

}

#pragma mark - 数字按钮方法
- (IBAction)numberBtnTapped:(UIButton *)sender {
    AudioServicesPlaySystemSound(touchID);
    NSInteger selectedRow = self.indexPath.row;
    NSInteger row = selectedRow / 9;
    NSInteger column = selectedRow % 9;
    SudoNumber * tmpSudo = self.self.sudoku.numbers[row][column];
    if (!tmpSudo.sudokuNumber.number) {
        self.selectdButton = sender;
        self.senderImage = sender.imageView;
        [self.animations addRoutingAnimationWithItem:sender toPosition:self.selectedPos  IndexX:row IndexY:column Sudoku:self.sudoku];
        
        for (UIButton *button in self.numberButtons) {
            button.userInteractionEnabled = NO;
        }
    }
}


#pragma mark - 悔棋操作
- (IBAction)redoButtonTapped:(UIButton *)sender {
    AudioServicesPlaySystemSound(touchID);
    if (self.sudoku.redoStack.items.count) {
        [self.sudoku popSudokuNumber];
        //选中悔棋位置
//        SudoNumber *redoNum = [self.sudoku.undoStack.items lastObject];
//        NSInteger redo_x = redoNum.sudokuNumber.pos.x;
//        NSInteger redo_y = redoNum.sudokuNumber.pos.y;

    }
    //悔棋按钮不与用户交互
    if (self.sudoku.redoStack.items.count == 0) {
        sender.userInteractionEnabled = NO;
    }
    [self.collectonView reloadData];
    //[self checkEveryNumberButtonForCount];
}

#pragma mark - animation delegate


-(void)mismatch
{
    AudioServicesPlaySystemSound(missmatchID);
}

-(void)judgeIsTrueOrNotWithShouldReverse:(BOOL)reverse
{
    self.isRight = reverse;
    
    //1.填数不正确
    if (self.animations.autoreverses)
    {//不正确
        
        [self.animations addBounceAnimatioWithItem:self.selectdButton];
        self.mistakes++;
        self.mistakesLabel.text = [NSString stringWithFormat:@"%d",self.mistakes];
    }
    
    
    //2.填数正确
    else
    {
        
        AudioServicesPlaySystemSound(matchID);
        //修改numbers
        NSInteger row = self.indexPath.row /9;
        NSInteger column = self.indexPath.row % 9;
        SudokuNumber newSDN = {CGPointMake(row, column),self.selectdButton.tag};
        SudoNumber *newSudo = self.sudoku.numbers[row][column];
        
        newSudo.sudokuNumber = newSDN;
        self.sudoku.numbers[row][column] = newSudo;
        
        //更换数字图片
        UICollectionViewCell *cell = [self.collectonView cellForItemAtIndexPath:self.indexPath];
        UIImageView *image = (UIImageView *)[cell viewWithTag:100];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"q%d",self.selectdButton.tag]];
        
        //修改选中图片
        int count = 0;
        for (int i = 0; i < 81; i++) {
            NSInteger row = i / 9;
            NSInteger column = i % 9;
            SudoNumber *cellSudo = self.sudoku.numbers[row][column];
            if (cellSudo.sudokuNumber.number == self.selectdButton.tag) {
                count ++;
                NSIndexPath *indexPah = [NSIndexPath indexPathForRow:i inSection:0];
                UICollectionViewCell *cell1 = [self.collectonView cellForItemAtIndexPath:indexPah];
                UIImageView *imageView = (UIImageView *)[cell1 viewWithTag:101];
                imageView.image = [UIImage imageNamed:@"selected1"];
            }
            if (count == 9) {
                self.selectdButton.hidden = YES;
                //MyLog(@"%d的次数%d",self.selectdButton.tag ,count);
            }
        }
        //入栈该步骤
        [self.sudoku pushSudokuNumber:newSudo];
        self.redoButton.userInteractionEnabled = YES;
       // MyLog(@"%@",self.sudoku.redoStack.items);
        
        
        //添加动画
        if ([self.sudoku IsLineFilledAllWithRow:row ] || [self.sudoku IsColumnFilledAllWithClumn:column] || [self.sudoku IsGridFilledAllWithRow:row Clumn:column]) {
            AudioServicesPlaySystemSound(allmatchID);
        }
        if ([self.sudoku IsLineFilledAllWithRow:row])
        {//行满
            //NSInteger row = self.indexPath.row / 9;
            for (int i = 0; i < 9; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:self.indexPath.row - self.indexPath.row % 9 + i inSection:0 ];
                UICollectionViewCell *NewCell = [self.collectonView cellForItemAtIndexPath:index];
                [self.animations addRotateAnimatioWithItem:NewCell];
            }
        }
        if ([self.sudoku IsColumnFilledAllWithClumn:column])
        {//列满
            for (int i = 0; i < 9; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:self.indexPath.row % 9 + i * 9 inSection:0 ];
                UICollectionViewCell *NewCell = [self.collectonView cellForItemAtIndexPath:index];
                [self.animations addRotateAnimatioWithItem:NewCell];
            }
        }
        if ([self.sudoku IsGridFilledAllWithRow:row Clumn:column])
        {//九宫格满
            NSInteger row = self.indexPath.row / 9;
            NSInteger column = self.indexPath.row % 9;
            
            NSInteger nine_x = row / 3 * 3;
            NSInteger nine_y = column /3 * 3;
            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:9 * (nine_x + i)+ nine_y + j inSection:0 ];
                    UICollectionViewCell *NewCell = [self.collectonView cellForItemAtIndexPath:index];
                    [self.animations addRotateAnimatioWithItem:NewCell];
                }
            }
        }
    }
    
    for (UIButton *button in self.numberButtons) {
        button.userInteractionEnabled = YES;
    }
}

@end
