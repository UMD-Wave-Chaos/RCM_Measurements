function logError(jEditbox,err)

logMessage(jEditbox,err.message);
     
     if strcmp(err.identifier,'MATLAB:UndefinedFunction')
         logMessage(handles.jEditbox,err.getReport(),'error');
     end