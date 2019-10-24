## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function Ret = cover_monot_bin_srch_slice(A, Bound, ConvertToCell)

    if ConvertToCell
        arr  = num2cell(A);
        elem = @cell_elem;
    else
        arr  = A;
        elem = @arr_elem;
    endif

    empt = isempty(Bound(1) : Bound(2));

    Ret = true;
    if empt
        searched    = 0;
        searchedOld = 0;
    else
        searched    = elem(Bound(1), arr) - 0.5;
        searchedOld = searched;
    endif
    firstIter = true;
    while Ret && (...
                   (empt && firstIter) ...
                     || ...
                   (~empt && searchedOld <= elem(Bound(2), arr)) ...
                 )

        if isequal(Bound, [1 numel(arr)])
            [r, k] = monot.bin_srch(arr, searched);
        else
            [r, k] = monot.bin_srch(arr, searched, Bound);
        endif
        Ret = validate_monot_bin_srch_rslt(arr, searched, Bound, r, k);
        Ret = Ret && validate_monot_insert(arr, searched, Bound, r, k);

        if ~empt
            searchedOld = searched;
            if r == monot.lt_first
                searched = elem(Bound(1), arr);
            elseif r == monot.interval
                searched = elem(k + 1, arr);
            else
                searched = searched + 0.5;
            endif
        endif

        firstIter = false;

    endwhile

endfunction
