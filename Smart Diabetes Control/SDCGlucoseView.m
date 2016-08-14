//
//  SDCGlucoseView.m
//  Smart Diabetes Control
//
//  Created by ladmin on 22/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SDCGlucoseView.h"
#import "SDCConstants.h"
#import "SDCMeasureStore.h"
#import "SDCPointView.h"
#import "SDCGlucoseMeasure.h"
#import "SDCConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "SDCEllipse.h"
#include <Accelerate/Accelerate.h>
#import "SDCDetailViewController.h"





@implementation SDCGlucoseView

@synthesize circleMinFillColor;
@synthesize circleHypoFillColor;
@synthesize circleNormalFillColor;
@synthesize circleHyperFillColor;
@synthesize circleMaxFillColor;
@synthesize circleFillColor;
@synthesize circleColor;
@synthesize am,pm;
@synthesize pointsToDraw;

@synthesize clusterIndex;
@synthesize plotInDetailVC;

NSMutableArray *cluster1;
NSMutableArray *cluster2;
NSMutableArray *cluster3;
NSMutableArray *cluster4;
NSMutableArray *cluster5;
NSMutableArray *clusters;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(self){
            
            // De inicio supongo que me voy a dibujar en GlucoseRegister
            [self setPlotInDetailVC:FALSE];

            //All HypnosisViews start with a clear background color
            [self setBackgroundColor:[UIColor clearColor]];
                
            // Trabajaremos con los radios
            maxCirclePix=(frame.size.width/2)-(percentSpaceLabels*(frame.size.width/2));
            maxLinealZonePix=maxCirclePix-(percentSpaceNoLinealExt*(frame.size.width/2));
            minLinealZonePix=(frame.size.width/2)*percentSpaceNoLinealInt;
            
            //Cuando ya tengo centro ya puedo dibujar puntos           
            widthLinealZonePix=maxLinealZonePix-minLinealZonePix;
            widthLinealZoneGlucose=maxHyperGlucose-minHypoGlucose;
            
            maxHyperPix=maxLinealZonePix;
            minHypoPix=minLinealZonePix;
            
            minHyperPix=(((minHyperGlucose-minHypoGlucose)*widthLinealZonePix)/widthLinealZoneGlucose)+minHypoPix;
            maxHypoPix=(((maxHypoGlucose-minHypoGlucose)*widthLinealZonePix)/widthLinealZoneGlucose)+minHypoPix;
            
            CGRect bounds=[self bounds];
            
            circleCenter.x=bounds.origin.x+bounds.size.width/2.0;
            circleCenter.y=bounds.origin.y+bounds.size.height/2.0;

        }
        
    }
    return self;
}

-(void)removeMeasures{

    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
}

-(void)didAddSubview:(UIView *)subview
    
