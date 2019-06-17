%%%-------------------------------------------------------------------
%% @doc cowboy_lager_example public API
%% @end
%%%-------------------------------------------------------------------

-module(cowboy_lager_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_h, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 18080}], #{
		env => #{dispatch => Dispatch}
	}),
    lager:error("cowboy is already started", []),
    cowboy_lager_example_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
