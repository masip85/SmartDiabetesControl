//
//  ImageViewController.m
//  Homepwner
//
//  Created by ladmin on 03/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SDCMealImageVC.h"

@implementation SDCMealImageVC
@synthesize image;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize sz=[[self image] size];
    [scrollView setContentSize:sz];
    [imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [imageView setImage:[self image]];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


//- (void)viewDidUnload
//{
//    [self setImageView:nil];
//    imageView = nil;
//    scrollView = nil;
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
