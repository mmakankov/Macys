//
//  MCColorsViewController.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCColorsViewController.h"
#import "MCDBStorage.h"
#import "MCColorTableViewCell.h"
#import "Color.h"
#import "UIColor+Hex.h"

@interface MCColorsViewController ()

@end

@implementation MCColorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Colors";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    MCColorTableViewCell *colorCell = (MCColorTableViewCell *)cell;
    
    Color *color = self.objects[indexPath.row];
    colorCell.labelName.text = color.name;
    colorCell.viewColor.backgroundColor = [UIColor colorFromRGB:color.code.unsignedIntegerValue];
    colorCell.labelKey.text = nil;
    
    for (Color *selectedColor in self.selectedObjects) {
        if (selectedColor.id.intValue == color.id.intValue) {
            colorCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
}

#pragma mark - Getters and setters

- (NSArray *)objects {
    
    return [[MCDBStorage sharedInstance] allColors];
    
}

@end
