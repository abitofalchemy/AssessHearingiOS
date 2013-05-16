//
//  LevelMonitor.h
//  NDsandbox1
//
//  Created by Salvador Aguinaga on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "S7GraphView.h"

@interface LevelMonitor : UIViewController {
    IBOutlet UIButton *touchMeBtn;   // controls level
    IBOutlet UIButton *noResponseBtn;
    IBOutlet UIButton *pausePlayBtn;
	IBOutlet UILabel *touchesLabel;   
    BOOL btnTouchedDownFlag;
    double value;
    
    NSTimer * timer;
//    NSTimer * timer2;
    
    AVAudioPlayer *audioPlayer;
}
@property (nonatomic, retain) IBOutlet UIButton  *touchMeBtn;
@property (nonatomic, retain) IBOutlet UIButton  *noResponseBtn;
@property (nonatomic, retain) IBOutlet UIButton  *pausePlayBtn;
@property (nonatomic, retain) IBOutlet UILabel   *touchesLabel;
//@property (nonatomic, retain) IBOutlet UINavigationController   *nav; 
//-(IBAction)pushToStart:(id)sender;
-(IBAction)touchDown:(id)sender;
-(IBAction)touchBtnEnded:(id)sender;
-(IBAction)pausePlayAction:(id)sender;
-(IBAction)noResponseAction:(id)sender;
//- (void) btnHeldDownAction: (id) sender;
-(void) targetmethod:(id)sender;
//-(void) levelDownMethod:(id)sender;
//Give the timer properties.
@property (nonatomic, retain) NSTimer *timer;
//-(void)processTouch:(UITouch *)touch;


@end
