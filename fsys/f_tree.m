## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Constructor} {@var{Obj} =} f_tree (@var{Path})
## @deftypefnx {Constructor} {@var{Obj} =} f_tree (@var{Path}, @var{OptStru})
## @deftypefnx {Constructor} {@var{Obj} =} f_tree (@var{TreeRootItem})
## @deftypefnx {Constructor} {@var{Obj} =} f_tree (@var{TreeRootItem}, @var{@
## OptStru})
## @deftypefnx {Constructor} {@var{Obj} =} f_tree (@var{FTreeArray})
## Create a file tree object.
##
## The returned object @var{Obj} contains a tree of @command{directory} and
## @command{normal_file} objects.
##
## When a single row character vector argument (@var{Path}) is provided, it
## designates the file tree root directory or the single member of the file
## tree object (if it's an existing file). The same if a single
## @command{fsys_item} object (@var{TreeRootItem}) is provided.
##
## @var{Path} and @var{TreeRootItem} can be complemented with an optional
## option structure argument (@var{OptStru}). Here is the list of fields that
## are used if they are present in the structure and the default values used if
## they are absent:
##
## @table @asis
## @item @qcode{depth}
## Directory exploration depth limit:
## @table @asis
## @item -1 (default)
## No limit.
##
## @item 0
## No exploration at all (not even the file tree root is explored).
##
## @item 1
## Only the file tree root is explored (and its subdirectories are included in
## the file tree object but not their content).
##
## @item 2, 3, etc.
## Like 1 but with one more directory depth level each time.
## @end table
##
## @item @qcode{file_filter} (empty by default)
## Row character array (the kind of character array that can be provided to
## @command{dir} (can contain wildcard characters, except the double star
## (**))), or cell array of such row character arrays. Used as a file
## @strong{inclusion} criterion (not applied to directories).
##
## @item @qcode{dir_filter} (empty by default)
## Like @qcode{file_filter}, but applied to directories (not to files).
##
## @item @qcode{file_skip_filter} (empty by default)
## Like @qcode{file_filter}, but as a file @strong{exclusion} criterion. If a
## file is selected by both the file filter and the file skip filter, then it
## is excluded.
##
## @item @qcode{dir_skip_filter} (@code{f_tree.default_dir_skip_filter} by default)
## Like @qcode{file_skip_filter}, but applied to directories (not to files). If
## a directory is selected by both the file filter and the file skip filter,
## then it is excluded.
## @end table
##
## Note that the @strong{filters are not applied to the tree root}, only to
## files and directories below the tree root. So a file tree object cannot be
## empty. There is at list the tree root item.
##
## Note also that if you need to catch everything with a filter, you have to
## use both @qcode{*.*} and @qcode{.*} (thus @code{@{'*.*', '.*'@}}).
##
## Alternatively, you can provide as unique argument an array (or a cell array)
## of @command{f_tree} objects (@var{FTreeArray}). In this case, the resulting
## object @var{Obj} contains every file and directory present in at least one
## element of the array. This is useful to merge @command{f_tree} objects built
## with different option structures and/or different root path. It is
## recommended to do such a merge immediately after building the original
## @command{f_tree} objects (i.e.@ before any processing like class
## substitution of file or directory items) because the merge won't respect
## that (in particular some directories may be reverted to @command{directory}
## class). Note also that @strong{the original @command{f_tree} objects may be
## affected by the merge} (for example, the output of their @qcode{path_list}
## method may be changed).
##
## Providing no argument is equivalent to providing @code{pwd} as first
## argument and @code{struct ('depth', 0)} as second argument.
##
## @seealso{dir, exist, fsys_item, f_tree.default_dir_skip_filter, pwd}
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} f_tree.traverse (@var{Process}, @var{@
## Arg1}, @var{Arg2}, ...)
## Run @var{Process} function for every item in the tree.
##
## @var{Process} must be a function handle.
##
## @code{@var{Ret} = f_tree.traverse (@var{Process})} initializes @var{Ret} to
## @code{[]} and runs @code{@var{Ret} = @var{Process} (@var{Ret}, @var{@
## Item}, @var{Arg1}, @var{Arg2}, ...)}
## for every item @var{Item} in the tree. The tree is traversed pre-order, with
## priority given to directories over files.
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} f_tree.path_list ()
## Return cell array of paths (trailing file separator for directories).
## @end deftypefn
##
## @deftypefn {Method} {@var{Ret} =} f_tree.file_list ()
## Return cell array of file paths.
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} f_tree.default_opt_stru ()
## Return default @command{f_tree} option structure.
##
## @seealso{f_tree}
## @end deftypefn
##
## @deftypefn {Static method} {@var{Ret} =} f_tree.default_dir_skip_filter ()
## Return @qcode{file_skip_filter} field of @command{f_tree} default option structure.
##
## @seealso{f_tree}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef f_tree

    properties (Access = private)

        top

    endproperties

