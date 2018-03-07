//
//  Animations.m
//  Sudoku
//
//  Created by dengyulai on 14-10-17.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import "Animations.h"

static Animations *animationInstance;

@implementation Animations


#pragma mark - 单例创建
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationInstance = [super allocWithZone:zone];
    });
    return animationInstance;
}

+ (Animations *)sharedAnimation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationInstance = [[self alloc] init];
    });
    return animationInstance;
}

#pragma mark -飞行动画

-(void)addRoutingAnimationWithItem:(UIButton *)button toPosition:(CGPoint)toPoint IndexX:(NSInteger)x IndexY:(NSInteger)y Sudoku:(Sudoku *)sudoku
{
    self.IsStop = NO;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"position"];
    ani.toValue = [NSValue valueWithCGPoint:toPoint];
    ani.duration = 1.0f;
    //ani.autoreverses = YES;
    ani.delegate = self;
    ani.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = button.layer.transform;
    
    transform.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D scaleValue = CATransform3DScale(fromValue, 0.7, 0.7, 1);
    CATransform3D rotateValue = CATransform3DRotate(fromValue, M_PI, 0, 0, 1);
    CATransform3D toValue = CATransform3DConcat(scaleValue, rotateValue);
    
    transform.toValue = [NSValue valueWithCATransform3D:toValue];
    transform.repeatCount = 2;
    transform.duration = 0.5f;
    transform.fillMode = kCAFillModeForwards;
    transform.cumulative = YES;
    
    CABasicAnimation *reachedAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D scale1 = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1);
    CATransform3D rotate1 = CATransform3DRotate(CATransform3DIdentity, M_PI_4, 0, 0, 1);
    CATransform3D reachedToValue = CATransform3DConcat(scale1, rotate1);
    reachedAni.toValue = [NSValue valueWithCATransform3D:reachedToValue];
    reachedAni.duration = 0.5f;
    //        reachedAni.autoreverses = YES;
    reachedAni.fillMode = kCAFillModeForwards;
    reachedAni.beginTime = 1.0f;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ani,transform,reachedAni];
    group.duration = 1.5f;
    group.delegate = self;
    if (sudoku->originalSudo[x][y].number != button.tag)
    {//不正确，不做任何修改
        [self performSelector:@selector(playMismatch) withObject:nil afterDelay:1.0f];
        self.shouldReverse = YES;
        group.autoreverses = YES;
        self.autoreverses = YES;
    }
    else
    {
        self.shouldReverse = NO;
        group.autoreverses = NO;
        self.autoreverses = NO;
    }

    [button.layer addAnimation:group forKey:nil];
}


- (void)playMismatch{
    [self.delegate mismatch];
}

#pragma mark 旋转动画

-(void)addRotateAnimatioWithItem:(UIView *)view
{
    CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D rotateValue = CATransform3DRotate(CATransform3DIdentity, -M_PI, 0, 0, 1);
    CATransform3D scaleValue = CATransform3DScale(CATransform3DIdentity, 1.3, 1.3, 1);
    CATransform3D toValue = CATransform3DConcat(rotateValue, scaleValue);
    transform.toValue = [NSValue valueWithCATransform3D:toValue];
    transform.repeatCount = 1;
    transform.duration = 0.5;
    [view.layer addAnimation:transform forKey:nil];
}

#pragma mark 弹跳动画

-(void)addBounceAnimatioWithItem:(UIView *)view
{
    CAKeyframeAnimation *bounceAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef bouncePath = CGPathCreateMutable();
    NSInteger x = view.center.x;
    NSInteger y = view.center.y;
    CGPathMoveToPoint(bouncePath, nil, x, y);
    CGPathAddLineToPoint(bouncePath, nil, x, y - 20);
    CGPathAddLineToPoint(bouncePath, nil, x, y );
    CGPathAddLineToPoint(bouncePath, nil, x, y - 10);
    CGPathAddLineToPoint(bouncePath, nil, x, y );
    CGPathAddLineToPoint(bouncePath, nil, x, y - 8);
    CGPathAddLineToPoint(bouncePath, nil, x, y );
    CGPathAddLineToPoint(bouncePath, nil, x, y - 5);
    CGPathAddLineToPoint(bouncePath, nil, x, y );
    bounceAni.path = bouncePath;
    bounceAni.duration = 0.3;
    [view.layer addAnimation:bounceAni forKey:nil];
    
}

- (void)addBounceAnimatioWithItem:(UIView *)view duration:(CGFloat)duration height:(CGFloat)height
{
    CAKeyframeAnimation *bounceAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef bouncePath = CGPathCreateMutable();
    NSInteger x = view.center.x;
    NSInteger y = view.center.y;
    CGPathMoveToPoint(bouncePath, nil, x, y);
    CGPathAddLineToPoint(bouncePath, nil, x, y - height);
    CGPathAddLineToPoint(bouncePath, nil, x, y);
    CGPathAddLineToPoint(bouncePath, nil, x, y - height * 0.5);
    CGPathAddLineToPoint(bouncePath, nil, x, y);
    CGPathAddLineToPoint(bouncePath, nil, x, y - height * 0.25);
    CGPathAddLineToPoint(bouncePath, nil, x, y);
    bounceAni.path = bouncePath;
    bounceAni.duration = duration;
    bounceAni.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    [view.layer addAnimation:bounceAni forKey:nil];
}


#pragma mark 自定义过渡动画

-(void)transitionAnimationWithType:(NSString *)type subType:(NSString *)subtype onLayer:(CALayer *)layer
{
    CATransition *transition = [[CATransition alloc] init];
    transition.type = type;
    transition.subtype = subtype;
    transition.duration = 1;
    [layer addAnimation:transition forKey:@"transition"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self.delegate judgeIsTrueOrNotWithShouldReverse:self.shouldReverse];
    }
}

#pragma mark - 两个view层之间的切换动画

- (void)pushAnimationBetweenView1:(UIView *)view1 view2:(UIView *)view2 isInView2:(BOOL)inView2
{
    if (inView2 == NO) {
        CGRect frame = view1.frame;
        frame.origin.x += frame.size.width;
        CGRect frame1 = view2.frame;
        frame1.origin.x -= frame1.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            view1.frame = frame;
            view1.frame = frame1;
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }else
    {
        CGRect frame = view1.frame;
        frame.origin.x -= frame.size.width;
        CGRect frame1 = view2.frame;
        frame1.origin.x += frame1.size.width;
        [UIView animateWithDuration:0.2f animations:^{
            view1.frame = frame;
            view1.frame = frame1;
        } completion:^(BOOL finished) {
            if (finished) {
               
            }
        }];
    }
}

#pragma mark - 粒子效果
-(void)emitterLayer:(CAEmitterLayer *)emitter     animationWithEmitterShape:(NSString *)shape
                                                    EmitterMode:(NSString *)emitterMode
                                                   EmitterCells:(NSArray *)emitterCells
{
    emitter.emitterShape = shape;
    emitter.emitterMode = emitterMode;
    emitter.emitterCells = emitterCells;
}

@end
