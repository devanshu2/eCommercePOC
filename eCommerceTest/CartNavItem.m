//
//  CartNavItem.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "CartNavItem.h"

@interface CartNavItem (){
    IBOutlet UILabel *cartCountLabel;
    IBOutlet UIImageView *cartIcon;
}

@end

@implementation CartNavItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCartCount:(NSInteger)cartCount{
    _cartCount = cartCount;
    cartCountLabel.text = @"";
    if (cartCount > 0) {
        cartCountLabel.hidden = NO;
        cartCountLabel.text = [NSString stringWithFormat:@"%ld", (long)cartCount];
        [cartCountLabel sizeToFit];
        cartCountLabel.frame = CGRectMake(cartCountLabel.frame.origin.x, cartCountLabel.frame.origin.y, cartCountLabel.frame.size.width + 6.0, cartCountLabel.frame.size.height);
        cartCountLabel.layer.cornerRadius = 5.0;
    }
    else{
        cartCountLabel.hidden = YES;
    }
}

- (CGFloat)getViewWidth{
    if (_cartCount > 0) {
        return (cartCountLabel.frame.origin.x + cartCountLabel.frame.size.width);
    }
    else{
        return (cartIcon.frame.origin.x + cartIcon.frame.size.width);
    }
}

@end
