## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function Ret = validate_monot_insert(A, Searched, Bound, R, K)

    aI = monot.insert(A, Searched, R, K);

    Ret = numel(aI) == numel(A) + 1 ...
            && ...
          searched_value_inserted(A, Searched, Bound, aI) ...
            && ...
          sorted(aI, [Bound(1), Bound(2) + 1]) ...
            && ...
          isequal(aI(1 : Bound(1) - 1), A(1 : Bound(1) - 1)) ...
            && ...
          isequal(aI(Bound(2) + 2 : end), A(Bound(2) + 1 : end));

endfunction

# -----------------------------------------------------------------------------

function Ret = searched_value_inserted(A, Searched, Bound, AI)

    if isempty(A)

        if iscell(A)
            Ret = isequal(AI, {Searched});
        else
            Ret = AI == Searched;
        endif

    else

        if iscell(A)
            elem = @cell_elem;
        else
            elem = @arr_elem;
        endif

        k = Bound(1);
        while elem(k, AI) == elem(k, A) && k < Bound(2)
            k = k + 1;
        endwhile

        Ret = (elem(k, AI) ~= elem(k, A) && elem(k, AI) == Searched) ...
                || ...
              elem(Bound(2) + 1, AI) == Searched;

        if elem(k, AI) ~= elem(k, A)
            for k2 = k : Bound(2)
                Ret = Ret && elem(k + 1, AI) == elem(k, A);
            endfor
        endif

    endif

endfunction

# -----------------------------------------------------------------------------

function Ret = sorted(A, Bound)

    Ret = true;

    if iscell(A)
        elem = @cell_elem;
    else
        elem = @arr_elem;
    endif

    for k = Bound(1) + 1 : Bound(2)
        Ret = Ret && elem(k, A) >= elem(k - 1, A);
    endfor

endfunction
