//
//  SDCSetsportVC.m
//  Smart Diabetes Control
//
//  Created by Mederi on 02/05/13.
//
//

#import "SDCSetSportVC.h"
#import "SDCSetInsulinVC.h"
#import "SDCSportStore.h"
#import "SDCSportMeasure.h"
#import "SDCSport.h"
#import "SDCImageStore.h"
#import "SDCMeasureStore.h"
#import "SportsVC.h"
#import "CollectionViewController.h"
#import "SDCSportDatesVC.h"
#import "CustomCell.h"
#import "LineLayout.h"
#import "CollectionViewController.h"
#import "SDCConstants.h"

@interface SDCSetSportVC ()

@end



const int SportCollectionBorderWidth=30;
NSString *dateString;
NSDateFormatter *dateFormat;
UICollectionView *sportCollectionView ;
NSInteger *indexSelected; // Contador de array que marca que alimento se selecciona. Determinado por collection view y autocomplete
int pages;
SDCSportMeasure *sportMeasure;

@implementation SDCSetSportVC

@synthesize sportNames;
@synthesize sportAutoComplete;
@synthesize autoCompleteTableView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCSetSportVC_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Deporte"];
        dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM/YYYY 'a las'  HH:mm"];
        
        sportMeasure=[[SDCSportMeasure alloc]init]; // Inicial
        [sportMeasure setDateStarted:[[NSDate alloc]init] ]; // Pongo fechas vacias por si no se introduce nada
        [self setTrack:[[NSMutableArray alloc]init]];
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{   // Recargo el collection View
    pages=[[[SDCSportStore sharedStore]allSports]count];
    sportCollectionView.reloadData;
    // Recargo datos de la tabla del autocomplete
    sportNames = [[NSMutableArray alloc] initWithObjects:nil];
    for (int i=0; i<[[[SDCSportStore sharedStore]allSports]count]; i++) { // Bucle crea array nombres
        NSString *s=[[[[SDCSportStore sharedStore]allSports]objectAtIndex:i]sportName];
        [sportNames addObject:s];
    }
    
    // Refresco labels date y duracion
    int i=[sportMeasure trackTime]/60;
    NSString *s=[NSString stringWithFormat:@"Duración: %d minutos",i,nil ];
    [sportFinishDateButton setTitle:s forState:UIControlStateNormal];
    
    dateString = [dateFormat stringFromDate:[sportMeasure dateStarted]];
    [sportStartDateButton setTitle:dateString forState:UIControlStateNormal];
    
    

    
    
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
    [sportFinishDateButton setTitle:dateString forState:UIControlStateNormal];
    [sportStartDateButton setTitle:@"Duración: 0" forState:UIControlStateNormal]; // Pongo fecha inicio actual
    // Pongo string al texto del medio
    [sportNameLabel setText:@"Deporte:"];
    [sportIntensitySlider setMaximumValue:100.0];
    [sportIntensitySlider setMinimumValue:0.0];
    [sportIntensitySlider setValue:50];
    

    /////// Configuro vector  el autocomplete
    sportNameTextEdit.delegate=self;
    sportNames = [[NSMutableArray alloc] initWithObjects:nil];
    for (int i=0; i<[[[SDCSportStore sharedStore]allSports]count]; i++) { // Bucle crea array nombres
        NSString *s=[[[[SDCSportStore sharedStore]allSports]objectAtIndex:i]sportName];
        [sportNames addObject:s];
    }
    sportAutoComplete = [[NSMutableArray alloc] init]; // Inicializo vector autocompletar
    
    /////// Configuro table del autocomplete
    CGRect tableRect=sportNameTextEdit.frame;
    tableRect.origin.y+=20;
    tableRect.size.width-=10;

    autoCompleteTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    autoCompleteTableView.delegate = self;
    autoCompleteTableView.dataSource = self;
    autoCompleteTableView.scrollEnabled = YES;
    autoCompleteTableView.hidden = YES;
    autoCompleteTableView.rowHeight=sportNameTextEdit.frame.size.height*0.75;
    
    [sportAutoComplete removeAllObjects];
    [self.view addSubview:autoCompleteTableView];
    

    /////// Configuro el collection    
    UICollectionViewFlowLayout *flowLayout = [[LineLayout alloc] init ];
    NSLog(@"%f,",sportViewToCollectionPlace.bounds.origin.x);
     sportCollectionView = [[UICollectionView alloc]
                           initWithFrame:sportViewToCollectionPlace.bounds
                           collectionViewLayout:flowLayout];
   // sportCollectionView.indexPathsForSelectedItems
    sportCollectionView.delegate = self;
    sportCollectionView.dataSource = self;
    sportCollectionView.showsHorizontalScrollIndicator = NO;
    [sportCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"Cell"];
    sportCollectionView.backgroundColor=[UIColor whiteColor];
    [sportCollectionView reloadData];
    [sportViewToCollectionPlace addSubview:sportCollectionView];
    pages=[[[SDCSportStore sharedStore]allSports]count]; // 1 to x


}

