//
//  SDCSportDetailDatesVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 29/05/13.
//
//

#import "SDCSportDatesVC.h"
#import "SDCSportMeasure.h"
#import "SDCConstants.h"
@interface SDCSportDatesVC ()

@end



NSDateFormatter *dateFormatStart;
NSDateFormatter *dateFormatInterval;
NSString *dateString;

@implementation SDCSportDatesVC


@synthesize sportMeasure;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSportDatesVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Periodo deporte"];
        
        dateFormatStart = [[NSDateFormatter alloc]init];
        [dateFormatStart setDateFormat:@"'Inicio el ' dd/MM/YYYY ' a las ' HH:mm"];
        
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dateString = [dateFormatStart stringFromDate:[NSDate date]];
    [sportDatesIntervalLabel setText:@"Duración:\n 0 minutos"];
    [sportDatesStartLabel setText:dateString];
    // Do any additional setup after loading the view from its nib.
    // Preparo picker y configuro evento asociado al cambio de fecha
    [sportDatesStartPicker setDate:[NSDate date]];
    [sportDatesStartPicker setMaximumDate:[NSDate date]];
    [sportDatesStartPicker addTarget:self  action:@selector(StartDateChange:)
                forControlEvents:UIControlEventValueChanged];
    [sportDatesIntervalPicker setCountDownDuration:0];
   
    [sportDatesIntervalPicker addTarget:self  action:@selector(IntervalChange:)
                          forControlEvents:UIControlEventValueChanged];

}
-(void)viewWillAppear:(BOOL)animated{
    
    // Si vuelvo a esta vista,no se carga de nuevo, pero necesito sus valores si los tuviera. Si la
    // medida estuviera vacia devuelve los que se ponen por defecto, ya que la medida iempre tiene
    // estos valores por defecto
    NSTimeInterval ti=[sportMeasure trackTime];
    int i=ti/60;
    NSString *s=[NSString stringWithFormat:@"Duración:\n %d minutos",i ];
    [sportDatesIntervalLabel setText:s];
    [sportDatesIntervalPicker setCountDownDuration:ti];
    
    NSDate *date =[sportMeasure dateStarted];
    dateString = [dateFormatStart stringFromDate:date];
    [sportDatesStartLabel setText:dateString];
    [sportDatesStartPicker setDate:date];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
     
// Evento de cambio de fecha de date Picker
- (void)StartDateChange:(id)sender
{
    NSDate *date =[sportDatesStartPicker date];
        
    dateString = [dateFormatStart stringFromDate:date];
    [sportDatesStartLabel setText:dateString];
    [sportMeasure setDateStarted:date]; // Añado el valor a la medida
        
}
     
- (void)IntervalChange:(id)sender
{
    NSTimeInterval ti=[sportDatesIntervalPicker countDownDuration];
    int i=ti/60;
    NSString *s=[NSString stringWithFormat:@"Duración:\n %d minutos",i ];
    [sportDatesIntervalLabel setText:s];
    
    
    [sportMeasure setTrackTime:ti]; // Añado el valor a la medida
    
}

@end