{
    
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rectdirtyRect{
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();

    
    //////// RELLENO GRADIENTE
    UIColor *darkOrange=[UIColor orangeColor];
    float red4 = 0.0, green4 = 0.0, blue4 = 0.0, alpha4 = 0.0;
    
    if ([darkOrange respondsToSelector:@selector(getRed:green:blue:alpha:)]) // MARRON
        [darkOrange getRed:&red4 green:&green4 blue:&blue4 alpha:&alpha4];
    red4=red4-0.1;
    blue4=blue4-0.1;
    green4=green4-0.1;
    UIColor *darkOrange2=[[UIColor alloc]initWithRed:red4 green:green4 blue:blue4 alpha:1];
    [self drawMyCircle2:circleCenter extLineColor:[UIColor blackColor] extLineWidth:1 radio0:minHypoPix radio1:maxHypoPix radio2:minHyperPix radio3:maxHyperPix radio4:maxCirclePix color0:[UIColor whiteColor] color1:[UIColor redColor] color2:[UIColor greenColor] color3:[UIColor orangeColor] color4:darkOrange2 context:ctx];
    
    // Dibujo medidas
     [self drawEllipses:clusters];
    [self drawMeasurePoints:pointsToDraw];
   

    // Añado ejes y numeros de los labels
    [self drawMyAxes:ctx];
    [self refreshLabels];
    
}
-(void) drawMeasurePoints:(NSMutableArray*)points{
    
    for (int i=0; i<[points count]; i++){
        
        [self addSubview:[points objectAtIndex:i]];
        NSLog(@"Pintando punto: %@",NSStringFromCGPoint([[points objectAtIndex:i]center]));
        
    }

}

-(void) setMeasureDrawUntil:(NSDate*)ud since:(NSDate*)sd{
    
    for (int j=0; j<[[[SDCMeasureStore sharedStore]allGlucoseMeasures] count]; j++) {
//        NSLog(@"*_*%@",[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j]);
        [[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j]setDrawed:NO]; // No es pintable hasta que no se me diga lo contrario
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j]dateValue]];
        NSInteger hour = [components hour];
        
        NSDate *date=[[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j] dateValue];
        
        if ([date compare:ud]==NSOrderedDescending && [date compare:sd]==NSOrderedAscending){
            // Si entra dentro de la fecha hay que ver si coincide con el modo hora que se muestra
            if ([self am] && [self pm]) { // en 24h se muestra todo
                [[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j] setDrawed:YES];
            }else if ([self am]){
                
                if (hour<12) { // AM solo dibuja estas horas
                    [[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j] setDrawed:YES];
                }
                
            }else if ([self pm]){
                if (hour>=12) { //PM sólo dibuja estas horas
                    [[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:j] setDrawed:YES];
                }
                
            }
        }
        
    }
    
}


-(void)setMeasurePointsAndClusters{
    
    [self removeMeasures];   //Esto habria que mejorarlo y no  borrar todo cada vez
    
    pointsToDraw=[[NSMutableArray alloc]init]; // aqui almacenaré las vistas de los puntos que han sido dibujados
    NSMutableArray *allPoints=[[NSMutableArray alloc]init];
    cluster1=[[NSMutableArray alloc]init];
    cluster2=[[NSMutableArray alloc]init];
    cluster3=[[NSMutableArray alloc]init];
    cluster4=[[NSMutableArray alloc]init];
    cluster5=[[NSMutableArray alloc]init];

    
     for (int i=0; i<[[[SDCMeasureStore sharedStore]allGlucoseMeasures] count]; i++) { 
         
         if ([[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:i]drawed]){

            int glucoseValueModule=[[[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:i]glucoseValue] intValue];
             
            //Convierto la medida a su equivalente en pixeles
            float glucoseValueModulePix=(((glucoseValueModule-minHypoGlucose)*widthLinealZonePix)/widthLinealZoneGlucose)+(float)minHypoPix;
            

             // Ahora busco el ángulo de acuerdo a la hora y a am/pm
             NSCalendar *calendar = [NSCalendar currentCalendar];
             NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:i]dateValue]];
             NSInteger hour = [components hour];
             NSNumber *minute=[NSNumber numberWithFloat:[components minute]];
             float angle;
             if ([self am] && [self pm]) { // si 24h
                 // No hago nada con la hora, ya está en fomato 24h
                 angle=(hour+([minute floatValue]/60))*(360/24);

             }else if ([self am] ||[self pm]) {
                 if (hour>=12) {hour=hour-12;} // Le resto 12 horas
                 angle=(hour+([minute floatValue]/60))*(360/12);

             }
             
             angle=angle-90; //OJO,comienzo sistema angulo sist. trigonometrico VS comienzo angulo reloj
             float x= glucoseValueModulePix*cosf((angle*2*M_PI)/360);
             float y= glucoseValueModulePix*sinf((angle*2*M_PI)/360);
             x=x+circleCenter.x;
             y=y+circleCenter.y;
             
             CGRect pointFrame=CGRectMake(x, y, pointSize, pointSize); // Poner punto en x-y . La relación esquina/centro está corregida en la vista del punto
             
             SDCPointView *pv=[[SDCPointView alloc] initWithFrame:pointFrame]; // Creo punto en su posición
             [pv setPlotInDetailVC:[self plotInDetailVC]]; // Le digo donde está pintado,si en register o detail
             [pv setCenter:CGPointMake(x, y)]; // Establezco el valor centro:desde esquina frame a centro del punto
             [pv setAngle:angle];
             // Le asocio al punto su medida de glucosa
             [pv setGlucoseMeasure:[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:i]];
             
             // Creo clusters de puntos,teniendo en cuenta su medida. TAMBIEN LOS PINTO
             [self createClusters:pv ofMeasure:[[[SDCMeasureStore sharedStore]allGlucoseMeasures]objectAtIndex:i]];
             
              if([pv clusterIndex]==0 || [pv plotInDetailVC]==YES){ // Sólo quiero que el punto sea tocable si no estoy en una elipse o me muestro en el modo detalle
                  [pv setTouchableAction];
              }else{
                  if ([pv plotInDetailVC]==NO) {
                      [pv setTouchableActionToEllipse]; // si toco un punto dentro de una elipse, entonces le pasaré el evento a la elipse a la que pertenece. OJO, solo en glucose register,no en detailVC
                  }
              }
             
             [allPoints addObject:pv];

         }
     }
    

    
    // Estos clusters son solo agrupaciones por hora del dia
    clusters=[[NSMutableArray alloc] initWithObjects:cluster1,cluster2,cluster3,cluster4,cluster5, nil];
    pointsToDraw=[self filterPoints:allPoints];
   
    
   
