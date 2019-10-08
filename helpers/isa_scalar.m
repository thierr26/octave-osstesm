## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} isa_scalar (@var{X}, @var{ClassName})
## Return true if @var{X} is a scalar and is of class @var{ClassName}.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = isa_scalar(X, ClassName)

    check_usage(nargin == 2 && is_str(ClassName) && ~isempty(ClassName));

    Ret = isscalar(X) && isa(X, ClassName);

endfunction