-(void)saveSportData:(NSNotification *)note{// Se activa con el boton ok de la barra. Guarda la medida en SharedStore
    indexSelected=[[[sportCollectionView indexPathsForSelectedItems]lastObject]row];
    NSNumber *intensity=[[NSNumber alloc]initWithFloat:[sportIntensitySlider value]];
    SDCSport *sportSelected=[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected];
    
    [sportMeasure setSport:sportSelected];
    [sportMeasure setTrack:[self track]];
    [sportMeasure setIntensityValue:intensity];
    // Los datos de fechas los guarda el controlador de vista de fechas

    [[SDCMeasureStore sharedStore]addSportMeasureToStore:sportMeasure]; // ¡GUARDO LA MEDIDA de DEPORTE!
    
    [self.navigationController popViewControllerAnimated:YES]; // Vuelvo a menu principal
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)goToInsulin:(NSNotification *)note{
//    
//    SDCSetInsulinVC *insulinVC=[[SDCSetInsulinVC alloc]init];
//    
//    [[self navigationController]pushViewController:insulinVC animated:YES];
//    
//    UIBarButtonItem *bbi=[[UIBarButtonItem alloc] initWithTitle:@"Fin" style:UIBarButtonItemStyleBordered target:insulinVC action:@selector(goToMenu:)];
//    [[insulinVC navigationItem] setRightBarButtonItem:bbi];
//}

- (IBAction)sportGoToList:(id)sender {
    SportsVC *mvc=[[SportsVC alloc]init];
    [[self navigationController]pushViewController:mvc animated:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    autoCompleteTableView.hidden = YES;
    [[self view] endEditing:YES];
}

- (IBAction)goToDate1:(id)sender {
    [self goToDates];
}

- (IBAction)gotoDate2:(id)sender {
    [self goToDates];
}

- (IBAction)goToDate3:(id)sender {
    [self goToDates];
}

- (IBAction)goToDate4:(id)sender {
    [self goToDates];
}

-(void)goToDates{
    SDCSportDatesVC *sdc=[[SDCSportDatesVC alloc]init];
    [sdc setSportMeasure:sportMeasure]; // Le paso al controlador de vista de las fechas la medida para que se encargue ella de actualizar sus valores
    [[self navigationController]pushViewController:sdc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    autoCompleteTableView.hidden = YES;
    [textField resignFirstResponder];
    //[sportIntensitySlider setValue:[[[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected]usualIntensity]floatValue]];

    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // Cuando acabado de editar busco la posición del sport dentro del array
    // perteneciente a la palabra introducida
    indexSelected=[self getSportIndex:[textField text]];
    [self setSliderAndLabel:[[[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected]usualIntensity]floatValue]];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexSelected inSection:0];//    // Además muevo el carrusel hasta donde toda y selecciono el elemento
    if ([[[SDCSportStore sharedStore]allSports]count]>0) {
          [sportCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    

    return YES;
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
    UIImage *cellImage=[[[[SDCSportStore sharedStore]allSports]objectAtIndex:[indexPath item]]thumbnailForSetMenu];
    
    if (cellImage!=nil) { // Si hay imagen borro texto que hubiese y meto imagen
        cell.label.text=NULL;
        cell.backgroundColor = [UIColor colorWithPatternImage:cellImage];

    }else{ // Si no hay imagen, utilizo el label de la celda para poner información
        cell.backgroundColor=[UIColor whiteColor];
        cell.label.numberOfLines=2;
        NSString *s=[[[[SDCSportStore sharedStore]allSports]objectAtIndex:[indexPath item]]sportName];
         NSString *s2=[NSString stringWithFormat:@"%d",[[[[[SDCSportStore sharedStore]allSports]objectAtIndex:[indexPath item]]usualIntensity]intValue]];
    
        cell.label.text =[[s stringByAppendingString:@"\n"]stringByAppendingString:s2];
        cell.label.textColor=[UIColor blackColor];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    indexSelected=indexPath.item;
    NSString *s=[[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected]sportName];
    [sportNameTextEdit setText:s];
    
    // Ir a la posición del collection view que he seleccionado
    [sportCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self setSliderAndLabel:[[[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected]usualIntensity]floatValue]];
    


}

////////////// Métodos del autocomplete ////////////////


// Siguiente método va recibiendo actualizaciones string nombre
// su objectivo, es comparar con los strings de los nombres de la base
// de datos, e ir refrescando la tabla si encuentra o no coincidencias
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // The items in this array is what will show up in the table view
    [sportAutoComplete removeAllObjects];

    for(NSString *curString in sportNames) {
        NSRange substringRangeLowerCase = [curString.lowercaseString rangeOfString:substring.lowercaseString];
       NSRange substringRangeUpperCase = [curString.uppercaseString rangeOfString:substring.uppercaseString];
       if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location==0) {
            [sportAutoComplete addObject:curString];
       }
    }

    [autoCompleteTableView reloadData];
    // Dinámicamente, voy cambiando el tamaño de la tabla en función del número de filas:
    CGRect r=[autoCompleteTableView frame];
    r.size.height=[autoCompleteTableView rowHeight]*sportAutoComplete.count;
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
    return sportAutoComplete.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.text = [sportAutoComplete objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Busco el indice teniendo en cuenta donde pulso de la tabla
    indexSelected=[self getSportIndex:[sportAutoComplete objectAtIndex:[indexPath row]]];
    [self setSliderAndLabel:[[[[[SDCSportStore sharedStore]allSports]objectAtIndex:indexSelected]usualIntensity]floatValue]];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    sportNameTextEdit.text = selectedCell.textLabel.text;
    [sportNameTextEdit resignFirstResponder];
    autoCompleteTableView.hidden = YES;

    
}

 // Consigo el índice del nombre introducido. Ademas muevo el collection
// view hasta su posición
-(NSInteger *)getSportIndex:(NSString *) substring{
    for (int i=0; i<[sportNames count]; i++) {
        NSString *curString=[sportNames objectAtIndex:i];
        NSRange substringRangeLowerCase = [curString.lowercaseString rangeOfString:substring.lowercaseString];
        NSRange substringRangeUpperCase = [curString.uppercaseString rangeOfString:substring.uppercaseString];
        if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location==0) {
            indexSelected=i;
        }
    }
    return indexSelected;
}

- (IBAction)intensityValueChanged:(id)sender {
    
    [self setSliderLabels];
}

-(void)setSliderLabels{
    
    if ([sportIntensitySlider value]<33){
        [sportIntensityLabel setText:@"Intensidad: Suave"];
    }else    if ([sportIntensitySlider value]<66){
        [sportIntensityLabel setText:@"Intensidad: Moderada"];
    } else{
        [sportIntensityLabel setText:@"Intensidad: Intensa"];
    }
}
-(void)setSliderAndLabel:(float)value{
    
    
    [sportIntensitySlider setValue:value];
    [self setSliderLabels];

    
    
}




@end