//    //Agrupo puntos en cluster
//    NSMutableArray *clusters=[self obtainClusters:[self pointsDrawed]]; // Obtengo vector de clusters
//    // Dibujo clusters
//    [self drawClusters:clusters fromPoints:[self pointsDrawed]]; // Dibujar los clusters del montón de puntos dibujados

}

-(NSMutableArray*)filterPoints:(NSMutableArray*)allPoints{
    
    NSMutableArray *aux=[[NSMutableArray alloc]init];
    
    // Discrimino que puntos pinto si estoy en modo detalles o glucoseregisterVC

    if ([self plotInDetailVC]==FALSE) { // Si estamos en ventana detalles pinto todos los puntos sin filtrar
        return allPoints;
    }else{ 
        for (int i=0; i<[allPoints count]; i++){
            SDCPointView *pv= [allPoints objectAtIndex:i];
    
            // Si estoy en modo detalle,averiguo que elipse se está pintando, y pongo el punto si coincide que tiene que dibujarse
            if ([self clusterIndex]==[pv clusterIndex]) {
            [aux addObject:pv];
                NSLog(@"Filtrando punto: %@",NSStringFromCGPoint([pv center]));

            }
        
        }
        return aux;
    }
    
    
}

-(NSArray*)covariancesOfCluster:(NSMutableArray*)cluster withCenter:(CGPoint)center{
    
    float meanX=0;
    float meanY=0;
    
    //Calculo medias x e y
    for (int i=0; i<[cluster count]; i++){
        
        CGPoint point1=[[cluster objectAtIndex:i]center];
        point1.x-=(circleCenter.x+center.x); // Traslado ejes de coordenadas al centro de la elipse
        point1.y-=(circleCenter.y+center.y);
        
        //Calcula medias X e Y de todos los puntos
        meanX+=point1.x;
        meanY+=point1.y;
    }
    meanX=meanX/[cluster count]; // Da 0
    meanY=meanY/[cluster count];
//    
//    meanX=0;
//    meanY=0;
    

    
    float sum12_21=0;
    float sum11=0;
    float sum22=0;
    // Numerador covarianza_xy,xx,yy
    for (int i=0; i<[cluster count]; i++){
        CGPoint point1=[[cluster objectAtIndex:i]center];
        point1.x-=(circleCenter.x+center.x); // Traslado eje de coordenadas al centro de la elipse
        point1.y-=(circleCenter.y+center.y);
        
        sum12_21+=(point1.x-meanX)*(point1.y-meanY);
        sum11+=pow((point1.x-meanX),2);
        sum22+=pow((point1.y-meanY),2);
   
    }
    
    float covXY=sum12_21/([cluster count]-1);
    float covXX=sum11/([cluster count]-1);
    float covYY=sum22/([cluster count]-1);
    

    
    NSArray *covariances=[[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:covXX],[NSNumber numberWithFloat:covXY],[NSNumber numberWithFloat:covXY],[NSNumber numberWithFloat:covYY],nil];
    return covariances;
 
    
}