# -----------------------------------------------------------------------------

    methods (Static)

        function Ret = default_opt_stru

            check_usage(nargin == 0);

            Ret = struct('depth',            -1, ...
                         'file_filter',      '', ...
                         'dir_filter',       '', ...
                         'file_skip_filter', '', ...
                         'dir_skip_filter',  {f_tree.default_dir_skip_filter});

        endfunction

        function Ret = default_dir_skip_filter

            check_usage(nargin == 0);

            # The list has been built based on the ignore list used by the
            # "ack" software.  See file ConfigDefault.pm in ack repository
            # (https://github.com/petdance/ack2).

            Ret = {
                    '.bzr'
                    '.cdv'
                    '~.dep'
                    '~.dot'
                    '~.nib'
                    '~.plst'
                    '.git'
                    '.hg'
                    '.pc'
                    '.svn'
                    '_MTN'
                    'CVS'
                    'RCS'
                    'SCCS'
                    '_darcs'
                    '_sgbak'
                    'autom4te.cache'
                    'blib'
                    '_build'
                    'cover_db'
                    'node_modules'
                    'CMakeFiles'
                    '.metadata'
                    '.cabal-sandbox'
                  };

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods

        function Obj = f_tree(varargin)

            check_usage(@valid_construct_args, varargin{:});

            [~, treeRootItem, optStru] = valid_construct_args;

            if isempty(treeRootItem)
                # An array of f_tree objects has been provided.

                fT = varargin{1};

                # Choose appropriate function to access the f_tree elements in
                # the array.
                if iscell(fT)
                    elem = @cell_elem;
                else
                    elem = @arr_elem;
                endif

                # Initialize number of top items in the f_tree array.
                topCount = 0;

                # Initialize upper bound for number of top items in the new
                # f_tree object.
                topMaxCount = 0;

                for k = 1 : numel(fT)
                    fTree       = elem(k, fT);
                    topCount    = topCount + numel(fTree.top);
                    topMaxCount = topMaxCount ...
                                    + ...
                                  numel(fTree.top) ...
                                    + ...
                                  sum(cellfun(@(x) x.children_count, ...
                                      fTree.top));
                endfor

                # Initialize row cell array of top items in the f_tree array.
                top = cell(1, topMaxCount);

                # Populate row cell array of top items in the f_tree array.
                fTK   = 1;
                topK  = 0;
                count = 0;
                fTree = elem(fTK, fT);
                while count < topCount
                    if topK < numel(fTree.top)
                        topK = topK + 1;
                    else
                        fTK   = fTK + 1;
                        topK  = 1;
                        fTree = elem(fTK, fT);
                    endif
                    count      = count + 1;
                    top{count} = fTree.top{topK};
                endwhile

                # isBelow(idx1) == idx2 means (if idx2 > 0) that item top{idx1}
                # is below directory top{idx2}.
                isBelow                        = is_below_arr(top, topCount);
                idxNotBelow                    = find(isBelow == 0);
                isBelow(end + 1 : topMaxCount) = -1;

                # isNewTop values will be true for top items that will be top
                # items in the new f_tree object, false for the other ones.
                isNewTop              = false(1, topMaxCount);
                isNewTop(idxNotBelow) = true;

                # processed values will be false for top items that need to be
                # "moved" (with grow_tree) to other subtrees, true for the
                # other ones.
                processed = isNewTop;

                # Split duplicate new top items into its children (because
                # leaving such duplicates would result in duplicated items in
                # the new f_tree object).
                k = 1;
                for k1 = idxNotBelow
                    k = k + 1;
                    for k2 = idxNotBelow(k : end)
                        if strcmp(top{k2}.path, top{k1}.path)
                            isNewTop(k2) = false;
                            c            = top{k2}.children_count;
                            extraRange   = topCount + (1 : c);
                            for k3 = extraRange
                                top{k3} = top{k2}.child(k3 - topCount);
                            endfor
                            isBelow(extraRange) = k1;
                            topCount            = topCount + c;
                        endif
                    endfor
                endfor

                # Trim processed to final size.
                processed = processed(1 : topCount);

                # Initialize the list of needed "moves" (column 1 for items to
                # move, column 2 for receiver parent). topMaxCount is used as
                # arbitrary initial size. The size is increased (doubled) when
                # needed by grow_tree_process.
                growTreeState = struct('move_count', 0, ...
                                       'move'      , {cell(topMaxCount, 2)});
                while ~all(processed)
                    for k = find(~processed)
                        if processed(isBelow(k))
                            growTreeState = grow_tree(growTreeState, ...
                                                      top{isBelow(k)}, ...
                                                      top{k});
                            processed(k) = true;
                        endif
                    endfor
                endwhile

                move = growTreeState.move;
                for k = 1 : growTreeState.move_count
                    move{k, 2}.add_child(move{k, 1});
                endfor

                top      = top(isNewTop);
                topCount = numel(top);

                # Sort top (directories first, deepest path last, and otherwise
                # alphabetically sorted).
                swapDone = true;
                while swapDone
                    swapDone = false;

                    for k = 1 : topCount - 1

                        cond1 = top{k + 1}.is_dir && ~top{k}.is_dir;
                        cond2 = ~cond1 ...
                                  && ...
                                (...
                                  numel(strfind(top{k + 1}.path, filesep)) ...
                                    > ...
                                  numel(strfind(top{k}.path, filesep)) ...
                                );
                        cond3 = ~cond1 ...
                                  && ...
                                ~cond2 ...
                                  && ...
                                lt_str(top{k + 1}.path, top{k}.path);

                        sw = cond1 || cond2 || cond3;

                        if sw
                            temp       = top{k + 1};
                            top{k + 1} = top{k};
                            top{k}     = temp;
                        endif

                        swapDone = swapDone || sw;

                    endfor
                endwhile

                Obj.top = top;

            else

                Obj.top = {treeRootItem};

                if isa(treeRootItem, 'directory')

                    explore_dir(treeRootItem, optStru);

                endif

            endif

        endfunction

        function Ret = traverse(Obj, Process, varargin)

            check_usage(nargin >= 2 && isa(Process, 'function_handle'));

            Ret = [];
            for k = 1 : numel(Obj.top)
                Ret = Obj.top{k}.traverse(Ret, Process, varargin{:});
            endfor

        endfunction

        function Ret = path_list(Obj)

            check_usage(nargin == 1);

            Ret = Obj.traverse(@path_list_process);

        endfunction

        function Ret = file_list(Obj)

            check_usage(nargin == 1);

            Ret = Obj.traverse(@file_list_process);

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function Ret = is_flt(X)

    Ret = is_str(X) ...
            && ...
          isempty(strfind(X, filesep));

