//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyCoreLocationController.h"
#import "MCLPOIStore.h"
#import "MCLVisitStore.h"
#import "MCLTrackStore.h"
#import "MCLTrack.h"
#import "CLLocationDispatch.h"
#import "MCLVisit.h"
#import "SDCConstants.h"
#import "SDCConstants.h"


@implementation MyCoreLocationController

@synthesize locationManager, delegate,lastAccurateLocation;//firstLocationApp;





// Variables mias a las que no necesito que accedan otras clases que implementen mi archivo de cabecera.
NSDate *firstLocationTime;
MCLTrack *lastTrack;
Boolean *firstLocationView;
NSDate const *bedTimeUp;
NSDate const *bedTimeDown;
CLLocation *lastPOILocation;
NSMutableArray *locationAccuracyBuffer;
NSMutableArray *locationSpeedAverageBuffer;

// Me facilito los logs de enum
-(NSString *)stringModes:(modes *)input {
    NSArray *arr = @[
                     @"PRECISO",            
                     @"BAJOCONSUMO",          
                     @"PRECISOCORTO",         
                     @"PRECISOPOI",
                     @"PRECISODEPORTE"
                     ];
    return (NSString *)[arr objectAtIndex:input];
}
-(NSString *)stringSpeed:(modes *)input {
    NSArray *arr = @[
                     @"PARADO",
                     @"ANDANDO",
                     @"DEPORTE",
                     @"MOTOR",
                     ];
    return (NSString *)[arr objectAtIndex:input];
}


- (id)init {
	self = [super init];
	
	if(self != nil) {
        
        
//        #if TARGET_IPHONE_SIMULATOR
//        [CLLocationDispatch sharedDispatch]; // Crea objecto, se inicializa,creando a su vez location manager
//        [[CLLocationDispatch sharedDispatch]addListener:self];
//        [[CLLocationDispatch sharedDispatch]startDemoWithLogFile : @"eci1mayo.archive" startLocationIndex:420];
//        
//        NSLog(@"Cargando ruta");
//        
//        #else
        // Creo Location Manager
		locationManager = [[CLLocationManager alloc] init];

		[locationManager setDelegate: self];        //#endif
//        #endif
        //Creo Centro de notificaciones
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willResignActiveEvent:)
                                                     name:@"UIApplicationWillResignActive"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(foregroundEvent:)
                                                     name:@"UIapplicationWillEnterForeground"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(terminateEvent:)
                                                     name:@"UIapplicationWillTerminate"
                                                   object:nil];
        mode=PRECISO; // Inicializo el GPS en preciso
        [locationManager startUpdatingLocation];
        
        locationSpeedAverageBuffer=[[NSMutableArray alloc]init];
        locationAccuracyBuffer=[[NSMutableArray alloc]init];

        shortAccurateTriggered=FALSE; // Variable control de disparo de secuencia-corta-precisa en mode bajo consumo
        
        // Defino bedTime limites entre las cuales miraré donde duerme
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setHour:bedTimeHourUp];
        [comps setMinute:bedTimeMinuteUp];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        bedTimeUp = [gregorian dateFromComponents:comps];
        [comps setHour:bedTimeHourDown];
        [comps setMinute:bedTimeMinuteDown];
        bedTimeDown = [gregorian dateFromComponents:comps];
        firstLocationView=TRUE;
               
	}
	
	return self;
}

- (void) willResignActiveEvent:(NSNotification *) notification {
    NSLog(@"App se irá a Background");
//    [locationManager stopUpdatingLocation];
//    [locationManager startMonitoringSignificantLocationChanges];
    [self locGoToMode:BAJOCONSUMO];
    appMode=BACKGROUND;    
}

- (void) foregroundEvent:(NSNotification *) notification {
    NSLog(@"App volverá a primer plano");
//    [locationManager stopMonitoringSignificantLocationChanges];
//    [locationManager startUpdatingLocation];
    [self locGoToMode:PRECISO];
    appMode=ACTIVA;    
}

