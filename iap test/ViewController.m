//
//  ViewController.m
//  iap test
//
//  Created by 张佗辉 on 2017/7/11.
//  Copyright © 2017年 张佗辉. All rights reserved.
//

#import "ViewController.h"
#import "IAPHelper/IAPShare.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	if(![IAPShare sharedHelper].iap) {
		NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.walewang.fzmj.01", @"com.walewang.fzmj.02",
						  @"com.walewang.fzmj.03", @"com.walewang.fzmj.04",
						  @"com.walewang.fzmj.05", @"com.walewang.fzmj.06", nil];
		
		[IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
	}
	
	[IAPShare sharedHelper].iap.production = YES;
	
	[[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
	 {
		 if(response > 0 ) {
			 SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
			 
			 NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
			 NSLog(@"Title: %@",product.localizedTitle);
			 
			 [[IAPShare sharedHelper].iap buyProduct:product
										onCompletion:^(SKPaymentTransaction* trans){
											
											if(trans.error)
											{
												NSLog(@"Fail %@",[trans.error localizedDescription]);
											}
											else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
												
												[[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"4b743ed8da1443e7825590acf3b7c440" onCompletion:^(NSString *response, NSError *error) {
													
													//Convert JSON String to NSDictionary
													NSDictionary* rec = [IAPShare toJSON:response];
													
													if([rec[@"status"] integerValue]==0)
													{
														
														[[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
														NSLog(@"SUCCESS %@",response);
														NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
													}
													else {
														NSLog(@"Fail");
													}
												}];
											}
											else if(trans.transactionState == SKPaymentTransactionStateFailed) {
												NSLog(@"Fail");
											}
										}];//end of buy product
		 }
	 }];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
