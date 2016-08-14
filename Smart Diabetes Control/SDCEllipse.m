//
//  SDCEllipse.m
//  Smart Diabetes Control
//
//  Created by Mederi on 14/06/13.
//
//

#import "SDCEllipse.h"
#import "SDCConstants.h"
#import "SDCDetailViewController.h"
#import "SDCAppDelegate.h"
#import "SDCLoginVC.h"

@implementation SDCEllipse


@synthesize clusterIndex; // Pertenece al grupo comida,desayuno,etc
@synthesize selected; // Cambio highlighted color en función de selected

@synthesize varValue;
@synthesize meanValue,maxValue,minValue;
@synthesize hyperPercent,normoPercent,hypoPercent;
@synthesize framePointCenter;


-initWithFrame:(CGRect)frame
{
    //Pequeña ampliación elipse para que no "tape" ningun punto que bordee la elipse
//    CGRect newFrame=CGRectMake([self frame].origin.x-(pointSize/2), [self frame].origin.y-(pointSize/2), [self frame].size.width+pointSize, [self frame].size.height+pointSize);
//    CGRect newBounds=CGRectMake(0, 0, [self frame].size.width+pointSize, [self frame].size.height+pointSize);
//    [self setFrame:newFrame];
//    [self setBounds:newBounds];
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setSelected:NO];
        [self setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}


 - (void)drawRect:(CGRect)rect {
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetLineWidth(context, 1.0);
     CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     CGContextSetStrokeColor(context, (CGFloat[8]){0.07, 0.07, 0.09, 0.2});
     CGRect rectangle = [self bounds];
     CGContextAddEllipseInRect(context, rectangle);
     ///////////////////////////////
   
     if ([self selected]==YES)
     {
         CGContextSetFillColor(context, (CGFloat[8]){0.07, 0.5, 0.99, 0.3});
     }
     else
     {
         CGContextSetFillColor(context, (CGFloat[8]){0.07, 0.99, 0.07, 0.2});
     }
          
     CGContextDrawPath(context, kCGPathFillStroke);
     [self setSelected:NO];
     [self resignFirstResponder];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if([self clusterIndex]!=0){ // Si no pertenece a ningún cluster, no se puede tocar

        [self setSelected:YES];
        [self setNeedsDisplay];
        SDCDetailViewController *dvc=[[SDCDetailViewController alloc]init];
        [dvc setEllipse:self];
        
        SDCAppDelegate *del = (SDCAppDelegate *)[UIApplication sharedApplication].delegate;
        
        // Ahora le paso al detail VC todos los datos necesarios para que pinte lo último que estaba pintando desde registerVC
        [dvc setUntilDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]untilDate]];
        [dvc setSinceDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]sinceDate]];
        [dvc setStringDate:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]stringDate]];
        [dvc setAm:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]am]];
        [dvc setPm:[[[[del glucoseRegisterNC]viewControllers]objectAtIndex:0]pm]];
        
        [[del glucoseRegisterNC]pushViewController:dvc animated:YES];
        
    }
}

@end
