%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-define(ControlC201,control_a@c201).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->

    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    pong=net_adm:ping(?ControlC201),
    ok=dependent_apps:start(),
    ok=setup(),

  %  ok=test1(20),

    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(3000),
   % init:stop(),
    ok.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
test1(N)->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    timer:sleep(3000),
    case lgh_web:set_temp(N+1) of
	ok->
	    NewN=N+1;
	{error,Reason}->
	    io:format("error,Reason ~p~n",[{Reason,?MODULE,?LINE}]),
	    NewN=N
    end,
    test1(NewN).


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
  
    ok=application:start(lgh_web),
    pong=lgh_web:ping(),
    ok.