endfunction

# -----------------------------------------------------------------------------

function Ret = is_existent_file(X)

    Ret = exist(X, 'file') ~= 0 && exist(X, 'dir') == 0;

endfunction

# -----------------------------------------------------------------------------

function Ret = is_cell_f_tree(X)

    Ret = iscell(X) && all(cellfun(@(a) isa(a, 'f_tree'), X(:)));

endfunction

# -----------------------------------------------------------------------------

function [Ret, varargout] = valid_construct_args(varargin)

    persistent treeRootItem optStru;

    if nargout == 1
        # Function used as validation function.

        fTreeArg = nargin > 0 && (isa(varargin{1}, 'f_tree') ...
                                    || ...
                                  is_cell_f_tree(varargin{1}));

        assert(...
                 nargin == 0 ...
                   || ...
                 (is_str(varargin{1}) && ~isempty(varargin{1})) ...
                   || ...
                 isa_scalar(varargin{1}, 'fsys_item') ...
                   || ...
                 fTreeArg, ...
               'Wrong type for first argument');

        assert(~fTreeArg || nargin == 1, ...
               ['No second argument allowed (''f_tree'' class array ' ...
                'provided as first argument)']);

        assert(nargin < 2 || isa_scalar(varargin{2}, 'struct'), ...
               'Second argument must be a scalar structure');

        if nargin == 2

            o = varargin{2};

            msgFmt = 'Invalid ''%s'' field in option structure';

            assert(~isfield(o, 'depth') || (isscalar(o.depth) ...
                                              && ...
                                            is_integer(o.depth) ...
                                              && ...
                                            o.depth >= -1), ...
                   msgFmt, ...
                   'depth');

            filterField = {'file_filter', ...
                           'dir_filter', ...
                           'file_skip_filter', ...
                           'dir_skip_filter'};

            for k = filterField

                f = k{1};
                assert(~isfield(o, f) || (is_flt(o.(f)) ...
                                            || ...
                                          (...
                                            iscell(o.(f)) ...
                                              && ...
                                            all(cellfun(@is_flt, o.(f)(:))) ...
                                          )), ...
                       msgFmt, ...
                       f);

            endfor

        endif

        if nargin == 0

            pa           = pwd;
            treeRootItem = directory(pa);

        else

            if ischar(varargin{1})
                pa = varargin{1};
            elseif isa(varargin{1}, 'fsys_item')
                pa = varargin{1}.path;
            else
                # fTreeArg is true.
                pa = '';
            endif

            if is_existent_file(pa)
                treeRootItem = normal_file(pa);
            elseif ~isempty(pa)
                treeRootItem = directory(pa);
            else
                # fTreeArg is true.
                treeRootItem = [];
            endif

        endif

        dfltOptStru = f_tree.default_opt_stru;
        if nargin == 0
            optStru = filled_in_stru(struct('depth', 0), dfltOptStru);
        elseif nargin == 2 && ~isempty(pa)
            optStru = filled_in_stru(varargin{2}, dfltOptStru);
        else
            optStru = dfltOptStru;
        endif

    else
        # Function used as "tree root item and option structure retriever".

        assert(nargin == 0, '''%s'' internal error', dbcaller('name'));
        varargout{1} = treeRootItem;
        varargout{2} = optStru;

    endif

    Ret = true;

endfunction

# -----------------------------------------------------------------------------

function Ret = depth_reached(Opt)

    Ret = Opt.depth == 0;

endfunction

# -----------------------------------------------------------------------------

function Ret = decrease_depth(Opt)

    Ret = Opt;

    if Ret.depth > 0
        Ret.depth = Ret.depth - 1;
    endif

endfunction

# -----------------------------------------------------------------------------

function Ret = dir_cnt(Path, varargin)

    # If provided and true, the optional argument means that Path is actually a
    # filter (like "/a/full/path/*.h").
    filterArg = nargin > 1 && varargin{1};

    if filterArg

        # The last component of Path is a filter.

        # Extract the directory part.
        targetFolder = fileparts(Path);

    else

        # Path is a directory.
        targetFolder = Path;

    endif

    # Get directory listing (with filter applied if any).
    Ret = dir(Path);

    # Check that the folder field of the resulting structure has a unique
    # value. It should be so because the double star filters have been excluded
    # by the class constructor argument checking.
    folder = unique({Ret.folder});
    assert(isempty(Ret) || isscalar(folder), ...
           ['''dir'' function called with argument %s unexpectedly ' ...
            'explored multiple directories'], ...
            Path);

    if isempty(folder)
        folder = targetFolder;
    else
        folder = folder{1};
    endif

    if ~strcmp(folder, targetFolder)

        # We should not be here if filterArg is false. And if we are here, it
        # is expected that folder is just below targetFolder. If it's not the
        # case, it's because the filter is "bad" (".", "..", contains double
        # star, ...).
        assert(filterArg && strcmp(fileparts(folder), targetFolder), ...
               ['Error condition following a call to ''dir'' function ' ...
                'with argument %s'], ...
               Path);

        # The dir function has actually explored a directory one level below
        # targetFolder. This happened because the filter has no wildcards and
        # happens to be an existing directory or has wildcards and expands to a
        # unique existing directory. And the dir function has explored this
        # directory.

        # Have the dir function explore targetFolder.
        Ret = dir(targetFolder);

        # Keep only the previously explored directory.
        [flag, idx] = ismember(file_basename(folder), {Ret.name});
        assert(flag, ['Internal error (inconsistency found between ' ...
                      'results of ''dir'' function for %s and %s'], ...
                      Path, ...
                      targetFolder);
        Ret = Ret(idx);

    else

        Ret = Ret(cellfun(@(name) ~(strcmp(name, '.') ...
                                      || ...
                                    strcmp(name, '..')), ...
                          {Ret.name}));

    endif

