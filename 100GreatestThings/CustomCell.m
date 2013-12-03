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
#import "CustomProgressBar.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CommonUserDefaults.h"

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
@synthesize labelEnergy;
@synthesize labelNrg;
@synthesize navigationController;
@synthesize storyboard;
@synthesize friendsCollection;


-(void)buttonTouched:(id)sender
{
    TasksTableViewController *tasksTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TasksTableView"];
    
    tasksTableViewController.things_list=self.things_list;
    
    [self.navigationController pushViewController:tasksTableViewController animated:YES];
}

-(void)buttonTouchFacebook:(id)sender
{
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self buttonTouchFacebook:sender];
                                          }
                                      }];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                         message:@"You've logged in!"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alert show];
}

-(void)buttonTouchTwitter:(id)sender
{
}

-(void)buttonTouchLevel:(id)sender
{
}

-(void)buttonTouchExpa:(id)sender
{
    int cost=40;
    UIAlertView* alert;
    if(cost>=[CommonUserDefaults getSharedInstance].energyrange)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Attention!" message:[NSString stringWithFormat:@"You don't have enough energy: %d!!!",cost] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Attention!" message:[NSString stringWithFormat:@"Open for %d energy?",cost] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    }
    [alert show];
}

//нажатие на вью
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    int cost=40;
    if(buttonIndex==0)
    {
        [[ExpaBarViewController getSharedInstance] addexpa:-cost];
        self.customCellType=CustomCellOpened;
        things_list.opened=[[NSNumber alloc]initWithBool:YES];
    }
    
    if(buttonIndex==1)
    {
        //do nothing
    }
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
    int cost=40;
    ((ListButton*)self.buttonView1).parentCell=self;
    customCellType=value;
    float lockalpha=0.8;
    [self.buttonView1 removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    switch (customCellType) {
        case CustomCellOpened:
            [self.buttonView1 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=nil;
            labelLockLevel.text=@"";
            labelLock.text=@"";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
        case CustomCellFacebook:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchFacebook:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)80/255.0f green: (float)94/255.0f blue: (float)138/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_facebook.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Login with facebook to unlock this list";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
            
        case CustomCellTwitter:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchTwitter:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)95/255.0f green: (float)169/255.0f blue: (float)221/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_twitter.png"];
            labelLock.text=@"Login with twitter to unlock this list";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
            
        case CustomCellExpa:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchExpa:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)43/255.0f green: (float)146/255.0f blue: (float)223/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_energy.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Unlock now";
            labelEnergy.text=[NSString stringWithFormat:@"%d",cost];
            labelNrg.text=@"NRG";
            break;
        
        case CustomCellLevel:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchLevel:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)90/255.0f green: (float)87/255.0f blue: (float)58/255.0f alpha:lockalpha];
            imageLock.image=nil;
            
            labelLockLevel.text=[NSString stringWithFormat:@"%@ lvl",things_list.level];
            labelLock.text=@"required";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;

        default:
            break;
    }
}


@end
