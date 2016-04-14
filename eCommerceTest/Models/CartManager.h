//
//  CartManager.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEntity.h"
@interface CartManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)addProductToCart:(ProductEntity*)product;

- (BOOL)removeProductFromCart:(ProductEntity*)product;

- (NSInteger)isProductInCart:(ProductEntity*)product;

- (void)flushProductsFromCart;

- (NSArray *)getProductsInCart;

@end
