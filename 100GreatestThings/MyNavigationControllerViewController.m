//
//  MyNavigationControllerViewController.m
//  CustomCellTutorial
//
//  Created by baskakov on 14/11/13.
//  Copyright (c) 2013 MyCompanyName. All rights reserved.
//

#import "MyNavigationControllerViewController.h"
#import "AppDelegate.h"
#import "TWTSideMenuViewController.h"
#import "FirstLoadingViewViewController.h"
#import "DatabaseFromUrl.h"

@interface MyNavigationControllerViewController ()

@end

@implementation MyNavigationControllerViewController

@synthesize buttonMenu;
@synthesize buttonBack;
@synthesize customBar;
@synthesize expaCustomBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate=self;
    
    //set customBarViewController
    UIViewController *customBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomBarViewController"];
    self.customBar=customBarController.view;
    
    //set expaCustomBarViewController
    UIViewController *expacustomBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpaBarController"];
    self.expaCustomBar=expacustomBarController.view;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    
    if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait)
    {
        [self setItemsPosition:width];
    }
    else
    {
        [self setItemsPosition:height];
    }
    [self.view addSubview:expaCustomBar];
    [self.view addSubview:customBar];
    [self.view addSubview:buttonMenu];
    [self.view addSubview:buttonBack];
    buttonBack.hidden=true;
    
    //проверим первая ли это загрузка
    if([CommonUserDefaults getSharedInstance].flagNotFirstLaunch==NO)
    {
        NSLog(@"first launch!!!");
        
        FirstLoadingViewViewController *myViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstLoadingView"];
        [self pushViewController:myViewController animated:YES];
        
        [[DatabaseFromUrl getSharedInstance] LoadDataFromURL:^(void){
            [CommonUserDefaults getSharedInstance].flagNotFirstLaunch=YES;
            [self performSelectorOnMainThread:@selector(ShowMainView:) withObject:nil waitUntilDone:NO];
        }];
    }
}


-(void)ShowMainView:(id)inobject
{
    [self popViewControllerAnimated:YES];
}


-(void)setItemsPosition:(float)width
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.customBar.frame = CGRectMake(0, 0, width, 44);
        self.expaCustomBar.frame = CGRectMake(0, 44.0f, width, 32);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.customBar.frame = CGRectMake(0, 0, width, 60.0f);
        self.expaCustomBar.frame = CGRectMake(0, 60, width, 32);
    }
    
    //set position menuButton
    int x1 = ([buttonMenu frame].size.width)/2+14;
    int y1 = ([buttonMenu frame].size.height)/2+15;
    [buttonMenu setCenter:CGPointMake(x1, y1)];
    
    //set position backButton
    int x2 = ([buttonMenu frame].size.width)/2+8;
    int y2 = ([buttonBack frame].size.height)/2+15;
    [buttonBack setCenter:CGPointMake(x2, y2)];
}


-(void)showMenu:(id)sender
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)showBack:(id)sender
{
     [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController==[self.viewControllers objectAtIndex:0]||[viewController isKindOfClass:[FirstLoadingViewViewController class]])
    {
        buttonBack.hidden=true;
        buttonMenu.hidden=false;
    }
    else
    {
        buttonBack.hidden=false;
        buttonMenu.hidden=true;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

#pragma mark -
#pragma mark InterfaceOrientationMethods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        //self.view = portraitView;
        [self changeTheViewToPortrait:YES andDuration:duration];
        
    }
    else if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        //self.view = landscapeView;
        [self changeTheViewToPortrait:NO andDuration:duration];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds) ;
    if(portrait){
        [self setItemsPosition:width];
    }
    else{
        [self setItemsPosition:height];
    }
    
    [UIView commitAnimations];
}

@end
