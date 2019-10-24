## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} filled_in_stru (@var{Stru}, @var{Dflt})
## Return @var{Stru} complemented with @var{Dflt} fields if needed.
##
## @var{Dflt} must be a scalar structure or a structure array the same size as
## @var{Stru}. @var{Ret} is initialized with the structure (or array of
## structure) @var{Stru} and fields that are present in @var{Dflt} and not in
## @var{Stru} is added to @var{Ret} with the same values as in @var{Dflt}.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = filled_in_stru(Stru, Dflt)

    check_usage(nargin == 2 ...
                  && ...
                isstruct(Stru) ...
                  && ...
                isstruct(Dflt) ...
                  && ...
                (isscalar(Dflt) || isequal(size(Stru), size(Dflt))));

    Ret = Stru;

    dfltFieldNames = fieldnames(Dflt);
    n = numel(Ret);
    for field = dfltFieldNames'
        if ~isfield(Ret, field{1})
            for k = 1 : n
                Ret(k).(field{1}) = Dflt.(field{1});
            endfor
        endif
    endfor

endfunction
