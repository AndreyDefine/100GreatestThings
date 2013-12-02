//
//  TaskCell.h
//  100GreatestThings
//
//  Created by baskakov on 29/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
{
}

@property (nonatomic, strong) IBOutlet UILabel *rowNumber;
@property (nonatomic, strong) IBOutlet UILabel *titleView1;
@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, retain) IBOutletCollection(UIImageView) NSArray *friendsCollection;

@end
