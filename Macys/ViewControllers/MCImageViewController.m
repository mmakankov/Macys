//
//  MCImageViewController.m
//  Macys
//
//  Created by mmakankov on 07/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCImageViewController.h"

@interface MCImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *viewImage;

@property (nonatomic) NSData *dataImage;

@end

@implementation MCImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataImage:(NSData *)dataImage
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataImage = dataImage;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil dataImage:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.viewImage.image = [UIImage imageWithData:self.dataImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
