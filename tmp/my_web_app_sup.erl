-module(my_web_app_sup).
-behavior(supervisor).

-define(SERVER, my_web_app_sup).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    {ok, {{one_for_one, 5, 10}, []}}.
