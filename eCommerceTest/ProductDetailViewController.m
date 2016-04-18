//
//  ProductDetailViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devenshu Saini. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppOptions.h"
#import "constants.h"
#import "CartNavItem.h"
#import "CartManager.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

static NSString *cellIdentifierImage = @"imageCellIdentifier";
static NSString *cellIdentifierBasic = @"cellIdentifierBasic";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewItems];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartButtonInNavigationBar:) name:CART_COUNT_NOTIFICATION object:nil];
    [self setViewControllerNavigationBar];
    [self updateViewOnAppearing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CART_COUNT_NOTIFICATION object:nil];
}

#pragma mark - Private Methods

- (void)initViewItems{
    [_addToCartButton setBackgroundColor:[UIColor blueColor]];
    [_addToCartButton.titleLabel setTextColor:[UIColor whiteColor]];
    _addToCartButton.layer.cornerRadius = 5.0;
    self.theTable.rowHeight = UITableViewAutomaticDimension;
    self.theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateViewOnAppearing{
    _productQuantity.text = @"1";
}

- (void)setViewControllerNavigationBar{
    self.navigationItem.title = _theProduct.productName;
    [self updateCartButtonInNavigationBar:nil];
}

- (void)updateCartButtonInNavigationBar:(NSNotification*)notification{
    NSInteger cartCount = notification ? [notification.object integerValue] : [[[CartManager sharedInstance] getProductsInCart] count];
    CartNavItem *cartNavBar = (CartNavItem*)[[[NSBundle mainBundle] loadNibNamed:@"CartNavItem" owner:self options:nil] firstObject];
    [cartNavBar setCartCount:cartCount];
    [cartNavBar setFrame:CGRectMake(0.0, 0.0, [cartNavBar getViewWidth], 30.0)];
    UITapGestureRecognizer *cartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentModalOfCart)];
    cartTap.numberOfTapsRequired = 1;
    [cartNavBar addGestureRecognizer:cartTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cartNavBar];
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"modalSegue2"])
    {
        CartViewController *theCartViewController = segue.destinationViewController;
        [theCartViewController setDelegate:self];
        NSLog(@"dfd");
    }
}

#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = indexPath.row ? cellIdentifierBasic : cellIdentifierImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIImageView *productImage = (UIImageView *)[cell viewWithTag:1];
        if (USE_LOCAL_PRODUCT_IMAGES) {
            [productImage setImage:[UIImage imageNamed:_theProduct.productLocalImage]];
        }
        else{
            [productImage sd_setImageWithURL:[NSURL URLWithString:_theProduct.productImageURL] placeholderImage:[UIImage imageNamed:PRODUCT_PLACEHOLDER_IMAGE_NAME]];
        }
    }
    else if (indexPath.row == 1) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = _theProduct.productName;
        label.font = [UIFont boldSystemFontOfSize:17.0];
    }
    else if (indexPath.row == 2) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%@ %.02f", CURRENCY_SYMBOL, _theProduct.productPrice];
        label.font = [UIFont systemFontOfSize:14.0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return 200.0;
    }
    static UITableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [_theTable dequeueReusableCellWithIdentifier:cellIdentifierBasic];
    });
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - Actions

- (IBAction)addToCartButtonAction:(id)sender{
    NSString *message = nil;
    [[CartManager sharedInstance] addProductToCart:_theProduct withQuantity:[_productQuantity.text intValue] forceQuantity:NO andMessage:&message];
    if (message) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)quantityChangeAction:(UIStepper*)sender {
    _productQuantity.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
}

- (void)presentModalOfCart{
    [self performSegueWithIdentifier:@"modalSegue2" sender:nil];
}

#pragma mark - CartViewProductDelegate Methods

- (void)moveToProductPageForProduct:(ProductEntity*)product{
    _theProduct = product;
}

@end
