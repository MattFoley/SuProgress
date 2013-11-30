//
//  SuProgressAtomView.h
//  Example
//
//  Created by teejay on 11/29/13.
//  Copyright (c) 2013 Max Howell. All rights reserved.
//

#import "SuProgressManager.h"

@interface SuProgressAtomView : UIView <SuProgressManagerDelegate>

@property NSInteger particlesOrbitingCount;

/**
 * Atom orbit border line color.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic) UIColor *atomOrbitColor;

/**
 * Colors for particles orbiting the atom.
 * Defaults to clear [UIColor clearColor];
 */
@property (nonatomic) NSArray *atomParticleColors;

/**
 * Color of the atom Nucleus.
 * Defaults to white [UIColor whiteColor].
 */
@property (nonatomic) UIColor *atomNucleusColor;

@end
