## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Constructor} {@
## @var{Obj} =} fsys_item_w_basename_relatio_ops (@var{FSysItem})
## Wrap a file system item handle in @command{w_relatio_ops} for basename comparisons.
##
## @var{FSysItem} must be a @command{fsys_item} object. The return value is a
## @var{w_relatio_ops} derived object with relational operators (@qcode{==},
## @qcode{~=}, @qcode{<}, @qcode{<=}, @qcode{>}, @qcode{>=}) defined to operate
## on the file system item name (@code{FSysItem.basname}).
##
## @seealso{w_relatio_ops}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} w_relatio_ops.item (@var{Obj})
## Return the @command{fsys_item} handle provided to the constructor.
##
## @seealso{fsys_item_w_basename_relatio_ops}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} w_relatio_ops.eq (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is equal to @var{Right}.
##
## This methods overloads the @qcode{==} operator.
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} w_relatio_ops.lt (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is strictly lower than @var{Right}.
##
## This methods overloads the @qcode{<} operator.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef fsys_item_w_basename_relatio_ops < w_relatio_ops

    properties (Access = private)

        fs_i

    endproperties

# -----------------------------------------------------------------------------

    methods

        function Obj = fsys_item_w_basename_relatio_ops(FSysItem)

            check_usage(isa(FSysItem, 'fsys_item'));

            Obj.fs_i = FSysItem;

        endfunction

        function Ret = item(Obj)

            Ret = Obj.fs_i;

        endfunction

        function Ret = eq(Left, Right)

            Ret = strcmp(Left.fs_i.basename, Right.fs_i.basename);

        endfunction

        function Ret = lt(Left, Right)

            Ret = lt_str(Left.fs_i.basename, Right.fs_i.basename);

        endfunction

    endmethods

endclassdef
