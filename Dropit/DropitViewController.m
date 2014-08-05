//
//  DropitViewController.m
//  Dropit
//
//  Created by Sayantan Chakraborty on 05/08/14.
//  Copyright (c) 2014 Sayantan Chakraborty. All rights reserved.
//

#import "DropitViewController.h"
#import "DropitBehavior.h"

@interface DropitViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehavior *dropItBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppinView;

@end

@implementation DropitViewController

//@synthesize animator = _animator;
//@synthesize gravityBehavior = _gravityBehavior;
-(UIDynamicAnimator *)animator
{
    if(!_animator)
    {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}
-(DropitBehavior *)dropItBehavior
{
    if(!_dropItBehavior)
    {
        _dropItBehavior = [[DropitBehavior alloc]init];
        [self.animator addBehavior:_dropItBehavior];
    }
    return _dropItBehavior;
}

static const CGSize DROP_SIZE = {40 , 40};

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}

-(BOOL)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc]init];
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height/2; y>0; y-=DROP_SIZE.height) {
        BOOL rowIsComplted = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc]init];
        for (CGFloat x = DROP_SIZE.width/2; x<= self.gameView.bounds.size.width - DROP_SIZE.width/2; x+=DROP_SIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if(hitView.superview == self.gameView)
            {
                [dropsFound addObject:hitView];
            }else{
                rowIsComplted = NO;
                break;
            }
        }
        if (![dropsFound count]) {
            break;
        }
        if(rowIsComplted)[dropsToRemove addObjectsFromArray:dropsFound];
        
        if([dropsToRemove count]){
            for (UIView *drop in dropsToRemove) {
                [self.dropItBehavior removeItem:drop];
            }
            [self animateRemoveDrops:dropsToRemove];
        }
        
    }
    return NO;
}

-(void)animateRemoveDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5))- (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, y);
                         }
                     }
                     completion:^(BOOL finished){
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self drop];
}
- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self attachDroppingViewtoPoint:gesturePoint];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        self.attachment.anchorPoint = gesturePoint;
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self.animator removeBehavior:self.attachment];
    }
}

-(void)attachDroppingViewtoPoint:(CGPoint)anchorPoint
{
    if(self.droppinView){
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppinView attachedToAnchor:anchorPoint];
        self.droppinView = nil;
        [self.animator addBehavior:self.attachment];
    }
}

-(void) drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x*DROP_SIZE.width;
    
    UIView *dropView =[[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    
    self.droppinView = dropView;
    [self.dropItBehavior addItem:dropView];
}

-(UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0:return [UIColor greenColor];
            break;
        case 1:return [UIColor redColor];
            break;
        case 2:return [UIColor blueColor];
            break;
        case 3:return [UIColor orangeColor];
            break;
        case 4:return [UIColor blueColor];
            break;
        
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
