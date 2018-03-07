//
//  SudoNumber.h
//  test
//
//  Created by dengyulai on 14-10-13.
//  Copyright (c) 2014年 Dylai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _SudokuNumber {
    CGPoint pos;       // (row, colum)  9 X 9
    NSInteger number;  // 当前给定位置放置的数字
}SudokuNumber;

@interface SudoNumber : NSObject

@property (nonatomic, strong)NSMutableArray *values;//保存可以取的值
@property (nonatomic, assign)SudokuNumber sudokuNumber;

@end