endfunction

# -----------------------------------------------------------------------------

function Keep = filter_dir_cnt(DCNa, ...
                               DCID, ...
                               ParentPath, ...
                               Opt, ...
                               FilterName, ...
                               varargin)

    if nargin > 5
        Keep = varargin{1};
    else
        Keep = true(size(DCNa));
    endif

    filter = Opt.(FilterName);

    if ~isempty(filter)

        if ischar(filter)
            filter = {filter};
        elseif iscolumn(filter)
            filter = filter';
        endif

        switch FilterName

            case 'file_filter'
                tmpKeep = false(size(Keep));
                tmpKeep(DCID) = true;

            case 'dir_filter'
                tmpKeep = false(size(Keep));
                tmpKeep(~DCID) = true;

            case {
                   'file_skip_filter'
                   'dir_skip_filter'
                 }
                tmpKeep = true(size(Keep));

        endswitch

        for k = filter

            f = k{1};

            if ~isempty(f)

                d = dir_cnt(fullfile(ParentPath, f), true);

                if ~isempty(d)

                    switch FilterName

                        case 'file_filter'
                            tmpKeep = tmpKeep ...
                                        | ...
                                      ismember(DCNa, {d(~[d.isdir]).name});

                        case 'dir_filter'
                            tmpKeep = tmpKeep ...
                                        | ...
                                      ismember(DCNa, {d([d.isdir]).name});

                        case 'file_skip_filter'
                            tmpKeep = tmpKeep ...
                                        & ...
                                      ~ismember(DCNa, {d(~[d.isdir]).name});

                        case 'dir_skip_filter'
                            tmpKeep = tmpKeep ...
                                        & ...
                                      ~ismember(DCNa, {d([d.isdir]).name});

                    endswitch

                endif

            endif

        endfor

        Keep = Keep & tmpKeep;

    endif

