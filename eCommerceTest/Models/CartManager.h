//
//  CartManager.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductEntity.h"
@interface CartManager : NSObject

/*!
 * @discussion Singleton instance of class
 * @return CartManager shared instance
 */
+ (instancetype)sharedInstance;

/*!
 * @discussion Add product to cart
 * @param Product of type ProductEntity
 * @param Quantity of type int
 * @param forceQuantity of type BOOL
 * @param Message of type NSString by reference
 * @return Affected items or added items in cart of type NSInteger
 */
- (NSInteger)addProductToCart:(ProductEntity*)product withQuantity:(int)quantity forceQuantity:(BOOL)doForceful andMessage:(NSString**)message;

/*!
 * @discussion Remove product from cart
 * @param Product of type ProductEntity
 * @return Success or failure type BOOL
 */
- (BOOL)removeProductFromCart:(ProductEntity*)product;


/*!
 * @discussion Get quantity of a product in the cart
 * @param Product of type ProductEntity
 * @return Quantity of that product type BOOL
 */
- (int)getQuantityForProductInCart:(ProductEntity*)product;


/*!
 * @discussion Flush products from the cart
 */
- (void)flushProductsFromCart;


/*!
 * @discussion Get all product in the cart
 * @return All product type NSArray
 */
- (NSArray *)getProductsInCart;

@end
