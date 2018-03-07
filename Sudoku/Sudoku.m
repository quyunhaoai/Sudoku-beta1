//
//  Sudoku.m
//  test
//
//  Created by dengyulai on 14-10-13.
//  Copyright (c) 2014年 Dylai. All rights reserved.
//

#import "Sudoku.h"

@implementation Sudoku

//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"values = %@,number = %d,pos = (%d,%d)",]
//}
- (id)init
{
    if (self = [super init]) {
        //初始化self.numbers
        self.numbers = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            NSMutableArray *rowArray  = [NSMutableArray array];
            for (int j = 0; j < 9; j++) {
                SudoNumber *sudoNumber = [[SudoNumber alloc] init];
                SudokuNumber tmpSudoNum = {CGPointMake(i, j),0};
                sudoNumber.sudokuNumber = tmpSudoNum;
                sudoNumber.values = [NSMutableArray array];
                [rowArray addObject:sudoNumber];
            }
            [self.numbers addObject:rowArray];
        }
        [self begin];
    }
    //此时，self.numbers为一个9x9二维数组
    return self;
}

-(id)initWithDifficulty:(SudokuDifficulty)difficulty
{
    if (self = [super init]) {
        //初始化self.numbers
        self.numbers = [NSMutableArray array];
        self.redoStack = [[Stack alloc] init];
        self.undoStack = [[Stack alloc] init];
        for (int i = 0; i < 9; i++) {
            NSMutableArray *rowArray  = [NSMutableArray array];
            for (int j = 0; j < 9; j++) {
                SudoNumber *sudoNumber = [[SudoNumber alloc] init];
                SudokuNumber tmpSudoNum = {CGPointMake(i, j),0};
                sudoNumber.sudokuNumber = tmpSudoNum;
                sudoNumber.values = [NSMutableArray array];
                [rowArray addObject:sudoNumber];
                
            }
            [self.numbers addObject:rowArray];
        }
        [self begin];
    }
    
    MyLog(@"备份棋盘：");
    //备份整个棋盘
    for (int i=0; i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            SudoNumber *number = self.numbers[i][j];
            originalSudo[i][j] = number.sudokuNumber;
            printf("%d   ",originalSudo[i][j].number);
        }
        printf("\n\n");
    }

    MyLog(@"difficult---->%d",difficulty);
    NSInteger additionalNumber = arc4random() % 10;
    NSInteger baseNumber;
    if (difficulty == SudokuDifficultyAnimation)
    {
        baseNumber = 10;
    }
    else if (difficulty == SudokuDifficultyEasy)
    {
        baseNumber = 20;
    }
    else if (difficulty == SudokuDifficultyMiddle)
    {
        baseNumber = 30;
    }
    else if (difficulty == SudokuDifficultyHard)
    {
        baseNumber = 40;
    }
    else{
        baseNumber = 50;
    }
    NSInteger displayNumber = baseNumber + additionalNumber; //空白格数目
    
    MyLog(@"空白格的数目为:%d",displayNumber);
    NSMutableSet *numbers = [NSMutableSet set];
    srand((unsigned)time(NULL));
    for (int i = 0; i < displayNumber; ) {
        NSInteger randomNumber = arc4random() % 81;
        //MyLog(@"随机数为:%d",randomNumber);
        if (![numbers containsObject:[NSNumber numberWithInteger:randomNumber]]) {
            [numbers addObject:[NSNumber numberWithInteger:randomNumber]];
            NSInteger x = randomNumber / 9;
            NSInteger y = randomNumber % 9;
            SudoNumber *tmpSudo = self.numbers[x][y];
            SudokuNumber tmpNum = {CGPointMake(x, y), 0};
            tmpSudo.sudokuNumber = tmpNum;
            self.numbers[x][y] = tmpSudo;
            i ++;
        }
        
    }
    MyLog(@"numbers count = %d",numbers.count);
//    printf("生成的残局数独为：\n");
//    for (int i=0; i<9; i++)
//    {
//        for (int j=0; j<9; j++)
//        {
//            SudoNumber *number = self.numbers[i][j];
//            printf("%d   ",number.sudokuNumber.number);
//        }
//        printf("\n\n");
//    }

    
    return self;
}

