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

#import "TTrackViewCntrlr.h"
#import <AudioToolbox/AudioToolbox.h>

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define COOKBOOK_WHITE_COLOR	[UIColor colorWithRed:1.f green:1.f blue:1.0f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]

OSStatus RenderTone(
                    void *inRefCon, 
                    AudioUnitRenderActionFlags 	*ioActionFlags, 
                    const AudioTimeStamp 		*inTimeStamp, 
                    UInt32 						inBusNumber, 
                    UInt32 						inNumberFrames, 
                    AudioBufferList 			*ioData)

{
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
    
	// Get the tone parameters out of the view controller
	LevelMonitor *levelViewController = (LevelMonitor *)inRefCon;
	double theta = levelViewController->theta;
	double theta_increment = 2.0 * M_PI * levelViewController->frequency / levelViewController->sampleRate;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++) 
	{
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	levelViewController->theta = theta;
    
	return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	LevelMonitor *viewController = (LevelMonitor *)inClientData;
	
	[viewController stop];
}

@implementation LevelMonitor

@synthesize touchesLabel, touchMeBtn, timer;
@synthesize pausePlayBtn, noResponseBtn;


-(IBAction)noResponseAction:(id)sender { 
    //[audioPlayer stop];
    [timer invalidate];
}

- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %ld", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = self;
	err = AudioUnitSetProperty(toneUnit, 
                               kAudioUnitProperty_SetRenderCallback, 
                               kAudioUnitScope_Input,
                               0, 
                               &input, 
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %ld", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;	
	streamFormat.mBytesPerFrame = four_bytes_per_float;		
	streamFormat.mChannelsPerFrame = 1;	
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %ld", err);
}

-(IBAction)pausePlayAction:(id)sender { 
    //    [audioPlayer stop];
    
    if (toneUnit)
	{
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
		toneUnit = nil;
        [timer invalidate];
		[pausePlayBtn setTitle:NSLocalizedString(@"  Play", nil) forState:0];
//        CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
//        UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
//        [myImage setImage:[UIImage imageNamed:@"UIBarButtonPlay.png"]];
//        myImage.opaque = YES; // explicitly opaque for performance
        [pausePlayBtn setImage:[UIImage imageNamed:@"UIBarButtonPlay.png"] forState:0];
//        [myImage release];
        
        
	} else {
        [timer fire];
		[self createToneUnit];
		
		// Stop changing parameters on the unit
		OSErr err = AudioUnitInitialize(toneUnit);
		NSAssert1(err == noErr, @"Error initializing unit: %ld", err);
		
		// Start playback
		err = AudioOutputUnitStart(toneUnit);
		NSAssert1(err == noErr, @"Error starting unit: %ld", err);
		
		[pausePlayBtn setTitle:NSLocalizedString(@"  Pause", nil) forState:0];
        [pausePlayBtn setImage:[UIImage imageNamed:@"UIBarButtonPause.png"] forState:0];
	}
    
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
        printf("current frequency: %0.2f\n",frequency/1000.0);
        frequency -= 150;
        //audioPlayer.volume = value;
        touchesLabel.text = [NSString stringWithFormat:@"%0.2f Hz",  frequency/1000.];
        //self.title = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];

    } else { 
        printf("+");
        frequency += 125;
        //audioPlayer.volume = value;
        //touchesLabel.text = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];
        //self.title = [NSString stringWithFormat:@"%0.2f",  audioPlayer.volume];
        touchesLabel.text = [NSString stringWithFormat:@"%0.2f Hz",  frequency/1000.];
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        timer = [[NSTimer scheduledTimerWithTimeInterval:(4.0f)  
//                                                  target:self 
//                                                selector:@selector(targetmethod:) 
//                                                userInfo:nil  
//                                                 repeats:YES] retain]; 
//        
    }
    return self;
}

- (void)dealloc
{
    //[audioPlayer release];;
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

    self.touchesLabel.backgroundColor = COOKBOOK_PURPLE_COLOR;
    self.touchesLabel.textColor = COOKBOOK_WHITE_COLOR;
    self.title = @"Threshold Tracking";
    
    
    // register target-actions for single and repeated touch
	[touchMeBtn addTarget:self action:@selector(touchDown:) 
         forControlEvents:UIControlEventTouchDown];
    [touchMeBtn addTarget:self action:@selector(touchBtnEnded:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    frequency  = 1000;
    sampleRate = 44100;
    self.touchesLabel.text = [NSString stringWithFormat:@"%0.2f Hz",  frequency/1000.0];
    
	OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, self);
	if (result == kAudioSessionNoError)
	{
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	}
	AudioSessionSetActive(true);

    //[timer invalidate];
    timer = [[NSTimer scheduledTimerWithTimeInterval:(4.0f)  
                                              target:self 
                                            selector:@selector(targetmethod:) 
                                            userInfo:nil  
                                             repeats:YES] retain]; 
    [self createToneUnit];
    
    // Stop changing parameters on the unit
    OSErr err = AudioUnitInitialize(toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %ld", err);
    
    // Start playback
    err = AudioOutputUnitStart(toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %ld", err);
    
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // ** this isn't needed yet: self.navigationItem.leftBarButtonItem = BARBUTTON(@"Left", @selector(leftAction:));
    self.touchesLabel = nil;
	self.pausePlayBtn = nil;
	//self.frequencySlider = nil;
    
	AudioSessionSetActive(false);
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
- (void)stop
{
	if (toneUnit)
	{
		[self pausePlayAction:pausePlayBtn];
	}
}

@end
