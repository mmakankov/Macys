//
//  MCSelectionBaseViewController.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCSelectionBaseViewController.h"
#import "MCDBStorage.h"
#import "Entity.h"

static NSString *cellIdentifier = @"ColorCell";

@interface MCSelectionBaseViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MCSelectionBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.allowsMultipleSelection = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.selectedObjects addObject:self.objects[indexPath.row]];
    [self.delegate objectDidSelected:self.objects[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.selectedObjects removeObject:self.objects[indexPath.row]];
    [self.delegate objectDidDeselected:self.objects[indexPath.row]];
    
}

- (NSString *)reuseIdentifier {
    return cellIdentifier;
}

@end
