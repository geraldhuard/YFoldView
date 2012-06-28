//
//  YFoldView.m
//  TalkieWinkie
//
//  Created by Gérald HUARD on 20/06/12.
//  Copyright (c) 2012 Gérald HUARD. All rights reserved.
//

#import "YFoldView.h"

@implementation YFoldView
@synthesize tag=_tag;
@synthesize delegate = _delegate;
@synthesize view = _view;


+(YFoldView*)create:(UIView*)view numberOfFold:(NSInteger)parts withWay:(YFoldViewWay)way{
    return [[YFoldView alloc] initWithView:view withWay:way andNumberOfFolds:parts];
}

+(YFoldView*)closeView:(UIView*)view
      withNumberOfFold:(NSInteger)folds
                 onWay:(YFoldViewWay)way
              duration:(NSTimeInterval)duration
          withDelegate:(id<YFoldViewDelegate>)delegate{
    
    YFoldView *foldv=[[YFoldView alloc] initWithView:view withWay:way andNumberOfFolds:folds];
    foldv.delegate=delegate;
    [foldv closeAnimatedDuration:duration];
    
    return foldv;
}

+(YFoldView*)closeView:(UIView*)view
      withNumberOfFold:(NSInteger)folds
                 onWay:(YFoldViewWay)way
              duration:(NSTimeInterval)duration{

    return [YFoldView closeView:view withNumberOfFold:folds onWay:way duration:duration withDelegate:nil];
}

+(YFoldView*)foldView:(UIView*)view withNbPart:(NSInteger)folds onWay:(YFoldViewWay)way {
    return [[YFoldView alloc] initWithView:view withWay:way andNumberOfFolds:folds];
}




- (id)initWithView:(UIView*)view withWay:(YFoldViewWay)way andNumberOfFolds:(NSInteger)parts
{
    self = [super init];
    if (self) {
        _view=view;
        _way=way;
        _folded=NO;
        _initialSizeView=_view.frame.size;
        _currentSize=_initialSizeView;
        _numberOfFolds=parts;
        _main3DLayer=nil;
        [self initialize];
    }
    return self;
}


-(void) initialize{
    
    if (!_main3DLayer){
        UIGraphicsBeginImageContext(_view.frame.size);
        [_view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

                
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0/700.0;
        _main3DLayer = [[CALayer layer] retain];
        _main3DLayer.frame = _view.bounds;
        _main3DLayer.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0].CGColor;
        _main3DLayer.sublayerTransform = transform;
        [_main3DLayer setHidden:YES];
        [_view.layer addSublayer:_main3DLayer];

    
        CGFloat partHeight=_view.bounds.size.height/_numberOfFolds;
        CGFloat partWidth=_view.bounds.size.width/_numberOfFolds;

        
        NSMutableArray *tmpLayer=[NSMutableArray array];
        NSMutableArray *tmpShadow=[NSMutableArray array];
        for (int i=0;i<_numberOfFolds;i++){
            CGRect frame=CGRectZero;
            
            if (_way==yFoldViewBottomToTop || _way==yFoldViewTopToBottom)
                frame=CGRectMake(0, i*partHeight, _view.bounds.size.width, partHeight);
            
            if (_way==yFoldViewRightToLeft || _way==yFoldViewLeftToRight)
                frame=CGRectMake(i*partWidth, 0, partWidth, _view.bounds.size.height);
            
            CGImageRef imageCrop = CGImageCreateWithImageInRect(viewSnapShot.CGImage, frame);
            CALayer *imageCroppedLayer = [CALayer layer];
            imageCroppedLayer.frame=frame;
            
            if (_way==yFoldViewBottomToTop || _way==yFoldViewTopToBottom){
                imageCroppedLayer.anchorPoint=CGPointMake(0.5, (i%2==0)?0.0:1.0);
                imageCroppedLayer.position=CGPointMake(imageCroppedLayer.position.x,(i%2==0)?(imageCroppedLayer.position.y-imageCroppedLayer.bounds.size.height/2):imageCroppedLayer.position.y+imageCroppedLayer.bounds.size.height/2);
            }
            if (_way==yFoldViewRightToLeft || _way==yFoldViewLeftToRight){
                imageCroppedLayer.anchorPoint=CGPointMake((i%2==0)?0.0:1.0,0.5);
                imageCroppedLayer.position=CGPointMake((i%2==0)?(imageCroppedLayer.position.x-imageCroppedLayer.bounds.size.width/2):imageCroppedLayer.position.x+imageCroppedLayer.bounds.size.width/2,imageCroppedLayer.position.y);
            }
            
            imageCroppedLayer.contents=(id)imageCrop;
            [tmpLayer addObject:imageCroppedLayer];
            
            
            CAGradientLayer *shadowLayer = [CAGradientLayer layer];
            shadowLayer.frame = imageCroppedLayer.bounds;
            shadowLayer.opacity = 0;
            shadowLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
            
            
            if (i%2) {
                shadowLayer.startPoint = CGPointMake(0.5, 0);
                shadowLayer.endPoint = CGPointMake(0.5, 0.5);
            }
            else {
                shadowLayer.startPoint = CGPointMake(0.5, 0.5);
                shadowLayer.endPoint = CGPointMake(0.5, 0.0);
            }
            shadowLayer.shouldRasterize=YES;
            [imageCroppedLayer addSublayer:shadowLayer];

            [tmpShadow addObject:shadowLayer];
            
            
            [_main3DLayer addSublayer:imageCroppedLayer];
        }
        
        _layerFolds=[tmpLayer retain];
        _shadowLayerFolds=[tmpShadow retain];
    }
}


