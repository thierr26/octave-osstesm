## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} error_stru (@var{Err})
## Return error @var{Err} converted to a structure.
##
## Only the fields @qcode{identifier}, @qcode{message} and @qcode{stack} of the
## error structure @var{Err} are preserved in the conversion.
##
## Compared to a @code{@var{Ret} = struct (@var{Err})} statement, a
## @code{@var{Ret} = error_stru (@var{Err})} statement does not produce any
## warning in @sc{matlab} when @var{Err} is a @command{MException} object.
##
## The point of converting a @command{MException} object to a structure is to
## get write permission on all the field. In a @command{MException} object,
## some prperties are read-only (e.g. @qcode{stack}).
##
## @seealso{lasterror}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = error_stru(Err)

    check_usage(nargin == 1);

    Ret = struct('identifier', Err.identifier, ...
                 'message',    Err.message, ...
                 'stack',      Err.stack);

endfunction