-(BOOL)isLegalWithSudokuNumber:(SudokuNumber)sudokuNumber
{
    NSInteger x = sudokuNumber.pos.x;
    NSInteger y = sudokuNumber.pos.y;
    
    for (int i = 0; i < 9; i++)
    {
        //按列判断
        if (i != y)
        {
            SudoNumber *sudo = self.numbers[x][i];
            if (sudo.sudokuNumber.number == sudokuNumber.number)
            {
                return NO;
            }
        }
    }
    
    for (int i = 0; i < 9; i++)
    {
        //按行判断
        if (i != x)
        {
            SudoNumber *sudo = self.numbers[i][y];
            if (sudo.sudokuNumber.number == sudokuNumber.number)
            {
                return NO;
            }
        }
    }
    
    //按小9宫格判断
    int nine_x = x / 3 * 3;//0,1,2
    int nine_y = y / 3 * 3;//0,1,2
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (!((nine_x + i == x) && (nine_y + j == y))) {
                SudoNumber *sudo = self.numbers[nine_x + i][nine_y + j];
                if (sudo.sudokuNumber.number == sudokuNumber.number) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

-(void)placeSudokuNumber:(SudokuNumber)sudokuNumber
{
    if ([self isLegalWithSudokuNumber:sudokuNumber]) {
        NSInteger x = sudokuNumber.pos.x;
        NSInteger y = sudokuNumber.pos.y;
        SudoNumber *newSudo = [[SudoNumber alloc] init];
        newSudo.sudokuNumber = sudokuNumber;
        self.numbers[x][y] = newSudo;
    }
}

//生成棋盘方法

//生成每个位置的可填值
- (void)getSudokuNumberValuesWithXValue:(NSInteger)x YValue:(NSInteger)y
{
    SudoNumber *tmpNum = self.numbers[x][y];
    for (int i = 1; i <= 9; i++) {
        SudokuNumber tmpSudo = {CGPointMake(x, y), i};
        if ([self isLegalWithSudokuNumber:tmpSudo]) {
            [tmpNum.values addObject:[NSNumber numberWithInt:i]];
        }
        self.numbers[x][y] = tmpNum;
    }
    MyLog(@"(%d,%d)可填的值有：%@",x,y,tmpNum.values);
}

//根据位置尝试填值
- (void)tryToFillSudokuWithXValue:(NSInteger)x YValue:(NSInteger)y
{
    SudoNumber *tmpNum = self.numbers[x][y];
    if (tmpNum.values.count) {//有值可填
        NSInteger count = tmpNum.values.count;
        srand((unsigned)time(NULL));
        NSInteger index = arc4random() % count;
        SudokuNumber tmpSudo = {CGPointMake(x, y), [tmpNum.values[index] intValue]};
        MyLog(@"(%d,%d)的值为：%d",x,y,[tmpNum.values[index] intValue]);
        [tmpNum.values removeObjectAtIndex:index];
        tmpNum.sudokuNumber = tmpSudo;
        self.numbers[x][y] = tmpNum;
    }
    else{//无可填值
        //修改前一个数
        NSInteger reTryx;
        NSInteger reTryy;
        if (y != 0) {
            reTryx = x;
            reTryy = y - 1;
        }
        else{
            reTryx = x - 1;
            reTryy = 8;
        }
        SudoNumber *reTrySudo = self.numbers[reTryx][reTryy];
        MyLog(@"重填(%d,%d)时可填的值为：%@",reTryx,reTryy,reTrySudo.values);
        [self tryToFillSudokuWithXValue:reTryx YValue:reTryy];
        
        //充填指定位置
        [self getSudokuNumberValuesWithXValue:x YValue:y];
        [self tryToFillSudokuWithXValue:x YValue:y];
    }
}

- (void)createChessboard
{
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            [self getSudokuNumberValuesWithXValue:i YValue:j];
            [self tryToFillSudokuWithXValue:i YValue:j];
        }
    }
    printf("\n\n");
    printf("生成的数独为：\n");
    for (int i=0; i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            SudoNumber *number = self.numbers[i][j];
            printf("%d   ",number.sudokuNumber.number);
        }
        printf("\n\n");
    }

}

-(void)begin
{
    [self createChessboard];
}

#pragma mark - 判断行、列、九宫格是否填满

#pragma mark 行判断
- (BOOL)IsLineFilledAllWithRow:(NSInteger)row
{
    for (int i = 0; i < 9; i++) {
        SudoNumber *tmpSudo = self.numbers[row][i];
        if (!tmpSudo.sudokuNumber.number) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 列判断
- (BOOL)IsColumnFilledAllWithClumn:(NSInteger)column
{
    for (int i = 0; i < 9; i++) {
        SudoNumber *tmpSudo = self.numbers[i][column];
        if (!tmpSudo.sudokuNumber.number) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 九宫格判断
- (BOOL)IsGridFilledAllWithRow:(NSInteger)row Clumn:(NSInteger)column
{
    NSInteger nine_x = row / 3 * 3;
    NSInteger nine_y = column /3 * 3;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            SudoNumber *tmpSudo = self.numbers[nine_x + i][nine_y + j];
            if (!tmpSudo.sudokuNumber.number) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 出、入栈
#pragma mark - 入栈
- (void)pushSudokuNumber:(SudoNumber *)sudoNum
{
    [self.redoStack push:sudoNum];
}

#pragma mark - 出栈
- (void)popSudokuNumber
{
    //出栈前先将出栈位置出的数独的数字清零
    SudoNumber *lastNum = [self.redoStack.items lastObject];
    SudokuNumber tmpSudokuNum = lastNum.sudokuNumber;
    tmpSudokuNum.number = 0; //置零
    NSInteger x = tmpSudokuNum.pos.x;
    NSInteger y = tmpSudokuNum.pos.y;
    SudoNumber *zeroNum = self.numbers[x][y];
    zeroNum.sudokuNumber = tmpSudokuNum;
    self.numbers[x][y] = zeroNum;
    
    //出栈
    [self.undoStack push:lastNum];
    [self.redoStack pop];
    
    printf("悔棋后的数独为：\n");
    for (int i=0; i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            SudoNumber *number = self.numbers[i][j];
            printf("%d   ",number.sudokuNumber.number);
        }
        printf("\n\n");
    }
    
}
@end