endfunction

# -----------------------------------------------------------------------------

function explore_dir(D, Opt)

    if ~depth_reached(Opt)

        parP = D.path;
        dirC = dir_cnt(parP);
        dCNa = {dirC.name};
        dCID = [dirC.isdir];

        keep = filter_dir_cnt(dCNa, dCID, parP, Opt, 'file_filter');
        keep = filter_dir_cnt(dCNa, dCID, parP, Opt, 'dir_filter', keep);
        keep = filter_dir_cnt(dCNa, dCID, parP, Opt, 'file_skip_filter', keep);
        keep = filter_dir_cnt(dCNa, dCID, parP, Opt, 'dir_skip_filter', keep);

        dDOpt = decrease_depth(Opt);

        dirC = dirC(keep);
        for k = 1 : numel(dirC)
            if dirC(k).isdir
                # Recursive call.
                explore_dir(directory(D, dirC(k).name), dDOpt);
            else
                normal_file(D, dirC(k).name);
            endif
        endfor

    endif

endfunction

# -----------------------------------------------------------------------------

function Ret = is_below(Item, D)

    pI   = Item.path;
    pDFS = [D.path filesep];
    Ret  = strncmp(pI, pDFS, numel(pDFS));
    assert(~Ret || D.is_dir, ...
           'Path %s appears to be below %s, which is not a directory', ...
           pI, ...
           D.path);

