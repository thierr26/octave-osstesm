## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {@var{Ret} =} file_ext (@var{File})
## Return a file extension.
##
## @code{@var{Ret} = file_ext(@var{File})} returns the extension of file
## @var{File} (leading dot included). It is equivalent to
## @code{[~, ~, @var{Ret}] = fileparts (@var{File})}
##
## @seealso{file_basename, fileparts}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = file_ext(File)

    check_usage(nargin == 1);

    [~, ~, Ret] = fileparts(File);

endfunction
