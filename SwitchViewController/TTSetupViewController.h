//
//  SwitchViewControllerViewController.h
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "ModalViewController.h"

@class AudiogramChart;

@interface TTSetupViewController : UIViewController {
    int depth;
    IBOutlet AudiogramChart *m_chartView;
    IBOutlet UIButton *upFrequencyBtn;
    IBOutlet UIButton *downFrequencyBtn;
    
    IBOutlet UILabel  *frequencyLabel;
    int currentFrequency;
    
    // system sounds
    CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
    
    ModalViewController *myModalViewController;
}
- (IBAction)pushButton; // Starts the test
- (IBAction)nextFrequencyAction;
- (IBAction)downFrequencyAction;

@property (retain, nonatomic) AudiogramChart *m_chartView;
@property (nonatomic, retain) IBOutlet UIButton  *upFrequencyBtn;
@property (nonatomic, retain) IBOutlet UIButton  *downFrequencyBtn;
@property (nonatomic, retain) IBOutlet UILabel  *frequencyLabel;

@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@property (retain, nonatomic) ModalViewController *myModalViewController;

@end
