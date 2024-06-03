%%%-------------------------------------------------------------------
%%% @author gta
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2024 19:34
%%%-------------------------------------------------------------------
-module(http_topo_sort_sup).
-author("gta").
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", http_topo_sort_handler, []}
    ]}
  ]),
  {ok, _} = cowboy:start_clear(http_listener,
    [{port, 8081}],
    #{env => #{dispatch => Dispatch}}
  ),
  {ok, {{one_for_one, 1, 5}, []}}.
