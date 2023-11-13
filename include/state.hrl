-define(NotAvailable,"Balkongsystem ej tillgaengligt- koll att el aer paeslagen ").
-define(Available,"Balkongsystem r tillgaengligt ").
-define(NoSession,"no_session_ongoing").

-define(InSession,"session_ongoing").
-define(ErrorTemp,"-273").


-record(state, {
		is_available,
		balcony_temp,
		in_session,
		socket_pid
	       }).
