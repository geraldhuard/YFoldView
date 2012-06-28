//
//  YFoldView.h
//  TalkieWinkie
//
//  Created by Gérald HUARD on 20/06/12.
//  Copyright (c) 2012 Gérald HUARD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    yFoldViewBottomToTop,
    yFoldViewTopToBottom,
    yFoldViewLeftToRight,
    yFoldViewRightToLeft
} YFoldViewWay;



@class YFoldView;

@protocol YFoldViewDelegate <NSObject>

@optional

/**
 Called when the view ids totally opened
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param opened : YES if it's opened
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view isOpen:(BOOL)opened;

/**
 Called when the view is totally closed
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param opened : YES if it's opened
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view isClose:(BOOL)closed;

/**
 Called when the height of the view changed
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param h : current height of view:w
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view heightChanged:(CGFloat)h;

/**
 Called when the width of the view changed
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param w : current width of view:w
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view widthChanged:(CGFloat)w;

/**
 Called when the size (width or height) of the view changed
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param size : current size:w
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view sizeChanged:(CGSize)size;


/**
 Called when animation finished
 @param foldview : YFoldView Class
 @param view : the UIView Object used
 @param finished : YES when finished
 */
-(void) yfoldview:(YFoldView*)foldview view:(UIView*)view animFinished:(BOOL)finished;



@end


@interface YFoldView : NSObject{
    
    id<YFoldViewDelegate>   _delegate;
    
    BOOL                    _folded;
    
    YFoldViewWay            _way;
    
    NSInteger               _tag;
    UIView                 *_view;
    CALayer                *_main3DLayer;
    
    CGSize                  _initialSizeView;
    CGSize                  _currentSize;
    NSInteger               _numberOfFolds;
    
    NSArray                *_layerFolds;
    NSArray                *_shadowLayerFolds;
    
    NSTimer                *_timerForAnimation;
    int                     _nbSteps;
    int                     _idxStep;
    float                   _increment;
    
    
}

@property (atomic) NSInteger tag;
@property (atomic,assign) id<YFoldViewDelegate> delegate;
@property (atomic,assign) UIView *view;

+(YFoldView*) create:(UIView*)view
        numberOfFold:(NSInteger)parts
             withWay:(YFoldViewWay)way;

+(YFoldView*)closeView:(UIView*)view
      withNumberOfFold:(NSInteger)folds
                 onWay:(YFoldViewWay)way
              duration:(NSTimeInterval)duration
          withDelegate:(id<YFoldViewDelegate>)delegate;

+(YFoldView*)closeView:(UIView*)view
      withNumberOfFold:(NSInteger)folds
                 onWay:(YFoldViewWay)way
              duration:(NSTimeInterval)duration;

+(YFoldView*)foldView:(UIView*)view
           withNbPart:(NSInteger)folds
                onWay:(YFoldViewWay)way ;

-(id)initWithView:(UIView*)view
           withWay:(YFoldViewWay)way
  andNumberOfFolds:(NSInteger)parts;

-(void) horizontalFoldWithHeight:(CGFloat)height;
-(void) animateHorizontalFoldFrom:(CGFloat)heightstart
                               to:(CGFloat)heightEnd
                         duration:(NSTimeInterval)duration;


-(void) verticalFoldWithWidth:(CGFloat)width;
-(void) animateVerticalFoldFrom:(CGFloat)widthstart
                             to:(CGFloat)widthEnd
                       duration:(NSTimeInterval)duration;


-(void) reset;
-(void) setEndPointPosition:(CGPoint)point;

-(void) closeAnimatedDuration:(NSTimeInterval)duration;
-(void) closeTo:(CGFloat)limit duration:(NSTimeInterval)duration;
-(void) openAnimatedDuration:(NSTimeInterval)duration;


@end
