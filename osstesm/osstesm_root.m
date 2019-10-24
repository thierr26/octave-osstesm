## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} osstesm_root ()
## Osstesm installation directory.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = osstesm_root

    persistent retMem;

    if isempty(retMem)
        retMem = fileparts(fileparts(mfilename('fullpath')));
    endif

    Ret = retMem;

endfunction
