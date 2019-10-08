## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Method} {@var{Ret} =} test_helpers.routine ()
## Return the cell vector of handles to the @qcode{helpers} test routines.
##
## Please see @command{test_case.run} for details about test routines.
##
## @seealso{test_case.run}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef test_helpers < test_case

    methods

        function Ret = routine(Obj)

            Ret = {
                    @is_octave_too_many_args
                    @is_octave_ok
                  };

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function is_octave_too_many_args

    is_octave(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = is_octave_ok

    isO = is_octave;
    Ret = isscalar(isO) && islogical(isO) && isequal(is_octave, isO);
    # The second 'is_octave' call is to check that memoization is working well.

endfunction
