//
//  SwitchViewControllerViewController.m
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTSetupViewController.h"
#import "LevelMonitor.h"
//#import "ModalViewController.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@implementation TTSetupViewController

@synthesize m_chartView, upFrequencyBtn, downFrequencyBtn, frequencyLabel;
@synthesize soundFileURLRef;
@synthesize soundFileObject, myModalViewController;


- (id) initWithDepth: (int) theDepth
{
	self = [super init];
	if (self) depth = theDepth;
	return self;
}

-(IBAction)nextFrequencyAction {
    currentFrequency += 500;
    frequencyLabel.text = [NSString stringWithFormat:@"%d",  currentFrequency];
    AudioServicesPlaySystemSound (soundFileObject);
}
-(IBAction)downFrequencyAction {
    currentFrequency -= 500;
    frequencyLabel.text = [NSString stringWithFormat:@"%d",  currentFrequency];
    AudioServicesPlaySystemSound (soundFileObject);
}

-(IBAction)pushButton { 
    LevelMonitor *screen = [[[LevelMonitor alloc] initWithNibName:nil bundle:nil] 
                            autorelease];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:screen animated:YES];
    [self.navigationController pushViewController:screen animated:YES];
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);  // Vibrate to start test
    
}



- (void)dealloc
{
    AudioServicesDisposeSystemSoundID (soundFileObject);
    CFRelease (soundFileURLRef);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    currentFrequency = 1000; 
    self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    self.title = @"Threshold Tracking";
    //self.navigationItem.rightBarButtonItem = BARBUTTON(@"Right", @selector(rightAction:));
	//self.navigationItem.leftBarButtonItem = BARBUTTON(@"Left", @selector(leftAction:));
    // Create the URL for the source audio file. The URLForResource:withExtension: method is
    //    new in iOS 4.0.
    //self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
//	NSString *valueString = [NSString stringWithFormat:@"%d", depth];
//	NSString *nextString = [NSString stringWithFormat:@"Push %d", depth + 1];
//    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
//                                                withExtension: @"aif"];
    // Set the main label
//	((UILabel *)[self.view viewWithTag:101]).text = valueString;
	
//	// Add the "next" bar button item. Max depth is 6
//	if (depth < 6) self.navigationItem.rightBarButtonItem = BARBUTTON(nextString, @selector(push));
    
    // Store the URL as a CFURLRef instance
 ///   self.soundFileURLRef = (CFURLRef) [tapSound retain];
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (soundFileURLRef,
                                      &soundFileObject);
    
//    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Instructions" 
//                                                  message:@"1. Select best ear\n"
//                                                           "2. Select stimulus\n"
//                                                           "3. Set initial level\n"
//                                                           "4. Starting frequency\n"
//                                                           "5. Start Test"
//                                                delegate:nil 
//                                        cancelButtonTitle:@"Dismiss"
//                                        otherButtonTitles: nil] autorelease];
//    [av show];
    
    // Create a final modal view controller
	UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:self action:@selector(modalViewAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalBarButtonItem;
	[modalBarButtonItem release];
}


- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)modalViewAction:(id)sender
{
    if (self.myModalViewController == nil)
        self.myModalViewController = [[[ModalViewController alloc] initWithNibName:
                                       NSStringFromClass([ModalViewController class]) bundle:nil] autorelease];
    
	[self.navigationController presentViewController:self.myModalViewController animated:YES completion:nil];
    // what should I have in this completion part?
    // presentModalViewController:self.myModalViewController animated:YES];
}

@end