-(void)drawEllipses:(NSMutableArray*)clusters{
    
    if ([self plotInDetailVC]==FALSE) { // Solo dibujo elipses en registerVC
    for (int k=0; k<[clusters count]; k++) {
        
        NSMutableArray *cluster=[clusters objectAtIndex:k];
        
        if ([cluster count]<3) {
            
            for (int i=0; i<[cluster count]; i++){
            [[cluster objectAtIndex:i]setTouchableAction]; // Si el cluster tiene un punto o dos solamente, te permite ser tocable para abrir detalle
            }
            
        }else{ // Solo haré la elipse si el cluster tiene más de dos puntos
            
            
            float sumX=0;
            float sumY=0;
            float sumAngle=0;
            
            //Primero encuentro el centro
            for (int i=0; i<[cluster count]; i++){
                CGPoint point1=[[cluster objectAtIndex:i]center];
                sumX+=point1.x-circleCenter.x; // Traslado coordenadas al centro reloj.
                sumY+=point1.y-circleCenter.y;
                sumAngle+=[[cluster objectAtIndex:i] angle]; //Grados
            }
            float centerX=(float)(sumX/[cluster count]);
            float centerY=(float)(sumY/[cluster count]);
            CGPoint centerFromClock=CGPointMake(centerX, centerY); //Defino centro elipse desde centro reloj
            CGPoint centerFrame=CGPointMake(centerX+circleCenter.x, centerY+circleCenter.y);
            
//            //Dibujo centro
//            UIView *v=[[SDCPointView alloc]initWithFrame:CGRectMake(centerFrame.x, centerFrame.y, 5, 5)];
//            [v setBackgroundColor:[UIColor redColor]];
//            [self addSubview:v];
            
    
            ////LAPACK!
            char JOBZ = 'V'; //Compute eigenvalues and eigenvectors.
            char UPLO = 'U'; // Upper triangle of A is stored;
            __CLPK_integer const N=2;
            __CLPK_integer const LDA=2;
            __CLPK_integer LWORK=3*N-1;
            __CLPK_integer info;
            __CLPK_doublereal W[N];
            __CLPK_doublereal WORK[LWORK];
            
            // La matriz de covarianzas,define la elipse, cuyo centro de coordenadas es el centro de la elipse
            NSArray *covariances=[self covariancesOfCluster:cluster withCenter:centerFromClock];
            
            float cov11=[[covariances objectAtIndex:0]floatValue]*factorSTD;
            float cov12=[[covariances objectAtIndex:1]floatValue]*factorSTD;
            float cov21=[[covariances objectAtIndex:2]floatValue]*factorSTD;
            float cov22=[[covariances objectAtIndex:3]floatValue]*factorSTD;
            __CLPK_doublereal A[LDA][N]= {
                cov11, cov21,  // The first column of A
                cov12, cov22,   // the second column of A
            };
            
            dsyev_(&JOBZ, &UPLO, &N, A, &LDA, &W, &WORK, &LWORK, &info); //Lapack. Eigen values en W y eigenvectors en A


            float axisX=sqrtf(W[0]);
            float axisY=sqrtf(W[1]);
            
            // Defino cuadrado de la elipse colocado centro con centro
            CGRect rectEllipse=CGRectMake((circleCenter.x+centerFromClock.x)-axisX, (circleCenter.x+centerFromClock.y)-axisY, axisX*2, axisY*2);
            // Pongo elipse en cuadrado
            SDCEllipse *ellipse=[[SDCEllipse alloc]initWithFrame:rectEllipse];
            [ellipse setFramePointCenter:centerFrame];
            [ellipse setClusterIndex:[[cluster objectAtIndex:1]clusterIndex]]; // le doy a la elipse el indice cluster de una de sus variables
            
            [self addSubview:ellipse];
            //Giro la elipse acorde inclinación autovector columna 2 matriz A, (corresponde a la inclinación ejeX)
            CGAffineTransform transform=CGAffineTransformMakeRotation(-atan2f(A[0][1], A[1][1]));
            
            [ellipse setTransform:transform];
            
            //// Además,ahora procedemos a rellenar la información del cluster/elipse
            
            float sumGlucose;
            float maxValue=0;
            float minValue=1000;
            float hypoCount=0;
            float normoCount=0;
            float hyperCount=0;
            float sumVar=0;
            
            
            for (int i=0; i<[cluster count]; i++){
                float aux=[[[[cluster objectAtIndex:i]glucoseMeasure]glucoseValue]floatValue];
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
            for (int i=0; i<[cluster count]; i++){
                float aux=[[[[cluster objectAtIndex:i]glucoseMeasure]glucoseValue]floatValue];
                sumVar+=abs(aux-(sumGlucose/[cluster count]));
            }
            
            // Añado información a la elipse
            [ellipse setVarValue:sumVar/[cluster count]];
            [ellipse setMeanValue:sumGlucose/[cluster count]];
            [ellipse setMaxValue:maxValue];
            [ellipse setMinValue:minValue];
            [ellipse setHyperPercent:hyperCount/(hyperCount+hypoCount+normoCount)];
            [ellipse setHypoPercent:hypoCount/(hyperCount+hypoCount+normoCount)];
            [ellipse setNormoPercent:normoCount/(hyperCount+hypoCount+normoCount)];
            
        }
    } // flor clusters
    } // If estamos en gluseRegisterVC
}

-(int)createClusters:(SDCPointView *)pv ofMeasure:(SDCGlucoseMeasure*)gm{
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[gm dateValue]];
    
    // Condición para estar  entre las horas: o estoy en las horas de dentro, o si estoy en el limite comparo los minutos
    if ((comp.hour<breakfastHourUp && comp.hour>breakfastHourDown)||(comp.hour==breakfastHourUp&& comp.minute<=breakfastMinuteUp)||(comp.hour==breakfastHourDown&&comp.minute>=breakfastMinuteDown)) {
        [pv setBackgroundColor: [UIColor brownColor]];
        [cluster1 addObject:pv]; // Introduzco la vista en mis vectores de cluster correspondiente
        [pv setClusterIndex:1]; // Y le asigno el mismo valor del indice del nombre del cluster, que es +1 de la pos de vector clusters
    }else if ((comp.hour<brunchHourUp && comp.hour>brunchHourDown)||(comp.hour==brunchHourUp&& comp.minute<=brunchMinuteUp)||(comp.hour==brunchHourDown&&comp.minute>=breakfastMinuteDown)){
        [pv setBackgroundColor:[UIColor cyanColor]];
        [cluster2 addObject:pv];
        [pv setClusterIndex:2];
    }else if ((comp.hour<lunchHourUp && comp.hour>lunchHourDown)||(comp.hour==lunchHourUp&& comp.minute<=lunchMinuteUp)||(comp.hour==lunchHourDown&&comp.minute>=lunchMinuteDown)){
        [pv setBackgroundColor:[UIColor blueColor]];
        [cluster3 addObject:pv];
        [pv setClusterIndex:3];
    }else if ((comp.hour<snackHourUp && comp.hour>snackHourDown)||(comp.hour==snackHourUp&& comp.minute<=snackMinuteUp)||(comp.hour==snackHourDown&&comp.minute>=snackMinuteDown)){
        [pv setBackgroundColor:[UIColor magentaColor]];
        [cluster4 addObject:pv];
        [pv setClusterIndex:4];
    }else if ((comp.hour<supperHourUp && comp.hour>supperHourDown)||(comp.hour==supperHourUp&& comp.minute<=supperMinuteUp)||(comp.hour==supperHourDown&&comp.minute>=supperMinuteDown)){
        [pv setBackgroundColor:[UIColor greenColor]];
        [cluster5 addObject:pv];
        [pv setClusterIndex:5];
    }else{
        [pv setBackgroundColor:[UIColor blackColor]];
        [pv setClusterIndex:0];
    }

}



