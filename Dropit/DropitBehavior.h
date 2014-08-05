//
//  DropitBehavior.h
//  Dropit
//
//  Created by Sayantan Chakraborty on 05/08/14.
//  Copyright (c) 2014 Sayantan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior
-(void)addItem:(id <UIDynamicItem>)item;
-(void)removeItem:(id <UIDynamicItem>)item;

@end
