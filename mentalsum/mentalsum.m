## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Static method} {} mentalsum.play ()
## Prompt the user for 3 mental sums.
## @end deftypefn
##
## @deftypefn {Static method} {} mentalsum.result ()
## Show results after one or more @command{mentalsum.play} runs.
##
## @seealso{mentalsum.play}
## @end deftypefn
##
## @deftypefn {Static method} {} mentalsum.terminate ()
## Reset the game.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef (Sealed) mentalsum < app

    methods (Static, ...
             Access = private)

        function varargout = update_state(varargin)

            persistent soleClassInstance;

            if nargout == 0

                assert(nargin <= 1, 'Too many input arguments');

                if nargin == 1
                    assert(~isempty(soleClassInstance), ...
                           ['Attempt to update the state of an ' ...
                            'inactive application']);
                    soleClassInstance.state = varargin{1};
                else
                    clear soleClassInstance;
                endif

            else

                assert(nargout <= 2, 'Too many output arguments');

                if isempty(soleClassInstance)

                    mFN = mfilename;
                    wS = 'caller';

                    # Call constructor to create the singleton class instance.
                    soleClassInstance = evalin(wS, mFN);

                    # Get application factory default configuration.
                    dCExpr = [mFN '.default_config'];
                    dC = evalin(wS, dCExpr);

                    # Set application configuration.
                    soleClassInstance.config = dC;

                    # Compute application initial state.
                    iS = evalin(wS, [mFN '.initial_state(' dCExpr ')']);

                    # Set application initial state.
                    soleClassInstance.state = iS;

                endif

                varargout{1} = soleClassInstance.state;

                if nargout == 2
                    varargout{2} = soleClassInstance.config;
                endif

            endif

        endfunction

        function Ret = default_config
            Ret = struct('OperandDigit', 2, ...
                         'Burst',        3);
        endfunction

        function Ret = initial_state(DefaultConfig)
            oD = DefaultConfig.OperandDigit;
            Ret = struct(...
              'Deg1PolyCoef', [10^oD - 1 - 10^(oD - 1), 10^(oD - 1)], ...
              'Evaluated',    0, ...
              'Correct',      0, ...
              'CumTime',      0.0);
        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods (Static)

        function terminate

            check_usage(nargin == 0);

            # Clear application.
            mentalsum.update_state;

        endfunction

        function play

            check_usage(nargin == 0);

            # Get application state and configuration.
            [state, config] = mentalsum.update_state;

            # Prompt the user for mental sums.
            n = config.Burst;
            for k = 1 : n
                state = do_sum(state);
            endfor

            # Update application state.
            mentalsum.update_state(state);

        endfunction

        function Ret = result

            check_usage(nargin == 0);

            # Get application state.
            state = mentalsum.update_state;

            assert(state.Evaluated > 0, ...
                   ['Please run ' mfilename '.play first']);

            Ret = struct('Evaluated', state.Evaluated, ...
                         'Correct',   state.Correct, ...
                         'MeanTime',  state.CumTime / state.Correct);

            if nargout == 0
                h = {'Evaluated', ...
                     'Correct', ...
                     'Correct answer mean time (s)'};
                hMxLength = max(cellfun(@numel, h));
                hFmt = ['%' num2str(hMxLength) 's'];
                vFmt = {'%d', '%d', '%.2f'};
                line = {sprintf([hFmt ': ' vFmt{1}], h{1}, Ret.Evaluated), ...
                        sprintf([hFmt ': ' vFmt{2}], h{2}, Ret.Correct), ...
                        sprintf([hFmt ': ' vFmt{3}], h{3}, Ret.MeanTime)};
                cellfun(@(ln) fprintf ('%s\n', ln), line);
            endif

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function [IsCorrect, Duration] = add(Operand1, Operand2)

    done = false;
    ticID = tic;
    while ~done

        answer = input(...
            sprintf('%d + %d = ? ', Operand1, Operand2), 's');

        done = ~isempty(regexp(answer, '^\s*-?[0-9]+\s*$', 'once'));
        if ~done
            fprintf('Please enter a literal integer.\n');
        endif

    endwhile
    Duration = toc(ticID);

    IsCorrect = str2double(answer) == Operand1 + Operand2;
    if IsCorrect
        fprintf('Correct!\n\n');
    else
        fprintf('Wrong!\n\n');
    endif

endfunction

# -----------------------------------------------------------------------------

function Ret = rand_op(State)

    Ret = floor(polyval(State.Deg1PolyCoef, rand(1)));

endfunction

# -----------------------------------------------------------------------------

function State = do_sum(State)

    [isCorrect, duration] = add(rand_op(State), rand_op(State));
    State.Evaluated = State.Evaluated + 1;
    if isCorrect
        State.Correct = State.Correct + 1;
        State.CumTime = State.CumTime + duration;
    endif

endfunction
