//
//  SDCMealExtraDetailsVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 27/05/13.
//
//

#import "SDCMealExtraDetailsVC.h"
#import "SDCConstants.h"
@interface SDCMealExtraDetailsVC ()

@end

@implementation SDCMealExtraDetailsVC

@synthesize meal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCMealExtraDetailsVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self view]endEditing:YES];
    // ¿Grabar los labels siempre que me vaya hacia atrás.:
    
    // FALTA POR HACER.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setMeal:(SDCMeal *)i
{   // AQUI la tabla me pasa que alimento muestra la vista detallada. además le pone título
    meal=i;
    // Titulo de arriba - bar
    if ([[meal mealName]isEqual:@""]) {
        NSString *s=@"Nuevo alimento";
        [[self navigationItem] setTitle:[s stringByAppendingString:@" - Info."]];
    }else{
         NSString *s=[meal mealName];
        [[self navigationItem] setTitle:[s stringByAppendingString:@" - Info."]];
    }

}


@end
