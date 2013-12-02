//
//  CustomCell.h
//  CustomCellTutorial
//
//  Created by Nick on 7/26/12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Things_list.h"

@interface CustomCell : UITableViewCell
{
}

@property (nonatomic, strong) IBOutlet UILabel *labelListName;
@property (strong, nonatomic) Things_list *things_list;
@property (nonatomic, strong) IBOutlet UIButton *buttonView1;
@property (nonatomic, strong) IBOutlet UIView *viewBack1;
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *friendsCollection;

@property (nonatomic, strong) IBOutlet UIView *roundRectView;


@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UIStoryboard* storyboard;

-(IBAction)buttonTouched:(id)sender;


@end
