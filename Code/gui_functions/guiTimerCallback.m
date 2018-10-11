function guiTimerCallback(obj, event, handles)

%generate random values for xpos,ypos,zpos,apos,bpos, xspeed,yspeed and
%zspeed
try

    %check the mode and set the status bar text
   % switch obj.UserData
    %    case 'Initializing'
     %       set(handles.statusBarTxt,'Background',java.awt.Color.lightGray);
      %      set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
       % case 'Idle'
        %    set(handles.statusBarTxt,'Background',java.awt.Color.lightGray);
         %   set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
       % case 'Sweeping'
         %   set(handles.statusBarTxt,'Background',java.awt.Color.yellow);
        %    set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
        %case 'Measuring'
         %   set(handles.statusBarTxt,'Background',java.awt.Color.green);
          %  set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
        %case 'Calibrating'
         %   set(handles.statusBarTxt,'Background',java.awt.Color.green);
          %  set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
        %case 'Running'
         %   set(handles.statusBarTxt,'Background',java.awt.Color.green);
          %  set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
        %case 'Closing'
         %   set(handles.statusBarTxt,'Background',java.awt.Color.lightGray);
          %  set(handles.statusBarTxt,'Foreground',java.awt.Color.black);
        %otherwise
    %end
    
catch err
     logMessage(handles.jEditbox,err.message,'error');
end