//
//  SDCEventsVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 04/07/13.
//
//

#import "SDCEventsVC.h"
#import "MCLVisitStore.h"
#import "MCLTrackStore.h"
#import "MCLVisit.h"
#import "MCLTrack.h"
#import "SDCConstants.h"
#import "MCLPOI.h"
#import "MCLTrackStore.h"
#import "MCLTrack.h"

@interface SDCEventsVC ()



@end

@implementation SDCEventsVC
@synthesize scrollView1,scrollView2;
NSDateFormatter *dateFormat;
UILabel *visitLabel;
UILabel *sportLabel;
NSString *s2;
NSString *s1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCEventsVC_iPhone5" bundle:nil];
    }else{

        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
        [scrollView1 setDelegate:self];
        [scrollView2 setDelegate:self];
        self.title = NSLocalizedString(@"Eventos", @"Eventos");
        self.tabBarItem.image = [UIImage imageNamed:@"Eventos"];
        dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM - HH:mm"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    visitLabel=[[UILabel alloc]init];
    sportLabel=[[UILabel alloc]init];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    s1=@"   ---   \n";
    int count=[[[MCLVisitStore sharedStore]allVisits]count];
    for (int i=0; i<count; i++) {
        MCLVisit *visit=[[[MCLVisitStore sharedStore]allVisits]objectAtIndex:i];
        float time1=[visit hereTime]/60;
        float time2=abs(fmod([visit hereTime], 60));
        NSString *dateString = [dateFormat stringFromDate:[visit dateStarted]];
        s1=[s1 stringByAppendingFormat:@"\nVisita %d a %@\n %@\nDuración:%.0f'%0.f'' \nLat:%f|Long:%f",i,searchPOIName,dateString,time1,time2,[[visit POI]locationCoordinate].latitude,[[visit POI]locationCoordinate].longitude];
        
    }
    
    [visitLabel setFrame:CGRectMake(0, 0, scrollView1.frame.size.width,10)];
    visitLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [visitLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [visitLabel setNumberOfLines:0];
    visitLabel.text=s1;
    [visitLabel setNeedsDisplay];
    [visitLabel sizeToFit];
    visitLabel.textAlignment=NSTextAlignmentLeft;
    [visitLabel setFrame:CGRectMake(0,0,visitLabel.frame.size.width,visitLabel.frame.size.height) ];
    
    [scrollView1 addSubview:visitLabel];
    [scrollView1 setContentSize:visitLabel.frame.size];
    
    
    
    s2=@"   ---   \n";
    int countb=[[[MCLTrackStore sharedStore]allTracks]count];
    for (int i=0; i<countb; i++) {
        MCLTrack *track=[[[MCLTrackStore sharedStore]allTracks]objectAtIndex:i];
        float timeb1=[track trackTime]/60;
        float timeb2=abs(fmod([track trackTime], 60));
        NSString *dateString = [dateFormat stringFromDate:[track dateStarted]];
        double lat=[[[track track]lastObject]coordinate].latitude;
        double longi=[[[track track]lastObject]coordinate].longitude;

        
        s2=[s2 stringByAppendingFormat:@"Deporte %d\nFecha:%@\nDuración:%.0f'%0.f''\nSitio última posición de la ruta:\n Lat:%f|Long:%f",i,dateString,timeb1,timeb2,lat,longi];
        
    }
    
    [sportLabel setFrame:CGRectMake(0, 0, scrollView2.frame.size.width,10)];
    sportLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [sportLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [sportLabel setNumberOfLines:0];
    sportLabel.text=s2;
    [sportLabel setNeedsDisplay];
    [sportLabel sizeToFit];
    sportLabel.textAlignment=NSTextAlignmentLeft;
    [sportLabel setFrame:CGRectMake(0,0,sportLabel.frame.size.width,sportLabel.frame.size.height) ];
    
    [scrollView2 addSubview:sportLabel];
    [scrollView2 setContentSize:sportLabel.frame.size];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [visitLabel removeFromSuperview];
    [sportLabel removeFromSuperview];
}

@end
