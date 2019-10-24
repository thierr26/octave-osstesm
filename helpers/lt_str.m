## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} lt_str (@var{Left}, @var{Right})
## Return true if string @var{Left} is strictly lower than string @var{Right}.
##
## @var{Left} and @var{Right} must be character strings in the sense of
## @command{is_str}.
##
## @code{lt_str (@var{Left}, @var{Right})} returns true if @var{Left} and
## @var{Right} are different (in the sense of @command{strcmp}) and if
## @code{sort (@{@var{Left}, @var{Right}@})} places @var{Left} before
## @var{Right}.
##
## @seealso{is_str, sort, strcmp}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = lt_str(Left, Right)

    check_usage(nargin == 2 && is_str(Left) && is_str(Right));

    Ret = ~strcmp(Left, Right);
    if Ret
        [~, idx] = sort({Left, Right});
        Ret = all(idx == [1 2]);
    endif

endfunction
