//
//  RootViewController.m
//  TalkieWinkie
//
//  Created by Gérald HUARD on 20/06/12.
//  Copyright (c) 2012 Gérald HUARD. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController




-(void) loadView{
    [super loadView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *imgv=[[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 200, 300)];
    imgv.image=[UIImage imageNamed:@"img"];
    
    
    [self.view addSubview:imgv];
    
    UITapGestureRecognizer *tapgr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tapgr.numberOfTapsRequired=2;
    
    [self.view addGestureRecognizer:tapgr];
    _foldView=[YFoldView create:self.view numberOfFold:4 withWay:yFoldViewRightToLeft];
    _foldView.tag=0;
    
}


-(void) doubleTap:(UIGestureRecognizer*)gr{
    
    if (_foldView.tag==0){
        [_foldView closeAnimatedDuration:1];
        NSLog(@"close");
    }else{
        [_foldView openAnimatedDuration:1];
        NSLog(@"open");

    }
    
    
    _foldView.tag=(_foldView.tag+1)%2;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint current = [touch locationInView: self.view];
    [_foldView setEndPointPosition:current];
 }

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
