//
//  MCDetailViewController.h
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface MCDetailViewController : UIViewController

/**
 Initialize MCDetailViewController. Designated initializer.
 @param nibNameOrNil Name of the nib file
 @param nibBundleOrNil Bundle, where should search nib file
 @param product Product to load
 @returns An initialized MCDetailViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProduct:(Product *)product;

@end
