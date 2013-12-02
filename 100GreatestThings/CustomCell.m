
//
//  CustomCell.m
//  CustomCellTutorial
//
//  Created by Nick on 7/26/12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import "CustomCell.h"
#import "TasksTableViewController.h"
#import "MyNavigationControllerViewController.h"
#import "ListButton.h"

@implementation CustomCell

@synthesize things_list;
@synthesize labelListName;
@synthesize buttonView1;
@synthesize viewBack1;
@synthesize roundRectView;
@synthesize imageView1;
@synthesize navigationController;
@synthesize storyboard;
@synthesize friendsCollection;


-(IBAction)buttonTouched:(id)sender
{
    TasksTableViewController *tasksTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TasksTableView"];
    
    //UIImage *image = ((CustomCell*)((ListButton*)sender).parentCell).imageView1.image;
    /*if (image){
        tasksTableViewController.bigImage=image;
    }*/
    
    tasksTableViewController.things_list=self.things_list;
    
    [self.navigationController pushViewController:tasksTableViewController animated:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.roundRectView.layer.cornerRadius = 4.0;
    self.roundRectView.layer.masksToBounds = YES;
    for(UIImageView *imageView in self.friendsCollection)
    {
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.masksToBounds = YES;
    }
}


@end
