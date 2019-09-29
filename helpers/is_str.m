## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} is_str (@var{X})
## Return true if @var{X} is a character matrix with no more than one line.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = is_str(X)

    check_usage(nargin == 1);

    Ret = ischar(X) ...
            && ...
          size_spec.match(X, size_spec.zero_one_size, size_spec.any_size);

endfunction
