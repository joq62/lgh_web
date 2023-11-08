%%%-------------------------------------------------------------------
%% @doc control public API
%% @end
%%%-------------------------------------------------------------------

-module(lgh_web_app).
 
-behaviour(application).

-export([start/2, stop/1]).

-define(AppBeam,atom_to_list(?MODULE)++".beam").
-define(Port,60201). % Change also Port and Path in index.htlm"
-define(Handler,lgh_web_handler).
-define(NoRouteHandler,no_matching_route_handler).

start(_StartType, _StartArgs) ->
    web_init(),
    lgh_web_sup:start_link().

stop(_State) ->
    ok.

%% internal functions



%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
web_init()->
    Port=?Port,
    % Init correct path complicated very erlang specific
    FullPAthWebServerBeam=code:where_is_file(?AppBeam),
    L1=filename:split(FullPAthWebServerBeam),
    [_,_|L2]=lists:reverse(L1),
    L3=lists:reverse(L2),
    case L3 of
	[]->
	    true=code:add_patha("priv");
	L3 ->
	    L4=lists:append(L3,["priv"]),
	    true=code:add_patha(filename:join(L4)) 
    end,
    PathToIndex=code:where_is_file("index.html"),
    io:format("PathToIndex :~p~n",[PathToIndex]),

    timer:sleep(1000),
    io:format("Port :~p~n",[Port]),

    ssl:start(),
    application:start(crypto),
    application:start(ranch), 
    application:start(cowlib), 
    application:start(cowboy), 

    HelloRoute = { "/", cowboy_static, {file,PathToIndex} },
    WebSocketRoute = {"/please_upgrade_to_websocket", ?Handler, []},
    CatchallRoute = {"/[...]", ?NoRouteHandler, []},

    Dispatch = cowboy_router:compile([
				      {'_',
				       [HelloRoute, 
					WebSocketRoute, 
					CatchallRoute
				       ]
				      }
				     ]),
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
							 env => #{dispatch => Dispatch}
							}),
    ok.
