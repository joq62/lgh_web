-module(my_handler).
-export([init/2, handle/2]).

init(Req, _Opts) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Req2} = cowboy_req:reply(200, [], <<"Hello, Cowboy!">>, Req),
    {ok, Req2, State}.
