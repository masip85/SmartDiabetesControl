//
//  SDCSetMealVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSetMealVC.h"
#import "SDCSetInsulinVC.h"
#import "SDCMealStore.h"
#import "SDCMealMeasure.h"
#import "SDCMeal.h"
#import "SDCImageStore.h"
#import "SDCMeasureStore.h"
#import "MealsVC.h"
#import "CollectionViewController.h"

#import "SDCConstants.h"
#import "CustomCell.h"
#import "LineLayout.h"
#import "CollectionViewController.h"

@interface SDCSetMealVC ()

@end

NSString *dateString;
NSDateFormatter *dateFormat;
UICollectionView *mealCollectionView ;
NSInteger *indexSelected; // Contador de array que marca que alimento se selecciona. Determinado por collection view y autocomplete
int pages;



@implementation SDCSetMealVC

const int MealCollectionBorderWidth=30;
@synthesize mealNames;
@synthesize mealAutoComplete;
@synthesize autoCompleteTableView;
@synthesize nextButton;
BOOL nextButton; // Esto me dirá si estoy metiendo todos los datos o solo uno

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSetMealVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Alimentos"];
        dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"'Hoy' dd/MM/YYYY 'a las'  HH:mm"];
        indexSelected=0;
        
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{   // Recargo el collection View
    pages=[[[SDCMealStore sharedStore]allMeals]count];
    [mealCollectionView reloadData];
    // Recargo la tabla del autocomplete
    mealNames = [[NSMutableArray alloc] initWithObjects:nil];
    for (int i=0; i<[[[SDCMealStore sharedStore]allMeals]count]; i++) { // Bucle crea array nombres
        NSString *s=[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:i]mealName];
        [mealNames addObject:s];
    }
//    NSLog(@"%@",[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:indexSelected]unitKind]);
    
    if ([[[SDCMealStore sharedStore]allMeals]count]>0) {
        
        [mealUnitLabel setText:[[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:indexSelected]unitKind]stringByAppendingString:@" de "]]; // esto rellena la parte entre num raciones y nombre alimento seleccionado,acorde al tipo de unidad
    }else{
        [mealUnitLabel setText:@"unidades de:"];
    }
    
    
//    [mealNameTextEdit setText:@""];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self view]endEditing:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Pongo label de la fecha
    dateString = [dateFormat stringFromDate:[NSDate date]];
    [mealDateLabel setText:dateString];
    // Pongo string al texto del medio
    [mealUnitLabel setText:@"unidades de:"];
    
    // Do any additional setup after loading the view from its nib.
    //////// Elemento accesorio de teclado
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    // Le añado la barra al numberpad textfield
    mealRationTextEdit.inputAccessoryView = numberToolbar;
   
    /////// Configuro datepicker
    [mealDatePicker addTarget:self  action:@selector(mealDateChange:)
                forControlEvents:UIControlEventValueChanged];
    [mealDatePicker setMaximumDate:[NSDate date]];
    
    /////// Configuro el autocomplete
    mealNameTextEdit.delegate=self;
    mealNames = [[NSMutableArray alloc] initWithObjects:nil];
    for (int i=0; i<[[[SDCMealStore sharedStore]allMeals]count]; i++) { // Bucle crea array nombres
        NSString *s=[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:i]mealName];
        [mealNames addObject:s];
    }
    mealAutoComplete = [[NSMutableArray alloc] init]; // Inicializo vector autocompletar
    
    CGRect tableRect=mealNameTextEdit.frame;
    tableRect.origin.y+=20;
    tableRect.size.width-=10;
    

    autoCompleteTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    autoCompleteTableView.delegate = self;
    autoCompleteTableView.dataSource = self;
    autoCompleteTableView.scrollEnabled = YES;
    autoCompleteTableView.hidden = YES;
    autoCompleteTableView.rowHeight=mealNameTextEdit.frame.size.height*0.75;
    //autoCompleteTableView.tableFooterView = [[UIView alloc] init]; // TRUco: Eliminar filas inferiores sobrantes
    [mealAutoComplete removeAllObjects];
    [self.view addSubview:autoCompleteTableView];
    

    /////// Configuro el collection    
    UICollectionViewFlowLayout *flowLayout = [[LineLayout alloc] init ];
    NSLog(@"%f,",mealViewToCollectionPlace.bounds.origin.x);
     mealCollectionView = [[UICollectionView alloc]
                           initWithFrame:mealViewToCollectionPlace.bounds
                           collectionViewLayout:flowLayout];
   // mealCollectionView.indexPathsForSelectedItems
    mealCollectionView.delegate = self;
    mealCollectionView.dataSource = self;
    mealCollectionView.showsHorizontalScrollIndicator = NO;
    [mealCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"Cell"];
    mealCollectionView.backgroundColor=[UIColor whiteColor];
    [mealCollectionView reloadData];
    [mealViewToCollectionPlace addSubview:mealCollectionView];
    pages=[[[SDCMealStore sharedStore]allMeals]count]; // 1 to x
    
    
    /////// Configuro los segmentos
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10], UITextAttributeFont, nil];
    [mealSegments setTitleTextAttributes:textAttributes forState:UIControlStateNormal];

    [mealSegments setTitle:@"Desayuno" forSegmentAtIndex:0];
    [mealSegments setTitle:@"Almuerzo" forSegmentAtIndex:1];
    [mealSegments setTitle:@"Comida" forSegmentAtIndex:2];
    [mealSegments setTitle:@"Merienda" forSegmentAtIndex:3];
    [mealSegments setTitle:@"Cena" forSegmentAtIndex:4];
    [mealSegments setTitle:@"Snack" forSegmentAtIndex:5];
    [mealSegments setSelected:NO];
    
    




}

