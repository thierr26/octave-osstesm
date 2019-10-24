## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Abstract method} {@var{Ret} =} w_relatio_ops.eq (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is equal to @var{Right}.
##
## This methods overloads the @qcode{==} operator.
## @end deftypefn
##
## @deftypefn {Abstract method} {@var{Ret} =} w_relatio_ops.lt (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is strictly lower than @var{Right}.
##
## This methods overloads the @qcode{<} operator.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} w_relatio_ops.ne (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is not equal to @var{Right}.
##
## This methods overloads the @qcode{~=} operator.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} w_relatio_ops.le (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is lower than or equal to @var{Right}.
##
## This methods overloads the @qcode{<=} operator.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} w_relatio_ops.gt (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is strictly greater than @var{Right}.
##
## This methods overloads the @qcode{>} operator.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} w_relatio_ops.ge (@var{@
## Left}, @var{Right})
## Return true if @var{Left} is greater than or equal to @var{Right}.
##
## This methods overloads the @qcode{>=} operator.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef (Abstract) w_relatio_ops

    methods

        function Ret = eq(Left, Right) %#ok 'Right' unused, 'Ret' unset.

            must_override(class(Left));

        endfunction

        function Ret = lt(Left, Right) %#ok 'Right' unused, 'Ret' unset.

            must_override(class(Left));

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods (Sealed)

        function Ret = ne(Left, Right)

            Ret = ~eq(Left, Right);

        endfunction

        function Ret = le(Left, Right)

            Ret = lt(Left, Right) || eq(Left, Right);

        endfunction

        function Ret = gt(Left, Right)

            Ret = ~le(Left, Right);

        endfunction

        function Ret = ge(Left, Right)

            Ret = ~lt(Left, Right);

        endfunction

    endmethods

endclassdef
