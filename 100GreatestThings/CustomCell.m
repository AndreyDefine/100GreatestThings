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
#import "ExpaBarViewController.h"

@implementation CustomCell

@synthesize customCellType;
@synthesize things_list;
@synthesize labelListName;
@synthesize buttonView1;
@synthesize viewBack1;
@synthesize roundRectView;
@synthesize lockView;
@synthesize imageView1;
@synthesize imageLock;
@synthesize labelLock;
@synthesize labelLockLevel;
@synthesize navigationController;
@synthesize storyboard;
@synthesize friendsCollection;


-(void)buttonTouched:(id)sender
{
    TasksTableViewController *tasksTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TasksTableView"];
    
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

-(void)setCustomCellType:(CustomCellType)value
{
    
    ((ListButton*)self.buttonView1).parentCell=self;
    customCellType=value;
    float lockalpha=0.8;
    switch (customCellType) {
        case CustomCellOpened:
            [(ListButton*)self.buttonView1 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=nil;
            labelLockLevel.text=@"";
            labelLock.text=@"";
            break;
        case CustomCellFacebook:
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)80/255.0f green: (float)94/255.0f blue: (float)138/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_facebook.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Login with facebook to unlock this list";
            break;
            
        case CustomCellTwitter:
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)95/255.0f green: (float)169/255.0f blue: (float)221/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_twitter.png"];
            labelLock.text=@"Login with twitter to unlock this list";
            break;
            
        case CustomCellExpa:
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)43/255.0f green: (float)146/255.0f blue: (float)223/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_energy.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Unlock now";
            break;
        
        case CustomCellLevel:
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)90/255.0f green: (float)87/255.0f blue: (float)58/255.0f alpha:lockalpha];
            imageLock.image=nil;
            
            labelLockLevel.text=[NSString stringWithFormat:@"%@ lvl",things_list.level];
            labelLock.text=@"required";
            break;

        default:
            break;
    }
}


@end
