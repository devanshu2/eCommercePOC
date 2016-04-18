//
//  constants.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#ifndef constants_h
#define constants_h

//For table product
#define TABLE_PRODUCT               @"product"
//For table product columns
#define COLUMN_PRODUCT_ID           @"product_id"
#define COLUMN_PRODUCT_NAME         @"product_name"
#define COLUMN_PRODUCT_IMAGE_URL    @"product_image_url"
#define COLUMN_PRODUCT_LOCAL_IMAGE  @"product_local_image"
#define COLUMN_PRODUCT_PRICE        @"product_price"
#define COLUMN_PRODUCT_CATEGORY     @"product_category"
#define COLUMN_PRODUCT_ORDER        @"product_order"
#define COLUMN_PRODUCT_MAX_QUANTITY @"product_max_qty"

//For table category
#define TABLE_CATEGORY              @"category"
//For table category columns
#define COLUMN_CATEGORY_ID          @"cat_id"
#define COLUMN_CATEGORY_NAME        @"cat_name"
#define COLUMN_CATEGORY_ORDER       @"cat_order"

//For table category
#define TABLE_CART                  @"cart"
//For table category columns
#define COLUMN_CART_ID              @"cart_id"
#define COLUMN_CART_PRODUCT_ID      @"cart_product_id"
#define COLUMN_CART_QUANTITY        @"cart_quantity"
#define COLUMN_CART_ORDER           @"cart_order"


//For table options
#define TABLE_OPTIONS               @"options"
//For table options columns
#define COLUMN_OPTIONS_ID           @"option_id"
#define COLUMN_OPTIONS_KEY          @"option_key"
#define COLUMN_OPTIONS_VALUE        @"option_value"

//Option Constants
#define DB_VERSION_STRING           @"dbversion"
#define CURRENCY_SYMBOL_STRING      @"currency"

//DB File Name
#define DBFileName @"sqlAppDB.sqlite"

#define PRODUCT_PLACEHOLDER_IMAGE_NAME @"product-placeholder"
#define TABLE_ARROW_RIGHT_IMAGE_NAME @"arrow-right"

#define CURRENCY_SYMBOL [[AppOptions sharedInstance] getOptionValueForKey:CURRENCY_SYMBOL_STRING]

#define CART_COUNT_NOTIFICATION @"CART_COUNT_NOTIFICATION"

//put it to 0 to fetch images from server for products, 1 for fetching from local bundle images
#define USE_LOCAL_PRODUCT_IMAGES 1
#endif /* constants_h */
