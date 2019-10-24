## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Constructor} {@var{Obj} =} normal_file (@var{AbsolutePath})
## @deftypefnx {Constructor} {@var{Obj} =} normal_file (@var{RelativePath})
## @deftypefnx {Constructor} {@var{Obj} =} normal_file (@var{@
## ParentItem}, @var{Name})
## @deftypefnx {Constructor} {@var{Obj} =} normal_file (@var{@
## ParentItem}, @var{Name}, @var{Ext})
## Create a normal file handle (descendant of @command{fsys_item}).
##
## A @command{normal_file} object cannot designate a file system root
## (e.g.@ @qcode{\/} on a Unix-like system, something like @qcode{C:\\} on a
## Windows system). Providing such a path as argument causes an error. A call
## without argument also causes an error if the current directory (as returned
## by @code{pwd}) is a file system root.
##
## Please see @command{fsys_item} for usage details.
##
## @seealso{fsys_item, pwd}
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} normal_file.child ()
## Return an empty cell array.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} normal_file.children_count ()
## Return 0.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef normal_file < fsys_item

    methods

        function Obj = normal_file(varargin)

            Obj = Obj@fsys_item(varargin{:});
            assert(~Obj.is_root, ...
                   'File system root path not allowed for a ''%s'' object', ...
                   mfilename);

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods (Sealed)

        function Ret = child(Obj) %#ok 'Obj' unused.

            Ret = {};

        endfunction

        function Ret = children_count(Obj) %#ok 'Obj' unused.

            Ret = 0;

        endfunction

    endmethods

endclassdef
