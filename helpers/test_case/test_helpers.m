## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Method} {@var{Ret} = } test_helpers.routine ()
## Return the cell vector of handles to the @qcode{helpers} test routines.
##
## Please see @command{test_case.run} for details about test routines.
##
## @seealso{test_case.run}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef test_helpers < test_case

    methods

        function Ret = routine(Obj) %#ok 'Obj' unused.

            Ret = {
                    @is_octave_too_many_args_error
                    @is_octave_ok
                    @monot_bin_srch_missing_arg
                    @monot_bin_srch_too_many_args_error
                    @monot_bin_srch_non_scalar_error
                    @monot_bin_srch_l_bound_error
                    @monot_bin_srch_u_bound_error
                    @monot_bin_srch_bound_dim_error
                    @monot_bin_srch_bound_not_integer_error
                    @monot_insert_missing_args_error
                    @monot_insert_too_many_args_error
                    @monot_insert_non_vector_error
                    @monot_insert_non_scalar_new_elem_error
                    @monot_insert_non_scalar_bin_srch_ret_error
                    @monot_insert_non_scalar_bin_srch_k_error
                    @monot_insert_non_integer_bin_srch_k_error
                    @monot_bin_srch_insert
                  };

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function is_octave_too_many_args_error

    is_octave(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = is_octave_ok

    isO = is_octave;
    Ret = isa_scalar(isO, 'logical') && isequal(is_octave, isO);
    # The second 'is_octave' call is to check that memoization is working well.

endfunction

# -----------------------------------------------------------------------------

function monot_bin_srch_missing_arg

    monot.bin_srch (0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_too_many_args_error

    monot.bin_srch (0, 0, [1 1], 0);

    endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_non_scalar_error

    monot.bin_srch (0, [0 0]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_l_bound_error

    monot.bin_srch ([0 1 2], 0, [0 2]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_u_bound_error

    monot.bin_srch ([0 1 2], 0, [2 4]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_bound_dim_error

    monot.bin_srch ([0 1 2], 0, [1 2 3]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_bin_srch_bound_not_integer_error

    monot.bin_srch ([0 1 2], 0, [2.1 3]);

endfunction

# -----------------------------------------------------------------------------

function monot_insert_missing_args_error

    insert(0, 0, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_too_many_args_error

    insert(0, 0, 0, 0, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_non_vector_error

    insert([10 11; 12 13; 14 15], 0, 0, 0, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_non_scalar_new_elem_error

    insert(0, [0 1], 0, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_non_scalar_bin_srch_ret_error

    insert(0, 0, [0 1], 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_non_scalar_bin_srch_k_error

    insert(0, 0, 0, [0 1]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function monot_insert_non_integer_bin_srch_k_error

    insert(0, 0, 0, 0.5);

endfunction

# -----------------------------------------------------------------------------

function Ret = monot_bin_srch_insert

    arr = monot_bin_srch_test_arr;
    n = numel(arr);

    Ret = true;

    Ret = Ret && cover_slice(arr, [1 n]);

    maxSliceLen = 7;

    fi = 1;
    la = 0;
    while Ret && fi < n + 1

        Ret = Ret && cover_slice(arr, [fi la]);

        if fi == 5
            Ret = Ret && cover_slice(arr', [fi la]);
        endif

        if la <= fi + 2 || fi == 5
            Ret = Ret && cover_slice(arr(fi : la), [fi la] - fi + 1);
        endif

        if la < n && numel(fi : la) < maxSliceLen
            la = la + 1;
        elseif la < n
            fi = fi + 1;
            la = la + 1;
        else
            fi = fi + 1;
        endif

    endwhile

    function Retu = cover_slice(A, B)
        Retu = true;
        for kConv = 1 : 2
            Retu = Retu && cover_monot_bin_srch_slice(A, B, kConv == 2);
        endfor
    endfunction

endfunction
