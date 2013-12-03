//
//  CustomProgressBar.m
//  100GreatestThings
//
//  Created by baskakov on 02/12/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "CustomProgressBar.h"

@interface CustomProgressBar ()

-(id)init;
-(id)initWithFrame:(CGRect)frame;
-(void)setExpiriencePosition:(int)range;

@end

@implementation CustomProgressBar

+(CustomProgressBar*)addProgressBarInFrame:(CGRect)frame onView:(id)inview withRange:(int)range image1:(NSString*)imagename1 imagebackground:(NSString*)imagenamebackground fullRange:(int)infullRange
{
    CustomProgressBar* newCustomProgressBar=[[CustomProgressBar alloc]initWithFrame:frame];

    if(newCustomProgressBar)
    {
        newCustomProgressBar.fullRange=infullRange;
        float widthOfJaggedBit = 4.f;
        float topOfJaggedBit = 0.f;
        UIImage * imageA= [[UIImage imageNamed:imagename1] stretchableImageWithLeftCapWidth:widthOfJaggedBit topCapHeight:topOfJaggedBit];
        UIImage * imageB= [[UIImage imageNamed:imagenamebackground] stretchableImageWithLeftCapWidth:widthOfJaggedBit topCapHeight:topOfJaggedBit];
        newCustomProgressBar->imageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        newCustomProgressBar->imageViewB = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        newCustomProgressBar->imageViewA.image = imageA;
        newCustomProgressBar->imageViewB.image = imageB;
        //label
        newCustomProgressBar->expirience=[[UILabel alloc]initWithFrame:CGRectMake(0,0,0,frame.size.height)];
        newCustomProgressBar->expirience.numberOfLines = 1;
        newCustomProgressBar->expirience.textColor = [UIColor whiteColor];
        [newCustomProgressBar->expirience setFont:[UIFont boldSystemFontOfSize:12]];
        [newCustomProgressBar setExpiriencePosition:range];
        
        [newCustomProgressBar addSubview:newCustomProgressBar->imageViewA];
        [newCustomProgressBar addSubview:newCustomProgressBar->imageViewB];
        [newCustomProgressBar addSubview:newCustomProgressBar->expirience];
        [inview addSubview:newCustomProgressBar];
    }
    return newCustomProgressBar;
}

-(void)setExpiriencePosition:(int)range;
{
    if(range>self.fullRange){
        range=self.fullRange;
    }
    float progress=(float)range/self.fullRange;
    
    expirience.text=[NSString stringWithFormat:@"%d/%d",range,self.fullRange ];
    
    [expirience sizeToFit];
    
    int label_left=self.frame.size.width*progress-expirience.frame.size.width;
    label_left=label_left<0?0:label_left;
    
    int label_right=expirience.frame.size.width;
    label_left=label_right>self.frame.size.width?self.frame.size.width-expirience.frame.size.width:label_left;
    
    expirience.frame=CGRectMake(label_left, 0.0f,expirience.frame.size.width,expirience.frame.size.height);
    
    imageViewA.frame=CGRectMake(0.0f, 0.0f, self.frame.size.width*progress, self.frame.size.height);
}

-(id)init
{
    self=[super init];
    if(self)
    {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}


-(void)setProgress:(int)range
{
    [self setExpiriencePosition:range];
}


@end
