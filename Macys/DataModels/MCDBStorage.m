//
//  DBStorage.m
//  Macys
//
//  Created by mmakankov on 04/06/14.
//  Copyright (c) 2014 mmakankov. All rights reserved.
//

#import "MCDBStorage.h"
#import "FMDatabase.h"
#import "Product.h"
#import "Color.h"
#import "Store.h"
#import "UIColor+Hex.h"

NSString * const dataBaseDidChangeNotification = @"dataBaseDidChangeNotification";

@interface MCDBStorage ()

//@property (nonatomic, readonly) NSMutableArray *mutableArrayOfProducts;
@property (nonatomic, readonly) NSString *documentsDirectory;
//@property (nonatomic, readonly) NSString *databasePath;
@property (nonatomic) FMDatabase *database;

@end


@implementation MCDBStorage

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initUniqueInstance];
    });
    
    return sharedInstance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    if (self) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDBFileCreated = [fileManager fileExistsAtPath:[self.documentsDirectory stringByAppendingPathComponent:@"data.sqlite"]];
            
        self.database = [FMDatabase databaseWithPath:[self.documentsDirectory stringByAppendingPathComponent:@"data.sqlite"]];
        
        if (![self.database open]) {
            DLog(@"Error. Could not open database. %d: %@", self.database.lastErrorCode, self.database.lastErrorMessage);
            return nil;
        }
        
        if (!isDBFileCreated) {
            [self prepareDataBase];
        }
    }
    return self;
}

