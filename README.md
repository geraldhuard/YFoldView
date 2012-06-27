# YFoldView

YFoldView is an simple and easy-to-use class for iOS UIView. YFoldView provide folding transition to sho or to hide a view. The Class YFoldView has different method to fold UIView Element.

## Features
* Customize the number of paper folds
* Support four opening directions
* Adjust animation duration
* Delegate functions to react to events events
* Automatic Reference Counting support

## Installation
* Add YFoldView.h/YFoldView.h files to your project and Import YFoldView.h in your file you want to use
* Add the QuartzCore framework to your project.

## Usage
(see example Xcode project in /Demo)

### Close view transition

	YFoldView* folding=[YFoldView closeView:self.view 
     			           withNumberOfFold:5 
    				                  onWay:yFoldViewBottomToTop 
		   		       duration:2 
	      		        	withDelegate:self];


### Open view transition:

	[folding openAnimatedDuration:2];

### To fold View Horizontaly
	[folding horizontalFoldWithHeight:self.view.bounds.size.height/3];

### To fold View Verticaly
	[folding verticalFoldWithWidth:self.view.bounds.size.width/3];

## Delegate:

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



## Demo
(see demo video on [Vimeo](http://vimeo.com/44810879))
(see demo video on [Vimeo](http://vimeo.com/44810878))

## Credit
YFoldView is brought to you by [Yooneo (Gerald HUARD)(http://www.yooneo.com/)]
