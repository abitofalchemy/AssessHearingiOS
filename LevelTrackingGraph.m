//
//  LevelTrackingGraph.m
//  SwitchViewController
//
//  Created by Salvador Aguinaga on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelTrackingGraph.h"


@implementation LevelTrackingGraph

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 1.0, 0.5);
    CGContextSetLineWidth(ctx, 2.0);
    // Draw abscissa and Ordinate
	// Origin is top left
    CGPoint addCartCoord[] =
	{
        CGPointMake(30.0, 20.0),
        CGPointMake(35.0, 20.0),
        CGPointMake(35.0, 120.0),
        CGPointMake(30.0, 120.0),
        CGPointMake(35.0+240.0, 120.0),
	};
    
    
    
    // Bulk call to add lines to the current path.
	// Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
	CGContextAddLines(ctx, addCartCoord, sizeof(addCartCoord)/sizeof(addCartCoord[0]));
    CGContextStrokePath(ctx);
    CGPoint addFreqGridLines[] =
	{
        CGPointMake(35.0+40.0, 20.0),
        CGPointMake(35.0+40.0, 120.0),
        CGPointMake(35.0+80.0, 120.0),
        CGPointMake(35.0+80.0, 20.0),
        CGPointMake(35.0+80.0, 120.0),
        CGPointMake(35.0+120.0, 120.0),
        CGPointMake(35.0+120.0, 20.0),
        CGPointMake(35.0+120.0, 120.0),
        CGPointMake(35.0+160.0, 120.0),
        CGPointMake(35.0+160.0, 20.0),
        CGPointMake(35.0+160.0, 120.0),
        CGPointMake(35.0+200.0, 120.0),
        CGPointMake(35.0+200.0, 20.0),
        CGPointMake(35.0+200.0, 120.0),
        CGPointMake(35.0+240.0, 120.0),
        CGPointMake(35.0+240.0, 20.0),
        //        CGPointMake(35.0+240.0, 150.0),
	};
    // Bulk call to add lines to the current path.
	// Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
	CGContextAddLines(ctx, addFreqGridLines, sizeof(addFreqGridLines)/sizeof(addFreqGridLines[0]));
    CGContextStrokePath(ctx);
    
    CGContextSelectFont (ctx, "Helvetica", 14, kCGEncodingMacRoman);
    //CGContextSetCharacterSpacing (ctx, 10); // 4
    //CGContextSetTextDrawingMode (ctx, kCGTextFillStroke); // 5
    
    CGContextSetRGBFillColor (ctx, 1., 1., 1., 1.); // 6 white
    CGContextSetRGBStrokeColor (ctx, 1., 1., 1., 1.);   // 7 white
    //myTextTransform =  CGAffineTransformMakeRotation(0.0); // 8
    //CGContextSetTextMatrix (ctx, myTextTransform); // 9
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    //CGContextShowTextAtPoint (ctx, 5., 10.0, "Audiogram", 9); // 10
    CGContextShowTextAtPoint (ctx, 05.0,      15.0, "Current Frequency:", 18);
    CGContextShowTextAtPoint (ctx, 05.0,      55.0, " dB", 3);
    CGContextShowTextAtPoint (ctx, 05.0,      75.0, "SPL", 3);

    

 
}


- (void)dealloc
{
    [super dealloc];
}

@end
