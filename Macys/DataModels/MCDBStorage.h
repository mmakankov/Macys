//
//  DBStorage.h
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Product;
@class Color;
@class Store;

extern NSString * const dataBaseDidChangeNotification;

@interface MCDBStorage : NSObject

/**
 @returns Unique shared instance of the MCDBStorage
 */
+(instancetype) sharedInstance;

/**
 Unavailable method
 */
+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

/**
 Unavailable method
 */
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));

/**
 Unavailable method
 */
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

#pragma mark - Products

/**
 Get all Product entities from DB
 @returns An array of all Product entities from DB
 */
- (NSArray *)allProducts;

/**
 Save or update Product entity in DB.
 Method detects existence of recieved product in DB and creates new entity if not.
 @param product Product to save or update
 @returns Value indicates that method worked correctly
 */
- (BOOL)saveOrUpdateProduct:(Product *)product;

/**
 Remove Product entity from DB
 @param product Product to remove
 @returns Value indicates that method worked correctly
 */
- (BOOL)removeProduct:(Product *)product;

#pragma mark - Colors

/**
 Get all Color entities from DB
 @returns An array of all Color entities from DB
 */
- (NSArray *)allColors;

/**
 Add Color entity to product's relations in DB
 @param color Color to add
 @param product Product to process
 @returns value indicates that method worked correctly
 */
- (BOOL)addColor:(Color *)color toProduct:(Product *)product;

/**
 Remove Color entity from product's relations in DB
 @param color Color to remove
 @param product Product to process
 @returns Value indicates that method worked correctly
 */
- (BOOL)removeColor:(Color *)color fromProduct:(Product *)product;

#pragma mark - Stores

/**
 Get all store entities from DB
 @returns An array of all Store entities from DB
 */
- (NSArray *)allStores;

/**
 Add Store entity to product's relations in DB
 @param store Store to add
 @param product Product to process
 @returns value indicates that method worked correctly
 */
- (BOOL)addStore:(Store *)store toProduct:(Product *)product;

/**
 Remove Store entity from product's relations in DB
 @param store Store to remove
 @param product Store to process
 @returns Value indicates that method worked correctly
 */
- (BOOL)removeStore:(Store *)color fromProduct:(Product *)product;

@end
