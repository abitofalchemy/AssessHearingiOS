//
//  LevelMonitor.m
//  NDsandbox1
//
//  Created by Salvador Aguinaga on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  References:
//
//  

#import "LevelMonitor.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define COOKBOOK_WHITE_COLOR	[UIColor colorWithRed:1.f green:1.f blue:1.0f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@implementation LevelMonitor

@synthesize   touchesLabel, touchMeBtn, timer;
@synthesize pausePlayBtn, noResponseBtn;


-(IBAction)pausePlayAction:(id)sender { 
    [audioPlayer stop];
    [timer invalidate];
}

-(IBAction)noResponseAction:(id)sender { 
    [audioPlayer stop];
    [timer invalidate];
}


//- (void) btnHeldDownAction:(id) sender
//{   
//    NSLog(@"btnHeldDownAction");
//    value += 0.1;
//    self.title = [NSString stringWithFormat:@"%0.2f",  value];
//	//self.title = [NSString stringWithFormat:@"%0.2f", [sender value]];
//}
-(void) targetmethod:(id)sender {
    
    if (btnTouchedDownFlag == true){
        //This is for "Touch and Hold"
        printf("-");
        value -= 0.05;
        audioPlayer.volume = value;
        touchesLabel.text = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];

    } else { 
        printf("+");
        value += 0.05;
        audioPlayer.volume = value;
        
        touchesLabel.text = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        timer = [[NSTimer scheduledTimerWithTimeInterval:(4.0f)  
                                                  target:self 
                                                selector:@selector(targetmethod:) 
                                                userInfo:nil  
                                                 repeats:YES] retain]; 
        
    }
    return self;
}

- (void)dealloc
{
    [audioPlayer release];;
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
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LevelMonitor alloc] init]];
//	[self.window addSubview:nav.view];
//    [self.window makeKeyAndVisible];
    self.touchesLabel.backgroundColor = COOKBOOK_PURPLE_COLOR;
    self.touchesLabel.textColor = COOKBOOK_WHITE_COLOR;
	//self.title = @"0.50";
    //btnTouchedDownFlag = NO;

    //
    //g = false;
    [timer fire];
        
    // register target-actions for single and repeated touch
	[touchMeBtn addTarget:self action:@selector(touchDown:) 
         forControlEvents:UIControlEventTouchDown];
    [touchMeBtn addTarget:self action:@selector(touchBtnEnded:) 
         forControlEvents:UIControlEventTouchUpInside];
    
//	[touchMeBtn addTarget:self action:@selector(btnHeldDownAction:) 
//         forControlEvents:UIControlEventValueChanged];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/500msTone750.wav", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error = nil;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    audioPlayer.volume = 0.1;
    touchesLabel.text = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];
    value = audioPlayer.volume;
    
    if (audioPlayer == nil) {
		NSLog(@"Error: %@", error);
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Something failed!" message:@"There was an error doing something." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    } else 
		[audioPlayer play];
    
    [url release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Left", @selector(leftAction:));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Button UIControl Actions
- (void) touchDown:(id)sender
{
    // The behavior is to lower the volume
    btnTouchedDownFlag = YES;
	NSLog(@"Touch Down");
    //touchesLabel.text=@"Lowering Level";

    [touchMeBtn setTitle:@"Down" forState:UIControlEventTouchDown];
        
}

- (void) touchBtnEnded:(id)sender
{
	NSLog(@"Touch Up");
    //touchesLabel.text=@"Touches Ended";
	// give it 0.2 sec for second touch
	//[self performSelector:@selector(singleTapOnButton:) withObject:sender afterDelay:0.2];
    
    [touchMeBtn setTitle:@"Up" forState:UIControlStateNormal];
    btnTouchedDownFlag = NO;
    
}

//-(void) touhesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self processTouch:[touches anyObject]];
//    printf("touches began ...\n");
//}
//-(void)processTouch:(UITouch *)touch
//{
//    value -= 0.05;
//    
//}
//#pragma mark Touch tracking
//
//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
////	CGPoint p = [touch locationInView:self];
////	CGPoint cp = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
////	// self.value = 0.0f; // Uncomment to set each touch to a separate value calculation
////    
////	// First touch must touch the gray part of the wheel
////	if (!pointInsideRadius(p, cp.x, cp)) return NO;
////	if (pointInsideRadius(p, 30.0f, cp)) return NO;
////    
////	// Set the initial angle
////	self.theta = getangle([touch locationInView:self], cp);
//    
//	return YES;
//}
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//	
//	// Update current values
//	value +=0.1;
//	
//    
//	// Send value changed alert
//	//[self sendActionsForControlEvents:UIControlEventValueChanged];
//    //    [ btnHeldDownAction];
//    value += 0.1;
//    self.title = [NSString stringWithFormat:@"%0.2f",  value];
//    
//	return YES;
//}

@end
