/***********************************************************************************
 * Description      : ERROR_HANDLER_ServiceResponse
 * @author          : Malinda (SLK)
 * @since           : 19-04-2016
 * Copyright 2016 ABSI. All rights reserved.  
 ***********************************************************************************/
Public class ERROR_HANDLER_ServiceResponse{

    public static DTO_ServiceResponse putErrorCode(Boolean paramIsSuccess, String paramErrorCode, String paramErrorMessage){
        DTO_ServiceResponse res =  new DTO_ServiceResponse();
        res.isSuccess= paramIsSuccess;
        res.errorCode = paramErrorCode;
        res.errorMessage = paramErrorMessage;
        return res;
    }

}
