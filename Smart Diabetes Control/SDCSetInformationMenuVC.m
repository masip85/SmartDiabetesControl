//
//  SDCMainMenuVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSetInformationMenuVC.h"
#import "SDCSetGlucoseVC.h"
#import "SDCSetInsulinVC.h"
#import "SDCSetSportVC.h"
#import "SDCSetMealVC.h"

@interface SDCSetInformationMenuVC ()

@end
NSMutableDictionary *titleBarAttributes;

@implementation SDCSetInformationMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Introducir datos"];
        self.title = NSLocalizedString(@"Datos", @"Datos");

        titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:@"Helvetica-Bold" size:18] forKey:UITextAttributeFont];
        [[UINavigationBar appearance]setTitleTextAttributes:titleBarAttributes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//- (IBAction)setGlucoseMainMenuButton:(id)sender {
//    
//    SDCSetGlucoseVC *setGlucoseVC=[[SDCSetGlucoseVC alloc]init];
//    [[self navigationController]pushViewController:[[SDCSetGlucoseVC alloc]init] animated:YES];
//    NSLog(@"sdsdsdsd");
//}
//
//- (IBAction)setSportMainMenuButton:(id)sender {
//}
//
//- (IBAction)setMealMainMenuButton:(id)sender {
//}
//
//- (IBAction)setInsulinMainMenuButton:(id)sender {
//}
//
//
//
//
//- (IBAction)setAllDataMainMenuButton:(id)sender {
//}
- (IBAction)setGlucoseMenuButton:(id)sender {
    SDCSetGlucoseVC *glucoseVC=[[SDCSetGlucoseVC alloc]init];
    [glucoseVC setNextButton:FALSE];
    [[self navigationController]pushViewController:glucoseVC animated:YES];
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:glucoseVC action:@selector(saveGlucoseData:)];
    [[glucoseVC navigationItem] setRightBarButtonItem:bbi];
    
}
- (IBAction)setSportMenuButton:(id)sender {
    SDCSetSportVC *sportVC=[[SDCSetSportVC alloc]init];
    
    [[self navigationController]pushViewController:sportVC animated:YES];
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:sportVC action:@selector(saveSportData:)];
    [[sportVC navigationItem] setRightBarButtonItem:bbi];}
-(IBAction)setInsulinMenuButton:(id)sender{
    SDCSetInsulinVC *insulinVC=[[SDCSetInsulinVC alloc]init];
    [insulinVC setNextButton:FALSE];
    [[self navigationController]pushViewController:insulinVC animated:YES];
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:insulinVC action:@selector(saveInsulinData:)];
    [[insulinVC navigationItem] setRightBarButtonItem:bbi];
}
- (IBAction)setMealMenuButton:(id)sender {
    SDCSetMealVC *mealVC=[[SDCSetMealVC alloc]init];
    [mealVC setNextButton:FALSE];
    [[self navigationController]pushViewController:mealVC animated:YES];
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:mealVC action:@selector(saveMealData:)];
    [[mealVC navigationItem] setRightBarButtonItem:bbi];
}
- (IBAction)setAllDataMenuButton:(id)sender { // Los voy lanzando todos en cadena

    SDCSetGlucoseVC *glucoseVC=[[SDCSetGlucoseVC alloc]init];
    [glucoseVC setNextButton:YES];
    [[self navigationController]pushViewController:glucoseVC animated:YES];
    
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithTitle:@"Siguiente" style:UIBarButtonItemStylePlain target:glucoseVC action:@selector(goToMeal:)];
    [[glucoseVC navigationItem] setRightBarButtonItem:bbi];
    
    
}







@end
