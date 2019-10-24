## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.
## Author: Thierry Rascle <thierr26@free.fr>

function Ret = validate_monot_bin_srch_rslt(A, Searched, Bound, R, K)

    if iscell(A)
        arr = cell2mat(A);
    else
        arr = A;
    endif

    fi = Bound(1);
    la = Bound(2);

    if la < fi
        Ret = R == monot.empty;
    elseif Searched < arr(fi)
        Ret = R == monot.lt_first;
    elseif arr(la) < Searched
        Ret = R == monot.gt_last;
    else

        expectedK = fi;
        while arr(expectedK) < Searched
            expectedK = expectedK + 1;
        endwhile

        if Searched == arr(expectedK)
            while expectedK < la && arr(expectedK + 1) == Searched
                expectedK = expectedK + 1;
            endwhile
            expectedR = monot.idx;
        else
            expectedK = expectedK - 1;
            expectedR = monot.interval;
        endif

        Ret = R == expectedR && K == expectedK;

    endif

endfunction
