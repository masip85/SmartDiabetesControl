//
//  SDCDetailViewController.m
//  Smart Diabetes Control
//
//  Created by ladmin on 01/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCDetailViewController.h"
#import "SDCGlucosePercent.h"
#import "SDCGlucoseView.h"
#import "SDCGlucoseRegisterVC.h"
#import "SDCMeasureStore.h"
#import "SDCRegisterDatesVC3.h"
#import "SDCConstants.h"
#import "SDCGlucoseScroll.h"

@implementation SDCDetailViewController
@synthesize ellipse,point;
@synthesize glucoseView;
@synthesize detailPeriodLabel;
@synthesize untilDate,sinceDate,stringDate;
@synthesize am,pm;
@synthesize glucoseScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([deviceString isEqualToString:@"iPhone5"]) {
        self=[super initWithNibName:@"SDCDetailViewController_iPhone5" bundle:nil];
    }else{
        
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)setTitleLabel:(int) index{
    switch (index) {
        case 1:
            [detailTitleLabel setText:@"Información desayuno"];
            break;
        case 2:
            [detailTitleLabel setText:@"Información almuerzo"];
            break;
        case 3:
            [detailTitleLabel setText:@"Información comida"];
            break;
        case 4:
            [detailTitleLabel setText:@"Información merienda"];
            break;
        case 5:
            [detailTitleLabel setText:@"Información cena"];
            break;
        default:
            [detailTitleLabel setText:@"Información snack"];
            break;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Cuando el punto sea tocado,llmará a esta notificación.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMeasureLabelEvent:)
                                                 name:@"chageDetailMeasureLabel"
                                               object:nil];
    
    // Edito labels. Le doy valor de la elipse cuyos datos se visualizan.
    //Ojo,si no visualizo elipse es que estoy visualizando punto
    if ([self ellipse]) { 
        [self setTitleLabel:[[self ellipse] clusterIndex]];
    }else{
        [self setTitleLabel:[[self point] clusterIndex]];
    }
    
       // Le doy tamaño a glucose scroll
    [self setGlucoseScroll:[[SDCGlucoseScroll alloc]initWithFrame:[detailCloudViewToScrollFrame frame]]] ;
    [self.view addSubview:[self glucoseScroll]];
    
    //Añado glucoseView
    CGRect bigRect=[[[[[self navigationController]viewControllers]objectAtIndex:0]glucoseView]bounds];
    glucoseView=[[SDCGlucoseView alloc]initWithFrame:bigRect];
    
    [glucoseView setPlotInDetailVC:YES];
    [glucoseView setClusterIndex:[ellipse clusterIndex]]; // Le digo a la pinta de glucosa que (puntos de )cluster tiene que dibujar
    // Le digo a glucose view que se va a pintar aquí.
    [glucoseView setAm:[self am]];
    [glucoseView setPm:[self pm]];
    
    
}

-(void)dealloc{
    // Obligatorio en notificaciones:
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self reloadCloudView];
    [self setStatisticsFromDrawedPoints];
}

-(void)reloadCloudView{

    //Modifico label periodo
    [detailPeriodLabel setText:[self stringDate]];
    
    // Establezco los puntos que entran en el nuevo periodo
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]];
    [glucoseView setMeasurePointsAndClusters]; //ahora Glucose view ya sabe los clusters y los puntos que dibuja
    [glucoseView drawRect:[glucoseView bounds]];
    
    [[self glucoseScroll] setScrollEnabled:FALSE];
    [[self glucoseScroll] setDelegate:self];// You will get a warning here, ignore it for now
    [[self glucoseScroll] addSubview:glucoseView];
    [[self glucoseScroll] setMaximumZoomScale:4];
    [[self glucoseScroll] setZoomScale:[[self glucoseScroll] frame].size.height/[ellipse frame].size.height];
    CGRect zoomRect = [self zoomRectForScrollView:[self glucoseScroll] withScale:[[self glucoseScroll] zoomScale] withCenter:[ellipse framePointCenter]];
    [[self glucoseScroll] zoomToRect:zoomRect animated:YES];
    
}


