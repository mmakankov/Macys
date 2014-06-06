//
//  MCProduct.h
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Entity.h"

@interface Product : Entity

@property (nonatomic) NSString *description;
@property (nonatomic) NSNumber *regularPrice;
@property (nonatomic) NSNumber *salePrice;
@property (nonatomic) NSString *image;
@property (nonatomic) NSMutableArray *colors;
@property (nonatomic) NSMutableArray *stores;

- (instancetype)initDefaultProduct;

@end
