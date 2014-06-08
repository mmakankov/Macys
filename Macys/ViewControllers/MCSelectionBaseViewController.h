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

/**
 MCSelectionBaseViewController's tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 MCSelectionBaseViewController's delegate
 */
@property (nonatomic, weak) id<MCSelectionViewControllerDelegate> delegate;

/**
 All available object from DB
 */
@property (nonatomic) NSArray *objects;

/**
 Object, that are selected
 */
@property (nonatomic) NSMutableArray *selectedObjects;

@end
