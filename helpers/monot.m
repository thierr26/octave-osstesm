## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Static method} {[@var{Ret}, @var{K}] =} monot.bin_srch (@var{@
## Arr}, @var{Searched})
## @deftypefnx {Static method} {[@var{Ret}, @var{K}] =} monot.bin_srch (@var{@
## Arr}, @var{Searched}, @var{Bound})
## Search for a value in a sorted array (or in a sorted array slice).
##
## @code{[@var{Ret}, @var{K}] = monot.bin_srch (@var{Arr}, @var{Searched})}
## searches value @var{Searched} in array (or cell array) @var{Arr}.
##
## @var{Arr} must contain values the same class as @var{Searched}. Operators
## @qcode{==} and @qcode{<} must be defined for this class. @var{Arr} is
## supposed to be sorted @strong{in ascending order} (this is not checked).
## Duplicate values are allowed.
##
## Search can be restricted to a slice of @var{Arr} using optional argument
## @var{Bound}. The slice is @code{@var{Arr}(@var{Bound}(1) : @var{Bound}(2))}.
## Elements of @var{Arr} that are not in this slice are not used at all by the
## function. Not providing argument @var{Bound} is equivalent to providing
## @var{Bound} with value @code{[1 numel(@var{Arr})]}.
##
## Return value @var{Ret} is one of:
##
## @table @asis
## @item @qcode{monot.idx}
## Searched value @var{Searched} has been found and it is
## @code{@var{Arr}(@var{K})} (or @code{@var{Arr}@{@var{K}@}} if @var{Arr} is a
## cell array). If the searched value appears multiple times in @var{Arr}, then
## @var{K} is the index of the last occurrence.
##
## @item @qcode{monot.lt_first}
## Searched value @var{Searched} is strictly lower than first element of
## @var{Arr}. @var{K} is 1 or @code{@var{Bound}(1)} if argument @var{Bound} is
## provided.
##
## @item @qcode{monot.gt_last}
## Searched value @var{Searched} is strictly greater than last element of
## @var{Arr}. @var{K} is @code{numel (@var{Arr})} or @code{@var{Bound}(2)} if
## argument @var{Bound} is provided.
##
## @item @qcode{monot.empty}
## @var{Arr} is empty. @var{K} is 1 or @code{@var{Bound}(1)} if argument
## @var{Bound} is provided.
##
## @item @qcode{monot.interval}
## Searched value @var{Searched} has not been found in @var{Arr} but the
## following is true:
##
## @example
## @group
## @var{Arr}(@var{K}) < @var{Searched} ...
##   && ...
## @var{Searched} < @var{Arr}(@var{K + 1})
## @end group
## @end example
##
## or (if @var{Arr} is a cell array):
##
## @example
## @group
## @var{Arr}@{@var{K}@} < @var{Searched} ...
##   && ...
## @var{Searched} < @var{Arr}@{@var{K + 1}@}
## @end group
## @end example
## @end table
##
## @seealso{monot.empty, monot.gt_last, monot.idx, monot.insert,
## monot.interval, monot.lt_first}
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.insert (@var{Arr}, @var{@
## NewElem}, @var{BinSrchRet}, @var{BinSrchK})
## Insert an element in a sorted array, preserve monotony.
##
## Assuming @var{Arr} is sorted @strong{in ascending order} and a @code{[@var{@
## BinSrchRet}, @var{BinSrchK}] = monot.bin_srch (@var{Arr}, @var{@
## NewElem}, ...)} call has been done, @code{monot.insert (@var{Arr}, @var{@
## NewElem}, @var{BinSrchRet}, @var{BinSrchK})} returns @var{Arr}
## with one element added at a position such that it's still sorted.
##
## If @var{Arr} is a row vector then @var{Ret} is a row vector. If @var{Arr} is
## a column vector, then @var{Ret} is a column vector. If @var{Arr} is a
## scalar, then @var{Ret} is a row vector.
##
## @seealso{monot.bin_srch}
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.idx ()
## @command{monot.bin_srch} return value meaning "value found".
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.lt_first ()
## @command{monot.bin_srch} return value meaning "value lower than first element".
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.gt_last ()
## @command{monot.bin_srch} return value meaning "value greater than last element".
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.empty ()
## @command{monot.bin_srch} return value meaning "empty array".
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} monot.interval ()
## @command{monot.bin_srch} return value meaning "lower and greater values found".
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef monot

    methods (Static)

        function Ret = idx
            check_usage(nargin == 0);
            Ret = 0;
        endfunction

        function Ret = lt_first
            check_usage(nargin == 0);
            Ret = -1;
        endfunction

        function Ret = gt_last
            check_usage(nargin == 0);
            Ret = 1;
        endfunction

        function Ret = empty
            check_usage(nargin == 0);
            Ret = -2;
        endfunction

        function Ret = interval
            check_usage(nargin == 0);
            Ret = -3;
        endfunction

        function [Ret, varargout] = bin_srch(Arr, Searched, varargin)

            check_usage((nargin == 2 || (nargin == 3 ...
                                           && ...
                                         numel(varargin{1}) == 2 ...
                                           && ...
                                         is_integer(varargin{1}) ...
                                           && ...
                                         (...
                                           diff(varargin{1}) < 0 ...
                                             || ...
                                           (...
                                             varargin{1}(1) >= 1 ...
                                               && ...
                                             varargin{1}(2) <= numel(Arr) ...
                                           )...
                                         ))) ...
                          && ...
                        isscalar(Searched));

            if nargin == 2
                fiIni = 1;
                laIni = numel(Arr);
            else
                fiIni = varargin{1}(1);
                laIni = varargin{1}(2);
            endif

            if iscell(Arr)
                elem = @cell_elem;
            else
                elem = @arr_elem;
            endif

            done = false;
            Ret  = enum('empty');
            k    = fiIni;

            if laIni < fiIni

                # Arr size and/or provided bounds are such that there is
                # nothing to search in.

                done = true;
                # Ret = enum('empty'); # Ret is already set to this value.
                # k   = fiIni; # k is already set to this value.

            else

                # Arr size and/or provided bounds are such that there is at
                # least one value to compare Searched to.

                # Handle the following cases immediately:
                # - Searched value is greater than the element at the upper
                #   bound.
                # - Searched value is equal to the element at the upper bound.
                # - Searched value is lower than the element at the lower
                #   bound.

                el = elem(laIni, Arr);
                if el < Searched
                    done = true;
                    Ret = enum('gt_last');
                    k = laIni;
                elseif Searched == el
                    done = true;
                    Ret = enum('idx');
                    k = laIni;
                elseif Searched < elem(fiIni, Arr)
                    done = true;
                    Ret = enum('lt_first');
                    k = fiIni;
                endif

            endif

            fi = fiIni;
            la = laIni;
            while ~done

                # At this point, we know that Arr size and/or provided bounds
                # are such that there are at least two values to compare
                # Searched to and that Ret will be either "idx" or "interval".

                # [fi : la] is the range of the possible values for the
                # searched index (k or varargout{1}, K in the documentation).
                # The range is reduced until finding the searched index.

                # Number of values in the [fi : la] range (at least 2).
                len = la - fi + 1;

                # mi is the middle of the [fi : la] range. If len is odd, it's
                # really the middle. If len is even, it's on the high side. If
                # len is 2, mi is la.
                mi = fi + floor(len / 2);
                el = elem(mi, Arr);

                if Searched == el

                    done = true;
                    Ret = enum('idx');

                    # Make sure the returned index is the highest possible.
                    k = mi;
                    while k < laIni && elem(k + 1, Arr) == Searched
                        k = k + 1;
                    endwhile

                elseif Searched < el

                    if len == 2

                        # At this point, we know that k is fi.
                        k = fi;
                        if Searched == elem(fi, Arr)
                            done = true;
                            Ret = enum('idx');
                        else
                            done = true;
                            Ret = enum('interval');
                        endif

                    else

                        # Reduce the [fi : la] range by eliminating the higher
                        # half. mi cannot be the searched index k because
                        # Searched < elem(mi, Arr) and we want
                        # Searched >= elem(k, Arr). But we have to keep it in
                        # the [fi : la] range, otherwise the function can fall
                        # in an infinite loop (if
                        # Searched > elem(mi - 1, Arr)).
                        la = mi;

                    endif

                else

                    # Reduce the [fi : la] range by eliminating the lower half.
                    # mi could be the searched index k.
                    fi = mi;

                endif

            endwhile

            if nargout > 1
                varargout{1} = k;
            endif

        endfunction

        function Ret = insert(Arr, NewElem, BinSrchRet, BinSrchK)

            check_usage(nargin == 4 ...
                          && ...
                        (isempty(Arr) || isvector(Arr)) ...
                          && ...
                        isscalar(NewElem) ...
                          && ...
                        isscalar(BinSrchRet) ...
                          && ...
                        (isscalar(BinSrchK) && is_integer(BinSrchK)));

            if iscolumn(Arr) && numel(Arr) > 1
                a = Arr';
            else
                a = Arr;
            endif

            switch BinSrchRet

                case {
                       monot.empty
                       monot.lt_first
                     }
                    Ret = [a(1 : BinSrchK - 1) 0 a(BinSrchK : end)];
                    if iscell(Ret)
                        Ret{BinSrchK} = NewElem;
                    else
                        Ret(BinSrchK) = NewElem;
                    endif

                case {
                       monot.idx
                       monot.interval
                       monot.gt_last
                     }
                    Ret = [a(1 : BinSrchK) 0 a(BinSrchK + 1 : end)];
                    if iscell(Ret)
                        Ret{BinSrchK + 1} = NewElem;
                    else
                        Ret(BinSrchK + 1) = NewElem;
                    endif

            endswitch

            if iscolumn(Arr) && numel(Arr) > 1
                Ret = Ret';
            endif

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function Ret = enum(EnumName)

    Ret = evalin('caller', [mfilename '.' EnumName]);

endfunction
