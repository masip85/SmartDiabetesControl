//
//  SDCSecondViewController.m
//  Smart Diabetes Control
//
//  Created by ladmin on 21/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCGlucoseRegisterVC.h"
#import "SDCGlucoseView.h"
#import "SDCMeasureStore.h"
#import "SDCGlucoseMeasure.h"
#import "SDCRegisterDatesVC3.h"
#import "SDCConstants.h"


@implementation SDCGlucoseRegisterVC

@synthesize periodLabel;
@synthesize glucoseView;
@synthesize stringDate;
@synthesize am,pm;

NSDateFormatter *dateFormatStart;
NSDateFormatter *dateFormatEnd;
NSString *dateStringStart;
NSString *dateStringEnd;
BOOL sinceNow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{          if ([deviceString isEqualToString:@"iPhone5"]) {
    self=[super initWithNibName:@"SDCGlucoseRegisterVC_iPhone5" bundle:nil];
}else{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
    
    if (self) {
        self.title = NSLocalizedString(@"Registro", @"Registro");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        double week=-(7*24*60*60);
        [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:week]];
        [self setSinceDate:[NSDate date]];
        sinceNow=YES; // Esta variable cuando este activa mi since será la actualidad, me servirá para saber SI refresco el since a la actualidad más inmediata
        [self setStringDate:@"Última semana"];
        [self setAm:YES];
        [self setPm:YES];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect glucoseFrame=[viewToGlucoseRect frame];
    glucoseView=[[SDCGlucoseView alloc] initWithFrame:glucoseFrame];
    [glucoseView setAm:[self am]];
    [glucoseView setPm:[self pm]];
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja
    
    [self.view addSubview:glucoseView]; 
    
    [periodLabel setText:[self stringDate]];
    
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openReport:)];
    
    //Set tjis bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbi];

}


-(void)openReport:(NSNotification *)note{
    
}
- (void)viewDidUnload
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Recojo el valor y lo muestro en label
    NSString *s=[self stringDate];
    [periodLabel setText:s];
    
    // Modifico en base de datos que puntos se dibujan:
    if  (sinceNow==YES){
         [glucoseView setMeasureDrawUntil:[self untilDate] since:[NSDate date]]; // Refresco since, el "ahora",para que no sea el "ahora anterior" 
    }else{
         [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; 
    }
    
    // Recojo los valores para pintar nuevos puntos
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja
    [glucoseView setNeedsDisplay];
   // [self.view setNeedsDisplay];

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

- (IBAction)oneDayTouched:(id)sender {    
    
    double day=-(24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:day]];
    [self setSinceDate:[NSDate date]];
     sinceNow=YES;
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    NSString *s=@"Último día";
    [self setStringDate:s];
    [periodLabel setText:s];
    [glucoseView setNeedsDisplay];
    
}

- (IBAction)oneWeekTouched:(id)sender {
    double week=-(7*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:week]];
    [self setSinceDate:[NSDate date]];
     sinceNow=YES;
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    NSString *s=@"Última semana";
    [self setStringDate:s];
    [periodLabel setText:s];
    [glucoseView setNeedsDisplay];
}

- (IBAction)threeDaysTouched:(id)sender {
    
    double threeDays=-(3*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:threeDays]];
    [self setSinceDate:[NSDate date]];
     sinceNow=YES;
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    NSString *s=@"Últimos 3 días";
    [self setStringDate:s];
    [periodLabel setText:s];
    [glucoseView setNeedsDisplay];

}
- (IBAction)oneMonthTouched:(id)sender {
    
    double month=-(30*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:month]];
    [self setSinceDate:[NSDate date]];
     sinceNow=YES;
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    NSString *s=@"Último mes";
    [self setStringDate:s];
    [periodLabel setText:s];
    [glucoseView setNeedsDisplay];
}

- (IBAction)calendarTouched:(id)sender {
    SDCRegisterDatesVC3 *calendarVC=[[SDCRegisterDatesVC3 alloc]init];
    [calendarVC setUntilDate:[self untilDate]];
    [calendarVC setSinceDate:[self sinceDate]];
     sinceNow=NO;
    [[self navigationController]pushViewController:calendarVC animated:YES];
}


- (IBAction)amTouched:(id)sender {
 
    [self setPm:NO];
    [self setAm:YES];
    [glucoseView setPm:NO];
    [glucoseView setAm:YES];
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    [glucoseView setNeedsDisplay];
}

- (IBAction)pmTouched:(id)sender {

    [self setPm:YES];
    [self setAm:NO];
    [glucoseView setPm:YES];
    [glucoseView setAm:NO];
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    [glucoseView setNeedsDisplay];
}

- (IBAction)allDayTouched:(id)sender {
    

    [self setPm:YES];
    [self setAm:YES];
    [glucoseView setPm:YES];
    [glucoseView setAm:YES];
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]]; // Modifico en base de datos que puntos se dibujan
    [glucoseView setMeasurePointsAndClusters]; //Glucose view ya sabe los clusters y los puntos que dibuja

    [glucoseView setNeedsDisplay];
}


@end
