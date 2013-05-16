//
//  myGraphView.m
//  QuartzSandbox0
//
//  Created by Salvador Aguinaga on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// http://www.youtube.com/watch?v=AyvtOSztQXg
// http://www.youtube.com/watch?v=EY5GVu1akaU&feature=related

#import "AudiogramChart.h"


@implementation AudiogramChart
//@synthesize infoColor = _infoColor, info=_info;

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
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 0.9, 0.9);
    CGContextSetLineWidth(ctx, 2.0);
    
    // Draw a connected sequence of line segments
	CGPoint addLines[] =
	{
        CGPointMake(10.0, 135.0),
		CGPointMake(10.0, 140.0),
		CGPointMake(150., 140.0),
        CGPointMake(150.0, 10.0),
        CGPointMake(150.0, 140.0),
		CGPointMake(290.0, 140.0),
        CGPointMake(290.0, 135.0),

	};
	// Bulk call to add lines to the current path.
	// Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
	CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
	CGContextStrokePath(ctx);

	// Draw Audiogram
    CGContextSetLineWidth(ctx, 0.7);\

    // Draw a series of line segments. Each pair of points is a segment
	CGPoint strokeSegments[] =
	{
		CGPointMake(20.0, 20.0),
		CGPointMake(20.0, 140.0),
		CGPointMake(40.0, 20.0),
		CGPointMake(40.0, 140.0),
		CGPointMake(60.0, 20.0),
		CGPointMake(60.0, 140.0),
        CGPointMake(80.0, 20.0),
		CGPointMake(80.0, 140.0),
        CGPointMake(100.0, 20.0),
		CGPointMake(100.0, 140.0),
        CGPointMake(120.0, 20.0),
		CGPointMake(120.0, 140.0),
        CGPointMake(140.0, 20.0),
		CGPointMake(140.0, 140.0),
        CGPointMake(160.0, 20.0),
		CGPointMake(160.0, 140.0),
        CGPointMake(180.0, 20.0),
		CGPointMake(180.0, 140.0),
        CGPointMake(200.0, 20.0),
		CGPointMake(200.0, 140.0),
        CGPointMake(220.0, 20.0),
		CGPointMake(220.0, 140.0),
        CGPointMake(240.0, 20.0),
		CGPointMake(240.0, 140.0),
        CGPointMake(260.0, 20.0),
		CGPointMake(260.0, 140.0),
        CGPointMake(280.0, 20.0),
		CGPointMake(280.0, 140.0),
	};
	// Bulk call to stroke a sequence of line segments.
	// Equivalent to for(i=0; i<count; i+=2) { MoveToPoint(point[i]); AddLineToPoint(point[i+1]); StrokePath(); }
	CGContextStrokeLineSegments(ctx, strokeSegments, 
                                sizeof(strokeSegments)/sizeof(strokeSegments[0]));

//    CGAffineTransform myTextTransform; // 2
    CGContextSelectFont (ctx, "Helvetica", 14, kCGEncodingMacRoman);
    //CGContextSetCharacterSpacing (ctx, 10); // 4
    CGContextSetTextDrawingMode (ctx, kCGTextFillStroke); // 5
    
    CGContextSetRGBFillColor (ctx, 1., 1., 1., 1.); // 6 white
    CGContextSetRGBStrokeColor (ctx, 1, 1, 1, 1);   // 7 white
    //myTextTransform =  CGAffineTransformMakeRotation(0.0); // 8
    //CGContextSetTextMatrix (ctx, myTextTransform); // 9
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0));
    CGContextShowTextAtPoint (ctx, 5., 10.0, "Audiogram", 9); // 10
    CGContextShowTextAtPoint (ctx, 140.0, 155.0, "1.0", 3); 
    CGContextShowTextAtPoint (ctx, 280.0, 155.0, "kHz", 3); 
    
}


- (void)dealloc
{
    [super dealloc];

}

@end
