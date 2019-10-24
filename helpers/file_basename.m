## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Function} {@var{Ret} =} file_basename (@var{File})
## @deftypefnx {Function} {@var{Ret} =} file_basename (@var{File}, @var{W_Ext})
## Return a file base name without or without extension.
##
## @code{@var{Ret} = file_basename(@var{File})} returns the base name of file
## @var{File}. It is equivalent to:
##
## @example
## @group
##     [~, @var{name}, @var{ext}] = fileparts (@var{File});
##     @var{Ret} = [@var{name} @var{ext}]
## @end group
## @end example
##
## The optional @var{W_Ext} argument is a logical scalar. If false, the
## extension part is not included in the returned value. @var{W_Ext} defaults
## to true.
##
## @seealso{file_ext, fileparts}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = file_basename(File, varargin)

    check_usage(nargin == 1 || (nargin == 2 ...
                                  && ...
                                isa_scalar(varargin{1}, 'logical')));

    [~, name, ext] = fileparts(File);
    if nargin == 2 && ~varargin{1}
        Ret = name;
    else
        Ret = [name ext];
    endif

endfunction
