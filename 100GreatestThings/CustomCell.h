//
//  CustomCell.h
//  CustomCellTutorial
//
//  Created by Nick on 7/26/12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Things_list.h"

enum {
    CustomCellOpened = 1,
    CustomCellFacebook = 2,
    CustomCellTwitter = 3,
    CustomCellEnergy = 4,
    CustomCellLevel = 5
};
typedef NSUInteger CustomCellType;


@interface CustomCell : UITableViewCell
{
}

@property (nonatomic, readwrite) CustomCellType customCellType;
@property (nonatomic, strong) IBOutlet UILabel *labelListName;
@property (nonatomic, strong) IBOutlet UILabel *labelProgress;
@property (strong, nonatomic) Things_list *things_list;
@property (nonatomic, strong) IBOutlet UIButton *buttonView1;
@property (nonatomic, strong) IBOutlet UIImageView*viewShadow;
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *friendsCollection;
@property (nonatomic, strong) IBOutlet UIImageView *imageLock;
@property (nonatomic, strong) IBOutlet UILabel *labelLock;
@property (nonatomic, strong) IBOutlet UILabel *labelLockLevel;
@property (nonatomic, strong) IBOutlet UILabel *labelEnergy;
@property (nonatomic, strong) IBOutlet UILabel *labelNrg;

@property (nonatomic, strong) IBOutlet UIView *roundRectView;
@property (nonatomic, strong) IBOutlet UIView *lockView;
@property (nonatomic, weak) UITableViewController* tableViewController;



@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UIStoryboard* storyboard;

//события на нажатия на кнопку списка
-(void)buttonTouched:(id)sender;
-(void)buttonTouchFacebook:(id)sender;
-(void)buttonTouchTwitter:(id)sender;
-(void)buttonTouchLevel:(id)sender;
-(void)buttonTouchEnergy:(id)sender;

-(void)updateTable;


@end
