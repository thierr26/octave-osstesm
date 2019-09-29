## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Constructor} {@var{Obj} =} size_spec (@var{SizeDescrVect})
## @deftypefnx {Constructor} {@var{Obj} =} size_spec (@var{SizeDescr1}, @var{@
## SizeDescr2}, ...)
## Create a size specification object.
##
## Shape specification objects are meant to be used for variable size checking.
##
## @code{@var{Obj} = size_spec (@var{SizeDescrVect})} creates a size
## specification object according to the size descriptor vector
## @var{SizeDescrVect}. The first element of @var{SizeDescrVect} is a
## size descriptor for the first dimension of a variable, the second element
## is a size descriptor for the second dimension of a variable, etc.
##
## A size descriptor can be one of:
##
## @table @asis
## @item a non-negative integer
## Specifies an exact size.
##
## @item @qcode{size_spec.any_size}
## Wild card that matches any size (0 included).
##
## @item @qcode{size_spec.positive_size}
## Wild card that matches any non-zero size.
##
## @item @qcode{size_spec.zero_one_size}
## Wild card that matches size 0 or 1.
## @end table
##
## @code{@var{Obj} = size_spec (@var{SizeDescr1}, @var{SizeDescr2}, ...)} takes
## the size descriptors as separate arguments.
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} size_spec.any_size ()
## Return a wild card size descriptor representing any size (0 included).
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} size_spec.positive_size ()
## Return a wild card size descriptor representing any non-zero size.
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} size_spec.zero_one_size ()
## Return a wild card size descriptor representing size 0 or 1.
## @end deftypefn
##
## @deftypefn  {Static method} {@var{Ret} =} size_spec.match (@var{X}, @var{@
## SizeDescrVect})
## @deftypefnx {Static method} {@var{Ret} =} size_spec.match (@var{X}, @var{@
## SizeDescr1}, @var{SizeDescr2}, ...)
## Return true if @var{X} size is matched by the provided size descriptors.
##
## @code{size_spec.match (@var{X}, @var{SizeDescrVect})} returns true if
## @code{numel (size (@var{X})) == numel (@var{SizeDescrVect}))} is true and
## elements of @code{size (@var{X})} are all matched by the corresponding
## size descriptors in @var{SizeDescrVect}.
##
## @code{size_spec.match (@var{X}, @var{SizeDescr1}, @var{SizeDescr2}, ...)}
## takes the size descriptors as separate arguments.
##
## Please see @command{size_spec} for details about the size descriptors.
##
## @seealso{numel, size, size_spec}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} size_spec.get_spec ()
## Return the size specification (i.e.@ the size descriptors vector).
##
## Please see @command{size_spec} for details about the size descriptors.
##
## @seealso{size_spec}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} size_spec.dims (@var{X})
## Return the number of dimensions of @var{X} and of the size specification.
##
## @var{Ret} is a 2-element row vector. The first element is
## @code{numel (size_spec.get_spec ())}. The second element is
## @code{numel (size (@var{X}))}.
##
## @seealso{numel, size, size_spec.get_spec}
## @end deftypefn
##
## @deftypefn  {Method} {@var{Ret} =} size_spec.matches (@var{X})
## @deftypefnx {Method} {@var{Ret} =} size_spec.matches (@var{X}, @var{@
## ElementWise})
## Return true if the size of @var{X} matches the size specification.
##
## If the optional logical scalar argument @var{ElementWise} is provided with
## value true and if @code{diff (size_spec.dims (@var{X})) == 0}, then the
## function returns a logical array (same size as
## @code{size_spec.get_spec ()}). The returned array has true values at indices
## where the size specication matches, false values elsewhere.
##
## Please see @command{size_spec} for details about the size specifications.
##
## @seealso{diff, size, size_spec, size_spec.dims, size_spec.get_spec}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef size_spec

    properties (Access = protected)

        size_descr

    endproperties

# -----------------------------------------------------------------------------

    methods (Static)

        function Ret = any_size
            check_usage(nargin == 0);
            Ret = -2;
        endfunction

        function Ret = positive_size
            check_usage(nargin == 0);
            Ret = -3;
        endfunction

        function Ret = zero_one_size
            check_usage(nargin == 0);
            Ret = -1;
        endfunction

        function Ret = match(X, varargin)
            try
                sizeSpecInstance = size_spec(varargin{:});
            catch
                check_usage(false);
            end_try_catch
            Ret = sizeSpecInstance.matches(X);
        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods

        function Obj = size_spec(varargin)

            check_usage((nargin ~= 1 || ((...
                                           isempty(varargin{1}) ...
                                             || ...
                                           isvector(varargin{1}) ...
                                         )...
                                           && ...
                                         is_integer(varargin{1})))...
                          && ...
                        (nargin <= 1 || all(cellfun(@(x) isscalar(x) ...
                                                           && ...
                                                         is_integer(x), ...
                                                    varargin(:)))));

            Obj.size_descr = [0 0];

            if nargin > 1

                Obj.size_descr = cell2mat(varargin);

                minVal = evalin('caller', [mfilename '.positive_size']);
                assert(all(Obj.size_descr >= minVal), ...
                       'No input value should be lower than %d', ...
                       minVal);

                if iscolumn(Obj.size_descr)
                    Obj.size_descr = Obj.size_descr';
                endif;

            endif

        endfunction

        function Ret = get_spec(Obj)

            check_usage(nargin == 1);
            Ret = Obj.size_descr;

        endfunction

        function Ret = dims(Obj, X)

            check_usage(nargin == 2);
            Ret = [numel(Obj.get_spec) numel(size(X))];

        endfunction

        function Ret = matches(Obj, X, varargin)

            check_usage(nargin == 2 || (nargin == 3 ...
                                          && ...
                                        isscalar(varargin{1}) ...
                                          && ...
                                        islogical(varargin{1})));

            Ret = diff(Obj.dims(X)) == 0;
            if Ret
                sX  = size(X);
                lSX = numel(sX);
                Ret = cellfun(@(a) dim_match(a(1), a(2)), ...
                              mat2cell([sX; Obj.size_descr], 2, ones(1, lSX)));
            endif

            if nargin == 2 || ~varargin{1}
                Ret = all(Ret);
            endif

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function Ret = dim_match(Dim, Descr)

    switch Descr
        case evalin('caller', [mfilename '.any_size'])
            Ret = true;
        case evalin('caller', [mfilename '.positive_size'])
            Ret = Dim > 0;
        case evalin('caller', [mfilename '.zero_one_size'])
            Ret = Dim <= 1;
        otherwise
            Ret = Dim == Descr;
    endswitch

endfunction
