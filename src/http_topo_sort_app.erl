%%%-------------------------------------------------------------------
%%% @author gta
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2024 19:34
%%%-------------------------------------------------------------------
-module(http_topo_sort_app).
-author("gta").
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    http_topo_sort_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
