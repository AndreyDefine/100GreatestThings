//
//  CustomCell.m
//  CustomCellTutorial
//
//  Created by Nick on 7/26/12.
//  Copyright (c) 2012 Phereo.com. All rights reserved.
//

#import "CustomCell.h"
#import "TasksTableViewController.h"
#import "MyNavigationControllerViewController.h"
#import "EnergyBarViewController.h"
#import "CustomProgressBar.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CommonUserDefaults.h"
#import "Things_task.h"
#import "DatabaseFromUrlBridge.h"

@implementation CustomCell

@synthesize customCellType;
@synthesize things_list;
@synthesize labelListName;
@synthesize buttonView1;
@synthesize viewShadow;
@synthesize roundRectView;
@synthesize lockView;
@synthesize lockViewLvl;
@synthesize imageView1;
@synthesize imageLock;
@synthesize labelLock;
@synthesize labelLockLevel;
@synthesize labelEnergy;
@synthesize labelNrg;
@synthesize navigationController;
@synthesize storyboard;
@synthesize friendsCollection;
@synthesize labelProgress;

@synthesize tableViewController;


- (Things_list*)things_list {
    return things_list;
}

- (void)awakeFromNib
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setThings_list: (Things_list*)newValue {
    things_list=newValue;
    //запишем все изменения в ячейку
    //set cell type
    if([things_list.level integerValue]>[CommonUserDefaults getSharedInstance].level){
        //need level for cell
        self.customCellType=CustomCellLevel;
    }
    else if(things_list.opened)
    {
        self.customCellType=CustomCellOpened;
    }else if([things_list.network_link_required isEqualToString:@"facebook"])
    {
        self.customCellType=CustomCellFacebook;
    }else if([things_list.network_link_required isEqualToString:@"twitter"])
    {
        self.customCellType=CustomCellTwitter;
    }
    else{
        //not facebook, twitter, level, opened
        self.customCellType=CustomCellEnergy;
    }
    
    //set label progress
    int progress=0;
    NSArray *myArray = [things_list.to_Things_task allObjects];
    if(myArray)
    {
        for (int i=0;i<myArray.count;i++)
        {
            //задача выполнена
            if([((Things_task*)[myArray objectAtIndex:i]).complete integerValue]==2)
            {
                progress++;
            }
        }
        
        progress=100*(float)progress/myArray.count;
    }
    
    self.labelProgress.text=[[NSNumber numberWithInt:progress] stringValue];
    
    self.labelListName.text=things_list.title;
    
    UIImage *img = [[UIImage imageNamed:@"shadow.png"]
                    resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 44, 14)];
    
    viewShadow.image=img;
    
    CGRect rect=CGRectMake(self.roundRectView.frame.origin.x-1, self.roundRectView.frame.origin.y, self.roundRectView.frame.size.width+2, self.roundRectView.frame.size.height+37);
    viewShadow.frame=rect;
    
    //add image
    [[DatabaseFromUrlBridge getSharedInstance] LoadImage:things_list.image_url todisk:things_list.disk_image_url toimageview:self.imageView1];
    
    self.roundRectView.layer.cornerRadius = 4.0;
    self.roundRectView.layer.masksToBounds = YES;
    for(UIImageView *imageView in self.friendsCollection)
    {
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.masksToBounds = YES;
    }

}

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

-(void)buttonTouchEnergy:(id)sender
{
    int cost=[things_list.energy_for_unlock intValue];
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
    if(buttonIndex==0)
    {
        //убрали енергию
        [[EnergyBarViewController getSharedInstance] addenergy:-[things_list.energy_for_unlock intValue]];
        //добавили икспириенс
        [CommonUserDefaults getSharedInstance].expa+=[things_list.exp_reward_for_unlock intValue];
        //узнали какая текущая максимальная энергия
        [[EnergyBarViewController getSharedInstance] setmaxenergy:[CommonUserDefaults getSharedInstance].maxenergy];
        
        self.customCellType=CustomCellOpened;
        things_list.opened=[[NSNumber alloc]initWithBool:YES];
        
        //необходимо обновить все списки, так как могло что-то поменяться
        [self updateTable];
    }
    
    if(buttonIndex==1)
    {
        //do nothing
    }
}

-(void)updateTable
{
     [self.tableViewController performSelector:@selector(reloadData)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setCustomCellType:(CustomCellType)value
{
    int cost=[things_list.energy_for_unlock intValue];
    customCellType=value;
    float lockalpha=0.80;
    [self.buttonView1 removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    switch (customCellType) {
        case CustomCellOpened:
            [self.buttonView1 addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            self.lockViewLvl.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=nil;
            labelLockLevel.text=@"";
            labelLock.text=@"";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
        case CustomCellFacebook:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchFacebook:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)87/255.0f green: (float)113/255.0f blue: (float)169/255.0f alpha:lockalpha];
            self.lockViewLvl.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=[UIImage imageNamed:@"lock_facebook.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Login with facebook to unlock this list";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
            
        case CustomCellTwitter:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchTwitter:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)119/255.0f green: (float)182/255.0f blue: (float)227/255.0f alpha:lockalpha];
            self.lockViewLvl.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=[UIImage imageNamed:@"lock_twitter.png"];
            labelLock.text=@"Login with twitter to unlock this list";
            labelEnergy.text=@"";
            labelNrg.text=@"";
            break;
            
        case CustomCellEnergy:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchEnergy:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: (float)80/255.0f green: (float)183/255.0f blue: (float)255/255.0f alpha:lockalpha];
            self.lockViewLvl.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            imageLock.image=[UIImage imageNamed:@"lock_energy.png"];
            labelLockLevel.text=@"";
            labelLock.text=@"Unlock now";
            labelEnergy.text=[NSString stringWithFormat:@"%d",cost];
            labelNrg.text=@"NRG";
            break;
        
        case CustomCellLevel:
            [self.buttonView1 addTarget:self action:@selector(buttonTouchLevel:) forControlEvents:UIControlEventTouchUpInside];
            self.lockView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:0];
            self.lockViewLvl.backgroundColor = [UIColor colorWithRed: (float)96/255.0f green: (float)96/255.0f blue: (float)96/255.0f alpha:lockalpha];
            imageLock.image=[UIImage imageNamed:@"lock_energy.png"];
            labelEnergy.text=[NSString stringWithFormat:@"%d",cost];
            labelNrg.text=@"NRG";
            
            labelLockLevel.text=[NSString stringWithFormat:@"%@ lvl",things_list.level];
            labelLock.text=@"required";
            break;

        default:
            break;
    }
}


@end
