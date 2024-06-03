%%%-------------------------------------------------------------------
%%% @author gta
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Jun 2024 19:34
%%%-------------------------------------------------------------------
-module(http_topo_sort_handler).
-author("gta").
-behaviour(cowboy_handler).

%% Cowboy callbacks
-export([init/2]).

init(Req, _Opts) ->
  {ok, Body, Req1} = cowboy_req:read_body(Req),
  #{<<"tasks">> := Tasks} = jsone:decode(Body),
  Sorted = topo_sort(Tasks, []),
  {ok, Req2} = cowboy_req:reply(
      200,
      #{<<"content-type">> => <<"application/json">>},
      jsone:encode(#{<<"tasks">> => Sorted,
                     <<"script">> => script(Sorted, <<>>)}),
      Req1),
  {ok, Req2, undefined}.

topo_sort([], Sorted) ->
    lists:reverse(Sorted);
topo_sort(Dependencies, Sorted) ->
    %% 1, Take all the elements that are not sorted yet
    {Unsorted, Rest} = lists:partition(fun(#{<<"name">> := Name}) ->
                                           not is_member(Name, Sorted)
                                       end, Dependencies),
    %% 2, Check if there's any that has all its requirements sorted
    case lists:partition(fun(#{<<"requires">> := Reqs}) ->
                                lists:all(fun(Req) -> is_member(Req, Sorted) end, Reqs);
                            (_) ->
                                true
                         end, Unsorted) of
        {[], _} ->
            {error, cycle_detected};
        {Ready, NotReady} ->
            %% 3, If there is, add it to the sorted list and repeat
            topo_sort(NotReady ++ Rest,
                lists:append(lists:map(
                    fun(M) ->
                        %% We don't want requirements in the result
                        maps:without([<<"requires">>], M)
                    end, Ready), Sorted))
    end.

is_member(Name, Map) ->
  lists:any(fun(#{<<"name">> := N}) when N == Name ->
                   true;
               (_) ->
                   false
            end, Map).

script([], Script) ->
    Script;
script([#{<<"command">> := Command}|Rest], Script) ->
    script(Rest, <<Script/binary, Command/binary, "\n">>).
