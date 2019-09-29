## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} is_octave ()
## Return true if Octave (not @sc{matlab}) is running the function.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = is_octave

    persistent retMem;

    check_usage(nargin == 0);

    if isempty(retMem)
        retMem = exist('OCTAVE_VERSION', 'builtin') == 5;
    endif
    Ret = retMem;

endfunction
