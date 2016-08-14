//
//  SDCSetInsulineVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSetInsulinVC.h"
#import "SDCSetInformationMenuVC.h"
#import "SDCInsulinMeasure.h"
#import "SDCMeasureStore.h"
#import "SDCConstants.h"

@interface SDCSetInsulinVC ()

@end

NSDateFormatter *dateFormat;
NSString *dateString;
Boolean EditArea;

@implementation SDCSetInsulinVC

@synthesize nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSetInsulinVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Insulina"];
        dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"'Hoy' dd/MM/YYYY 'a las'  HH:mm"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Pongo label de la fecha
    dateString = [dateFormat stringFromDate:[NSDate date]];
    [insulinDateLabel setText:dateString];
    // Pongo string al texto de las marcas

    // Elemento accesorio de teclado
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    insulinBasalEdit.inputAccessoryView = numberToolbar;
    insulinBolusEdit.inputAccessoryView = numberToolbar;
    [insulinDatePicker addTarget:self  action:@selector(DateChange:)
                forControlEvents:UIControlEventValueChanged];
    [insulinDatePicker setMaximumDate:[NSDate date]];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *bolusKind=[[NSUserDefaults standardUserDefaults] objectForKey:@"bolusKind"];
    NSString *basalKind=[[NSUserDefaults standardUserDefaults] objectForKey:@"basalKind"];

    [insulinBasalKindLabel setText:basalKind];
    [insulinBolusKindLabel setText:bolusKind];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goToMenu:(NSNotification *)note{

    [self saveInsulinData:note];
[[self navigationController] popToRootViewControllerAnimated:YES];
    
}

// Las dos acciones de elemento accesorio de teclado
-(void)cancelNumberPad{
    
    if (insulinBolusEdit.editing) {
        [insulinBolusEdit resignFirstResponder];
        insulinBolusEdit.text = @"";
    }
    if (insulinBasalEdit.editing) {
        [insulinBasalEdit resignFirstResponder];
        insulinBasalEdit.text = @"";
    }
}

-(void)doneWithNumberPad{
    if (insulinBolusEdit.editing) {
        [insulinBolusEdit resignFirstResponder];
    }
    if (insulinBasalEdit.editing){
        [insulinBasalEdit resignFirstResponder];
    }
}

// Evento de cambio de fecha de date Picker
- (void)DateChange:(id)sender
{
    NSDate *date =[insulinDatePicker date];
    dateString = [dateFormat stringFromDate:date];
    [insulinDateLabel setText:dateString];
    
}

// Quito teclado si toco el fondo
- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

-(void)saveInsulinData:(NSNotification *)note{ // Se activa con el boton ok de la barra. Guarda la medida en SharedStore
    NSNumber *bav = [[[NSNumberFormatter alloc]init] numberFromString:[insulinBasalEdit text]];
    NSNumber *bov = [[[NSNumberFormatter alloc]init] numberFromString:[insulinBolusEdit text]];
    SDCInsulinMeasure *ttt=[[SDCInsulinMeasure alloc]initWithBolusValue:bov basalValue:bav dateValue:[insulinDatePicker date]];
    
    [[SDCMeasureStore sharedStore] addInsulinMeasureToStore: ttt];
    
    if (!nextButton) {
            [self.navigationController popViewControllerAnimated:YES]; // Vuelvo a menu principal
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// Evento de cambio de fecha de date Picker
- (void)insulinDateChange:(id)sender
{
    NSDate *date =[insulinDatePicker date];
    
    dateString = [dateFormat stringFromDate:date];
    [insulinDateLabel setText:dateString];
    
}


@end
