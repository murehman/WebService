/********************************************************************************************
 * Description      : Test Class for Product_Price_Update. 
 * @author          : Mushtaq (NL)
 * @since           : 06-06-2016
 * Copyright 2016 ABSI. All rights reserved.  
 ********************************************************************************************/
 @isTest(SeeAllData=true)
 private Class Product_Price_Update_TestClass{
 	/* First creates a product with pricebook entry and than updates field values of existing project*/
 	Static testmethod void validateProductInsertion(){
    	/* make a new instance of custom settings Object and give value to its fields.*/
    	
 		Product_Price_Update.ProductRequest prodReq = new Product_Price_Update.ProductRequest();
 		prodReq.Model = 'I-zIEV i-ziEV';
 		prodReq.isActive = true;
 		prodReq.modelCode = 'modelcode';
 		prodReq.netPrice = '21479';
 		prodReq.StandaardPriceBookCodeEntry = 'modelcode';
 		Product_Price_Update.Validate_Product_Detail(prodReq);
 		//Product_Price_Update.Validate_Product_Detail(prodReq, cs);
 		
 		List<Product2> products = [Select Model_Code__c
 							FROM Product2
 							 WHERE Model_Code__c = :prodReq.modelCode];
 		
 		List<PricebookEntry> pricebookEntries = [Select Pricebook_Entry_ID__c, UnitPrice, IsActive
 												FROM PricebookEntry
 												WHERE Pricebook_Entry_ID__c = :prodReq.StandaardPriceBookCodeEntry];
 		//test if creation works.
 		// check if product is added.
 		System.assertEquals(products.size(), 1);
 		//check if pricebook entry is added.
 		System.assertEquals(pricebookEntries.size(), 1);
 

 		prodReq.netPrice = '11111';
 		prodReq.StandaardPriceBookCodeEntry = 'modelcode';
 		prodReq.modelCode = 'modelcode';

 		Product_Price_Update.Validate_Product_Detail(prodReq);
 		
 		products = [Select Model_Code__c, Name, IsActive
 							FROM Product2
 							 WHERE Model_Code__c = :prodReq.modelCode];
 		Product2 product = products[0];
 		//System.debug(product);
 		pricebookEntries = [Select Pricebook_Entry_ID__c, UnitPrice, IsActive
 							FROM PricebookEntry
 							WHERE Pricebook_Entry_ID__c = :prodReq.StandaardPriceBookCodeEntry 
 							AND Product2Id = :product.Id];

 		PricebookEntry pricebookEntry = pricebookEntries[0];
 		
 		System.assertEquals(pricebookEntry.UnitPrice, Integer.valueOf('11111'));
 	}

 	/* first makes one product without pricecode entry. so we have a product without pricecode entry than we update the product
 	and add pricebook entry */ 
 	Static testmethod void validatePricebookentry(){
 		
 		Product_Price_Update.ProductRequest prodReq = new Product_Price_Update.ProductRequest();
 		prodReq.Model = 'I-NIEV i-NiEV';
 		prodReq.isActive = true;
 		prodReq.modelCode = 'modelcode2';
 		prodReq.StandaardPriceBookCodeEntry = '';
 		prodReq.netPrice = '5000';
 		
 		Product_Price_Update.Validate_Product_Detail(prodReq);
 //		//Product_Price_Update.Validate_Product_Detail(prodReq);
 		
 		List<Product2> products = [Select Model_Code__c
 							FROM Product2
 							 WHERE Model_Code__c = :prodReq.modelCode];
 		Product2 product1 = products[0];
 		List<PricebookEntry> pricebookEntries = [Select Pricebook_Entry_ID__c
 													FROM PricebookEntry
 													WHERE Pricebook_Entry_ID__c = :prodReq.StandaardPriceBookCodeEntry
 													AND Product2Id = :product1.Id];
 //		//test if creation works.
 //		// test product is added.
 		System.assertEquals(products.size(), 1);
 //		//System.debug(pricebookEntries[0]);
 //		//test there is no pricebook entry for this product.
 		System.assertEquals(pricebookEntries.size(), 0);
	//	// add pricebook entry into same product
		prodReq.Model = 'I-NIEV i-NiEV';
 		prodReq.isActive = true;
 		prodReq.modelCode = 'modelcode2';
 		prodReq.netPrice = '21479';
 		prodReq.StandaardPriceBookCodeEntry = 'modelcode2';
 		Product_Price_Update.Validate_Product_Detail(prodReq);
 		products = [Select Model_Code__c
 					FROM Product2
 					WHERE Model_Code__c = :prodReq.modelCode];
 		Product2 product = products[0];
 		pricebookEntries = [Select Pricebook_Entry_ID__c
 							FROM PricebookEntry
 							WHERE Pricebook_Entry_ID__c = :prodReq.StandaardPriceBookCodeEntry
 							AND Product2Id = :product.Id];
 		PricebookEntry pricebookEntry = pricebookEntries[0];
 //		System.debug(pricebookEntry);
 //	//	//check if product
 		System.assertEquals(products.size(), 1);

 //	//	//test if we have sucessfully added pricebook entry into that same product.
		System.assertEquals(pricebookEntries.size(), 1);
		//System.assertEquals(product.Name, 'Name Not Specified');

	}

 }
