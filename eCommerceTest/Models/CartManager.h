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

- (NSInteger)addProductToCart:(ProductEntity*)product withQuantity:(int)quantity forceQuantity:(BOOL)doForceful andMessage:(NSString**)message;

- (BOOL)removeProductFromCart:(ProductEntity*)product;

- (int)getQuantityForProductInCart:(ProductEntity*)product;

- (void)flushProductsFromCart;

- (NSArray *)getProductsInCart;

@end
