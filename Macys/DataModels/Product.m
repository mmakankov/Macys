//
//  MCProduct.m
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithJSONDictionary:dictionary];
    if (self) {
        self.description = dictionary[@"description"];
        self.regularPrice = dictionary[@"regularPrice"];
        self.salePrice = dictionary[@"salePrice"];
        self.image = dictionary[@"image"];
    }
    return self;
}

- (instancetype)initDefaultProduct {
    
    self = [self initWithJSONDictionary:nil];
    if (self) {
        self.name = @"New product";
        self.description = @"New description";
        self.colors = [NSMutableArray arrayWithCapacity:0];
        self.regularPrice = @1500.50;
        self.salePrice = @999.99;
    }
    return self;
}

- (instancetype)init {
    
    self = [self initDefaultProduct];
    if (self) {
        
    }
    return self;
}

@end
