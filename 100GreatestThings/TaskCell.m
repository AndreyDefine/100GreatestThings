//
//  TaskCell.m
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "TaskCell.h"
#import "Things_task.h"
#import "DatabaseFromUrl.h"

@implementation TaskCell
@synthesize rowNumber;
@synthesize doneButton;
@synthesize imageView1;
@synthesize titleView1;
@synthesize friendsCollection;
@synthesize tableViewController;
@synthesize things_task;


- (Things_task*)things_task {
    return things_task;
}

- (void)setThings_task: (Things_task*)newValue {
    things_task=newValue;
    self.titleView1.text=things_task.title;
    self.doneButton.selected=[things_task.complete boolValue];    
    //image
    [[DatabaseFromUrl getSharedInstance] LoadImage:things_task.image_url todisk:things_task.disk_image_url toimageview:self.imageView1];
    self.imageView1.layer.cornerRadius = 4.0;
    self.imageView1.layer.masksToBounds = YES;
    for(UIImageView *imageView in self.friendsCollection)
    {
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.masksToBounds = YES;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(IBAction)makeTask:(id)sender
{
    self.doneButton.selected=!self.doneButton.selected;
    self.things_task.complete=[NSNumber numberWithBool:self.doneButton.selected];
    [self updateTable];
}

-(void)updateTable
{
    [self.tableViewController performSelector:@selector(reloadData)];
}

@end
