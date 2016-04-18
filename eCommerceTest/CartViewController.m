//
//  CartViewController.m
//  eCommerceTest
//
//  Created by Devanshu Saini on 14/04/16.
//  Copyright © 2016 Devanshu Saini. All rights reserved.
//

#import "CartViewController.h"
#import "CartManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AppOptions.h"
#import "CartFooterView.h"

#define KEY_PRODUCT @"product"
#define KEY_QUANTITY @"quantity"

#define CELL_TAG_PRODUCT_IMAGE 11
#define CELL_TAG_PRODUCT_TITLE 12
#define CELL_TAG_PRODUCT_UNIT_PRICE 13
#define CELL_TAG_PRODUCT_QUANTITY 14
#define CELL_TAG_PRODUCT_PRICE 15
#define CELL_TAG_PRODUCT_DELETE 16
#define CELL_TAG_PRODUCT_VIEW 17

@interface CartViewController (){
    NSInteger pickerNumberOfRows;
    NSMutableArray *tableData;
    UIAlertController *alertController;
    double cartTotalAmount;
}

@end

@implementation CartViewController

static NSString *productCellIdentifier = @"cartcellidentifier";
static NSString *noRecordsCellIdentifier = @"norecordscellidentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewItems];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewControllerNavigationBar];
    [self setupCart];
}

#pragma mark - Private Methods

- (void)setupCart{
    cartTotalAmount = 0;
    NSArray *products = [[CartManager sharedInstance] getProductsInCart];
    tableData = [@[] mutableCopy];
    for (NSDictionary *productData in products) {
        ProductEntity *product = [[ProductEntity alloc] initWithProductDictionaryData:productData];
        NSDictionary *dataElement = @{KEY_PRODUCT : product, KEY_QUANTITY : [productData objectForKey:COLUMN_CART_QUANTITY]};
        cartTotalAmount += product.productPrice * [[productData objectForKey:COLUMN_CART_QUANTITY] integerValue];
        [tableData addObject:dataElement];
    }
}

- (void)initViewItems{
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pickerNumberOfRows = 1;
    self.pickerViewBottomCons.constant = -250.0;
}

- (void)setViewControllerNavigationBar{
    self.navigationItem.title = @"Cart";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelButtonAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerNumberOfRows;
}

