//  Copyright 2013 Max Howell. All rights reserved.
//  BSD licensed. See the README.
//
//  Heavily rewritten for cleaner code styling and pedantic stuff by Tj Fallon

#import <UIKit/UIKit.h>

/**
 *  This is enum handles the state of the SuProgressBars currently in play
 */
typedef NS_ENUM(NSUInteger, SuProgressBarViewAnimationStyle) {
    /**
     *  Determinate iOS 7 navigation bar style.
     */
    SuProgressAnimationDeterminateNavigation,
    /**
     *  Indeterminate atom style animation.
     */
    SuProgressAnimationAtom,

};


@class AFHTTPRequestOperation;
@class SuProgressBarView;

//Nifty, forward protocol declarations are valid.
@protocol SuProgressManagerDelegate;

/**
 *  This is your main interface for accessing SuProgress awesome capabilities.
 */
@interface UIViewController (SuProgress)

/**
 *  Welcome to our magic function. Any NSURLConnections
 *  created in this block will have all delegate messages
 *  proxied via the SuProgressBar so that
 *  progress is automatically provided. Wonderful.
 *
 *  @Note This is not a threadsafe block, dispatching multiple threads from inside this block can cause issues.
 *
 *  @param void creationBlock Create all of your NSURLConnections in this block
 *
 */
- (void)progressWithStyle:(SuProgressBarViewAnimationStyle)style
           forConnections:(void(^)(void))creationBlock;

/**
 *  Call this method **after** you have set the UIWebVIews delegate.
 *  It will then proxy delegate events as needed.
 *
 *  @Note This could be wrapped into the swizzling, but is still a To-Do. Feel free to fork and implement.
 *
 *  @param webView The webview to proxy connection events and show progress for.
 */
- (void)proxyProgressForWebView:(UIWebView *)webView;

/**
 *  Use this method to track progress for AFHTTPRequestOperations.
 *
 *  @param operation The operation who's progress should be tracked.
 */
- (void)proxyProgressForAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

/**
 *  Fetch and/or initialize a SuProgressBar view object for your UIViewController.
 *
 *  @return Progress bar contained in your View Controller's view.
 */
- (id<SuProgressManagerDelegate>)progressViewWithStyle:(SuProgressBarViewAnimationStyle)style;

@end
