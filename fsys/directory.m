## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Constructor} {@var{Obj} =} directory (@var{AbsolutePath})
## @deftypefnx {Constructor} {@var{Obj} =} directory (@var{RelativePath})
## @deftypefnx {Constructor} {@var{Obj} =} directory (@var{ParentItem}, @var{@
## Name})
## @deftypefnx {Constructor} {@var{Obj} =} directory (@var{ParentItem}, @var{@
## Name}, @var{Ext})
## Create a file system directory handle (descendant of @command{fsys_item}).
##
## Please see @command{fsys_item} for usage details.
##
## @command{directory} class instances have pointers (i.e.@ handles) to their
## "children". When a @command{fsys_item} object is created with a call like
## @code{normal_file (@var{ParentItem}, ...)} or
## @code{directory (@var{ParentItem}, ...)}, a pointer to the newly created
## object is added in @var{ParentItem}.
##
## @seealso{fsys_item, normal_file}
## @end deftypefn
##
## @deftypefn {Method} {} directory.add_child (@var{Child})
## Add a @command{fsys_item} object as child.
##
## An error is issued if there already is a child with the same name.
## @end deftypefn
##
## @deftypefn  {Method} {[@var{Ret}, @var{Dir_Count}] =} directory.child ()
## @deftypefnx {Method} {@var{Ret} =} directory.child (@var{K})
## Return the children (directories and files linked to the object).
##
## @code{@var{Ret} = @var{Obj}.child} returns a cell array containing the
## child of @var{Obj} (that is the @command{fsys_item} objects (files or
## directories) that are pointed to by @var{Obj}).
##
## The second output argument @var{Dir_Count} is the number of directories in
## @var{Ret}.
##
## First positions in @var{Ret} are occupied by directories. Directories are
## sorted by name.
##
## Files occupy the latest positions in @var{Ret}. They are also sorted by
## name.
##
## If the optional argument @var{K} is provided, only the child at index
## @var{K} is returned and the second output argument is not returned.
##
## @seealso{fsys_item, normal_file}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} directory.children_count ()
## Return the number of children (directories and files linked to the object).
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef directory < fsys_item

    properties (Access = private)

        child_cell
        dir_children_count

    endproperties

# -----------------------------------------------------------------------------

    methods

        function Obj = directory(varargin)

            Obj = Obj@fsys_item(varargin{:});

            Obj.child_cell      = {};
            Obj.dir_children_count = 0;

        endfunction

        function add_child(Obj, Child)

            check_usage(nargin == 2 && isa_scalar(Child, 'fsys_item'));

            wRO = fsys_item_w_basename_relatio_ops(Child);
            bD  = [1,                          Obj.dir_children_count];
            bF  = [Obj.dir_children_count + 1, numel(Obj.child_cell)];

            [searchResultD, idxD] = monot.bin_srch(Obj.child_cell, wRO, bD);
            [searchResultF, idxF] = monot.bin_srch(Obj.child_cell, wRO, bF);

            assert(searchResultD ~= monot.idx ...
                     && ...
                   searchResultF ~= monot.idx, ...
                   '''%s'' object ("%s") already has a child named "%s"', ...
                   mfilename, ...
                   Obj.path, ...
                   Child.basename);

            Child.parent_item_or_path = Obj;

            if Child.is_dir
                bSOA                   = {searchResultD, idxD};
                Obj.dir_children_count = Obj.dir_children_count + 1;
            else
                bSOA = {searchResultF, idxF};
            endif

            Obj.child_cell = monot.insert(Obj.child_cell, wRO, bSOA{:});

        endfunction

        function [Ret, varargout] = child(Obj, varargin)

            check_usage(nargin == 1 || (nargin == 2 ...
                                          && ...
                                        is_integer(varargin{1}) ...
                                          && ...
                                        isscalar(varargin{1}) ...
                                          && ...
                                        nargout < 2));

            if nargin > 1
                Ret = Obj.child_cell{varargin{1}}.item;
            else
                Ret = cellfun(@(x) x.item, ...
                              Obj.child_cell, ...
                              'UniformOutput', false);
            endif

            if nargout > 1
                varargout{1} = Obj.dir_children_count;
            endif

        endfunction

        function Ret = children_count(Obj)

            check_usage(nargin == 1);

            Ret = numel(Obj.child_cell);

        endfunction

    endmethods

endclassdef
