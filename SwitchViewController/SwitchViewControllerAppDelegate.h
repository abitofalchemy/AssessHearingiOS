//
//  SwitchViewControllerAppDelegate.h
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSetupViewController;

@interface SwitchViewControllerAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *nav;
    int depth;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TTSetupViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *nav;

- (id) initWithDepth: (int) theDepth;
@end
