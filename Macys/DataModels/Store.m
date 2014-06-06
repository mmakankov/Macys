//
//  Store.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Store.h"

@implementation Store

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithJSONDictionary:dictionary];
    if (self) {
        self.key = dictionary[@"key"];
    }
    return self;
}

@end