#pragma mark - UIPickerViewDelegate Methods

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", (long)(row + 1)];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (![tableData count]) {
        return nil;
    }
    CartFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"CartFooterView" owner:self options:nil] firstObject];
    footerView.totalLabel.text = [NSString stringWithFormat:@"Total: %@ %.02f", CURRENCY_SYMBOL, cartTotalAmount];
    [footerView.proceedToCheckout addTarget:self action:@selector(checkOutAction) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [tableData count] ? 38.0 : 0.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count] ? [tableData count] : 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [tableData count] ? productCellIdentifier : noRecordsCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([tableData count]) {
        [self configureProductCell:cell ForIndexPath:indexPath];
    }
    else{
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"No product in cart.";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)configureProductCell:(UITableViewCell*)cell ForIndexPath:(NSIndexPath*)indexPath{
    UIImageView *productImageView = [cell viewWithTag:CELL_TAG_PRODUCT_IMAGE];
    UILabel *productTitleLabel = [cell viewWithTag:CELL_TAG_PRODUCT_TITLE];
    UILabel *productUnitPriceLabel = [cell viewWithTag:CELL_TAG_PRODUCT_UNIT_PRICE];
    EComButton *productQuantityButton = [cell viewWithTag:CELL_TAG_PRODUCT_QUANTITY];
    [productQuantityButton.layer setCornerRadius:5.0];
    [productQuantityButton.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [productQuantityButton.layer setBorderWidth:1.0];
    [productQuantityButton setBackgroundColor:[UIColor clearColor]];
    UILabel *productPriceLabel = [cell viewWithTag:CELL_TAG_PRODUCT_PRICE];
    EComButton *viewProductButton = [cell viewWithTag:CELL_TAG_PRODUCT_VIEW];
    EComButton *deleteProductButton = [cell viewWithTag:CELL_TAG_PRODUCT_DELETE];
    
    NSDictionary *productElementData = [tableData objectAtIndex:indexPath.row];
    ProductEntity *product = [productElementData objectForKey:KEY_PRODUCT];
    NSInteger productQuantity = [[productElementData objectForKey:KEY_QUANTITY] integerValue];
    
    if (USE_LOCAL_PRODUCT_IMAGES) {
        [productImageView setImage:[UIImage imageNamed:product.productLocalImage]];
    }
    else{
        [productImageView sd_setImageWithURL:[NSURL URLWithString:product.productImageURL] placeholderImage:[UIImage imageNamed:PRODUCT_PLACEHOLDER_IMAGE_NAME]];
    }
    productTitleLabel.text = product.productName;
    productUnitPriceLabel.text = [NSString stringWithFormat:@"%@ %.02f", CURRENCY_SYMBOL, product.productPrice];
    [productQuantityButton setTitle:[NSString stringWithFormat:@"%ld", (long)productQuantity] forState:UIControlStateNormal];
    productPriceLabel.text = [NSString stringWithFormat:@"%@ %.02f", CURRENCY_SYMBOL, ((double)productQuantity * product.productPrice)];
    viewProductButton.extraTag = indexPath.row;
    deleteProductButton.extraTag = indexPath.row;
    productQuantityButton.extraTag  = indexPath.row;
    [productQuantityButton addTarget:self action:@selector(quantityOfProductAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewProductButton addTarget:self action:@selector(viewProductAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteProductButton addTarget:self action:@selector(deleteProductAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)quantityOfProductAction:(EComButton*)sender{
    NSDictionary *productElementData = [tableData objectAtIndex:sender.extraTag];
    ProductEntity *product = [productElementData objectForKey:KEY_PRODUCT];
    NSInteger productQuantity = [[productElementData objectForKey:KEY_QUANTITY] integerValue];
    pickerNumberOfRows = product.productMaxQuantity;
    _quantityPicker.delegate = self;
    _quantityPicker.dataSource = self;
    [_quantityPicker reloadAllComponents];
    [_quantityPicker selectRow:(productQuantity - 1) inComponent:0 animated:NO];
    self.pickerViewBottomCons.constant = 0.0;
    _quantityPickerUpdate.tag = sender.extraTag;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.extraTag inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }
    }];
}

- (void)viewProductAction:(EComButton*)sender{
    NSDictionary *productElementData = [tableData objectAtIndex:sender.extraTag];
    ProductEntity *product = [productElementData objectForKey:KEY_PRODUCT];
    if ([self.delegate respondsToSelector:@selector(moveToProductPageForProduct:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate performSelector:@selector(moveToProductPageForProduct:) withObject:product];
        }];
    }
}

- (void)deleteProductAction:(EComButton*)sender{
    alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete this product from cart?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *productElementData = [tableData objectAtIndex:sender.extraTag];
        ProductEntity *product = [productElementData objectForKey:KEY_PRODUCT];
        [[CartManager sharedInstance] removeProductFromCart:product];
        [self setupCart];
        [_tableView reloadData];
    }];
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pickerCancelAction:(id)sender {
    self.pickerViewBottomCons.constant = -250.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)pickerUpdateAction:(UIButton*)sender {
    NSDictionary *productElementData = [tableData objectAtIndex:sender.tag];
    ProductEntity *product = [productElementData objectForKey:KEY_PRODUCT];
    NSInteger productQuantity = [[productElementData objectForKey:KEY_QUANTITY] integerValue];
    NSInteger selectedPickerItem = [_quantityPicker selectedRowInComponent:0];
    selectedPickerItem = (selectedPickerItem == -1) ? productQuantity : (selectedPickerItem + 1);
    NSString *message = nil;
    [[CartManager sharedInstance] addProductToCart:product withQuantity:(int)selectedPickerItem forceQuantity:YES andMessage:&message];
    if (message) {
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setupCart];
            [_tableView reloadData];
            [_tableView beginUpdates];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            [self pickerCancelAction:nil];
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)checkOutAction{
    alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thanks for buying." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CartManager sharedInstance] flushProductsFromCart];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
