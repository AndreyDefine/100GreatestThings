//
//  MyNavigationControllerViewController.h
//  CustomCellTutorial
//
//  Created by baskakov on 14/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbriaRequest.h"
#import "CommonUserDefaults.h"
#import "FirstLoadingViewController.h"

@interface MyNavigationControllerViewController : UINavigationController <UINavigationBarDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate>
{    
    NSMutableData *_responseData;
}

@property (strong, nonatomic)IBOutlet UIButton *buttonMenu;
@property (strong, nonatomic)IBOutlet UIButton *buttonBack;
@property (strong, nonatomic) UIView *customBar;
@property (strong, nonatomic) UIView *expaCustomBar;

-(void)showMenu:(id)sender;
-(void)showBack:(id)sender;

@end
