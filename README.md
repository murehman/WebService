 WebSerivce to create, update and delete record in EmployeeTraining object.
    InnerClass EmployeeTechnicalLevelRequest recieves the request from AS400 through SOAP. 
    This information is stored in EmployeeTechnicalLevelRequest object.
    
    Do need to create custom labels used in this webservice in salesforce platform.
    
    Webservice Method is the method (webservice CreateUpdateEmployeeTechnicalLevel) which is called automatically 
    when request is recieved. All the other methods are called from within this method.

    Methods
        EmployeeTechnicalLevelCreateUpdate: This method validates that userName, technicalLevel, education and result
            fields in the request are not blank. In case of any blank value in these fields, it gives an error message and
            code does not run further.In case no none of these fields are empty. It gives a sucess response.

        CheckContactTrainingTechnicalLevelExist: This methods checks if information recieved in request like
        
            userName = Contact.Innovam_ID__c
            technicalLevel = Employee_Technical_Level.Employee_Technical_Level_ID__c
            education = Training.Training_ID__c
            user with InnovamID exist in cantact, technicalLevel exists in EmployeeTechnicalLevel and education exists in 
            Training objects. If any of them does not exist, it gives a specific error for every field. If all of them exist
            than it give a success response.

        checkIfEmployeeTechnicalLevelExits: 
            This method checks if request recieved already exists in EmployeeTraining. It returns an
            employeeTraining record if there already exists a rocord which can be deleted or updated. 
            OR it returns an empty record in case there is no matching record in EmployeeTraining, this can be inserted into EmployeeTraining.

