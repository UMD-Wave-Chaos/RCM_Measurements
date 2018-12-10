function logMessage(jEditbox,text,severity)
   % Ensure we have an HTML-ready editbox
   HTMLclassname = 'javax.swing.text.html.HTMLEditorKit';
   if ~isa(jEditbox.getEditorKit,HTMLclassname)
      jEditbox.setContentType('text/html');
   end
 
   % Parse the severity and prepare the HTML message segment
   if nargin == 3
       switch lower(severity(1))
          case 'i',  icon = 'greenarrowicon.gif'; color='blue';
          case 'w',  icon = 'demoicon.gif';       color='black';
          case 'e',  icon = 'warning.gif';        color = 'red';
          otherwise, icon = [];        color='blue';
       end
       icon = fullfile(matlabroot,'toolbox/matlab/icons',icon);
       iconTxt =['<img src="file:///',icon,'" height=16 width=16>'];
       msgTxt = ['&nbsp;<font color=',color,'>',text,'</font>'];
       newText = [iconTxt,msgTxt];
   else
       color = 'gray';
       newText = ['&nbsp;<font color=',color,'>',text,'</font>'];
   end
       endPosition = jEditbox.getDocument.getLength;
       if endPosition>0, newText=['<br/>' newText];  end

 
   % Place the HTML message segment at the bottom of the editbox
   currentHTML = char(jEditbox.getText);
   jEditbox.setText(strrep(currentHTML,'</body>',newText));
   endPosition = jEditbox.getDocument.getLength;
   jEditbox.setCaretPosition(endPosition); % end of content
end