//
//  SuProgressAtomView.m
//  Example
//
//  Created by teejay on 11/29/13.
//  Copyright (c) 2013 Max Howell. All rights reserved.
//

#import "SuProgressAtomView.h"
#import "CAAnimation+Blocks.h"

@interface SuProgressAtomView ()

@property NSMutableArray *orbitTraceLayers;
@property NSMutableArray *orbitParticles;
@property CAShapeLayer *atomNucleus;

@property BOOL isProgressing;

@end

@implementation SuProgressAtomView

//Oddly enough, protocol declared properties must still be synthesized
@synthesize manager = _manager;


CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:8.0f];
        [self.layer setMasksToBounds:YES];
        [self.layer setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:.8].CGColor];
        
        _orbitParticles = [NSMutableArray new];
        _orbitTraceLayers = [NSMutableArray new];
        _particlesOrbitingCount = 4;
        
        _atomOrbitColor = [UIColor whiteColor];
        _atomNucleusColor =  [UIColor redColor];
        _atomParticleColors = @[[UIColor blueColor]];
        
        _manager = [SuProgressManager managerWithDelegate:self];
        self.alpha = 0.0f;
    }
    return self;
}

- (void)createOrbits
{
    for (int i = 1; i < self.particlesOrbitingCount; i ++) {
     
        //Create Orbit Traces
        CAShapeLayer *orbitTrace = [[CAShapeLayer alloc] init];
        [orbitTrace setFrame:(CGRect){0, 0, self.frame.size}];
        
        CGFloat radius = self.frame.size.width/2 - self.frame.size.width/10;
        
        orbitTrace.path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){self.frame.size.width/10,
                                                                            self.frame.size.height/10, 2.0*radius, 2.0*radius}
                                                 cornerRadius:radius].CGPath;
        
        [orbitTrace setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        
        [orbitTrace setStrokeEnd:0];
        [orbitTrace setAnchorPoint:CGPointMake(.5, .5)];
        CGFloat rotationInDegrees = (360.0f/self.particlesOrbitingCount)*i;
        NSLog(@"Transform degrees y %f", rotationInDegrees);
        if (rotationInDegrees > 84 && rotationInDegrees < 96) {
            if (rotationInDegrees < 90) {
                rotationInDegrees = 82;
            } else {
                rotationInDegrees = 98;
            }
        }
        
        [orbitTrace setTransform:CATransform3DRotate(orbitTrace.transform, DegreesToRadians(rotationInDegrees), 1.0f, 1.0f, 1.0f)];
        [orbitTrace setStrokeColor:self.atomOrbitColor.CGColor];
        [orbitTrace setLineWidth:2.0f];
        [orbitTrace setFillColor:[UIColor clearColor].CGColor];
        [orbitTrace setShadowColor:[UIColor lightGrayColor].CGColor];
        [orbitTrace setShadowOpacity:.6];
        [orbitTrace setShadowOffset:CGSizeMake(1, 1)];
        //[orbitTrace setMagnificationFilter:kCAFilterNearest];
        [self.orbitTraceLayers addObject:orbitTrace];
        [self.layer addSublayer:orbitTrace];
        
        //Create Particles
        
        CAShapeLayer *particle  = [[CAShapeLayer alloc] init];
        particle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 6, 6) cornerRadius:3].CGPath;
        [orbitTrace addSublayer:particle];
        [particle setFillColor:[UIColor blueColor].CGColor];
        [particle setOpacity:0];
        particle.transform = CATransform3DInvert(orbitTrace.transform);
        [self.orbitParticles addObject:particle];
    }
}

- (void)progressed:(float)progress
{
    if (!self.isProgressing) {
        NSLog(@"begin progress");
        [self createOrbits];
        [self beginProgressAnimation];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)finished
{
    NSLog(@"end progress");
    [self endOrbiting];
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeFromSuperview];
    }];
}

- (void)beginProgressAnimation
{
    self.isProgressing = YES;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.orbitTraceLayers enumerateObjectsUsingBlock:^(CAShapeLayer *shapeLayer, NSUInteger idx, BOOL *stop) {
            [shapeLayer setStrokeEnd:1.0f];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.3f;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            
            //Using '==' because we really want the last object.
            if (shapeLayer == self.orbitTraceLayers.lastObject) {
                [pathAnimation setCompletion:^(BOOL finished) {
                    [self beginOrbits];
                }];
            }
            
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            
        }];
    }];
    
    [self.orbitParticles enumerateObjectsUsingBlock:^(CAShapeLayer *particle, NSUInteger idx, BOOL *stop) {
        [particle setOpacity:1.0f];
        
        CABasicAnimation *showParticle = [CABasicAnimation animationWithKeyPath:@"opacity"];
        showParticle.fromValue = @(0.0);
        showParticle.toValue = @(1.0);
        showParticle.duration = 1.0;        // 1 second
        showParticle.autoreverses = YES;    // Back
        showParticle.repeatCount = 3;       // Or whatever
        
        [particle addAnimation:showParticle forKey:@"flashAnimation"];
    }];
}

- (void)beginOrbits
{
    [self.orbitParticles enumerateObjectsUsingBlock:^(CAShapeLayer *particle, NSUInteger idx, BOOL *stop) {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.duration = 1.0f;
        pathAnimation.path = [(CAShapeLayer *)particle.superlayer path];
        pathAnimation.calculationMode = kCAAnimationLinear;
        pathAnimation.repeatCount = NSIntegerMax;
        [particle addAnimation:pathAnimation forKey:@"movingAnimation"];
    }];
}

- (void)endOrbiting
{
    self.isProgressing = NO;
}

- (void)dealloc
{
    NSLog(@"Memory management win %@", self);
}

@end
