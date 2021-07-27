-module(test2).
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("public_key/include/public_key.hrl").
% -include("esaml.hrl").
-export([test/0]).

test() ->
	Req = lists:flatten(xmerl:export([], xmerl_xml)),
	Req.