-(void) closeAnimatedDuration:(NSTimeInterval)duration{
    [self closeTo:5 duration:duration];
}

-(void) closeTo:(CGFloat)limit duration:(NSTimeInterval)duration{
    if (_way == yFoldViewBottomToTop || _way == yFoldViewTopToBottom){
        [self animateHorizontalFoldFrom:_currentSize.height to:limit duration:duration];
        NSLog(@"Horiz");
    }
    if (_way == yFoldViewRightToLeft || _way == yFoldViewLeftToRight){
        [self animateVerticalFoldFrom:_currentSize.width to:limit duration:duration];
        NSLog(@"Vertic %f => %f",_currentSize.width,limit);
    }
}

-(void) openAnimatedDuration:(NSTimeInterval)duration{
    if (_way == yFoldViewBottomToTop || _way == yFoldViewTopToBottom){
        [self animateHorizontalFoldFrom:_currentSize.height to:_initialSizeView.height duration:duration];
    }
    if (_way == yFoldViewRightToLeft || _way == yFoldViewLeftToRight){
        [self animateVerticalFoldFrom:_currentSize.width to:_initialSizeView.width duration:duration];
    }
}

-(void) horizontalFoldWithHeight:(CGFloat)height{
    [self horizontalFoldWithHeight:height andForce:NO];
}

-(void) horizontalFoldWithHeight:(CGFloat)height andForce:(BOOL)force{
    [self initialize];
    
    if (height+10>=_initialSizeView.height)height=_initialSizeView.height;

    
    if (_currentSize.height!=height || force){
        _currentSize.height=height;
        if (_currentSize.height<=_initialSizeView.height){
            
            if (_way==yFoldViewBottomToTop || _way==yFoldViewTopToBottom){
                for (int i=0;i<[_layerFolds count];i++){
                    [self setPropertyToLayer:[_layerFolds objectAtIndex:i] withShadow:[_shadowLayerFolds objectAtIndex:i]
                                  withHeight:height
                                       ofIdx:i];
                }
            }
        }
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:heightChanged:)]){
            [_delegate yfoldview:self view:_view heightChanged:height];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:sizeChanged:)]){
            [_delegate yfoldview:self view:_view sizeChanged:_currentSize];
        }
   }
    
    if (height==_initialSizeView.height){
        [self folded:NO];
    }
    
    if (height<_initialSizeView.height){
        [self folded:YES];
    }
}


-(void) verticalFoldWithWidth:(CGFloat)width{
    [self verticalFoldWithWidth:width andForce:NO];
}

