## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} cell_elem (@var{K}, @var{X})
## Return @code{@var{X}@{@var{K}@}}.
##
## @seealso{arr_elem}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = cell_elem(K, X)

    Ret = X{K};

endfunction