-(float)euclidianDistanceFromRect:(CGRect)frameStart toRect:(CGRect)frameFinish{
    
    float aux=frameFinish.origin.x-frameStart.origin.x;
    float aux2=frameFinish.origin.y-frameStart.origin.y;
    return sqrtf((powf(aux, 2))+(powf(aux2, 2)));
    
}

-(void)refreshLabels{
    
    if ([self am] && ![self pm]) {
        north.text=@"12";
        south.text=@"6";
        east.text=@"3";
        west.text=@"9";
    }else if ([self pm] && ![self am]){
        north.text=@"24";
        south.text=@"18";
        east.text=@"15";
        west.text=@"21";
    }else if ([self am] && [self pm]){
        north.text=@"24";
        south.text=@"12";
        east.text=@"6";
        west.text=@"18";
    }
    
}
-(void)drawMyAxes:(CGContextRef)ctx{
    
  
    north=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x-((percentSpaceLabels*self.frame.size.width)/2), circleCenter.y-maxCirclePix-(percentSpaceLabels*self.frame.size.width), percentSpaceLabels*self.frame.size.width, percentSpaceLabels*self.frame.size.width)];
    north.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    north.text=@"12";
    north.textAlignment=NSTextAlignmentCenter;
    [self addSubview:north];
    
    south=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x-((percentSpaceLabels*self.frame.size.width)/2), circleCenter.y+maxCirclePix, percentSpaceLabels*self.frame.size.width, percentSpaceLabels*self.frame.size.width)];
    south.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    south.text=@"6";
    south.textAlignment=NSTextAlignmentCenter;
    [self addSubview:south];
    
    
    east=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x+maxCirclePix, circleCenter.y-(percentSpaceLabels*self.frame.size.width)/2, percentSpaceLabels*self.frame.size.width, percentSpaceLabels*self.frame.size.width)];
    east.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    east.text=@"3";
    east.textAlignment=NSTextAlignmentCenter;
    [self addSubview:east];
    
    west=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x-(percentSpaceLabels*self.frame.size.width)-maxCirclePix, circleCenter.y-(percentSpaceLabels*self.frame.size.width)/2, percentSpaceLabels*self.frame.size.width, percentSpaceLabels*self.frame.size.width)];
    west.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    west.text=@"9";
    west.textAlignment=NSTextAlignmentCenter;
    [self addSubview:west];
        int linesWidth=2;
    
    
    
    [self drawLabelsCircleOfRadio:minHypoPix andValue:minHypoGlucose];
        [self drawLabelsCircleOfRadio:maxHypoPix andValue:maxHypoGlucose];
        [self drawLabelsCircleOfRadio:minHyperPix andValue:minHyperGlucose];
        [self drawLabelsCircleOfRadio:maxHyperPix andValue:maxHyperGlucose];