-(void) verticalFoldWithWidth:(CGFloat)width andForce:(BOOL)force{
    [self initialize];
    
    if (width+10>=_initialSizeView.width)width=_initialSizeView.width;

    
    if (_currentSize.width!=width || force){
        _currentSize.width=width;
        
        if (_currentSize.width<=_initialSizeView.width){
            
            if (_way==yFoldViewRightToLeft || _way==yFoldViewLeftToRight){
                for (int i=0;i<[_layerFolds count];i++){
                    [self setPropertyToLayer:[_layerFolds objectAtIndex:i] withShadow:[_shadowLayerFolds objectAtIndex:i]
                                  withWidth:width
                                       ofIdx:i];
                }
            }
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:widthChanged:)]){
            [_delegate yfoldview:self view:_view widthChanged:width];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:sizeChanged:)]){
            [_delegate yfoldview:self view:_view sizeChanged:_currentSize];
        }
    
    }
    
    if (width==_initialSizeView.width){
        [self folded:NO];
    }
    if (width<_initialSizeView.width){
        [self folded:YES];
    }
}


-(void) setEndPointPosition:(CGPoint)point{
    BOOL opened=NO;
    BOOL closed=NO;
    
    
    if (_way==yFoldViewBottomToTop || _way==yFoldViewTopToBottom){
        float height=0;
        
        if (_way==yFoldViewBottomToTop)height=point.y-_view.frame.origin.y;
        if (_way==yFoldViewTopToBottom)height=_view.bounds.size.height-(point.y-_view.frame.origin.y);
        
        
        if (height+10>=_initialSizeView.height){
            height=_initialSizeView.height;   
            opened=YES;
        }
        
        if (height-10<=0){
            height=10;
            closed=YES;
        }
        [self horizontalFoldWithHeight:height];
    }
    if (_way==yFoldViewRightToLeft || _way==yFoldViewLeftToRight){
        float width=0;
        
        if (_way==yFoldViewLeftToRight)width=point.x-_view.frame.origin.x;
        if (_way==yFoldViewRightToLeft)width=_view.bounds.size.width-(point.x-_view.frame.origin.x);
        
        
        if (width+10>=_initialSizeView.width){
            width=_initialSizeView.width;
            opened=YES;
        }
        if (width-10<=0){
            width=10;
            closed=YES;
        }
        
        [self verticalFoldWithWidth:width];
    }
    
    if (closed && _delegate && [_delegate respondsToSelector:@selector(yfoldview:view:isClose:)]){
        [_delegate yfoldview:self view:_view isClose:YES];
    }
    if (opened && _delegate && [_delegate respondsToSelector:@selector(yfoldview:view:isOpen:)]){
        [_delegate yfoldview:self view:_view isOpen:YES];
    }
    
}


-(void) folded:(BOOL)folded{
    [self initialize];

    
    
    if (folded != _folded){
        _folded=folded;


        if (_folded){
            for (int i=0;i<[_view.layer.sublayers count] ;i++){
                [[_view.layer.sublayers objectAtIndex:i] setHidden:YES];
            }

            [_main3DLayer setHidden:NO];
            
            NSLog(@"View folded");
        }else{
            
            for (int i=0;i<[_view.layer.sublayers count] ;i++){
                [[_view.layer.sublayers objectAtIndex:i] setHidden:NO];
            }

            [_main3DLayer setHidden:YES];
            

            
            
            NSLog(@"View Opened");
            //[_main3DLayer removeFromSuperlayer];
        }
    }
    [_view.layer setNeedsDisplay];

}


-(void) setPropertyToLayer:(CALayer*)layer withShadow:(CALayer*)shadow withHeight:(CGFloat)height ofIdx:(NSInteger)idx{
    float heightPartCurr=height/_numberOfFolds;
    float heightPartInitial=_initialSizeView.height/_numberOfFolds;
    float percentOfHeight=(height/_initialSizeView.height);
    shadow.opacity=1.0-percentOfHeight;
    
    CGPoint posCurr=layer.position;
    
    
    if (_way==yFoldViewBottomToTop && idx>0){
        posCurr.y=heightPartCurr*idx;
        if (layer.anchorPoint.y==1.0)posCurr.y+=heightPartCurr;
    }
    if (_way==yFoldViewTopToBottom && idx<([_layerFolds count]-1)){
        posCurr.y=heightPartCurr*idx+(_initialSizeView.height-_currentSize.height);
        if (layer.anchorPoint.y==1.0)posCurr.y+=heightPartCurr;
    }
    
    layer.position=posCurr;
    
    float angle2=acos(heightPartCurr/heightPartInitial);
    if (idx%2==0)angle2=angle2*-1;
    CATransform3D transform=CATransform3DIdentity;
    transform=CATransform3DRotate(transform, angle2, 1.0, 0.0, 0);
    layer.transform=transform;
}