-(void)saveMealData:(NSNotification *)note{// Se activa con el boton ok de la barra. Guarda la medida en SharedStore
    
    if ([mealSegments selectedSegmentIndex]!=UISegmentedControlNoSegment){
        NSNumber *rv = [[[NSNumberFormatter alloc]init] numberFromString:[mealRationTextEdit text]];
        NSString *ks=[mealSegments titleForSegmentAtIndex:[mealSegments selectedSegmentIndex]];

        indexSelected=[[[mealCollectionView indexPathsForSelectedItems]lastObject]row];
        SDCMeal *mealSelected=[[[SDCMealStore sharedStore]allMeals]objectAtIndex:indexSelected];
        SDCMealMeasure *ttt=[[SDCMealMeasure alloc]initWithRationValue:rv myMeal:mealSelected dateValue:[mealDatePicker date] kindValue:ks];
        [[SDCMeasureStore sharedStore]addMealMeasureToStore:ttt];
    
        
        if (!nextButton) {
            [self.navigationController popViewControllerAnimated:YES]; // Vuelvo a menu principal
        }

    
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Datos incorrectos"
                                                        message:@"Dime que comida del dia es"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToInsulin:(NSNotification *)note{
    
      [self saveMealData:note];
    
    SDCSetInsulinVC *insulinVC=[[SDCSetInsulinVC alloc]init];
    [insulinVC setNextButton:YES];
  
    
    [[self navigationController]pushViewController:insulinVC animated:YES];
    
    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithTitle:@"Fin" style:UIBarButtonItemStyleBordered target:insulinVC action:@selector(goToMenu:)];
    [[insulinVC navigationItem] setRightBarButtonItem:bbi];
    
}

- (IBAction)mealGoToList:(id)sender {
    MealsVC *mvc=[[MealsVC alloc]init];
    [[self navigationController]pushViewController:mvc animated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    autoCompleteTableView.hidden = YES;
    [[self view] endEditing:YES];
}

// Las dos acciones de elemento accesorio de teclado
-(void)cancelNumberPad{
    [mealRationTextEdit resignFirstResponder];
    mealRationTextEdit.text = @"";
}

-(void)doneWithNumberPad{
    [mealRationTextEdit resignFirstResponder];
}

// Evento de cambio de fecha de date Picker
- (void)DateChange:(id)sender
{
    NSDate *date =[mealDatePicker date];
    mealDateLabel = [dateFormat stringFromDate:date];
    [mealDateLabel setText:dateString];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    autoCompleteTableView.hidden = YES;
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // Cuando acabado de editar busco la posición del meal dentro del array
    // perteneciente a la palabra introducida
    indexSelected=[self getMealIndex:[textField text]];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexSelected inSection:0];//    // Además muevo el carrusel hasta donde toda y selecciono el elemento
    [mealCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    return YES;
}

// Evento de cambio de fecha de date Picker
- (void)mealDateChange:(id)sender
{
    NSDate *date =[mealDatePicker date];
    dateString = [dateFormat stringFromDate:date];
    [mealDateLabel setText:dateString];
    
}

/////////// METODOS DELEGATE collection controller //////////////////

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame=collectionView.bounds;
    //    frame.size.width-=100;
    frame.size.width=100;
    frame.size.height=80;
    
    return frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return pages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView // CARGO CELDA QUE APARECERÁ
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a prototype cell and set the label to indicate the page
    CustomCell *cell = [collectionView
                        dequeueReusableCellWithReuseIdentifier:@"Cell"
                        forIndexPath:indexPath
                        ];
    
    // Ahora accedo a la imagen correspondiente al índice
    UIImage *cellImage=[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:[indexPath item]]thumbnailForSetMenu];
    
    if (cellImage!=nil) { // Si hay imagen borro texto que hubiese y meto imagen
        cell.label.text=NULL;
        cell.backgroundColor = [UIColor colorWithPatternImage:cellImage];

    }else{ // Si no hay imagen, utilizo el label de la celda para poner información
        cell.backgroundColor=[UIColor whiteColor];
        cell.label.numberOfLines=2;
        NSString *s=[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:[indexPath item]]mealName];
         NSString *s2=[[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:[indexPath item]]rationValue]stringValue];
        cell.label.text =[[s stringByAppendingString:@"\n"]stringByAppendingString:s2];
        cell.label.textColor=[UIColor blackColor];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *s=[[[[SDCMealStore sharedStore]allMeals]objectAtIndex:indexPath.item]mealName];
    [mealNameTextEdit setText:s];
    [mealCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

////////////// Métodos del autocomplete ////////////////


// Siguiente método va recibiendo actualizaciones string nombre
// su objectivo, es comparar con los strings de los nombres de la base
// de datos, e ir refrescando la tabla si encuentra o no coincidencias
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // The items in this array is what will show up in the table view
    [mealAutoComplete removeAllObjects];

    for(NSString *curString in mealNames) {
        NSRange substringRangeLowerCase = [curString.lowercaseString rangeOfString:substring.lowercaseString];
       NSRange substringRangeUpperCase = [curString.uppercaseString rangeOfString:substring.uppercaseString];
       if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location==0) {
            [mealAutoComplete addObject:curString];
       }
    }

    [autoCompleteTableView reloadData];
    // Dinámicamente, voy cambiando el tamaño de la tabla en función del número de filas:
    CGRect r=[autoCompleteTableView frame];
    r.size.height=[autoCompleteTableView rowHeight]*mealAutoComplete.count;
    [autoCompleteTableView setFrame:r];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autoCompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
        
    //[autoCompleteTableView deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationTop];
    // Modifico el tamaño en función del número de sugerencias
    return mealAutoComplete.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.text = [mealAutoComplete objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Busco el indice teniendo en cuenta donde pulso de la tabla
    indexSelected=[self getMealIndex:[mealAutoComplete objectAtIndex:[indexPath row]]];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    mealNameTextEdit.text = selectedCell.textLabel.text;
    [mealNameTextEdit resignFirstResponder];
    autoCompleteTableView.hidden = YES;
    
}

 // Consigo el índice del nombre introducido. Ademas muevo el collection
// view hasta su posición
-(NSInteger *)getMealIndex:(NSString *) substring{
    for (int i=0; i<[mealNames count]; i++) {
        NSString *curString=[mealNames objectAtIndex:i];
        NSRange substringRangeLowerCase = [curString.lowercaseString rangeOfString:substring.lowercaseString];
        NSRange substringRangeUpperCase = [curString.uppercaseString rangeOfString:substring.uppercaseString];
        if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location==0) {
            indexSelected=i;
        
        }
    }
    
    return indexSelected;
    
    

}



@end
