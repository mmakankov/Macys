//
//  MCProduct.h
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Entity.h"

@interface Product : Entity

/**
 Description of the product
 */
@property (nonatomic) NSString *description;

/**
 Regular price of the product
 */
@property (nonatomic) NSNumber *regularPrice;

/**
 Sale price of the product
 */
@property (nonatomic) NSNumber *salePrice;

/**
 Image of the product
 */
@property (nonatomic) NSString *image;

/**
 Available colors of the product
 */
@property (nonatomic) NSMutableArray *colors;

/**
 Available stores of the product
 */
@property (nonatomic) NSMutableArray *stores;

/**
 Initialize new Product
 @returns A newly created Product
 */
- (instancetype)initDefaultProduct;

@end