//    maxHypoValueLabel=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x, circleCenter.y, 5, 5)];
//    maxHypoValueLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//    [maxHypoValueLabel setFont:[UIFont fontWithName:@"Helvetica" size:8]];
//    maxHypoValueLabel.text=[NSString stringWithFormat:@"%d",maxHypoGlucose];
//    // Se adapta al tamaño del contenido,es decir del texto. Así consigo alineación vertical respecto al frame.
//    [maxHypoValueLabel sizeToFit];
//    maxHypoValueLabel.textAlignment=NSTextAlignmentCenter;
//    [maxHypoValueLabel setFrame:CGRectMake(circleCenter.x-maxHypoValueLabel.frame.size.width/2,circleCenter.y-maxHypoPix-maxHypoValueLabel.frame.size.height/2,maxHypoValueLabel.frame.size.width,maxHypoValueLabel.frame.size.height) ];
//    [self addSubview:maxHypoValueLabel];
    
    
    
    // Dibujo los ejes reloj
    CGContextSetPatternPhase(ctx, CGSizeMake(3.0, 2.0));
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.1);
    CGContextMoveToPoint(ctx, circleCenter.x,circleCenter.y ); //start at this point
    CGContextSetLineWidth(ctx,linesWidth);
    CGContextAddLineToPoint(ctx, circleCenter.x+maxCirclePix, circleCenter.y); //draw to this point
    CGContextStrokePath(ctx);
    CGContextMoveToPoint(ctx, circleCenter.x,circleCenter.y ); //start at this point
    CGContextSetLineWidth(ctx,linesWidth);
    CGContextAddLineToPoint(ctx, circleCenter.x-maxCirclePix, circleCenter.y); //draw to this point
    CGContextStrokePath(ctx);
    CGContextMoveToPoint(ctx, circleCenter.x,circleCenter.y ); //start at this point
    CGContextSetLineWidth(ctx,linesWidth);
    CGContextAddLineToPoint(ctx, circleCenter.x, circleCenter.y+maxCirclePix); //draw to this point
    CGContextStrokePath(ctx);
    CGContextMoveToPoint(ctx, circleCenter.x,circleCenter.y ); //start at this point
    CGContextSetLineWidth(ctx,linesWidth);
    CGContextAddLineToPoint(ctx, circleCenter.x, circleCenter.y-maxCirclePix); //draw to this point
    CGContextStrokePath(ctx);

}

