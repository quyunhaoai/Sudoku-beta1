//
//  Stack.m
//  Sudoku
//
//  Created by whunf on 14-10-8.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import "Stack.h"

@interface Stack()



@end

@implementation Stack

- (id)init
{
    if (self = [super init]) {
        self.items =[NSMutableArray array];
    }
    return self;
}

-(BOOL)isEmpty
{
    if (self.items.count) {
        return NO;
    }
    return YES;
}

- (void)push:(id)item
{
    [self.items addObject:item];
}

- (id)pop
{
    [self.items removeLastObject];
    return self.items;
}

- (NSInteger)size
{
    return self.items.count;
}
@end
