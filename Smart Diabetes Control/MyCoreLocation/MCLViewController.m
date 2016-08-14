//
//  MCLViewController.m
//  MyCoreLocation
//
//  Created by ladmin on 13/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MCLViewController.h"

@implementation MCLViewController
@synthesize locationLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"GPS", @"GPS");
        self.tabBarItem.image = [UIImage imageNamed:@"GPS"];
        CLController = [[MyCoreLocationController alloc] init];
        [CLController setDelegate:self];

    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	    [[self worldView]setMapType:MKMapTypeSatellite];
    


//	[[CLController locationManager] startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	[locationLabel setText:[location description]];
    [[self worldView]setCenterCoordinate:location.coordinate animated:YES];
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate, 150, 150); // metros
    [[self worldView]setRegion:region];
    [self.worldView setRegion:[self.worldView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.worldView addAnnotation:point];

}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (annotation == mapView.userLocation) return nil;}

- (void)locationError:(NSError *)error {
	[locationLabel setText:[error description]];
}

-(void)addPOIPins:(CLLocationCoordinate2D)loc called:(NSString*)s{
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = loc;
    point.title = @"Point of Interest";
    point.subtitle = s;
    
    [self.worldView addAnnotation:point];
    
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
