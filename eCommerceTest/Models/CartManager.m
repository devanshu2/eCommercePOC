//
//  CartManager.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "CartManager.h"

#define CART_KEY @"cartdata"

@implementation CartManager

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static CartManager *theInstance;
    dispatch_once(&onceToken, ^{
        theInstance = [[CartManager alloc] init];
    });
    return theInstance;
}

- (BOOL)addProductToCart:(ProductEntity*)product{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:CART_KEY]) {
        [defaults setObject:@[] forKey:CART_KEY];
        [defaults synchronize];
    }
    NSMutableArray *cartProducts = [(NSArray*)[defaults objectForKey:CART_KEY] mutableCopy];
    for (NSDictionary *productData in cartProducts) {
        if ([[productData objectForKey:COLUMN_PRODUCT_ID] intValue] == product.productID) {
            return NO;
        }
    }
    [cartProducts addObject:product.productDictionaryData];
    [defaults setObject:cartProducts forKey:CART_KEY];
    [defaults synchronize];
    return YES;
}

- (NSInteger)isProductInCart:(ProductEntity*)product{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:CART_KEY]) {
        [defaults setObject:@[] forKey:CART_KEY];
        [defaults synchronize];
        return -1;
    }
    NSMutableArray *cartProducts = [(NSArray*)[defaults objectForKey:CART_KEY] mutableCopy];
    NSInteger counterIndex = -1;
    BOOL productExist = NO;
    for (NSDictionary *productData in cartProducts) {
        counterIndex++;
        if ([[productData objectForKey:COLUMN_PRODUCT_ID] intValue] == product.productID) {
            productExist = YES;
            break;
        }
    }
    return productExist ? counterIndex : -1;
}

- (BOOL)removeProductFromCart:(ProductEntity*)product{
    NSInteger counterIndex = [self isProductInCart:product];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cartProducts = [(NSArray*)[defaults objectForKey:CART_KEY] mutableCopy];
    if (counterIndex >= 0) {
        [cartProducts removeObjectAtIndex:counterIndex];
        [defaults setObject:cartProducts forKey:CART_KEY];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

- (void)flushProductsFromCart{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@[] forKey:CART_KEY];
    [defaults synchronize];
}

- (NSArray *)getProductsInCart{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:CART_KEY]) {
        return @[];
    }
    NSArray *cartProducts = [defaults objectForKey:CART_KEY];
    NSMutableArray *returnData = [@[] mutableCopy];
    for (NSDictionary *productsDataDictionary in cartProducts) {
        [returnData addObject:[[ProductEntity alloc] initWithProductDictionaryData:productsDataDictionary]];
    }
    return returnData;
}

@end
