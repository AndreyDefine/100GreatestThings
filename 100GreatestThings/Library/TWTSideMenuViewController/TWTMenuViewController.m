//
//  TWTMenuViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TWTMenuViewController.h"
#import "TWTSideMenuViewController.h"

@interface TWTMenuViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TWTMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"galaxy"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];

    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10.0f, 100.0f, 200.0f, 44.0f);
    closeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    //[closeButton setBackgroundColor:[UIColor whiteColor]];
    //[closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(10.0f, 200.0f, 200.0f, 44.0f);
    [changeButton setTitle:@"Swap" forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:30];
    //[changeButton setBackgroundColor:[UIColor greenColor]];
    //[changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
}

- (void)changeButtonPressed
{
    UIStoryboard *storyboard;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    }
    
    UINavigationController* navigationViewController=[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    [self.sideMenuViewController setMainViewController:navigationViewController animated:YES closeMenu:YES];
    //UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[TWTMainViewController new]];
    //[self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
    //[self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (void)closeButtonPressed
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
