//
//  SecondViewController.h
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SecondViewController : UIViewController {
    SystemSoundID soundID_;
}
-(IBAction)pushBack;
- (IBAction)playSoundAction;
@end