-(void) drawLabelsCircleOfRadio:(float)arcRadius andValue:(int)gv{
    
    //Dibujo unidades glucosa en el aro
    UILabel *labelArc=[[UILabel alloc] initWithFrame:CGRectMake(circleCenter.x, circleCenter.y, 5, 5)];
    labelArc.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [labelArc setFont:[UIFont fontWithName:@"Helvetica" size:8]];
    labelArc.text=[NSString stringWithFormat:@"%d",gv];
    // Se adapta al tamaño del contenido,es decir del texto. Así consigo alineación vertical respecto al frame.
    [labelArc sizeToFit];
    labelArc.textAlignment=NSTextAlignmentCenter;
    [labelArc setFrame:CGRectMake(circleCenter.x-labelArc.frame.size.width/2,circleCenter.y-arcRadius-labelArc.frame.size.height/2,labelArc.frame.size.width,labelArc.frame.size.height) ];
    [self addSubview:labelArc];
    
}

-(void) drawMyCircle2:(CGPoint)center extLineColor:(UIColor *)extLineColor  extLineWidth:(int)extLineWidth 
               radio0:(float)r0 radio1:(float)r1 radio2:(float)r2 radio3:(float)r3 radio4:(float)r4 color0:(UIColor *)color0 color1:(UIColor *)color1 color2:(UIColor *)color2 color3:(UIColor *)color3 color4:(UIColor *)color4 context:(CGContextRef)ctx
{
    CGPoint myStartPoint, myEndPoint;
    
    myStartPoint.x = center.x;
    myStartPoint.y = center.y;
    myEndPoint=myStartPoint;
    
    float red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 = 0.0;
    if ([color0 respondsToSelector:@selector(getRed:green:blue:alpha:)]) // BLANCO
        [color0 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    float red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 = 0.0;
    if ([color1 respondsToSelector:@selector(getRed:green:blue:alpha:)]) // ROJO
        [color1 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    float red3 = 0.0, green3 = 0.0, blue3 = 0.0, alpha3 = 0.0;
    if ([color2 respondsToSelector:@selector(getRed:green:blue:alpha:)]) // VERDE
        [color2 getRed:&red3 green:&green3 blue:&blue3 alpha:&alpha3];
    float red4 = 0.0, green4 = 0.0, blue4 = 0.0, alpha4 = 0.0;
    if ([color3 respondsToSelector:@selector(getRed:green:blue:alpha:)]) // MARRON
        [color3 getRed:&red4 green:&green4 blue:&blue4 alpha:&alpha4];
    float red5 = 0.0, green5 = 0.0, blue5 = 0.0, alpha5 = 0.0;
    if ([color4 respondsToSelector:@selector(getRed:green:blue:alpha:)]) // BLANCO
        [color4 getRed:&red5 green:&green5 blue:&blue5 alpha:&alpha5];
    
    size_t num_locations = 9;
    // Normalizo radios
    float nn0=r0/r4; // minhypo
    float n01=(nn0+0)/2; // punto medio
    float n1=r1/r4; // maxhypo
    float n11=(n1+nn0)/2; // punto medio
    float n2=r2/r4; // minhyper
    float n21=(n2+n1)/2; // punto medio
    float n3=r3/r4; // maxhyper
    float n31=(n3+n2)/2; // punto medio
    float n4=r4/r4; //=1 // max circle
    float n41=(n4+n3)/2; // punto medio
    
    // Localizaciones de fuera a dentro de 0 a 1
    CGFloat locations[9] = {0,n01,nn0,n11,n21,n2,n31,(n31+n4)/2,n41};
    
    // Colores de fuera a dentro
    CGFloat components[36] = {red1,green1,blue1,alpha1,red2,green2,blue2,alpha2,red2,green2,blue2,alpha2,red2,green2,blue2,alpha2,red3,green3,blue3,alpha3,red4,green4,blue4,alpha4,red5,green5,blue5,alpha5,red5,green5,blue5,alpha5,red1,green1,blue1,alpha1};
    
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                                    locations, num_locations);
    
    CGContextDrawRadialGradient(ctx, myGradient, myStartPoint, 0, myEndPoint, r4, kCGGradientDrawsAfterEndLocation);

    CGContextSetAlpha(ctx, 0.2);
    CGContextSetLineWidth(ctx, extLineWidth); // Grosor pincel
    CGContextAddArc(ctx, center.x, center.y, r0 , 0.0, M_PI*2.0, YES);
    CGContextMoveToPoint(ctx, center.x+r1, center.y);
    CGContextAddArc(ctx, center.x, center.y, r1 , 0.0, M_PI*2.0, YES);
    CGContextMoveToPoint(ctx, center.x+r2, center.y);
    CGContextAddArc(ctx, center.x, center.y, r2 , 0.0, M_PI*2.0, YES);
    CGContextMoveToPoint(ctx, center.x+r3, center.y);
    CGContextAddArc(ctx, center.x, center.y, r3 , 0.0, M_PI*2.0, YES);
//    CGContextMoveToPoint(ctx, center.x+r4, center.y);
//    CGContextAddArc(ctx, center.x, center.y, r4 , 0.0, M_PI*2.0, YES);
    CGContextStrokePath(ctx);

}

// Devuelve la el controlador de vista padre:UIView is a subclass of UIResponder. UIResponder lays out the method -nextResponder with an implementation that returns nil. UIView overrides this method, as documented in UIResponder (for some reason instead of in UIView) as follows: if the view has a view controller, it is returned by -nextResponder. If there is no view controller, the method will return the superview.
- (UIViewController *)viewController {
    if ([self.nextResponder isKindOfClass:UIViewController.class])
        return (UIViewController *)self.nextResponder;
    else
        return nil;
    
}
@end
