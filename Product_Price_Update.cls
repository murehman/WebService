/********************************************************************************************
 * Description      : Webservice to fetch data from AS400 to salesforce. 
 * @author          : Mushtaq (NL)
 * @since           : 06-06-2016
 * Copyright 2016 ABSI. All rights reserved.  
 ********************************************************************************************/
// ToDo... How can i introduce transaction here?????

global class Product_Price_Update{

    //get the pricebook2id from custom settings. getting a 0 value for net price and model name "name not specified" if these
    //values dont come along in the requeste.

    
    //Pricebook2__c customPricebook = Pricebook2__c.getInstance('Pricebook2Id');
    //if product modelCode field is blank it will not create any product or pricebook entry.
    public static DTO_ServiceResponse check_Product_Details(ProductRequest req, DTO_ServiceResponse response) {
   
        if (String.isBlank(req.modelCode)){
            return ERROR_HANDLER_ServiceResponse.putErrorCode(FALSE, ERROR_CODE_101, ERROR_MSG_101);
        }else{
            response.isSuccess = true;
            return response;
        }
    }


    //handles information from http call
    webservice static DTO_ServiceResponse Validate_Product_Detail(ProductRequest vProduct){
        Pricebook2__c customPricebook = Pricebook2__c.getInstance('Pricebook2Id');
        DTO_ServiceResponse response = new DTO_ServiceResponse();
        response = check_Product_Details(vProduct, response);

        if(String.isBlank(vProduct.netPrice)){
            vProduct.netPrice = customPricebook.Price_Not_Specified__c;
        }
        if(String.isBlank(vProduct.Model)){
            vProduct.Model = customPricebook.Name_Not_Specified__c;
        }
        if(response.isSuccess){
        
        try{
            list<Product2> products = [Select Id,  Name, Model_Code__c, IsActive 
                                    FROM Product2 
                                    WHERE Model_Code__c = :vProduct.modelCode limit 1];

        //check if product requested to be added aleready exist. if not add product also add pricebookentery.    
        if (products.isEmpty()) {
            createProductPricebookEntry(vProduct, customPricebook);

        // if product already exists. update it with new field values. 
        }else if (!products.isEmpty()){
            updateProductPricebookEntry(vProduct, products, customPricebook);
        }

        }catch(Exception ex){
            ex.getMessage();
        }

        }
        return response;


}
    // creates new product and related pricebookentry
    private static void createProductPricebookEntry(ProductRequest newProduct, Pricebook2__c customPricebook){
        Product2 prod = new Product2();
        PricebookEntry pricebookEntry = new PricebookEntry();
        prod.Name = newProduct.Model;
        prod.IsActive = newProduct.isActive;
        prod.Model_Code__c = newProduct.modelCode;
        try{
        insert prod;
        } catch(exception e){
            e.getMessage();
        }
        if (String.isNotEmpty(newProduct.StandaardPriceBookCodeEntry)){
            System.debug(newProduct.StandaardPriceBookCodeEntry);
        //if (String.isNotEmpty(newProduct.StandaardPriceBookCodeEntry)) {
            pricebookEntry.Pricebook_Entry_ID__c = newProduct.StandaardPriceBookCodeEntry;
            pricebookEntry.UnitPrice = Integer.valueOf(newProduct.netPrice);
            pricebookEntry.IsActive = newProduct.isActive;
            pricebookEntry.Pricebook2Id = customPricebook.Standard_Pricebook_Id__c;
            pricebookEntry.Product2Id = prod.Id;
            insert pricebookEntry;
            System.debug(pricebookEntry);
        }
    }
    //updates existing product and looks if a related price book entry exits.
    private static void updateProductPricebookEntry(ProductRequest updateProduct, Product2[] products, Pricebook2__c customPricebook){
        Product2 prod = new Product2();
        PricebookEntry pricebookEntry = new PricebookEntry();
        prod = products[0];
        prod.Name = updateProduct.Model;
        prod.IsActive = updateProduct.isActive;
        prod.Model_Code__c = updateProduct.modelCode;
        update prod;
        list<PricebookEntry> pricebookEntries = [Select Id 
                                                     From PricebookEntry 
                                                     Where Pricebook_Entry_ID__c = :updateProduct.StandaardPriceBookCodeEntry 
                                                     AND Product2Id = :prod.Id
                                                     limit 1];

        if (pricebookEntries.isEmpty() && String.isNotBlank(updateProduct.StandaardPriceBookCodeEntry)){
            createPricebookEntry(updateProduct, prod, pricebookEntry, customPricebook);
            } 
        else if(!pricebookEntries.isEmpty() && String.isNotBlank(updateProduct.StandaardPriceBookCodeEntry)) {
            updatePricebookEntry(updateProduct, pricebookEntry, pricebookEntries);

            }

    }

    //if product does not have a related pricebookentry it creates a new one.
    private static void createPricebookEntry(ProductRequest newPricebookEntry, Product2 prod, PricebookEntry pricebookEntry, Pricebook2__c customPricebook){
        pricebookEntry.Pricebook_Entry_ID__c = newPricebookEntry.StandaardPriceBookCodeEntry;
        pricebookEntry.UnitPrice = Integer.valueOf(newPricebookEntry.netPrice);
        pricebookEntry.IsActive = newPricebookEntry.isActive;
        pricebookEntry.Pricebook2Id = customPricebook.Standard_Pricebook_Id__c;
        pricebookEntry.Product2Id = prod.Id;
        insert pricebookEntry;
    }
    // if a product already has a related pricebook entry it updates its values.
     private static void updatePricebookEntry(ProductRequest updatePricebookEntry, PricebookEntry pricebookEntry, PricebookEntry[] pricebookEntries){
        pricebookEntry = pricebookEntries[0];
        pricebookEntry.UnitPrice = Integer.valueOf(updatePricebookEntry.netPrice);
        pricebookEntry.IsActive = updatePricebookEntry.isActive;
        update pricebookEntry;
    }

    // recieves the information from http call
     global class ProductRequest{
         webservice String Model;
         webservice boolean isActive;
         webservice String modelCode;
         webservice String StandaardPriceBookCodeEntry;
         webservice String netPrice;
     }
     ////Error Codes
     public static final String ERROR_CODE_101 = '101';
     public static final String ERROR_CODE_102 = '102';




     ////Error Messages
     public static final String ERROR_MSG_101 = System.Label.CL_PP_ERROR_MSG_101;
     public static final String ERROR_MSG_102 = System.Label.CL_PP_ERROR_MSG_102;
     
}
