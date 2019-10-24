## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {} must_override (@var{X})
## Issue an error stating that class of @var{X} must override calling method.
##
## @command{must_override} is useful as long as Octave does not support
## abstract methods (see
## @uref{https://savannah.gnu.org/bugs/?51377, Octave bug #51377}).
##
## Instead of defining a method as abstract, define it as concrete and have it
## call @command{must_override}. Example:
##
## @example
## @group
##     method
##
##         function @var{Y} = my_abstract_method (@var{Obj}, @var{X})
##
##             must_override (@var{Obj});
##
##         end
##
##     end
## @end group
## @end example
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function must_override(X)

    methodName = dbcaller('name');
    error('Class ''%s'' must override method ''%s''', ...
          class(X), ...
          methodName);

endfunction