-(void)setStatisticsFromDrawedPoints{
    
    //// Además,ahora procedemos a rellenar la información del cluster/elipse
    float sumGlucose;
    float maxValue=0;
    float minValue=1000;
    float hypoCount=0;
    float normoCount=0;
    float hyperCount=0;
    float sumVar=0;
    
    for (int i=0; i<[[glucoseView pointsToDraw]count]; i++){
        
        float aux=[[[[[glucoseView pointsToDraw] objectAtIndex:i]glucoseMeasure]glucoseValue]floatValue];
        sumGlucose+=aux;
        if(aux>maxValue){
            maxValue=aux;
        }
        if (aux<minValue) {
            minValue=aux;
        }
        if (aux<maxHypoGlucose) {
            hypoCount++;
        }else if (aux<=minHyperGlucose){
            normoCount++;
        }else{
            hyperCount++;
        }
    }
    
    //Ya tengo sumatorio media. procedo a obtener varianza
    for (int i=0; i<[[glucoseView pointsToDraw] count]; i++){
        float aux=[[[[[glucoseView pointsToDraw] objectAtIndex:i]glucoseMeasure]glucoseValue]floatValue];
        sumVar+=abs(aux-(sumGlucose/[[glucoseView pointsToDraw] count]));
    }
    
    // Añado información a la elipse
    [self setVarValue:sumVar/[[glucoseView pointsToDraw] count]];
    [self setMeanValue:sumGlucose/[[glucoseView pointsToDraw] count]];
    [self setMaxValue:maxValue];
    [self setMinValue:minValue];
    [self setHyperPercent:hyperCount/(hyperCount+hypoCount+normoCount)];
    [self setHypoPercent:hypoCount/(hyperCount+hypoCount+normoCount)];
    [self setNormoPercent:normoCount/(hyperCount+hypoCount+normoCount)];
    
    
    // Meto estos valores en sus labels
    if ([[glucoseView pointsToDraw] count]>2) { // Si hay más de un punto pinto todo
        [detailMeanValueLabel setText:[NSString stringWithFormat:@"%.0f mg/dl",[self meanValue]]];
        [detailMaxValueLabel setText:[NSString stringWithFormat:@"%.0f mg/dl",[self maxValue]]];
        [detailMinValueLabel setText:[NSString stringWithFormat:@"%.0f mg/dl",[self minValue]]];
        [detailVarValueLabel setText:[NSString stringWithFormat:@"%.0f mg/dl",[self varValue]]];
        [detailMeasureValueLabel setText:@"-"];
        SDCGlucosePercent *percentView=[[SDCGlucosePercent alloc]initWithFrame:[detailPercentRectView frame]];
        [[self view]addSubview:percentView];
        [percentView setNormoPercent:[self normoPercent]];
        [percentView setHypoPercent:[self hypoPercent]];
        [percentView setHyperPercent:[self hyperPercent]];
        [percentView setNeedsDisplay];
        
        
    }else{ // Si no es una elipse,es un dato suelto, y no quiero mostrar nada más que su valor
        [detailMeanValueLabel setHidden:YES];
        [detailMaxValueLabel  setHidden:YES];
        [detailMinValueLabel  setHidden:YES];
        [detailVarValueLabel  setHidden:YES];
        [detailMeanLabel setHidden:YES];
        [detailMaxLabel  setHidden:YES];
        [detailMinLabel  setHidden:YES];
        [detailVarLabel  setHidden:YES];
        [detailPercentRectView setHidden:YES];
        [glucoseScroll setHidden:YES]; //No pinto glucoseView tampoco
        NSString *s=[self getDetailMeasureValueLabelOfDate:[[ point glucoseMeasure]dateValue] andMeasure:[[[[self point] glucoseMeasure]glucoseValue]floatValue]];
        detailMeasureValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [detailMeasureValueLabel setNumberOfLines:0];//Tantas líneas como necesita
        [detailMeasureValueLabel setText:s];
        
    }

    
}




// de doy el recuadro del zoom si me das centro y escala
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return glucoseView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) changeMeasureLabelEvent:(NSNotification *) notification {
    NSDictionary* userInfo = [notification userInfo];
    SDCGlucoseMeasure *glucoseMeasure = [userInfo objectForKey:@"glucoseMeasure"];
    NSString *s=[self getDetailMeasureValueLabelOfDate:[glucoseMeasure dateValue] andMeasure:[ [glucoseMeasure glucoseValue]floatValue]];
    detailMeasureValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [detailMeasureValueLabel setNumberOfLines:0];//Tantas líneas como necesita
    [detailMeasureValueLabel setText:s];
}

-(NSString*) getDetailMeasureValueLabelOfDate:(NSDate*)date andMeasure:(float)measure // Le doy medida y fecha y me devuelve string
{
    if (measure!=0) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"' el 'dd/MM/YYYY 'a las'  HH:mm"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSString *glucoseString=[NSString stringWithFormat:@"%.0f mg/dl",measure];
        return [glucoseString stringByAppendingString:dateString];
        
    } else
        return @"- -";
}

- (IBAction)oneDayTouched:(id)sender {
    

    NSString *s=@"Último día";
    [self setStringDate:s];
    [detailMeasureValueLabel setText:@"-"];
    
    double day=-(24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:day]];
    [self setSinceDate:[NSDate date]];    
    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]];

    [self reloadCloudView];
    [self setStatisticsFromDrawedPoints];
}

- (IBAction)oneWeekTouched:(id)sender {
    double week=-(7*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:week]];
    [self setSinceDate:[NSDate date]];
    NSString *s=@"Última semana";
    [self setStringDate:s];
    [detailMeasureValueLabel setText:@"-"];

    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]];
    
    [self reloadCloudView];
    [self setStatisticsFromDrawedPoints];
}

- (IBAction)threeDaysTouched:(id)sender {
    double threeDays=-(3*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:threeDays]];
    NSString *s=@"Últimos 3 días";
    [self setStringDate:s];
    [detailMeasureValueLabel setText:@"-"];

    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]];
    
    [self reloadCloudView];
    [self setStatisticsFromDrawedPoints];
}
- (IBAction)oneMonthTouched:(id)sender {
    
    double month=-(30*24*60*60);
    [self setUntilDate:[[NSDate alloc]initWithTimeIntervalSinceNow:month]];
    [self setSinceDate:[NSDate date]];
    NSString *s=@"Último mes";
    [self setStringDate:s];
    [detailMeasureValueLabel setText:@"-"];

    [glucoseView setMeasureDrawUntil:[self untilDate] since:[self sinceDate]];
    
    [self reloadCloudView];
    [self setStatisticsFromDrawedPoints];
}

- (IBAction)calendarTouched:(id)sender {
    SDCRegisterDatesVC3 *calendarVC=[[SDCRegisterDatesVC3 alloc]init];
    [calendarVC setUntilDate:[self untilDate]];
    [calendarVC setSinceDate:[self sinceDate]];
    [[self navigationController]pushViewController:calendarVC animated:YES];
}



@end
