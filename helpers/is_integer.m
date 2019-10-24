## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Function} {@var{Ret} =} is_integer (@var{X})
## @deftypefnx {Function} {@var{Ret} =} is_integer (@var{X}, @var{ElementWise})
## Return true for integer values.
##
## @code{is_integer (@var{X})} returns true if all the elements of @var{X} are
## integer values. An element is considered to be an integer value if it's
## numeric, not a complex number, not a NaN value and not an infinite value and
## if @command{floor} and @command{ceil} applied to the element return equal
## values. It returns false otherwise.
##
## Providing the optional logical scalar argument @var{ElementWise} with value
## true causes @command{is_integer} to return a logical array (same size as
## @var{X}). The returned array has true values at indices where @var{X} has
## integer values, false values elsewhere.
##
## @seealso{ceil, floor, isinf, isinteger, isnan, isnumeric, isreal}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = is_integer(X, varargin)

    check_usage(nargin == 1 || (nargin == 2 ...
                                  && ...
                                isa_scalar(varargin{1}, 'logical')));

    Ret = isnumeric(X) ...
            & ...
          isreal(X) ...
            & ...
          ~isnan(X) ...
            & ...
          ~isinf(X) ...
            & ...
          floor(X) == ceil(X);

    if nargin == 1 || ~varargin{1}
        Ret = cumulate(Ret, @all);
    endif

endfunction
