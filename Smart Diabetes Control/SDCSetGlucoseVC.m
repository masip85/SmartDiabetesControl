//
//  SDCSetGlucoseVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSetGlucoseVC.h"
#import "SDCSetMealVC.h"
#import "SDCGlucoseMeasure.h"
#import "SDCMeasureStore.h"
#import "SDCConstants.h"

@interface SDCSetGlucoseVC ()

@end

NSDateFormatter *dateFormat;
NSString *dateString;
@implementation SDCSetGlucoseVC

@synthesize nextButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSetGlucoseVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Glucosa"];
        dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"'Hoy' dd/MM/YYYY 'a las'  HH:mm"];
//        NSString *now=[[NSString alloc]initWithString:[@"Hoy %d/%d/%d a las %d:%d",[[NSDate date]day],[[NSDate date]day],[[NSDate date]day],[[NSDate date]day],[[NSDate date]day]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [glucoseGlucoseLabel setText:@"Glucosa: "];
    [glucoseUnitsLabel setText:@"mg/dL"];
    [glucoseMeasureEdit setDelegate:self ]; /// ? necesario
    NSDate *date = [NSDate date];
    
    dateString = [dateFormat stringFromDate:date];
    [glucoseDateLabel setText:dateString];

    // Elemento accesorio de teclado
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    glucoseMeasureEdit.inputAccessoryView = numberToolbar;
    
    // Preparo picker y configuro evento asociado al cambio de fecha
    [glucoseDatePicker addTarget:self  action:@selector(DateChange:)
         forControlEvents:UIControlEventValueChanged];
   [glucoseDatePicker setMaximumDate:[NSDate date]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToMeal:(NSNotification *)note{
    
    [self saveGlucoseData:note];
    
    SDCSetMealVC *mealVC=[[SDCSetMealVC alloc]init];
    [mealVC setNextButton:YES];
    [[self navigationController]pushViewController:mealVC animated:YES];
    
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithTitle:@"Siguiente" style:UIBarButtonItemStylePlain target:mealVC action:@selector(goToInsulin:)];
    [[mealVC navigationItem] setRightBarButtonItem:bbi];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)saveGlucoseData:(NSNotification *)note{ // Se activa con el boton ok de la barra. Guarda la medida en SharedStore
    NSLog(@"Guardo medida glucosa");
    
    NSNumber *gv = [[[NSNumberFormatter alloc]init] numberFromString:[glucoseMeasureEdit text]];
    SDCGlucoseMeasure *ttt=[[SDCGlucoseMeasure alloc]initWithGlucoseValue:gv dateValue:[glucoseDatePicker date]];
    [[SDCMeasureStore sharedStore] addGlucoseMeasureToStore: ttt];
    
    if (!nextButton) {
            [self.navigationController popViewControllerAnimated:YES]; // Vuelvo a menu principal
    }

}

// Las dos acciones de elemento accesorio de teclado
-(void)cancelNumberPad{
    [glucoseMeasureEdit resignFirstResponder];
    glucoseMeasureEdit.text = @"";
}

-(void)doneWithNumberPad{
    [glucoseMeasureEdit resignFirstResponder];
}

// Evento de cambio de fecha de date Picker
- (void)DateChange:(id)sender
{
    NSDate *date =[glucoseDatePicker date];
    
    dateString = [dateFormat stringFromDate:date];
    [glucoseDateLabel setText:dateString];

}

// Quito teclado si toco el fondo
- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

@end
