//
//  Animations.h
//  Sudoku
//
//  Created by dengyulai on 14-10-17.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Sudoku.h"

@protocol  AnimationsDelegate<NSObject>

@optional
- (void)judgeIsTrueOrNotWithShouldReverse:(BOOL)reverse;
- (void)mismatch;

@end
@interface Animations : NSObject

@property (nonatomic,assign)id<AnimationsDelegate>delegate;
@property (nonatomic, assign)BOOL autoreverses;
@property (nonatomic, assign)BOOL IsStop;
@property (nonatomic, assign)BOOL shouldReverse;

+ (Animations *)sharedAnimation;

#pragma mark 飞行动画

- (void) addRoutingAnimationWithItem:(UIView *)view toPosition:(CGPoint)toPoint IndexX:(NSInteger)x IndexY:(NSInteger)y Sudoku:(Sudoku *)sudoku;

#pragma mark 弹跳动画

- (void) addBounceAnimatioWithItem:(UIView *)view;

- (void) addBounceAnimatioWithItem:(UIView *)view duration:(CGFloat)duration height:(CGFloat)height;


#pragma mark 旋转动画

- (void) addRotateAnimatioWithItem:(UIView *)view;


#pragma mark 自定义过渡动画

- (void) transitionAnimationWithType:(NSString *)type subType:(NSString *)subtype onLayer:(CALayer *)layer;


#pragma mark - 两个view层之间的切换动画

- (void) pushAnimationBetweenView1:(UIView *)view1 view2:(UIView *)view2 isInView2:(BOOL)inView2;

#pragma mark - 粒子效果

- (void) emitterLayer:(CAEmitterLayer *)emitter animationWithEmitterShape:(NSString *)shape
                                                              EmitterMode:(NSString *)emitterMode
                                                             EmitterCells:(NSArray *)emitterCells;

@end
