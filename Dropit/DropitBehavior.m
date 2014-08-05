//
//  DropitBehavior.m
//  Dropit
//
//  Created by Sayantan Chakraborty on 05/08/14.
//  Copyright (c) 2014 Sayantan Chakraborty. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;

@end


@implementation DropitBehavior

-(instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.gravityBehavior];
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.animationOptions];
    return self;
}

-(UIDynamicItemBehavior *)animationOptions
{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc]init];
        _animationOptions.allowsRotation = NO;
    }
    return _animationOptions;
}

-(UIGravityBehavior *)gravityBehavior
{
    if(!_gravityBehavior)
    {
        _gravityBehavior =[[UIGravityBehavior alloc]init];
        _gravityBehavior.magnitude = 0.8;
    }
    return _gravityBehavior;
}

-(UICollisionBehavior *)collider
{
    if(!_collider)
    {
        _collider = [[UICollisionBehavior alloc]init];
        _collider.translatesReferenceBoundsIntoBoundary =YES;
    }
    return _collider;
}
-(void)addItem:(id <UIDynamicItem>)item
{
    [self.gravityBehavior addItem:item];
    [self.collider addItem:item];
    [self.animationOptions addItem:item];
}
-(void)removeItem:(id <UIDynamicItem>)item
{
    [self.gravityBehavior removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}
@end
