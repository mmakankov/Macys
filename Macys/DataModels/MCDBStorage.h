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

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));

+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (NSArray *)allProducts;

- (BOOL)saveOrUpdateProduct:(Product *)product;

- (Product *)createNewProduct;

- (BOOL)removeProduct:(Product *)product;

- (NSNumber*)productLastId;

//colors
- (NSArray *)allColors;

- (NSArray *)colorsForProductId:(NSNumber *)productId;

- (BOOL)addColor:(Color *)color toProduct:(Product *)product;

- (BOOL)removeColor:(Color *)color fromProduct:(Product *)product;

//stores
- (NSArray *)allStores;

- (BOOL)addStore:(Store *)color toProduct:(Product *)product;

- (BOOL)removeStore:(Store *)color fromProduct:(Product *)product;

@end
