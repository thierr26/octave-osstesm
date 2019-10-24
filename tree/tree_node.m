## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Abstract method} {@var{Ret} =} tree_node.parent ()
## Return a handle to the parent node.
## @end deftypefn
##
## @deftypefn {Abstract method} {@var{Ret} =} tree_node.children_count ()
## Return the number of children nodes.
## @end deftypefn
##
## @deftypefn  {Abstract method} {@var{Ret} =} tree_node.child ()
## @deftypefnx {Abstract method} {@var{Ret} =} tree_node.child (@var{K})
## Return handles to the children nodes.
##
## If no argument is provided, then all the children are returned in a row
## vector. The vector may be a cell array or a "normal" vector. It depends on
## the concrete implementation. In all case, the length of the vector is
## @code{tree_node.children_count ()}.
##
## If argument @var{K} is provided, then only the child with index @var{K} is
## returned.
##
## @seealso{tree_node.children_count}
## @end deftypefn
##
## @deftypefn {Method} {@var{State} =} tree_node.traverse (@var{@
## Process}, @var{State}, @var{Arg1}, @var{Arg2}, ...)
## Run @var{Process} function for the node tree, its children, their children, etc.
##
## @var{Process} must be a function handle. @var{State} can be anything.
##
## @code{@var{State} = tree_node.traverse (@var{Process}, @var{State}, @var{@
## Arg1}, @var{Arg2}, ...)} runs @code{@var{State} = @var{Process} (@var{@
## State}, @var{Node}, @var{Arg1}, @var{Arg2}, ...)} for every node in the
## subtree made of the tree node and all the nodes below (children, children of
## children, etc.). The subtree is traversed pre-order.
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef (Abstract) tree_node < handle

    methods

        function Ret = parent(Obj) %#ok 'Ret' unset.

            must_override(class(Obj));

        endfunction

        function Ret = children_count(Obj) %#ok 'Ret' unset.

            must_override(class(Obj));

        endfunction

        function Ret = child(Obj, varargin) %#ok 'Ret' unset.

            must_override(class(Obj));

        endfunction

        function State = traverse(Obj, State, Process, varargin)

            check_usage(nargin >= 3 && isa(Process, 'function_handle'));

            stk      = empty_stack;
            curIndex = 1;
            stk      = push(stk, curIndex);
            cur      = Obj;
            State    = Process(State, cur, varargin{:});
            done     = false;

            while ~done

                if cur.children_count > 0

                    # Current item has at least one child.

                    curIndex = 1;
                    stk      = push(stk, curIndex);
                    cur      = cur.child(curIndex);
                    State    = Process(State, cur, varargin{:});

                else

                    # Current item has no child.

                    while stk.d > 1 && curIndex == cur.parent.children_count
                        stk      = pop(stk);
                        cur      = cur.parent;
                        curIndex = stk.a(stk.d);
                    endwhile

                    done = stk.d == 1;

                    if ~done

                        # Current item has at least one more brother.

                        curIndex = curIndex + 1;
                        stk      = pop(stk);
                        stk      = push(stk, curIndex);
                        cur      = cur.parent.child(curIndex);
                        State    = Process(State, cur, varargin{:});

                    endif

                endif

            endwhile

            function Stack = empty_stack
                Stack = struct('d', 0, ...
                               'a', []);
            endfunction

            function Stack = push(Stack, Index)
                Stack.d = Stack.d + 1;
                if ~isempty(Stack.a)
                    if Stack.d > numel(Stack.a)
                        # Double the stack size.
                        Stack.a = [Stack.a zeros(1, numel(Stack.a))];
                    endif
                    Stack.a(Stack.d) = Index;
                # else
                #     Stack.a empty means that no pop has been done yet, and
                #     thus only Index values 1 have been pushed.
                #     This strategy may avoid to grow the stack by very small
                #     amounts at the beginning of the traversal.
                endif
            endfunction

            function Stack = pop(Stack)
                if isempty(Stack.a)
                    # Catching up. See comment above.
                    Stack.a = ones(1, Stack.d);
                endif
                Stack.d = Stack.d - 1;
            endfunction

        endfunction

    endmethods

endclassdef
