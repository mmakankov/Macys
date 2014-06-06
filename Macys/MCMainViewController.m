//
//  MCViewController.m
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCMainViewController.h"
#import "MCDBStorage.h"
#import "Product.h"
#import "MCDetailViewController.h"
#import "Base64.h"

@interface MCMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSArray *products;

@end

@implementation MCMainViewController

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataBaseDidChangeNotification:) name:dataBaseDidChangeNotification object:nil];
    
    self.title = @"Products";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddClicked:)];
    
    self.navigationItem.rightBarButtonItem = buttonAdd;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataBaseDidChangeNotification object:nil];
}

#pragma mark - Private methods

#pragma mark - Handle Notifications

- (void)dataBaseDidChangeNotification:(NSNotification *)notification {
    
    [self.tableView reloadData];
    
}

#pragma mark - Actions

- (void)buttonAddClicked:(id)sender {
    
    Product *product = [[MCDBStorage sharedInstance] createNewProduct];
    
    BOOL isSaved = [[MCDBStorage sharedInstance] saveOrUpdateProduct:product];
    if (isSaved) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        DLog(@"Could not save product!");
    }
}

#pragma mark - Handle Notifications



#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Product *product = self.products[indexPath.row];
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text = product.description;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:product.image]];
    //cell.imageView.contentMode = UIViewContentMode;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCDetailViewController *detailController = [[MCDetailViewController alloc] initWithNibName:@"DetailView" bundle:[NSBundle mainBundle] andProduct:self.products[indexPath.row]];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BOOL isDeleted = [[MCDBStorage sharedInstance] removeProduct:self.products[indexPath.row]];
        
        if (isDeleted) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - Getters and setters

- (NSArray *)products {
    return [[MCDBStorage sharedInstance] allProducts];
}

@end
