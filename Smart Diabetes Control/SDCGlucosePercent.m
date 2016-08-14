//
//  SDCGlucosePercent.m
//  Smart Diabetes Control
//
//  Created by Mederi on 19/06/13.
//
//

#import "SDCGlucosePercent.h"

@implementation SDCGlucosePercent
@synthesize normoPercent,hyperPercent,hypoPercent;
CGRect hyperRect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNormoPercent:0.33333];
        [self setHypoPercent:0.33333];
        [self setHyperPercent:0.33333];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    CGRect upperRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height * hyperPercent);
    CGRect midRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height * hyperPercent), rect.size.width, rect.size.height *normoPercent);
    CGRect lowerRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height * (normoPercent+hyperPercent)), rect.size.width, rect.size.height *hypoPercent);
                                  
    [[UIColor orangeColor] set];
    UIRectFill(upperRect);
    [[UIColor greenColor] set];
    UIRectFill(midRect);
    [[UIColor redColor] set];
    UIRectFill(lowerRect);
    
    
    // Ahora dibujo labels
    //Dibujo unidades glucosa
    
    CGPoint middlePoint=CGPointMake(upperRect.origin.x+upperRect.size.width/2, upperRect.origin.y+upperRect.size.height/2);
    UILabel *hyperPercentLabel=[[UILabel alloc] initWithFrame:CGRectMake(middlePoint.x, middlePoint.y, 5, 5)];
    hyperPercentLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [hyperPercentLabel setFont:[UIFont fontWithName:@"Helvetica" size:7]];
    hyperPercentLabel.text=[NSString stringWithFormat:@"%.0f %%",hyperPercent*100];
    // Se adapta al tamaño del contenido,es decir del texto. Así consigo alineación vertical respecto al frame.
    [hyperPercentLabel sizeToFit];
    hyperPercentLabel.textAlignment=NSTextAlignmentCenter;
    
    [hyperPercentLabel setFrame:CGRectMake(hyperPercentLabel.frame.origin.x-hyperPercentLabel.frame.size.width/2,hyperPercentLabel.frame.origin.y-hyperPercentLabel.frame.size.height/2,hyperPercentLabel.frame.size.width,hyperPercentLabel.frame.size.height) ];
    if (hyperPercent>0.1) {
        [self addSubview:hyperPercentLabel];
    }
    
    

    middlePoint=CGPointMake(lowerRect.origin.x+lowerRect.size.width/2, lowerRect.origin.y+lowerRect.size.height/2);
    
    UILabel *hypoPercentLabel=[[UILabel alloc] initWithFrame:CGRectMake(middlePoint.x, middlePoint.y, 5, 5)];
    hypoPercentLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [hypoPercentLabel setFont:[UIFont fontWithName:@"Helvetica" size:7]];
    hypoPercentLabel.text=[NSString stringWithFormat:@"%.0f %%",hypoPercent*100];
    // Se adapta al tamaño del contenido,es decir del texto. Así consigo alineación vertical respecto al frame.
    [hypoPercentLabel sizeToFit];
    hypoPercentLabel.textAlignment=NSTextAlignmentCenter;
    
    [hypoPercentLabel setFrame:CGRectMake(hypoPercentLabel.frame.origin.x-hypoPercentLabel.frame.size.width/2,hypoPercentLabel.frame.origin.y-hypoPercentLabel.frame.size.height/2,hypoPercentLabel.frame.size.width,hypoPercentLabel.frame.size.height) ];
     if (hypoPercent>0.1) {
    [self addSubview:hypoPercentLabel];
     }
    
    middlePoint=CGPointMake(midRect.origin.x+midRect.size.width/2, midRect.origin.y+midRect.size.height/2);

    UILabel *normoPercentLabel=[[UILabel alloc] initWithFrame:CGRectMake(middlePoint.x, middlePoint.y, 5, 5)];
    normoPercentLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [normoPercentLabel setFont:[UIFont fontWithName:@"Helvetica" size:7]];
    normoPercentLabel.text=[NSString stringWithFormat:@"%.0f %%",normoPercent*100];
    // Se adapta al tamaño del contenido,es decir del texto. Así consigo alineación vertical respecto al frame.
    [normoPercentLabel sizeToFit];
    normoPercentLabel.textAlignment=NSTextAlignmentCenter;
    
    [normoPercentLabel setFrame:CGRectMake(normoPercentLabel.frame.origin.x-normoPercentLabel.frame.size.width/2,normoPercentLabel.frame.origin.y-normoPercentLabel.frame.size.height/2,normoPercentLabel.frame.size.width,normoPercentLabel.frame.size.height) ];
    
    if (normoPercent>0.1) {
    [self addSubview:normoPercentLabel];
    }
}


@end
