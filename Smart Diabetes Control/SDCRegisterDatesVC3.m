//
//  SDCRegisterDatesVC3.m
//  Smart Diabetes Control
//
//  Created by Mederi on 21/06/13.
//
//

#import "SDCRegisterDatesVC3.h"
#import "SDCGlucoseRegisterVC.h"
#import "SDCConstants.h"
@interface SDCRegisterDatesVC3 ()

@end



NSDateFormatter *dateFormatStart;
NSDateFormatter *dateFormatEnd;
NSString *dateStringStart;
NSString *dateStringEnd;

@implementation SDCRegisterDatesVC3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCRegisterDatesVC3_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    
    if (self) {
        
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Periodo registro"];
        
        dateFormatStart = [[NSDateFormatter alloc]init];
        [dateFormatStart setDateFormat:@"'Desde' dd/MM "];
        dateFormatEnd = [[NSDateFormatter alloc]init];
        [dateFormatEnd setDateFormat:@"' hasta ' dd/MM "];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dateStringStart = [dateFormatStart stringFromDate:[self untilDate]];
    dateStringEnd = [dateFormatEnd stringFromDate:[self sinceDate]];
    NSString *s=[dateStringStart stringByAppendingString:dateStringEnd];
    [registerDatesLabel setText:s];
    
    // Do any additional setup after loading the view from its nib.
    // Preparo picker y configuro evento asociado al cambio de fecha
    [registerDatesStartPicker setDate:[self untilDate]];
    [registerDatesEndPicker setDate:[self sinceDate]];
    [registerDatesEndPicker setMaximumDate:[NSDate date]];
    [registerDatesStartPicker setMaximumDate:[NSDate date]];
     
    [registerDatesStartPicker addTarget:self  action:@selector(startDateChange:)
                    forControlEvents:UIControlEventValueChanged];
    
    [registerDatesEndPicker addTarget:self  action:@selector(endDateChange:)
                       forControlEvents:UIControlEventValueChanged];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    // Si vuelvo a esta vista,no se carga de nuevo, pero necesito sus valores si los tuviera. Si la
    // medida estuviera vacia devuelve los que se ponen por defecto, ya que la medida siempre tiene
    // estos valores por defecto
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Evento de cambio de fecha de date Picker: recojo cambio, envio datos y string al view controller correspondiente,es decir,el último

- (void)startDateChange:(id)sender
{
    NSDate *date =[registerDatesStartPicker date];
    [self setUntilDate:date];
    // Le paso también el valor a la ventana anterior
    int aux=[[[self navigationController]viewControllers]count]-2; // Accedo al último elemento que abrio datepickers->al último viewController,es decir el viewController que me llama para abrir pickers
    [[[[self navigationController]viewControllers]objectAtIndex:aux]setUntilDate:date];
    // Recojo el valor y lo muestro en label
    dateStringStart = [dateFormatStart stringFromDate:[self untilDate]];
    dateStringEnd = [dateFormatEnd stringFromDate:[self sinceDate]];
    NSString *s=[dateStringStart stringByAppendingString:dateStringEnd];
    [registerDatesLabel setText:s];

    [[[[self navigationController]viewControllers]objectAtIndex:aux]setStringDate:s];
    
}

- (void)endDateChange:(id)sender
{   
    NSDate *date =[registerDatesEndPicker date];
    [self setSinceDate:date];
    int aux=[[[self navigationController]viewControllers]count]-2; // Accedo al último elemento->al último viewController,es decir el viewController que me llama

    [[[[self navigationController]viewControllers]objectAtIndex:aux]setSinceDate:date];
    
    // Recojo el valor y lo muestro en label
    dateStringStart = [dateFormatStart stringFromDate:[self untilDate]];
    dateStringEnd = [dateFormatEnd stringFromDate:[self sinceDate]];
    NSString *s=[dateStringStart stringByAppendingString:dateStringEnd];
    [registerDatesLabel setText:s];
    [[[[self navigationController]viewControllers]objectAtIndex:aux]setStringDate:s];
    
}

@end
