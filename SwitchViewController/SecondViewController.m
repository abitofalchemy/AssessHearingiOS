//
//  SecondViewController.m
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@interface SecondViewController ( Internal )
- (void)loadSoundIfNecessary;
- (void)disposeSound;
@end

@implementation SecondViewController

-(IBAction)pushBack { 
    [self dismissModalViewControllerAnimated:YES];    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playSoundAction {
	[self loadSoundIfNecessary];
	AudioServicesPlaySystemSound(soundID_);
}

#pragma mark Loading / Disposal

- (void)loadSoundIfNecessary {
	if (soundID_ == 0) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"1ktone" ofType:@"mp3"];
		NSURL *url = [NSURL fileURLWithPath:path];
		AudioServicesCreateSystemSoundID ((CFURLRef)url, &soundID_);
	}
}

- (void)disposeSound {
	if (soundID_) {
		AudioServicesDisposeSystemSoundID(soundID_);
		soundID_ = 0;
	}
}


//////////////////////////
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Left", @selector(leftAction:));
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
