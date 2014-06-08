//
//  MCImageViewController.h
//  Macys
//
//  Created by mmakankov on 07/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCImageViewController : UIViewController

/**
 Initialize MCImageViewController. Designated initializer.
 @param nibNameOrNil Name of the nib file
 @param nibBundleOrNil Bundle, where should search nib file
 @param dataImage image as NSData
 @returns An initialized MCImageViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataImage:(NSData *)dataImage;

@end
