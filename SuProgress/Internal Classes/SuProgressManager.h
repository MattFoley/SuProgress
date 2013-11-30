//  Copyright 2013 Max Howell. All rights reserved.
//  BSD licensed. See the README.
//
//  Heavily rewritten for cleaner code styling and pedantic stuff by Tj Fallon

#import <Foundation/Foundation.h>
#import "SuProgress.h"

@class SuProgressManager;

@protocol SuProgressManagerDelegate <NSObject>

@property (nonatomic, strong) SuProgressManager *manager;

- (void)finished;

@optional
- (void)progressed:(float)progress;

@end

@interface SuProgressManager : NSObject <SuProgressDelegate>

+ (id)currentManager;
+ (void)setCurrentManager:(SuProgressManager *)manager;

+ (id)managerWithDelegate:(id<SuProgressManagerDelegate>)delegate;

- (void)addOgre:(SuProgress *)ogre singleUse:(BOOL)singleUse;

@property (nonatomic, readonly) NSMutableArray *ogres;
@property (nonatomic, weak, readonly) id<SuProgressManagerDelegate> delegate;
@property (nonatomic, readonly) CGFloat progress;

@end