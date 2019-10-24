## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Function} {@var{Ret} =} dbcaller ()
## @deftypefnx {Function} {@var{Ret} =} dbcaller (@var{Field})
## Return caller of caller function (from @command{dbstack} output).
##
## @code{dbcaller ()} returns a component of the array of structures returned
## by @command{dbstack}. The component is the one designating the caller of the
## caller function.
##
## If optional argument @var{Field} is provided, then the field @var{Field} is
## returned instead of the whole structure.
##
## @seealso{dbstack}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = dbcaller(varargin)

    check_usage(nargin == 0 || (nargin == 1 ...
                                  && ...
                                is_str(varargin{1})));

    stack = dbstack(2, '-completenames');

    if nargin == 1
        Ret = stack(1).(varargin{1});
    else
        Ret = stack;
    endif

endfunction
