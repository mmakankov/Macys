//
//  Color.m
//  Macys
//
//  Created by mmakankov on 06/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "Color.h"

@implementation Color

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithJSONDictionary:dictionary];
    if (self) {
        self.code = dictionary[@"code"];
    }
    return self;
}

@end
