//
//  CartFooterView.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 18/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "CartFooterView.h"

@implementation CartFooterView

- (void)awakeFromNib{
    [_proceedToCheckout setBackgroundColor:[UIColor blueColor]];
    [_proceedToCheckout.titleLabel setTextColor:[UIColor whiteColor]];
    _proceedToCheckout.layer.cornerRadius = 5.0;
}

@end
