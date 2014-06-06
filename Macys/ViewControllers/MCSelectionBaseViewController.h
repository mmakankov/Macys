//
//  MCSelectionBaseViewController.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Entity;

@protocol MCSelectionViewControllerDelegate <NSObject>

- (void)objectDidSelected:(Entity *)object;
- (void)objectDidDeselected:(Entity *)object;

@end

@interface MCSelectionBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id<MCSelectionViewControllerDelegate> delegate;

@property (nonatomic) NSArray *objects;

@property (nonatomic) NSMutableArray *selectedObjects;

@end