-(void) setPropertyToLayer:(CALayer*)layer withShadow:(CALayer*)shadow withWidth:(CGFloat)width ofIdx:(NSInteger)idx{
    float widthPartCurr=width/_numberOfFolds;
    float widthPartInitial=_initialSizeView.width/_numberOfFolds;
    float percentOfwidth=(width/_initialSizeView.width);
    shadow.opacity=1.0-percentOfwidth;
    
    CGPoint posCurr=layer.position;
    
    
    if (_way==yFoldViewLeftToRight && idx>0){
        posCurr.x=widthPartCurr*idx;
        if (layer.anchorPoint.x==1.0)posCurr.x+=widthPartCurr;
    }
    if (_way==yFoldViewRightToLeft && idx<([_layerFolds count]-1)){
        posCurr.x=widthPartCurr*idx+(_initialSizeView.width-_currentSize.width);
        if (layer.anchorPoint.x==1.0)posCurr.x+=widthPartCurr;
    }
    
    layer.position=posCurr;
    
    float angle2=acos(widthPartCurr/widthPartInitial);
    if (idx%2!=0)angle2=angle2*-1;
    CATransform3D transform=CATransform3DIdentity;
    transform=CATransform3DRotate(transform, angle2, 0.0, 1.0, 0);
    layer.transform=transform;
    
    
}


-(void) animationStepForHeight{
    [self horizontalFoldWithHeight:_currentSize.height andForce:YES];
    _currentSize.height+=_increment;
    
    if (_idxStep>_nbSteps){
        [_timerForAnimation invalidate];
        _timerForAnimation=nil;
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:animFinished:)]){
            [_delegate yfoldview:self view:_view animFinished:YES];
        }
    }
    _idxStep++;
}


-(void) animateHorizontalFoldFrom:(CGFloat)heightstart to:(CGFloat)heightEnd duration:(NSTimeInterval)duration{
    
    float freq=1.0/10.0;
    _nbSteps=(duration/freq)+1;
    _increment=(heightEnd-heightstart)/_nbSteps;
    _idxStep=0;
    _currentSize.height=heightstart;
    _timerForAnimation=[NSTimer scheduledTimerWithTimeInterval:freq
                                                        target:self
                                                      selector:@selector(animationStepForHeight)
                                                      userInfo:nil
                                                       repeats:YES];
    [_timerForAnimation fire];
}
-(void) animationStepForWidth{
    [self verticalFoldWithWidth:_currentSize.width andForce:YES];
    _currentSize.width+=_increment;
    
    if (_idxStep>_nbSteps){
        [_timerForAnimation invalidate];
        _timerForAnimation=nil;

    
        if (_delegate && [_delegate respondsToSelector:@selector(yfoldview:view:animFinished:)]){
            [_delegate yfoldview:self view:_view animFinished:YES];
        }
    }
    _idxStep++;
}


-(void) animateVerticalFoldFrom:(CGFloat)widthstart to:(CGFloat)widthEnd duration:(NSTimeInterval)duration{
    float freq=1.0/10.0;
    _nbSteps=(duration/freq)+1;
    _increment=(widthEnd-widthstart)/_nbSteps;
    _idxStep=0;
    _currentSize.width=widthstart;
    _timerForAnimation=[NSTimer scheduledTimerWithTimeInterval:freq
                                                        target:self
                                                      selector:@selector(animationStepForWidth)
                                                      userInfo:nil
                                                       repeats:YES];
    [_timerForAnimation fire];
    
}



-(void) reset{
    [_main3DLayer removeFromSuperlayer];
    [_main3DLayer release];
    _main3DLayer=nil;
    CGRect frm=_view.frame;
    frm.size=_initialSizeView;
    _currentSize=_initialSizeView;
    _view.frame=frm;
    [_layerFolds release];
    _layerFolds=nil;
}


@end
