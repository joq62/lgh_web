-define(Port,60201).


-define(TempSensor,"weather_1").
-define(HeatherBalcony,"switch_inglasade_heather_balcony").
-define(HeatherDoor,"switch_inglasade_heather_door").
-define(MaxSessionTime,60*1000*60*5). %60*1000*60=hour 


-define(å,"&aring;").
-define(ä,"&auml;").
-define('ö',"&ouml;").
-define(Degrees,"&deg;").
-define(TempPrint(TempStr),TempStr++?Degrees++" C").

-define(NotAvailable,"Balkongsystem ej tillgaengligt- koll att el aer paeslagen ").
% -define(Available,"Balkongsystemet &aring;r tillg&aring;ngligt").
-define(Available,"Balkongsystemet "++?ä++"r tillg"++?ä++"ngligt").

-define(NoSession,"V"++?ä++"rmen "++?ä++"r inte p"++?å++"slagen och f"++?ö++"r att sl"++?å++" p"++?å++" den tryck p"++?å++" Starta v"++?ä++"rmen").




-define(InSession,"InSession").
%-define(InSession,"V&uml;en är p&aring;slagen").

-define(ErrorTemp,"-273&deg; C").

%  <p>This is a Swedish ö: &ouml;</p>
% <p>This is the Swedish character "å": &aring;</p>
%   <p>This is a Swedish character "ä" : &auml;</p>
%  <p>Temperature: 25&deg;C</p>

