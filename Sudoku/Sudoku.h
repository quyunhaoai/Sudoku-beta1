//
//  Sudoku.h
//  test
//
//  Created by dengyulai on 14-10-13.
//  Copyright (c) 2014年 Dylai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SudoNumber.h"
#import "Stack.h"

//数独游戏的难度
typedef enum _SudokuDifficulty {
    SudokuDifficultyAnimation =0,
    SudokuDifficultyEasy,
    SudokuDifficultyMiddle,
    SudokuDifficultyHard,
    SudokuDifficultyMaster
    
}SudokuDifficulty;

@interface Sudoku : NSObject
{
    @public
    SudokuNumber originalSudo[9][9];
}


@property (nonatomic, strong) NSMutableArray *numbers; // NSString NSNumber
@property (nonatomic, strong) Stack *undoStack;
@property (nonatomic, strong) Stack *redoStack;

- (id)initWithDifficulty:(SudokuDifficulty)difficulty;
- (BOOL)isLegalWithSudokuNumber:(SudokuNumber)sudokuNumber;
- (void)placeSudokuNumber:(SudokuNumber)sudokuNumber;

#pragma mark - 判断行、列、九宫格是否填满
- (BOOL)IsLineFilledAllWithRow:(NSInteger)row;
- (BOOL)IsColumnFilledAllWithClumn:(NSInteger)column;
- (BOOL)IsGridFilledAllWithRow:(NSInteger)row Clumn:(NSInteger)column;


#pragma mark - 出、入栈
- (void)pushSudokuNumber:(SudoNumber *)sudoNum;
- (void)popSudokuNumber;

//- (BOOL)isSuccess;
//- (void)nextStep;
//- (void)printFootSteps;

//- (void)redo;
//- (void)undo;
//- (void)hint;

//test
- (void)begin;

@end
