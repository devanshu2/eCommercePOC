//
//  CartManager.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import "CartManager.h"
#import "DBManager.h"

@implementation CartManager

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static CartManager *theInstance;
    dispatch_once(&onceToken, ^{
        theInstance = [[CartManager alloc] init];
    });
    return theInstance;
}

- (void)updateCartCountToObservers{
    NSNumber *totalCartItems = [NSNumber numberWithUnsignedInteger:[[self getProductsInCart] count]];
    [[NSNotificationCenter defaultCenter]postNotificationName:CART_COUNT_NOTIFICATION object:totalCartItems];
}

- (NSInteger)addProductToCart:(ProductEntity*)product withQuantity:(int)quantity forceQuantity:(BOOL)doForceful andMessage:(NSString**)message{
    if (quantity <= 0) {
        *message = @"Invalid Quanity";
        return 0;
    }
    int productExistingQuantity = [self getQuantityForProductInCart:product];
    NSString *sqlQuery;
    DBManager *dbMgr = [DBManager sharedInstance];
    if (productExistingQuantity) {
        *message = @"Product quanity successfully updated in cart.";
        quantity = doForceful ? quantity : (quantity + productExistingQuantity);
        if (quantity > product.productMaxQuantity) {
            *message = [NSString stringWithFormat:@"The max quantity to buy per user is %d\nUpdated quantity to %d instead of %d", product.productMaxQuantity, product.productMaxQuantity, quantity];
            quantity = product.productMaxQuantity;
        }
        sqlQuery = [NSString stringWithFormat:@"update %@ set %@ = %d where %@ = %d", TABLE_CART, COLUMN_CART_QUANTITY, quantity, COLUMN_CART_PRODUCT_ID, product.productID];
        dbMgr.affectedRows = 0;
        [dbMgr executeQuery:sqlQuery];
        NSInteger affectedRows = dbMgr.affectedRows;
        [self updateCartCountToObservers];
        return affectedRows;
    }
    else{
        *message = @"Product successfully added in cart.";
        if (quantity > product.productMaxQuantity) {
            *message = [NSString stringWithFormat:@"The max quantity to buy per user is %d\nUpdated quantity to %d instead of %d", product.productMaxQuantity, product.productMaxQuantity, quantity];
            quantity = product.productMaxQuantity;
        }
        sqlQuery = [NSString stringWithFormat:@"select (max(%@)+1) as neworder from %@", COLUMN_CART_ORDER, TABLE_CART];
        int newOrder = 0;
        NSArray *orderData = [dbMgr loadDataFromDB:sqlQuery];
        if ([orderData count]) {
            newOrder = [[[orderData firstObject] objectForKey:@"neworder"] intValue];
        }
        sqlQuery = [NSString stringWithFormat:@"INSERT INTO %@(%@, %@, %@) VALUES(%d,%d,%d)", TABLE_CART, COLUMN_CART_PRODUCT_ID, COLUMN_CART_QUANTITY, COLUMN_CART_ORDER, product.productID, quantity, newOrder];
        dbMgr.lastInsertedRowID = 0;
        [dbMgr executeQuery:sqlQuery];
        NSInteger lastInsertedRowID = dbMgr.lastInsertedRowID;
        [self updateCartCountToObservers];
        return lastInsertedRowID;
    }
}

- (int)getQuantityForProductInCart:(ProductEntity*)product{
    NSString *sqlQuery = [NSString stringWithFormat:@"select %@ from %@ where %@ = %d", COLUMN_CART_QUANTITY, TABLE_CART, COLUMN_CART_PRODUCT_ID, product.productID];
    NSArray *data = [[DBManager sharedInstance] loadDataFromDB:sqlQuery];
    if (data.count) {
        return [[[data firstObject] objectForKey:COLUMN_CART_QUANTITY] intValue];
    }
    return 0;
}

- (BOOL)removeProductFromCart:(ProductEntity*)product{
    DBManager *dbMgr = [DBManager sharedInstance];
    dbMgr.affectedRows = 0;
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@ where %@ = %d", TABLE_CART, COLUMN_CART_PRODUCT_ID, product.productID];
    [dbMgr executeQuery:sqlQuery];
    BOOL returnData = (BOOL)dbMgr.affectedRows;
    [self updateCartCountToObservers];
    return returnData;
}

- (void)flushProductsFromCart{
    DBManager *dbMgr = [DBManager sharedInstance];
    dbMgr.affectedRows = 0;
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from %@ where 1=1", TABLE_CART];
    [dbMgr executeQuery:sqlQuery];
    [self updateCartCountToObservers];
}

- (NSArray *)getProductsInCart{
    NSString *query = [NSString stringWithFormat:@"select * from %@ left join %@ on %@ = %@ order by %@", TABLE_CART, TABLE_PRODUCT, COLUMN_CART_PRODUCT_ID, COLUMN_PRODUCT_ID, COLUMN_CART_ORDER];
    NSArray *products = [[DBManager sharedInstance] loadDataFromDB:query];
    return products;
}

@end
