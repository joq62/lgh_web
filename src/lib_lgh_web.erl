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
	 heathers_are_reachable/0,
	 are_heathers_on/0,
	 are_heathers_off/0,
	 get_temp/0
	 
	]).

-include("lgh_web.hrl").
%%%===================================================================
%%% API
%%%===================================================================


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_on()->	 
    HB=rd:call(zigbee_devices,call,[?HeatherBalcony,is_reachable,[]],5000),
    HD=rd:call(zigbee_devices,call,[?HeatherDoor,is_reachable,[]],5000),
    Result=case {HB,HD} of
	       {true,true}->
		   R_HB=rd:call(zigbee_devices,call,[?HeatherBalcony,turn_on,[]],5000),
		   R_HD=rd:call(zigbee_devices,call,[?HeatherDoor,turn_on,[]],5000),
		   {ok,[R_HB,R_HD]};
	       _->
		   {error,["Heathers not reachable, turn on electricity ",?MODULE,?LINE]}
	   end,
    Result.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_off()->	 
    HB=rd:call(zigbee_devices,call,[?HeatherBalcony,is_reachable,[]],5000),
    HD=rd:call(zigbee_devices,call,[?HeatherDoor,is_reachable,[]],5000),
    Result=case {HB,HD} of
	       {true,true}->
		   R_HB=rd:call(zigbee_devices,call,[?HeatherBalcony,turn_off,[]],5000),
		   R_HD=rd:call(zigbee_devices,call,[?HeatherDoor,turn_off,[]],5000),
		   {ok,[R_HB,R_HD]};
	       _->
		   {error,["Heathers not reachabl,electricity probably turned off ",?MODULE,?LINE]}
	   end,
    Result.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_temp()->    
    rd:call(zigbee_devices,call,[?TempSensor,temp,[]],5000).
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
are_heathers_on()->    
    HB=rd:call(zigbee_devices,call,[?HeatherBalcony,is_on,[]],5000),
    HD=rd:call(zigbee_devices,call,[?HeatherDoor,is_on,[]],5000),
    case {HB,HD} of
	{true,true}->
	    true;
	_->
	    false
    end.
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
are_heathers_off()->    
    false=:=are_heathers_on(). 
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
heathers_are_reachable()->    
    HB=rd:call(zigbee_devices,call,[?HeatherBalcony,is_reachable,[]],5000),
    HD=rd:call(zigbee_devices,call,[?HeatherDoor,is_reachable,[]],5000),
    case {HB,HD} of
	{true,true}->
	    true;
	_->
	    false
    end.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

   

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

