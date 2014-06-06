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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProduct:(Product *)product;

@end
