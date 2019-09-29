## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} call_stack_head (@var{Stack}, @var{@
## Filename})
## Keep only first elements of a @qcode{stack} field of an error structure.
##
## @code{call_stack_head (@var{Stack}, @var{Filename})} returns @var{Stack}
## supposed to be the @qcode{stack} field of an error structure or a return
## value of @command{dbstack}) with some elements removed. The removed elements
## are the first one with the @qcode{file} field equal to @var{Filename} and
## all the other ones with a higher index.
##
## If @var{Filename} is not found in @var{Stack}, @var{Stack} is returned as
## is.
##
## @var{Filename} could be the return value of a
## @code{mfilename ('fullpathext')} call.
##
## @seealso{dbstack, error, lasterror, mfilename}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = call_stack_head(Stack, Filename)

    check_usage(nargin == 2);

    n = numel(Stack);
    filenameFound = false;
    k = 0;
    while ~filenameFound && k < n
        k = k + 1;
        filenameFound = strcmp(Filename, Stack(k).file);
    endwhile

    if filenameFound
        Ret = Stack(1 : k - 1);
    else
        Ret = Stack;
    endif

endfunction
