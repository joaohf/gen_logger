%%%-----------------------------------------------------------------------------
%%% Copyright (c) 2015, Feng Lee <feng@emqtt.io>
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%-----------------------------------------------------------------------------

-module(gen_logger).

-include("gen_logger.hrl").

%%%=========================================================================
%%% API
%%%=========================================================================
-export([new/1, new/2,
         debug/2, debug/3,
         info/2, info/3,
         warning/2, warning/3,
         error/2, error/3,
         critical/2, critical/3]).

%%%=========================================================================
%%% Types
%%%=========================================================================

-type level() :: all | debug | info | warning | error | critical | none.

-type logmod() :: {gen_logger, module(), level()}.

-export_type([level/0, logmod/0]).

%%%=========================================================================
%%% Behaviour Callbacks
%%%=========================================================================

-ifdef(use_specs).

-callback debug(Msg :: string()) -> ok. 
-callback debug(Format :: string(), Args :: list()) -> ok. 

-callback info(Msg :: string()) -> ok. 
-callback info(Format :: string(), Args :: list()) -> ok. 

-callback warning(Msg :: string()) -> ok. 
-callback warning(Format :: string(), Args :: list()) -> ok. 

-callback error(Msg :: string()) -> ok. 
-callback error(Format :: string(), Args :: list()) -> ok. 

-callback critical(Msg :: string()) -> ok. 
-callback critical(Format:: string(), Args :: list()) -> ok. 

-else.

-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{debug, 1}, {debug, 2},
     {info, 1}, {info, 2},
     {warning, 1}, {warning, 2},
     {error, 1}, {error, 2},
     {critical, 1}, {critical, 2}];
behaviour_info(_Other) ->
    undefined.

-endif.

%%%=========================================================================
%%% gen_logger API
%%%=========================================================================

-spec new(LevelOrTuple) -> logmod() when
      LevelOrTuple  :: level() | {atom(), level()}.
new(Level) when is_atom(Level) ->
    new(console, Level);
new({Name, Level}) ->
    new(Name, Level).

-spec new(Name, Level) -> logmod() when
      Name  :: atom(),
      Level :: level().
new(Name, Level) when is_atom(Name) and is_atom(Level) ->
    {?MODULE, mod(Name), ?LOG_LEVEL_NUM(Level)}.

mod(Name) ->
    list_to_atom(atom_to_list(Name) ++ "_logger").

%%%-------------------------------------------------------------------------
%%% DEBUG
%%%-------------------------------------------------------------------------
-spec debug(Msg, Mod) -> ok when
      Msg :: string(),
      Mod :: logmod().
debug(Msg, {?MODULE, Logger, Level}) when Level =< ?LOG_DEBUG ->
    Logger:debug(Msg);
debug(_Msg, {?MODULE, _Logger, _Level}) ->
    ok.

-spec debug(Format, Args, Mod) -> ok when
      Format :: string(),
      Args   :: list(),
      Mod    :: logmod().
debug(Format, Args, {?MODULE, Logger, Level}) when Level =< ?LOG_DEBUG ->
    Logger:debug(Format, Args);
debug(_Format, _Args, {?MODULE, _Logger, _Level}) ->
    ok.

%%%-------------------------------------------------------------------------
%%% INFO
%%%-------------------------------------------------------------------------
-spec info(Msg, Mod) -> ok when
      Msg :: string(),
      Mod :: logmod().
info(Msg, {?MODULE, Logger, Level}) when Level =< ?LOG_INFO ->
    Logger:info(Msg);
info(_Msg, {?MODULE, _Logger, _Level}) ->
    ok.

-spec info(Format, Args, Mod) -> ok when
      Format :: string(),
      Args :: list(),
      Mod :: logmod().
info(Format, Args, {?MODULE, Logger, Level}) when Level =< ?LOG_INFO ->
    Logger:info(Format, Args);
info(_Format, _Args, {?MODULE, _Logger, _Level}) ->
    ok.

%%%-------------------------------------------------------------------------
%%% WARNING
%%%-------------------------------------------------------------------------
-spec warning(Msg, Mod) -> ok when
      Msg :: string(),
      Mod :: logmod().
warning(Msg, {?MODULE, Logger, Level}) when Level =< ?LOG_WARNING ->
    Logger:warning(Msg);
warning(_Msg, {?MODULE, _Logger, _Level}) ->
    ok.

-spec warning(Format, Args, Mod) -> ok when
      Format :: string(),
      Args :: list(),
      Mod :: logmod().
warning(Format, Args, {?MODULE, Logger, Level}) when Level =< ?LOG_WARNING ->
    Logger:warning(Format, Args);
warning(_Format, _Args, {?MODULE, _Logger, _Level}) ->
    ok.
    
%%%-------------------------------------------------------------------------
%%% ERROR
%%%-------------------------------------------------------------------------
-spec error(Msg, Mod) -> ok when
      Msg :: string(),
      Mod :: logmod().
error(Msg, {?MODULE, Logger, Level}) when Level =< ?LOG_ERROR ->
    Logger:error(Msg);
error(_Msg, {?MODULE, _Logger, _Level}) ->
    ok.

-spec error(Format, Args, Mod) -> ok when
      Format :: string(),
      Args :: list(),
      Mod :: logmod().
error(Format, Args, {?MODULE, Logger, Level}) when Level =< ?LOG_ERROR ->
    Logger:error(Format, Args);
error(_Format, _Args, {?MODULE, _Logger, _Level}) ->
    ok.

%%%-------------------------------------------------------------------------
%%% CRITICAL
%%%-------------------------------------------------------------------------
-spec critical(Msg, Mod) -> ok when
      Msg :: string(),
      Mod :: logmod().
critical(Msg, {?MODULE, Logger, Level}) when Level =< ?LOG_CRITICAL ->
    Logger:critical(Msg);
critical(_Msg, {?MODULE, _Logger, _Level}) ->
    ok.

-spec critical(Format, Args, Mod) -> ok when
      Format:: string(),
      Args :: list(),
      Mod :: logmod().
critical(Format, Args, {?MODULE, Logger, Level}) when Level =< ?LOG_CRITICAL ->
    Logger:critical(Format, Args);
critical(_Format, _Args, {?MODULE, _Logger, _Level}) ->
    ok.

