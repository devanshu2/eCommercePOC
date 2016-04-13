//
//  constants.h
//  eCommerceTest
//
//  Created by Devanshu Saini on 09/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#ifndef constants_h
#define constants_h

//For table product
#define TABLE_PRODUCT               @"product"
//For table product columns
#define COLUMN_PRODUCT_ID           @"product_id"
#define COLUMN_PRODUCT_NAME         @"product_name"
#define COLUMN_PRODUCT_IMAGE_URL    @"product_image_url"
#define COLUMN_PRODUCT_PRICE        @"product_price"
#define COLUMN_PRODUCT_CATEGORY     @"product_category"

//For table category
#define TABLE_CATEGORY              @"category"
//For table category columns
#define COLUMN_CATEGORY_ID          @"cat_id"
#define COLUMN_CATEGORY_NAME        @"cat_name"
#define COLUMN_CATEGORY_ORDER       @"cat_order"

//For table options
#define TABLE_OPTIONS               @"options"
//For table options columns
#define COLUMN_OPTIONS_ID           @"option_id"
#define COLUMN_OPTIONS_KEY          @"option_key"
#define COLUMN_OPTIONS_VALUE        @"option_value"

//Option Constants
#define DB_VERSION                  @"dbversion"
#define CURRENCY_SYMBOL             @"currency"

//DB File Name
#define DBFileName @"sqlAppDB.sqlite"

#endif /* constants_h */
