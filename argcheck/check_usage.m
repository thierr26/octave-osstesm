## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function} {} check_usage (@var{ValidationFuncHandle}, @var{@
## Arg1}, @var{Arg2}, ...)
## @deftypefnx {Function} {} check_usage (@var{ValidationFuncReturn})
## Submit arguments to a validation function or just check a logical value.
##
## @code{check_usage (@var{ValidationFuncHandle}, @var{Arg1}, @var{Arg2}, ...)}
## issues an error if @code{logical (@var{ValidationFuncHandle} (@var{@
## Arg1}, @var{Arg2}, ...))} is false or issues an error.
##
## If the function is run by Octave, the error is issued by @code{print_usage}
## when possible, otherwise it is issued by rethrowing the
## @var{ValidationFuncHandle} error (if any) or by explicitly calling
## @code{error}.
##
## In all case, the caller function name (obtained using @command{dbcaller}) is
## inserted in the error message.
##
## @code{check_usage (@var{ValidationFuncReturn})} does the same but takes the
## validation function return value instead of taking the function handle and
## its arguments.
##
## @seealso{dbcaller, error, is_octave, rethrow}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function check_usage(varargin)

    assert(nargin >= 1, 'Missing argument');

    err = [];

    if isa(varargin{1}, 'function_handle')

        r = false;

        try
            r = varargin{1}(varargin{2 : end});
        catch err
            # Do nothing with err here. Non-emptiness of err is tested later.
            1;
        end_try_catch

        if isempty(err)
            try
                r = logical(r);
            catch
                error(['Wrong return type for validation function (return ' ...
                       'type should be convertible to logical type)']);
            end_try_catch
        endif

    else

        assert(nargin == 1, ['First argument is not a function handle, so ' ...
                             'it should be the only argument']);
        r = varargin{1};

    endif

    if ~isempty(err) || ~r

        callerName = dbcaller('name');

        printUsageFailed = false;

        if is_octave

            try
                print_usage(callerName);
            catch printUsageErr
                if isempty(printUsageErr.identifier)
                    printUsageFailed = true;
                else
                    rethrow(printUsageErr);
                endif
            end_try_catch

        endif

        if ~is_octave || printUsageFailed

            callerFile = dbcaller('file');
            errM = sprintf('Invalid call to ''%s''\n(file %s)', ...
                           callerName, ...
                           callerFile);

            if isempty(err)
                error('%s', errM);
            else
                err.message = sprintf('%s\n%s', errM, err.message);
                rethrow(err);
            endif

        endif

    endif

endfunction
