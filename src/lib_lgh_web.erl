%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_lgh_web). 

%% API
-export([
	 
	 init_web/2,
	 start_new_session/1,
	 stop_session/1

	]).

-include("lgh_web.hrl").
-include("state.hrl").
-include("log.api").

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
init_web(State,SocketPid)->
    
    StateArgs=case rd:call(balcony_pid,is_available,[],5000) of
		  {error,Reason}->
		      ?LOG_WARNING("Error when checking availability",Reason),
		      [{is_available=?NotAvailable},{balcony_temp=?ErrorTemp},
		       {in_session=?NoSession},{socket_pid=SocketPid}];
		  false->
		      ?LOG_WARNING("Error when checking availability",[]),
		      [{is_available,?NotAvailable},{balcony_temp,?ErrorTemp},
		       {in_session,?NoSession},{socket_pid,SocketPid}];
		  true->
		      case rd:call(balcony_pid,get_temp,[],5000) of
			  {error,Reason}->
			      ?LOG_WARNING("Error when checking temp ",Reason),
			      [{is_available,?Available},{balcony_temp,?ErrorTemp},
			       {in_session,?NoSession},{socket_pid,SocketPid}];
			  TempFloat ->
			      TempStr=float_to_list(TempFloat,[{decimals,1}]),
			      Temp=?TempPrint(TempStr),
			     % Temp=float_to_list(TempFloat,[{decimals,1}])++" "++?degree++" C",
			      [{is_available,?Available},{balcony_temp,Temp},
			       {in_session,?NoSession},{socket_pid,SocketPid}]
		      end
	      end,
    Result=format_text(init,State#state{
			      is_available=proplists:get_value(is_available,StateArgs),
			      balcony_temp=proplists:get_value(balcony_temp,StateArgs),
			      in_session=proplists:get_value(in_session,StateArgs),
			      socket_pid=proplists:get_value(socket_pid,StateArgs)
			     }),
    
    io:format("Result ~p~n",[{Result,?MODULE,?FUNCTION_NAME,?LINE}]),
    Result.
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
start_new_session(State)->
  %% Check if avaialble
   %    IsAvailable=case rd:call(balcony_pid,is_available,[],5000) of
%		     true->
%			 "Available";
%		     false ->
%			 "Not available"
%		 end,
    IsAvailable="Available",
    case rd:call(balcony_pid,get_temp,[],5000) of
	{error,Reason}->
	    Result={{error,Reason},State};
	TempFloat ->
	    case rd:call(balcony_pid,new_session,[],5000) of
		{error,Reason}->
		    Result={{error,Reason},State};
		ok->
		    InSession=?InSession,
		    Temp=float_to_list(TempFloat,[{decimals,1}])++" grader",
		    Result=format_text(init,State#state{
					      is_available=IsAvailable,
					      balcony_temp=Temp,
					      in_session=InSession
					     })
	    end
    end,
    Result.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
stop_session(State)->
  %% Check if avaialble
   %    IsAvailable=case rd:call(balcony_pid,is_available,[],5000) of
%		     true->
%			 "Available";
%		     false ->
%			 "Not available"
%		 end,
    IsAvailable="Available",
    case rd:call(balcony_pid,get_temp,[],5000) of
	{error,Reason}->
	    Result={{error,Reason},State};
	TempFloat ->
	    case rd:call(balcony_pid,stop_session,[],5000) of
		{error,Reason}->
		    Result={{error,Reason},State};
		ok->
		    InSession=?NoSession,
		    Temp=float_to_list(TempFloat,[{decimals,1}])++" grader",
		    Result=format_text(init,State#state{
					      is_available=IsAvailable,
					      balcony_temp=Temp,
					      in_session=InSession
					     })
	    end
    end,
    Result.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
send_msg_to_web(NewState)->
    {ReplyToWeb,NewState}=format_text(NewState),
    NewState#state.socket_pid!ReplyToWeb,
    ReplyToCaller=ok,
    ReplyToCaller.


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
format_text(init,State)->
    format_text(State).

format_text(NewState)->
    Type=text,
    M=io_lib,
    F=format,
    InSession=NewState#state.in_session,
    BalconyTemp=NewState#state.balcony_temp,
    IsAvailable=NewState#state.is_available,
    
    A=["~s~s~s~s~s", [IsAvailable,",",BalconyTemp,",",InSession]],
    {{ok,Type,M,F,A},NewState}.
