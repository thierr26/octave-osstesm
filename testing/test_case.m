## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Static method} {@var{Ret} =} test_case.run (@var{@
## TestCaseClassName})
## @deftypefnx {Static method} {[@var{Ret}, @var{@
## Err}] =} test_case.run (@var{TestCaseClassName})
## @deftypefnx {Static method} {[@var{Ret}, @var{@
## Err}, @var{TestCaseObj}] =} test_case.run (@var{TestCaseClassName})
## Create and run an instance of a test case class.
##
## @code{@var{Ret} = test_case.run (@var{TestCaseClassName})} internally
## creates an instance of test case class @var{TestCaseClassName}, runs it
## (i.e.@ runs its @qcode{outcome} method) and returns the outcome in
## @var{Ret} (true for a successful run, false otherwise).
##
## Class @var{TestCaseClassName} must derive from @qcode{test_case}. Please see
## examples of such classes in Osstesm source tree (e.g.@
## @qcode{test_helpers}). To create a @qcode{test_case} derived class, just
## override the @qcode{routine} method. It must return a cell vector of handles
## to test routines. You can implement the test routines as local functions in
## the @qcode{classdef} file. Test routines are functions with no input
## arguments and one or zero output argument. One output argument means that
## the routine is not supposed to issue any error and reports its outcome
## through the output argument, which must be convertible to the logical type
## (true means success). Zero output argument means that the routine is
## supposed to issue an error (not issuing any error would be a failure).
##
## If the second output argument @var{Err} is required, then it is assigned
## a cell vector (one element per test routine). The cells are empty (for
## successful test routines) or assigned with an error structure (the kind of
## structure returned by @command{lasterror}) that should help analyse the
## issue.
##
## If the third output argument @var{TestCaseObj} is required, then it is
## assigned the test case class instance.
##
## @seealso{lasterror, test_case.outcome}
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} test_case.is_test_routine (@var{@
## X})
## Return true for a valid test routine handle.
##
## @code{test_case.is_test_routine (@var{X})} returns true if @var{X} is a
## handle to a function with zero or one output argument.
##
## Please see @command{test_case.run} for details about test routines.
##
## @seealso{test_case.run}
## @end deftypefn
##
## @deftypefn {Static method} {@var{@
## Ret} =} test_case.is_expected_to_fail (@var{R})
## Return true for a handle to a test routine supposed to issue an error.
##
## Please see @command{test_case.run} for details about test routines.
##
## @seealso{test_case.run}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} test_case.routine ()
## Return a cell vector of handles to test routines.
##
## Please see @command{test_case.run} for details about test routines.
##
## @seealso{test_case.run}
## @end deftypefn
##
## @deftypefn  {Method} {@var{Ret} =} test_case.outcome ()
## @deftypefnx {Method} {[@var{Ret}, @var{Err}] =} test_case.outcome ()
## @deftypefnx {Method} {[@var{Ret}, @var{@
## Err}, @var{TestCaseObj}] =} test_case.outcome ()
## Run test case.
##
## Please see @command{test_case.run} for details about the output arguments.
##
## @seealso{test_case.run}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef (Abstract) test_case

    methods (Static, Access = private)

        function Ret = t_r_h_descr(N)

            if N > 1
                p = 's';
            else
                p = '';
            endif

            Ret = sprintf(['handle%s to functions with zero or one output ' ...
                           'argument'], ...
                          p);

        endfunction

        function Ret = derived_class_error_message(ClassName)

            Ret = sprintf('''%s'' is not a descendant of ''%s''', ...
                          ClassName, ...
                          mfilename);

        endfunction

        function Ret = func_handle_arg_error_message

            Ret = sprintf('Invalid argument, %s expected', ...
                          test_case.t_r_h_descr(1));

        endfunction

        function Ret = routine_array_error_message(TestCaseObj)

            Ret = sprintf(['The ''routine'' method of a ''%s'' derived ' ...
                           'class (here ''%s'') should return a cell ' ...
                           'vector of %s'], ...
                          mfilename, ...
                          class(TestCaseObj), ...
                          test_case.t_r_h_descr(2));

        endfunction

        function Ret = routine_outcome_error_message(RArr, K, TestCaseObj)

            Ret = sprintf(['Falsy return value for routine #%d (''%s'') ' ...
                           'of test case ''%s'''], ...
                          K, ...
                          func2str(RArr{K}), ...
                          class(TestCaseObj));

        endfunction

        function Ret = routine_type_error_message(RArr, K, TestCaseObj)

            Ret = sprintf(['Wrong return value type for routine #%d ' ...
                           '(''%s'') of test case ''%s'' (return ' ...
                           'type should be convertible to logical type)'], ...
                          K, ...
                          func2str(RArr{K}), ...
                          class(TestCaseObj));

        endfunction

        function Ret = routine_succ_error_message(RArr, K, TestCaseObj)

            Ret = sprintf(['No error issued by routine #%d (''%s'') of ' ...
                           'test case ''%s'''], ...
                          K, ...
                          func2str(RArr{K}), ...
                          class(TestCaseObj));

        endfunction

        function Ret = func_handle_error_message(K, TestCaseObj)

            Ret = sprintf(['Component #%d of the output of the ' ...
                           '''routine'' method of test case ''%s'' is not ' ...
                           'a valid test routine (%s)'], ...
                          K, ...
                          class(TestCaseObj), ...
                          test_case.routine_array_error_message(TestCaseObj));

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods (Static)

        function [Outc, varargout] = run(Name)

            check_usage(nargin == 1 && isvarname(Name));

            obj = evalin('caller', Name);
            assert(isa_scalar(obj, mfilename), ...
                   test_case.derived_class_error_message(Name));

            if nargout > 1
                [Outc, varargout{1}] = obj.outcome;
                if nargout > 2
                    varargout{2} = obj;
                endif
            else
                Outc = obj.outcome;
            endif

        endfunction

        function Ret = is_test_routine(X)

            check_usage(nargin == 1);

            Ret = isa(X, 'function_handle') ...
                    && ...
                  (...
                    nargout(X) == 0 ...
                      || ...
                    nargout(X) == 1 ...
                  );

        endfunction

        function Ret = is_expected_to_fail(R)

            check_usage(nargin == 1);

            assert(test_case.is_test_routine(R), ...
                   test_case.func_handle_arg_error_message);

            Ret = nargout(R) == 0;

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods

        function Ret = routine(Obj) %#ok 'Obj' unused.

            Ret = {};

        endfunction

        function [Outc, varargout] = outcome(Obj)

            check_usage(nargin == 1);

            rA = Obj.routine;
            assert(iscell(rA) && isvector(rA), ...
                   test_case.routine_array_error_message(Obj));

            n = numel(rA);
            iETF = false(1, n);
            for k = 1 : n
                try
                    iETF(k) = test_case.is_expected_to_fail(rA{k});
                catch
                    error(test_case.func_handle_error_message(k, Obj));
                end_try_catch
            endfor

            Outc = true;
            if nargout > 1
                varargout{1} = cell(1, n);
            endif

            for k = 1 : n

                if iETF(k)
                    # Test routine is expected to fail.

                    err = [];
                    try

                        # Run test routine.
                        rA{k}();

                    catch err
                        # Do nothing with err here. Non-emptiness of err is
                        # tested later.
                    end_try_catch

                    if nargout > 1
                        try
                            assert(~isempty(err), ...
                                   test_case.routine_succ_error_message(rA, ...
                                                                        k, ...
                                                                        Obj));
                        catch e
                            if nargout > 1
                                varargout{1}{k} = error_stru(e);
                                varargout{1}{k}.stack(:) = [];
                            endif
                        end_try_catch
                    endif

                    Outc = Outc && ~isempty(err);

                else
                    # Test routine is not expected to fail.

                    failErr = [];
                    convErr = [];
                    ou      = false;

                    try
                        # Run test routine and store the outcome.
                        ou = rA{k}();
                    catch failErr
                        # Do nothing with failErr here. Non-emptiness of
                        # failErr is tested later.
                        1;
                    end_try_catch

                    if isempty(failErr)
                        try

                            # Convert test routine outcome to logical.
                            ou = logical(ou);

                            # Make sure to have a scalar test routine outcome.
                            if ou
                                ou = true;
                            else
                                ou = false;
                            endif

                        catch convErr
                            ou = false;
                            # Do nothing with convErr here. Non-emptiness of
                            # convErr is tested later.
                            1;
                        end_try_catch
                    endif

                    try
                        assert(isempty(convErr), ...
                               test_case.routine_type_error_message(rA, ...
                                                                    k, ...
                                                                    Obj));
                    catch e
                        if nargout > 1
                            varargout{1}{k}          = error_stru(e);
                            varargout{1}{k}.stack(:) = [];
                        endif
                    end_try_catch

                    if ~isempty(failErr)
                        if nargout > 1
                            mFNF            = mfilename('fullpathext');
                            eS              = error_stru(failErr);
                            eS.stack        = call_stack_head(eS.stack, mFNF);
                            varargout{1}{k} = eS;
                        endif
                    endif

                    try
                        assert(~isempty(convErr) ...
                                 || ...
                               ~isempty(failErr) ...
                                 || ...
                               ou, ...
                               test_case.routine_outcome_error_message(rA, ...
                                                                       k, ...
                                                                       Obj));
                    catch e
                        if nargout > 1
                            varargout{1}{k}          = error_stru(e);
                            varargout{1}{k}.stack(:) = [];
                        endif
                    end_try_catch

                    Outc = Outc && ou;

                endif

            endfor

        endfunction

    endmethods

endclassdef
