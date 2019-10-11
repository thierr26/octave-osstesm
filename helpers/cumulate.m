## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Function} {@var{Ret} =} cumulate (@var{X}, @var{FuncHandle})
## @deftypefnx {Function} {@var{Ret} =} cumulate (@var{X}, @var{@
## FuncHandle}, @var{Iter})
## Apply cumulating function (e.g.@ @command{all}, @command{sum}) iteratively.
##
## @code{@var{Ret} = cumulate (@var{X}, @var{FuncHandle})} initializes
## @var{Ret} to @var{X} and runs
## @code{@var{Ret} = @var{FuncHandle} (@var{Ret})} at least once and until
## @var{Ret} is scalar (i.e.@ @code{isequal (size (@var{Ret}), [1 1])}). The
## number of iterations is limited to @code{numel (size (@var{X}))}. An error
## is issued if @var{Ret} is not scalar after the iterations.
##
## @var{FuncHandle} is supposed to be a handle to a function like
## @command{all}, @command{any} or @command{sum}.
##
## @code{@var{Ret} = cumulate (@var{X}, @var{FuncHandle}, 0)} is equivalent to
## @code{@var{Ret} = cumulate (@var{X}, @var{FuncHandle})}. If the optional
## integer argument @var{Iter} is provided and is greater then 0, then the
## function iterates @var{Iter} whatever @code{size (@var{Ret})}.
##
## @seealso{all, any, numel, isequal, size, sum}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function Ret = cumulate(X, FuncHandle, varargin)

    check_usage((nargin == 2 || (nargin == 3 ...
                                   && ...
                                 isscalar(varargin{1}) ...
                                   && ...
                                 is_integer(varargin{1}) ...
                                   && ...
                                 varargin{1} >= 0))...
                  && ...
                isa(FuncHandle, 'function_handle'));

    if nargin == 2
        iter = 0;
    else
        iter = varargin{1};
    endif

    lim = [];
    if iter == 0
        lim = numel(size(X));
    endif

    Ret = X;
    k   = 0;
    while ~done(Ret, k, iter, lim)
        Ret = FuncHandle(Ret);
        k   = k + 1;
    endwhile

endfunction

# -----------------------------------------------------------------------------

function Ret = done(X, K, Iter, Lim)

    if Iter > 0
        Ret = K == Iter;
    else
        assert(K < Lim || isscalar(X), 'Scalar shape not reached');
        Ret = isscalar(X);
    endif

endfunction