- (void)prepareDataBase {
        
    // first start
    [self.database executeUpdate:@"create table products (id integer primary key autoincrement, name text, description text, regularPrice double, salePrice double, image text)"];
    [self.database executeUpdate:@"create table colors (id integer primary key autoincrement, name text, code integer)"];
    [self.database executeUpdate:@"create table productsToColors (product integer, color integer)"];
    
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"red", @([UIColor redColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"green", @([UIColor greenColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"blue", @([UIColor blueColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"magenta", @([UIColor magentaColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"yellow", @([UIColor yellowColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"orange", @([UIColor orangeColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"black", @([UIColor blackColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"purple", @([UIColor purpleColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"brown", @([UIColor brownColor].colorCode)];
    [self.database executeUpdate:@"insert into colors (name, code) values (?, ?)", @"cyan", @([UIColor cyanColor].colorCode)];
    
    [self.database executeUpdate:@"create table stores (id integer primary key autoincrement, key text, name text)"];
    [self.database executeUpdate:@"create table productsToStores (product integer, store integer)"];
    
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st1", @"Store 1"];
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st2", @"Store 2"];
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st3", @"Store 3"];
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st4", @"Small Store"];
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st5", @"Large Store"];
    [self.database executeUpdate:@"insert into stores (key, name) values (?, ?)", @"st6", @"Huge Store"];
    
    [self readMockDataFromJSON];
    //[self.database commit];
}

#pragma mark - Public Methods

- (NSArray *)allProducts {
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from products"];
    
    NSMutableArray *products = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
        Product *product = [Product new];
        product.id = @([resultSet intForColumn:@"id"]);
        product.name = [resultSet stringForColumn:@"name"];
        product.description = [resultSet stringForColumn:@"description"];
        product.regularPrice = @([resultSet doubleForColumn:@"regularPrice"]);
        product.salePrice = @([resultSet doubleForColumn:@"salePrice"]);
        product.image = [resultSet stringForColumn:@"image"];
        product.colors = [NSMutableArray arrayWithArray:[self colorsForProductId:product.id]];
        product.stores = [NSMutableArray arrayWithArray:[self storesForProductId:product.id]];
        //DLog(@"%@", product.image);
        [products addObject:product];
    }
    [resultSet close];

    return products;
}

- (BOOL)saveOrUpdateProduct:(Product *)product {
    
    BOOL isCorrect = NO;
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from products where id = ?", product.id];
    
    
    if ([resultSet next]) {
            
        isCorrect = [self updateProduct:product];
        
        if (isCorrect) {
            [[NSNotificationCenter defaultCenter] postNotificationName:dataBaseDidChangeNotification object:nil];
        }
    }
    else {
        isCorrect = [self insertProduct:product];
    }
    
    return isCorrect;
}

- (Product *)createNewProduct {
    
    Product *product = [[Product alloc] initDefaultProduct];
    
    //if ([self insertProduct:product]) {
        return product;
    //}
    
    //return nil;
}

- (BOOL)removeProduct:(Product *)product {
    
    return [self.database executeUpdate:@"delete from products where id = ?", product.id];
    
}

- (NSNumber*)productLastId {
    
    NSString *query = [NSString stringWithFormat:@"SELECT last_insert_rowid() FROM products"];
    FMResultSet *resultSet = [self.database executeQuery:query];
    
    [resultSet next];
    NSDictionary *dictionary = resultSet.resultDictionary;
    
    return dictionary[@"last_insert_rowid()"];
}

#pragma mark - Colors

- (NSArray *)allColors {
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from colors"];
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
        Color *color = [Color new];
        color.id = [resultSet objectForColumnName:@"id"];
        color.name = [resultSet stringForColumn:@"name"];
        color.code = [resultSet objectForColumnName:@"code"];
        
        [colors addObject:color];
    }
    [resultSet close];

    return colors;
}

- (NSArray *)colorsForProductId:(NSNumber *)productId {
    
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT c.* FROM colors c, productsToColors  pc WHERE c.id = pc.color and pc.product = ?", productId];
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
        Color *color = [Color new];
        color.id = [resultSet objectForColumnName:@"id"];
        color.name = [resultSet stringForColumn:@"name"];
        color.code = [resultSet objectForColumnName:@"code"];
        
        [colors addObject:color];
    }
    [resultSet close];
    
    return colors;
}

- (BOOL)addColor:(Color *)color toProduct:(Product *)product {
    
    [self.database beginTransaction];
    BOOL isCorrect = [self.database executeUpdate:@"insert into productsToColors (product, color) values (?, ?)", product.id, color.id];
    [self.database commit];
    
    return isCorrect;
}

- (BOOL)removeColor:(Color *)color fromProduct:(Product *)product {
    
    [self.database beginTransaction];
    BOOL isCorrect = [self.database executeUpdate:@"delete from productsToColors where product = ? and color = ?", product.id, color.id];
    [self.database commit];
    
    return isCorrect;
}

#pragma mark - Stores

- (NSArray *)allStores {
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from stores"];
    
    NSMutableArray *stores = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
        Store *store = [Store new];
        store.id = [resultSet objectForColumnName:@"id"];
        store.key = [resultSet stringForColumn:@"key"];
        store.name = [resultSet stringForColumn:@"name"];
        [stores addObject:store];
    }
    [resultSet close];
    
    return stores;
}

- (NSArray *)storesForProductId:(NSNumber *)productId {
    
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT s.* FROM stores s, productsToStores ps WHERE s.id = ps.store and ps.product = ?", productId];
    
    NSMutableArray *stores = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
        Store *store = [Store new];
        store.id = [resultSet objectForColumnName:@"id"];
        store.key = [resultSet stringForColumn:@"key"];
        store.name = [resultSet stringForColumn:@"name"];
        
        [stores addObject:store];
    }
    [resultSet close];
    
    return stores;
}

- (BOOL)addStore:(Store *)store toProduct:(Product *)product {
    
    [self.database beginTransaction];
    BOOL isCorrect = [self.database executeUpdate:@"insert into productsToStores (product, store) values (?, ?)", product.id, store.id];
    [self.database commit];
    
    return isCorrect;
}

- (BOOL)removeStore:(Store *)store fromProduct:(Product *)product {
    
    [self.database beginTransaction];
    BOOL isCorrect = [self.database executeUpdate:@"delete from productsToStores where product = ? and store = ?", product.id, store.id];
    [self.database commit];
    
    return isCorrect;
}

#pragma mark - Privet Methods

- (BOOL)insertProduct:(Product *)product {
    
    [self.database beginTransaction];
    
    BOOL isCorrect = [self.database executeUpdate:@"insert into products (name, description, regularPrice, salePrice, image) values (?, ?, ?, ?, ?)",
                 product.name,
                 product.description,
                 product.regularPrice,
                 product.salePrice,
                 product.image];
    
    [self.database commit];
    
    product.id = [self productLastId];
    
    return isCorrect;
}

- (BOOL)updateProduct:(Product *)product {
    
    [self.database beginTransaction];
    
    BOOL isCorrect = [self.database executeUpdate:@"update products set name = ?, description = ?, regularPrice = ?, salePrice = ?, image = ? where id = ?",
                                                 product.name,
                                                 product.description,
                                                 product.regularPrice,
                                                 product.salePrice,
                                                 product.image,
                                                 product.id];
    [self.database commit];
    
    return isCorrect;
}

- (void)readMockDataFromJSON {
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mockData" ofType:@"json"]];
    
    NSError *error;
    
    NSArray *products = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        DLog(@"error: %@", error.localizedDescription);
    }
    else {
        for (NSDictionary *itemProduct in products) {
            
            Product *product = [[Product alloc] initWithJSONDictionary:itemProduct];
            [self insertProduct:product];
            
            for (NSDictionary *itemColor in itemProduct[@"colors"]) {
                
                Color *color = [[Color alloc] initWithJSONDictionary:itemColor];
                [self addColor:color toProduct:product];
                //[product.colors addObject:color];
            }
            for (NSDictionary *itemStore in itemProduct[@"stores"]) {
                
                Store *store = [[Store alloc] initWithJSONDictionary:itemStore];
                [self addStore:store toProduct:product];
                //[product.stores addObject:store];
            }
        }
    }
    
    /*
     NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:products options:NSJSONWritingPrettyPrinted error:&error];
     
     [[NSFileManager defaultManager] createFileAtPath:self.documentsDirectory contents:jsonData attributes:nil];
     */
}

- (NSArray *)getColorsForProductId:(NSNumber *)productId {
    
    FMResultSet *resultSet = [self.database executeQuery:@"select * from products"];
    
    NSMutableArray *colorsArray = [NSMutableArray arrayWithCapacity:0];
    
    while ([resultSet next]) {
        
    }
    // close the result set.
    [resultSet close];
    
    return colorsArray;
}

#pragma mark - Getters and setters

- (NSString *)documentsDirectory {
    
    static NSString *documentsDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    });
    return documentsDirectory;
}

@end
