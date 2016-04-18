//
//  CartNavItem.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import "CartNavItem.h"
#import "constants.h"

@interface CartNavItem (){
    IBOutlet UILabel *cartCountLabel;
    IBOutlet UIImageView *cartIcon;
}

@end

@implementation CartNavItem

- (void)setCartCount:(NSInteger)cartCount{
    _cartCount = cartCount;
    cartCountLabel.text = @"";
    if (cartCount > 0) {
        cartCountLabel.hidden = NO;
        cartCountLabel.text = [NSString stringWithFormat:@"%ld", (long)cartCount];
        [cartCountLabel sizeToFit];
        cartCountLabel.frame = CGRectMake(cartCountLabel.frame.origin.x, cartCountLabel.frame.origin.y, cartCountLabel.frame.size.width + 4.0, cartCountLabel.frame.size.height);
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.size.height/2;
        cartCountLabel.clipsToBounds = YES;
        cartCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        cartCountLabel.hidden = YES;
    }
}

- (CGFloat)getViewWidth{
    if (_cartCount > 0) {
        return (cartCountLabel.frame.origin.x + cartCountLabel.frame.size.width + 8.0);
    }
    else{
        return (cartIcon.frame.origin.x + cartIcon.frame.size.width + 8.0);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
