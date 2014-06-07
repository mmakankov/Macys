//
//  MCStoresViewController.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCStoresViewController.h"
#import "MCDBStorage.h"
#import "Store.h"
#import "MCColorTableViewCell.h"

@interface MCStoresViewController ()

@end

@implementation MCStoresViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.title = @"Stores";
        
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
    
    MCColorTableViewCell *storeCell = (MCColorTableViewCell *)cell;
    
    Store *store = self.objects[indexPath.row];
    storeCell.labelName.text = store.name;
    storeCell.labelKey.text = store.key;
    storeCell.viewColor.backgroundColor = [UIColor clearColor];
    
    for (Store *selectedStore in self.selectedObjects) {
        if (selectedStore.id.intValue == store.id.intValue) {
            storeCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
}

#pragma mark - Getters and setters

- (NSArray *)objects {
    
    return [[MCDBStorage sharedInstance] allStores];
    
}

@end