- (void) terminateEvent:(NSNotification *) notification {
    NSLog(@"MATANDO APLICACIÓN");

}



-(void) queryGooglePlaces: (NSString *) googleType atPage:(NSString *)pageToken {
    
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    ////tps://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", lastAccurateLocation.coordinate.latitude, lastAccurateLocation.coordinate.longitude, [NSString stringWithFormat:@"%i", radius],googleType,kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    // Retrieve the results of the URL.
    
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    //Write out the data to the console.
    NSLog(@"Google Data places obtained: %d", [places count]);
    
    CLLocationCoordinate2D loc2D;
    // Cuando consigo datos los añado a mi base de datos de POI
    for (int i=0; i<[places count]; i++) {
        
        // Extraigo los datos del diccionario json de google,y le paso los parametros que quiero a locationcoordinate2d
        loc2D.latitude=[[[[[places objectAtIndex:i] objectForKey:@"geometry"]  objectForKey:@"location"]objectForKey:@"lat"] doubleValue];
        loc2D.longitude=[[[[[places objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location" ]objectForKey:@"lng"] doubleValue];
        NSLog(@"Nuevo POI: Longitud:  %f - Latitud:%f",loc2D.longitude,loc2D.latitude);

        [[MCLPOIStore sharedStore]addPOI:[[MCLPOI alloc]initWithLocationCoordinate:loc2D kind:GIMANSIO]];
        
        
        [delegate addPOIPins:loc2D called:searchPOIName];
        
    }

}




-(CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)originCoordinate toCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    CLLocation *originLocation = [[CLLocation alloc] initWithLatitude:originCoordinate.latitude longitude:originCoordinate.longitude];
    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:destinationCoordinate.latitude longitude:destinationCoordinate.longitude];
    CLLocationDistance distance = [originLocation distanceFromLocation:destinationLocation];
    
    return distance;
}




// Método que compara distancia y devuelve Booleano para checkClosePOI
-(BOOL*)aroundPOI:(MCLPOI *)poi{
    
    if([self distanceFrom: lastAccurateLocation.coordinate toCoordinate:poi.locationCoordinate]<aroundLimit)
        return YES;
    else
        return NO;
}

-(BOOL*)herePOI:(MCLPOI *)poi{
    if([self distanceFrom: lastAccurateLocation.coordinate toCoordinate:poi.locationCoordinate]<hereLimit)
        return YES;
    else
        return NO;
}

// Compruebo de los puntos de interés cuales están cerca
-(BOOL *)checkAroundPOI{

    BOOL aux=FALSE;
    for(int i=0; i<[[[MCLPOIStore sharedStore]allPOI]count];i++){

        if([self aroundPOI:[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]]) // Si estoy cerca grabo en ese POI estado around=true
        {
            [[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]setAround:TRUE]; // TRUE para el campo around del POI
            aux=TRUE;
            NSLog(@"Estoy around del poi %d",i);
        }
        else{
            [[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]setAround:FALSE];
        }
    }

    if(aux) // Si hay algun around cerca aux=TRUE
        return TRUE;
    else // Si aux no es true es que TODAS eran false: ningún around
        return FALSE;
}

-(BOOL *)checkHerePOI{
    
    BOOL aux=FALSE;
    for(int i=0; i<[[[MCLPOIStore sharedStore]allPOI]count];i++){
        
        
        if([self herePOI:[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]]) // Si estoy cerca grabo en ese POI estado here=true
        {
            
            [[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]setHere:TRUE]; // TRUE para el campo here del POI
            aux=TRUE;
            NSLog(@"SET  VISIT with POI %d",i);
            [self setVisit:[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]]; // GRABO LA VISITA
            
        }
        else{
            
            [[[[MCLPOIStore sharedStore]allPOI]objectAtIndex:i]setHere:FALSE];// Lo desactivo en cualquier caso si no estoy aquí
        }
    }
    
    if(aux) // Si estoy HERE aux=TRUE
        return TRUE;
    else // Si aux no es true es que TODAS eran false: ningún here
        return FALSE;
    
}

- (void)compareBedTime:(CLLocationCoordinate2D )loc2D{
    NSDate *date=[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSHourCalendarUnit| NSMinuteCalendarUnit fromDate:date];
    NSDate *dateClock=[gregorian dateFromComponents:comps];
    
    
    if ([dateClock compare: bedTimeDown] == NSOrderedDescending && [dateClock compare:bedTimeUp]==NSOrderedAscending )
    {
        NSLog(@"Nuevo POI hogar");
        MCLPOI *poi=[[MCLPOI alloc]initWithLocationCoordinate:loc2D kind:HOGAR];
        [[MCLPOIStore sharedStore]addPOI:poi];
        
    }else{
        //
    }
}

-(void) setVisit:(MCLPOI *)poi{
    BOOL newPlace=TRUE; // Presupongo que es un sitio no visitado
    
    if ([[[MCLVisitStore sharedStore] allVisits]count]>0) {
        
        int count=[[[MCLVisitStore sharedStore] allVisits]count];
        for (int i=0; i<[[[MCLVisitStore sharedStore] allVisits]count] ; i++) {
            
            MCLVisit *visit=[[[MCLVisitStore sharedStore]allVisits]objectAtIndex:i];
            NSTimeInterval t=[visit.dateLeave timeIntervalSinceDate:[NSDate date]];
           
            
            // Ahora compruebo si la visita actual coincide con alguna última visita
            if(poi.locationCoordinate.latitude==visit.POI.locationCoordinate.latitude && poi.locationCoordinate.longitude==visit.POI.locationCoordinate.longitude)
            {
                newPlace=FALSE; // El sitio no es nuevo: Refresco tiempo, o visita nueva si hace tiempo que no vengo
                i=[[[MCLVisitStore sharedStore] allVisits]count];// Si ya he encontrado el punto en mis visitas, no hace falta que busque más. Con esto saldré del bucle
                
                if (t<-10*60){// Si hace mucho que se hizo ( más de 10'), no se trata de la misma visita. Añado una nueva
                     NSLog(@"Conocía el POI, pero hace tiempo que no vengo. Visita nueva");
                    MCLVisit *visit=[[MCLVisit alloc]init];
                    [visit setPOI:poi];
                
                    [[MCLVisitStore sharedStore]addVisit:visit];

                } else{
                    NSLog(@"Refresco el tiempo de estancia de la visita");
                    [visit setHereTime:[[visit dateStarted] timeIntervalSinceNow]];
                    [visit setDateLeave:[NSDate date]];
                }
                
                
            }else{
                // Esta visita no reconoce el POI. Para esta visita, el sitio es nueva. quiza otra visita lo desmienta

            }
            

        }
        //Una vez recorrido todo el bucle puedo confirmar si el lugar es nuevo para la base de datos
        if (newPlace) {
            MCLVisit *visit=[[MCLVisit alloc]init];
            [visit setPOI:poi];
            [[MCLVisitStore sharedStore]addVisit:visit];
            NSLog(@"Añado primera visita a este POI");
        }
        
    }else{
        
        MCLVisit *visit=[[MCLVisit alloc]init];
        [visit setPOI:poi];
        [[MCLVisitStore sharedStore]addVisit:visit];
        NSLog(@"Añado primera visita");

    }
}
        


-(void) setSport:(CLLocation *)loc{

    //NSLog(@"Numero de deportes almacenados:%d \nUltimo deporte almacenados:\n %@ \n",[[[MCLSportStore sharedStore] allSports] count],lastSport);
        if (lastTrack!=NULL) {
            // Intervalo de tiempo entre la última visita y la de ahora
            NSTimeInterval t=[lastTrack.dateStarted timeIntervalSinceDate:[NSDate date]];
            
           
                if (t<-10*60){// Si  hace mucho que se hizo ( más de 10'), no se trata de la misma ruta. Añado una nueva
                    NSLog(@"Nueva Ruta (INDEFINIDO)");
                    MCLTrack *track=[[MCLTrack alloc]initWithLocation:loc kind:INDEFINIDO];
                    [[MCLTrackStore sharedStore]addTrack:track];
                    
                    lastTrack=track;
//                    [delegate sportUpdate:loc];// Refresco mapa de la vista
                    
                }else{
                    NSLog(@"Actualizo ruta");

                    // Si hace poco que se hizo, como además es la misma, refresco el tiempo de track
                    [[[[MCLTrackStore sharedStore] allTracks] lastObject] setTrackTime:[[lastTrack dateStarted]timeIntervalSinceNow]]; // Refresco tiempo de track
                     [[[[[MCLTrackStore sharedStore] allTracks] lastObject] track]addObject:loc]; // Refresco la ruta añadiendo localización
//                    [delegate sportUpdate:loc];// Refresco mapa de la vista

                
                }
                
        }else{ // Si no hay una visita anterior pregrabada, guardo la visita directamente
            NSLog(@"No existen rutas. Añado la primera (INDEFINIDO)");

            MCLTrack *track=[[MCLTrack alloc]initWithLocation:loc kind:INDEFINIDO];
            [[MCLTrackStore sharedStore]addTrack:track];
//            [delegate sportUpdate:loc];// Refresco mapa de la vista
            lastTrack=track;

        }


}

-(void) addPOIs{
    
    if (firstLocationView) { // Llamada a google la primera vez que se crea este objeto
        lastPOILocation=[self lastAccurateLocation];
        [self queryGooglePlaces:searchPOIName atPage:@""];
        firstLocationView=FALSE;
    }else if ([[self lastAccurateLocation] distanceFromLocation:lastPOILocation]<radius){
        //NSLog(@"Centro para obtener POI dentro del radio");
        // No hago nada, ya tengo los POI de dentro del radio
    }else{ // Vuelvo a recoger valores, fuera de este radio no tenia POI
        NSLog(@"Distancia ultimo centro para obtener POI:%f - Llamo a Google y reubico centro",[[self lastAccurateLocation] distanceFromLocation:lastPOILocation]);
        lastPOILocation=[self lastAccurateLocation];
        [self queryGooglePlaces:searchPOIName atPage:@""]; // LLAMADA A GOOGLE - OJO LIMITE PERMITIDO
    }

    
}



-(void)locGoToMode:(modes *)nextMode{
    mode=nextMode;
    switch (mode) {
            
        case PRECISO:
            NSLog(@"Me voy a preciso");
            [locationManager stopMonitoringSignificantLocationChanges];
            [locationManager startUpdatingLocation];
//            mode=PRECISO;
        break;
        case BAJOCONSUMO:
            NSLog(@"Me voy a bajo consumo");
            [locationManager stopUpdatingLocation];
            [locationManager startMonitoringSignificantLocationChanges];
//            mode=BAJOCONSUMO;
        break;
        case PRECISOCORTO:
            [locationManager stopMonitoringSignificantLocationChanges];
            [locationManager startUpdatingLocation];
//            mode=PRECISOCORTO;

        break;
        case PRECISOPOI:
            // Cuando voy a preciso POI ya debía yo de estar en modo preciso
            // y obviamente seguiré en modo preciso,asi que no toco locmanager
//             mode=PRECISOPOI;
        break;
        case PRECISODEPORTE:
            // Cuando voy a preciso deporte ya debía yo de estar en modo preciso
            // y obviamente seguiré en modo preciso,asi que no toco locmanager
            //             mode=PRECISOPOI;
            break;
            
        default:
        break;
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSArray *locations=[[NSArray alloc]initWithObjects:newLocation, nil];
    [self locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations];
   // envio localización al mapa -- PROVISIONAL
    

}

-(CLLocation*)locationAverage:(NSMutableArray*)locBuffer{
    CLLocationDegrees latitude=0;
    CLLocationDegrees longitude=0;
    CLLocationDistance altitude=0;
    CLLocationAccuracy hAcc=0;
    CLLocationAccuracy vAcc=0;
    CLLocationDirection course=0;
    CLLocationSpeed speed;
    
    for (int i=0; i<[locBuffer count]; i++) {
        CLLocationCoordinate2D coord=[[locBuffer objectAtIndex:i]coordinate];
        latitude+=coord.latitude;
        longitude+=coord.longitude;
        altitude+=[[locBuffer objectAtIndex:i]altitude];
        hAcc+=[[locBuffer objectAtIndex:i]horizontalAccuracy];
        vAcc+=[[locBuffer objectAtIndex:i]verticalAccuracy];
        course+=[[locBuffer objectAtIndex:i]course];
        speed+=[[locBuffer objectAtIndex:i]speed];
    }
    latitude=latitude/[locBuffer count];
    longitude=longitude/[locBuffer count];
    altitude=altitude/[locBuffer count];
    hAcc=hAcc/[locBuffer count];
    vAcc=vAcc/[locBuffer count];
    course=course/[locBuffer count];
    speed=speed/[locBuffer count];
        
                           
    CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:altitude horizontalAccuracy:hAcc verticalAccuracy:vAcc course:course speed:speed timestamp:NULL];
    return location;
    
}

-(CLLocation*)filterLocation:(CLLocation*)loc{
    double radioAccuracy=loc.horizontalAccuracy;
    if (radioAccuracy>15) {
        
        if (radioAccuracy<120)
        {NSLog(@"Localización imprecisa. Añado localización al buffer");
        [locationAccuracyBuffer addObject:loc]; // Si es una medida imprecisa, pero no demasiado imprecisa, guardala
        }else{
        NSLog(@"Localización muy imprecisa. No sirve para nada");
        }
        
        if ([locationAccuracyBuffer count]>=10) {
            NSLog(@"El buffer ha llegado a 10. Calculo su medio, lo devuelvo, y lo reinicio");
            NSMutableArray *aux=locationAccuracyBuffer;
            locationAccuracyBuffer=[[NSMutableArray alloc]init];
           return  [self locationAverage:aux]; // Si tengo 10 puntos,devolvemos la media
        }else{
            return NULL; //la precision me sirve para añadir al buffer,pero no tengo suficientes para devolver. así que de momento devuelvo nada
        }
        
    } else {
        NSLog(@"Localización precisa. Devuelvo esta y Reinicio buffer");
        locationAccuracyBuffer=[[NSMutableArray alloc]init]; // Volvemos a empezar el buffer de imprecisos,ya tengo
        return loc; //Lo devuelvo tal cual
    }
}

// Método que compara velocidad y devuelve mode
-(speedMode) getSpeedMode:(CLLocation *)loc{
    
    float speedKMH=loc.speed*conversionSpeed;
    NSLog(@"\nVelocidad:%f,",speedKMH);
    float speedAverageKMH=[self speedAverageLocation:loc]*conversionSpeed; // Solo devuelve el valor si ha almacenado 50
    NSLog(@"\nVelocidad Media:%f, de %d puntos",speedAverageKMH,[locationSpeedAverageBuffer count]);
    
    
    //Cada vez que pregunto por la velocidad, primero miro el promedio de los ultimos 60 locations(con condicion de que por lo menos el cálculo se haga sobre 50 puntos). Si correspondiese con el de la velocidad deporte, entonces es bastante probable que esté haciendo deporte.
    
    if (speedAverageKMH<speedSportUpLimit && speedAverageKMH>speedWalkUpLimit)
    {
        speedModeNow=DEPORTE;
        lastSpeedMode=speedModeNow;
        return speedModeNow;
    }else{
        
        if(speedKMH<speedStayUpLimit){
            speedModeNow=PARADO;
            lastSpeedMode=speedModeNow;

        } else if(speedKMH<speedWalkUpLimit){
            speedModeNow=ANDANDO;
            lastSpeedMode=speedModeNow;

        }else if(speedKMH<speedSportUpLimit){
            speedModeNow=lastSpeedMode; // Aunque detecte velocidad deporte,puede que no sea así, ya que la media de los ultimos 60 seg no se corresponde con una persona que hace deporte. así que vuelvo al modo en el que estaba, y si este era motor, borro el buffer de velocidades
            
            if (lastSpeedMode==MOTOR) 
                locationSpeedAverageBuffer=[[NSMutableArray alloc]init];
            
            
        }else{
            speedModeNow=MOTOR;
            lastSpeedMode=speedModeNow;

            locationSpeedAverageBuffer=[[NSMutableArray alloc]init]; // si estoy motorizado, es que no he hecho deporte. borro lo que habia
        }
        
        NSLog([self stringSpeed:speedModeNow]);
        return speedModeNow;
        
    }
    
}

-(double)speedAverageLocation:(CLLocation*)loc{
    
    //Calculo la media de velocidad de los últimos 60seg
    NSNumber *speedNow=[NSNumber numberWithDouble:[loc speed]];
    if ([locationSpeedAverageBuffer count]==60)
        [locationSpeedAverageBuffer removeLastObject]; // borro el ultimo para que siempre sea la media de los últimos 60 
    
    [locationSpeedAverageBuffer insertObject:speedNow atIndex:0];
    
    double aux=0;
    for (int i=0; i<[locationSpeedAverageBuffer count]; i++) {
        aux+=[[locationSpeedAverageBuffer objectAtIndex:i]doubleValue];
    }
    aux/=[locationSpeedAverageBuffer count];
    
    //Siempre devuelve la media de velocidad de los ultimos 60 puntos si los hubiese
    if ([locationSpeedAverageBuffer count]>50) {
        return aux;
    }else{
        return 0;
    }
    

    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    if([delegate conformsToProtocol:@protocol(MyCoreLocationControllerDelegate)]) {
        CLLocation* location = [locations lastObject];
        //NSLog(@"--- %@",location);
        location=[self filterLocation:location]; // Miro si es preciso. Sino calculo la media de los ultimos puntos. 
       

        
        if (location!=NULL){ // Ojo,si la localización devuelta es nula,paso de todo,estoy a la espera de una buena localización
        
            switch (mode) { //////////////// MANEJO DE MODOS //////////////////////////
                
                case PRECISODEPORTE:
                    NSLog(@"\n Haciendo deporte - Registro ruta");
                    [delegate locationUpdate:location];
                    lastAccurateLocation=location;
                
                    [self setSport:location];
                
                    // Si estoy en modo deporte y dejo de estarlo el modo se ha acabado y la ruta también
                    if ([self getSpeedMode:location]!=DEPORTE){
                        [self locGoToMode:lastModeBeforeSport];
                        NSLog(@"Fin deporte - Cierro ruta y vuelvo a lo que estaba");
                    }
                
                    
                    break;
                    
                case PRECISO:
                    
                    [delegate locationUpdate:location]; // delegate de  MyCoreLocationController recibe la informacion de la localización
                    lastAccurateLocation=location; // Me guardo esta localización que es accesible
                    // NSLog(@"\n -- GOOD Location:%@",location);
                    
                    // COMPRUEBO si estoy cerca de algún POI
                    if(![self checkAroundPOI])
                    {
                        NSLog(@"NO POI AROUND");
                        //Sigo como estoy - check aroundPOI ha devuelto falso
                    }
                    else{
                        NSLog(@"SÍ POI AROUND,pasemos al mode POI preciso");
                        lastModeBeforePOI=PRECISO; // Guardo donde estaba antes de irme a PRECISO POI
                        [self locGoToMode:(PRECISOPOI)];
                    }
                    // COMPRUEBO SI HAGO DEPORTE . PREVALEZCO SOBRE POI
                    if ([self getSpeedMode:location]==DEPORTE){   // Si la velocidad detectada es deporte, y la media de los ultimos 60 location es de deporte,entonces  fuerzo el modo deporte,que transcurrirá también en modo preciso.
                        NSLog(@"SÍ DEPORTE, pasemos al modo deporte");
                        lastModeBeforeSport=mode;
                        [self locGoToMode:PRECISODEPORTE];
                    }
                    
                    break;
                    
                case BAJOCONSUMO:
                    [delegate locationUpdate:location];
                    NSLog(@"MALA localización de bajo consumo- Lanzo PRECISOCORTO");
                    [self locGoToMode:(PRECISOCORTO)];
                    shortAccurateTriggered=TRUE;
                    break;
                    
                case PRECISOCORTO:
                    if (shortAccurateTriggered){ // Primera obtencion precisa en ciclo Preciso corto
                        
                        shortAccurateTriggered=FALSE;
                        firstLocationTime = location.timestamp;
                        
                    }else { // Una vez he fijado el tiempo del primer location, sigo obteniendo location durante 7 segundos
                        
                        if([firstLocationTime timeIntervalSinceNow]>-7){
                            
                            NSLog(@"Buena localización PRECISOCORTO %f",[firstLocationTime timeIntervalSinceNow]);
                            lastAccurateLocation=location;
                            [delegate locationUpdate:location];
                            
                            
                            // Busco si estoy cerca de algún POI
                            if(![self checkAroundPOI])
                            {
                                NSLog(@"\n NO POI AROUND"); //Sigo como estoy
                            }
                            else{
                                NSLog(@"\n SÍ POI AROUND,pasemos al mode POI preciso");
                                shortAccurateTriggered=TRUE; // Tendré que volver a lanzar el disparo cuando vuelva mode preciso corto
                                lastModeBeforePOI=PRECISOCORTO; // Guardo donde estaba antes de irme a PRECISO POI
                                [self locGoToMode:(PRECISOPOI)];
                                
                            }
                            // COMPRUEBO SI HAGO DEPORTE . PREVALECE SOBRE POI
                            if ([self getSpeedMode:location]==DEPORTE){   // Si la velocidad detectada es deporte, fuerzo el modo preciso.
                                lastModeBeforeSport=mode;
                                [self locGoToMode:PRECISODEPORTE];
                            }
                            
                            
                            
                            
                        }else{ // Cuando ya llevo 7 segundos vuelvo al bajo consumo
                            NSLog(@"\n Vuelvo al bajo consumo");
                            [self locGoToMode:(BAJOCONSUMO)];
                            shortAccurateTriggered=TRUE;
                        }
                    }
                    
                    break;
                    
                case PRECISOPOI: // Estoy cerca y el gps funciona normal.
                    
                    lastAccurateLocation=location; // Me guardo esta localización que es accesible
                    
                    if(![self checkHerePOI]) // Esta comprobación APROVECHA PARA GUARDAR LA VISITA
                    {
                        NSLog(@"\n NO POI HERE");//Sigo como estaba - check herePOI ha devuelto falso
                        [self locGoToMode:(lastModeBeforePOI)]; // OJO,esto irá rebotando hasta que NO AROUND
                    }
                    else{
                        NSLog(@"\n SÍ POI HERE"); // También,sigo como estaba a no ser que la visita se prolongue
                        
                        if ([[[[MCLVisitStore sharedStore]allVisits]lastObject]hereTime]<-10*60) {
                            
                            [self locGoToMode:(lastModeBeforePOI)];
                            
                        }
                        
                    }
                    
                    break;
                default:
                    break;
            }
            
            
             [self addPOIs]; // Le pido que consiga POI - dentro de getPOI comprobará si le toca o no hacerlo
            
            // COMPRUEBO SI ES HORA DE DORMIR
            // [self compareBedTime:location.coordinate]; // Compruebo si es la hora de dormir. Allí añado POI HOGAR
        } // IF LOCALIZACION ES BUENA
        
        NSLog([self stringModes:mode]);
        
    } // IF PROTOCOLO
        
       
        
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([delegate conformsToProtocol:@protocol(MyCoreLocationControllerDelegate)]) {
		[delegate locationError:error];
	}
}

-(void)dealloc{
    NSLog(@"Desalojando memoria");
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//////////////////////// MAPA - PROVISIONAL ////////////////////////////////////
@end