endfunction

# -----------------------------------------------------------------------------

function Ret = is_below_arr(Top, TopCount)

    Ret = zeros(1, TopCount);

    for k1 = 1 : TopCount

        item1 = Top{k1};

        k2  = 0;
        isB = false;
        while ~isB && k2 < TopCount
            k2    = k2 + 1;
            item2 = Top{k2};
            isB   = is_below(item1, item2);
        endwhile

        if isB
            Ret(k1) = k2;
        endif

    endfor

endfunction

# -----------------------------------------------------------------------------

function List = path_list_process(List, Item)

    if Item.is_dir
        suff = filesep;
    else
        suff = '';
    endif

    p = [Item.path suff];

    if isempty(List)
        List = {p};
    else
        List = [List p];
    endif

endfunction

# -----------------------------------------------------------------------------

function List = file_list_process(List, Item)

    if ~Item.is_dir

        if isempty(List)
            List = {Item.path};
        else
            List = [List Item.path];
        endif

    endif

endfunction

# -----------------------------------------------------------------------------

function State = grow_tree_process(State, Item, ReceiverTreeRoot)

    itemParentPath = fileparts(Item.path);

    if isfield(State, 'parent_path') ...
         && ...
       strcmp(itemParentPath, State.parent_path)

        parentItem = State.parent_item;

    else

        parentItem = ReceiverTreeRoot;
        while ~strcmp(parentItem.path, itemParentPath)
            parentItemChild = parentItem.child;
            iB = cellfun(@(x) is_below(Item, x), parentItemChild);
            if any(iB)
                parentItem = parentItemChild{iB};
            else
                pa = '';
                while ~strcmp(parentItem.path, pa)
                    [pa, na, ex] = fileparts(itemParentPath);
                endwhile
                d          = directory(parentItem, [na ex]);
                parentItem = d;
            endif
        endwhile

        State.parent_item = parentItem;
        State.parent_path = parentItem.path;

    endif

    parentItemChild = parentItem.child;
    if ~any(cellfun(@(x) strcmp(Item.path, x.path), parentItemChild))

        if Item.is_dir
            directory(parentItem, file_basename(Item.path));
        else
            if State.move_count == size(State.move, 1)
                State.move = [State.move; cell(State.move_count, 2)];
            endif
            State.move_count                = State.move_count + 1;
            State.move(State.move_count, :) = {Item parentItem};
        endif

    endif


endfunction

# -----------------------------------------------------------------------------

function State = grow_tree(State, ReceiverTreeRoot, SingleTopSubFTree)

    State = SingleTopSubFTree.traverse(State, ...
                                       @grow_tree_process, ...
                                       ReceiverTreeRoot);

endfunction
