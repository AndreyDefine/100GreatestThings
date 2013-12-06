//
//  TaskCell.m
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "TaskCell.h"
#import "Things_task.h"
#import "DatabaseFromUrlBridge.h"
#import "CommonUserDefaults.h"
#import "Things_list.h"

@implementation TaskCell
@synthesize rowNumber;
@synthesize doneButton;
@synthesize imageView1;
@synthesize titleView1;
@synthesize friendsCollection;
@synthesize tableViewController;
@synthesize things_task;
@synthesize things_list;


- (Things_task*)things_task {
    return things_task;
}

- (void)setThings_task: (Things_task*)newValue {
    things_task=newValue;
    self.titleView1.text=things_task.title;
    if([things_task.complete integerValue]==2){
        self.doneButton.selected=YES;
    }else
    {
        self.doneButton.selected=NO;
    }
    //image
    [[DatabaseFromUrlBridge getSharedInstance] LoadImage:things_task.image_url todisk:things_task.disk_image_url toimageview:self.imageView1];
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
    BOOL needToAddExpa=false;
    if(self.doneButton.selected)
    {
        //ещё никогда не отмечали
        if([self.things_task.complete integerValue]==0)
        {
            needToAddExpa=YES;
        }
        self.things_task.complete=@2;
    }
    else
    {
        if([self.things_task.complete integerValue]==2)
        {
            //задача была отмечена ранее, помечаем это
            self.things_task.complete=@1;
        }
        else
        {
            //задача никогда не была отмечена, скорее всего сюда никогда не попадём
            self.things_task.complete=@0;
        }
    }
    //NSLog(@"%f",[CommonUserDefaults getSharedInstance].expa);
    if(needToAddExpa)
    {
        //получим все списки с этой таской
        NSArray *myArrayLists = [things_task.to_Things_list allObjects];
        Things_list *curthings_list;
        for(int j=0;j<myArrayLists.count;j++)
        {
            curthings_list=myArrayLists[j];
            //посчитаем экспу
            int progress=0;
            NSArray *myArray = [curthings_list.to_Things_task allObjects];
            //считаем только в открытых списках
            if(myArray&&curthings_list.opened)
            {
                for (int i=0;i<myArray.count;i++)
                {
                    if([((Things_task*)[myArray objectAtIndex:i]).complete integerValue]==2)
                    {
                        progress++;
                    }
                }
                
                if(self.doneButton.selected==YES)
                {
                    //добавили икспириенс
                    [CommonUserDefaults getSharedInstance].expa+=(float)[curthings_list.exp_reward_for_unlock floatValue]+(float)[curthings_list.exp_reward_for_task_delta floatValue]*progress;
                }else{
                    //экспу не отнимаем
                    
                    //[CommonUserDefaults getSharedInstance].expa-=(float)[curthings_list.exp_reward_for_unlock floatValue]+(float)[curthings_list.exp_reward_for_task_delta floatValue]*(progress+1);
                }
            }
        }
    }
    //NSLog(@"%f",[CommonUserDefaults getSharedInstance].expa);
    [self updateTable];
}

-(void)updateTable
{
    [self.tableViewController performSelector:@selector(reloadData)];
}

@end
