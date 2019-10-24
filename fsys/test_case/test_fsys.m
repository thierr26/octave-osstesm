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

classdef test_fsys < test_case

    methods

        function Ret = routine(Obj) %#ok 'Obj' unused.

            Ret = {
                    @directory_no_arg
                    @directory_path_ext
                    @directory_path_ext_superfluous_fileseps
                    @directory_path_no_ext_superfluous_fileseps
                    @directory_path_root_parent
                    @directory_path_root
                    @directory_path_dot_1
                    @directory_path_dot_2
                    @directory_path_dot_3
                    @directory_path_dot_4
                    @directory_path_dot_dot_1
                    @directory_path_dot_dot_2
                    @directory_path_dot_dot_3
                    @directory_path_dot_dot_4
                    @directory_path_dot_dot_5
                    @directory_path_dot_dot_dot_1
                    @directory_path_dot_dot_dot_2
                    @directory_path_dot_dot_dot_3
                    @directory_path_wrong_type_error
                    @directory_path_empty_error
                    @directory_path_ispc_per_drive_default_dir_error
                    @directory_path_ispc_per_drive_path_error
                    @directory_parent_name_not_scalar_1_error
                    @directory_parent_name_wrong_type_1_error
                    @directory_parent_name_wrong_type_2_error
                    @directory_parent_name_empty_2_error
                    @directory_parent_name_ext_wrong_type_3_error
                    @directory_parent_name_ext_no_leading_dot_3_error
                    @directory_parent_error
                    @directory_parent
                    @directory_parent_name
                    @directory_parent_name_ext
                    @directory_parent_name_ext_empty
                    @normal_file_path_root_error
                    @normal_file_path_dot_file
                    @normal_file_parent_dot_file
                    @f_tree_path_wrong_type_error
                    @f_tree_path_stru_wrong_type_2_error
                    @f_tree_path_stru_not_scalar_depth_error
                    @f_tree_path_stru_not_integer_depth_error
                    @f_tree_path_stru_too_low_depth_error
                    @f_tree_path_stru_wrong_type_file_filter_error
                    @f_tree_path_stru_wrong_cell_type_file_filter_error
                    @f_tree_path_stru_filesep_file_filter_error
                    @f_tree_path_stru_filesep_cell_file_filter_error
                    @f_tree_path_stru_wrong_type_dir_filter_error
                    @f_tree_path_stru_wrong_cell_type_dir_filter_error
                    @f_tree_path_stru_filesep_dir_filter_error
                    @f_tree_path_stru_filesep_cell_dir_filter_error
                    @f_tree_path_stru_wrong_type_file_skip_filter_error
                    @f_tree_path_stru_wrong_cell_type_file_skip_filter_error
                    @f_tree_path_stru_filesep_file_skip_filter_error
                    @f_tree_path_stru_filesep_cell_file_skip_filter_error
                    @f_tree_path_stru_wrong_type_dir_skip_filter_error
                    @f_tree_path_stru_wrong_cell_type_dir_skip_filter_error
                    @f_tree_path_stru_filesep_dir_skip_filter_error
                    @f_tree_path_stru_filesep_cell_dir_skip_filter_error
                    @f_tree_path_stru_not_scalar_2_error
                    @f_tree_f_tree_too_many_args_error
                    @f_tree_no_arg
                    @f_tree_depth_0
                    @f_tree_depth_1
                    @f_tree_depth_2
                    @f_tree_filters
                    @f_tree_f_tree
                    @f_tree_file_list
                  };

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function Ret = fs

    Ret = filesep;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = fs_l

    Ret = numel(fs);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = dfs

    Ret = [filesep filesep];

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = tfs

    Ret = [filesep filesep filesep];

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = hlp

    Ret = 'helpers';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = appm

    Ret = 'appmech';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = argch

    Ret = 'argcheck';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = tst_case

    Ret = 'test_case';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = priv

    Ret = 'private';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = dep

    Ret = 'dependencies';

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = is_flt

    Ret = 'is_*';

endfunction

# -----------------------------------------------------------------------------

function Ret = directory_no_arg

    dirObj = directory;
    Ret = strcmp(dirObj.path, pwd) && dirObj.is_dir;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_ext

    ba = 'a_file_name.ext';
    if ispc
        pa = fullfile(['C:' fs 'Program Files (x86)' fs 'kbc'], ba);
    else
        pa = fullfile([fs 'usr' fs 'bin'], ba);
    endif

    dirObj = directory(pa);

    Ret = ~dirObj.is_root ...
            && ...
          strcmp(dirObj.path, pa) ...
            && ...
          strcmp(dirObj.parent_dir, fileparts(pa)) ...
            && ...
          strcmp(dirObj.basename, ba);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_ext_superfluous_fileseps

    if ispc
        pa = ['C:' dfs 'Program Files (x86)' dfs 'kbc' dfs 'k_file_name.ext'];
    else
        pa = [dfs 'usr' dfs 'bin' dfs 'a_file_name.ext'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ...
                     ['C:' fs 'Program Files (x86)' fs 'kbc' fs ...
                      'k_file_name.ext']) ...
                && ...
              strcmp(dirObj.parent_dir, ...
                     ['C:' fs 'Program Files (x86)' fs 'kbc']);
    else
        Ret = strcmp(dirObj.path, [fs 'usr' fs 'bin' fs 'a_file_name.ext']) ...
                && ...
              strcmp(dirObj.parent_dir, [fs 'usr' fs 'bin']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_no_ext_superfluous_fileseps

    ba = 'k_file_name';
    if ispc
        pa = ['C:' dfs 'Program Files (x86)' tfs 'kbc' dfs ba];
    else
        pa = [dfs 'usr' tfs 'bin' dfs ba];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ...
                     ['C:' fs 'Program Files (x86)' fs 'kbc' fs ...
                      'k_file_name']) ...
                && ...
              strcmp(dirObj.parent_dir, ...
                     ['C:' fs 'Program Files (x86)' fs 'kbc']);
    else
        Ret = strcmp(dirObj.path, [fs 'usr' fs 'bin' fs 'k_file_name']) ...
                && ...
              strcmp(dirObj.parent_dir, [fs 'usr' fs 'bin']);
    endif

    Ret = Ret && ~dirObj.is_root && strcmp(dirObj.basename, ba);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_root_parent

    if ispc
        pa                = ['C:' fs 'k_file_name.ext'];
        expectedParentDir = ['C:' fs];
    else
        pa                = [fs 'a_file_name.ext'];
        expectedParentDir = fs;
    endif

    dirObj = directory(pa);

    Ret = strcmp(dirObj.path, pa) ...
            && ...
          ~dirObj.is_root ...
            && ...
          strcmp(dirObj.parent_dir, expectedParentDir);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_root

    if ispc
        pa = ['C:' fs];
    else
        pa = fs;
    endif

    dirObj = directory(pa);

    Ret = strcmp(dirObj.path, pa) ...
            && ...
          dirObj.is_root ...
            && ...
          isempty(dirObj.parent_dir);

endfunction
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_1

    if ispc
        pa = ['C:' fs '.'];
    else
        pa = [fs '.'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs]);
    else
        Ret = strcmp(dirObj.path, fs);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_2

    if ispc
        pa = ['C:' fs 'kbc' fs '.'];
    else
        pa = [fs 'abc' fs '.'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_3

    if ispc
        pa = ['C:' fs 'kbc' fs '.' fs];
    else
        pa = [fs 'abc' fs '.' fs];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_4

    if ispc
        pa = ['C:' fs 'kbc' fs '.' fs '.' fs 'defg'];
    else
        pa = [fs 'abc' fs '.' fs '.' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc' fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_1

    if ispc
        pa = ['C:' fs '..'];
    else
        pa = [fs '..'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs]);
    else
        Ret = strcmp(dirObj.path, fs);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_2

    if ispc
        pa = ['C:' fs 'kbc' fs '..'];
    else
        pa = [fs 'abc' fs '..'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs]);
    else
        Ret = strcmp(dirObj.path, fs);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_3

    if ispc
        pa = ['C:' fs 'kbc' fs '..' fs];
    else
        pa = [fs 'abc' fs '..' fs];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs]);
    else
        Ret = strcmp(dirObj.path, fs);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_4

    if ispc
        pa = ['C:' fs 'kbc' fs 'xy' fs '..' fs '..' fs 'defg'];
    else
        pa = [fs 'abc' fs 'xy' fs '..' fs '..' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_5

    if ispc
        pa = ['C:' fs 'kbc' fs '..' fs 'defg'];
    else
        pa = [fs 'abc' fs '..' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_dot_1

    if ispc
        pa = ['C:' fs 'kbc' fs 'xy' fs '..' fs '.' fs 'defg'];
    else
        pa = [fs 'abc' fs 'xy' fs '..' fs '.' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc' fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_dot_2

    if ispc
        pa = ['C:' fs 'kbc' fs 'xy' fs '.' fs '..' fs 'defg'];
    else
        pa = [fs 'abc' fs 'xy' fs '.' fs '..' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc' fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_path_dot_dot_dot_3

    if ispc
        pa = ['C:' fs 'kbc' fs 'xy' fs '.' fs '..' fs '.' fs 'defg'];
    else
        pa = [fs 'abc' fs 'xy' fs '.' fs '..' fs '.' fs 'defg'];
    endif

    dirObj = directory(pa);

    if ispc
        Ret = strcmp(dirObj.path, ['C:' fs 'kbc' fs 'defg']);
    else
        Ret = strcmp(dirObj.path, [fs 'abc' fs 'defg']);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_path_wrong_type_error

    directory(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_path_empty_error

    directory('');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_path_ispc_per_drive_default_dir_error

    assert(ispc, 'Test routine makes sense for ''ispc'' case only');
    directory('C:');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_path_ispc_per_drive_path_error

    assert(ispc, 'Test routine makes sense for ''ispc'' case only');
    directory('C:a_file_name.ext');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_not_scalar_1_error

    warning('off', 'all');
    directory([directory directory], 'a_file_name');
    warning('on', 'all');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_wrong_type_1_error

    directory(0, 'a_file_name');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_wrong_type_2_error

    directory(directory, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_empty_2_error

    directory(directory, '');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_ext_wrong_type_3_error

    directory(directory, 'a_file_name', 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_name_ext_no_leading_dot_3_error

    directory(directory, 'a_file_name', 'ext');

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function directory_parent_error

    dirObj = directory;
    dirObj.parent;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_parent

    dirObj    = directory(directory, 'a_file_name.ext');
    parentObj = dirObj.parent;
    Ret = strcmp(parentObj.path, pwd);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_parent_name

    dirObj = directory(directory, 'a_file_name.ext');
    Ret    = strcmp(dirObj.path, fullfile(pwd, 'a_file_name.ext'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_parent_name_ext

    dirObj = directory(directory, 'a_file_name', '.ext');
    Ret    = strcmp(dirObj.path, fullfile(pwd, 'a_file_name.ext'));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = directory_parent_name_ext_empty

    dirObj = directory(directory, 'a_file_name.ext', '');
    Ret    = strcmp(dirObj.path, fullfile(pwd, 'a_file_name.ext'));

endfunction

# -----------------------------------------------------------------------------

function normal_file_path_root_error

    if ispc
        normal_file(['C:' fs]);
    else
        normal_file(fs);
    endif

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = normal_file_path_dot_file

    ba    = '.dotfile';
    pa    = fullfile(pwd, ba);
    nFObj = normal_file(pa);
    Ret   = ~nFObj.is_root ...
              && ...
            strcmp(nFObj.parent_dir, pwd) ...
              && ...
            strcmp(nFObj.path, pa) ...
              && ...
            strcmp(nFObj.basename, ba) ...
              && ...
            ~nFObj.is_dir;

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = normal_file_parent_dot_file

    ba    = '.dotfile';
    pa    = fullfile(pwd, ba);
    nFObj = normal_file(directory(pwd), ba);
    Ret   = ~nFObj.is_root ...
              && ...
            strcmp(nFObj.parent_dir, pwd) ...
              && ...
            strcmp(nFObj.path, pa) ...
              && ...
            strcmp(nFObj.basename, ba) ...
              && ...
            ~nFObj.is_dir;

endfunction

# -----------------------------------------------------------------------------

function f_tree_path_wrong_type_error

    f_tree(0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_type_2_error

    f_tree(pwd, 0);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_not_scalar_depth_error

    f_tree(pwd, struct('depth', [0 0]));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_not_integer_depth_error

    f_tree(pwd, struct('depth', 1.1));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_too_low_depth_error

    f_tree(pwd, struct('depth', -2));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_type_file_filter_error

    f_tree(pwd, struct('file_filter', 0));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_cell_type_file_filter_error

    f_tree(pwd, struct('file_filter', {{'*.m', 0}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_file_filter_error

    f_tree(pwd, struct('file_filter', ['a' filesep 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_cell_file_filter_error

    f_tree(pwd, struct('file_filter', {{['a' filesep 'b']}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_type_dir_filter_error

    f_tree(pwd, struct('dir_filter', 0));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_cell_type_dir_filter_error

    f_tree(pwd, struct('dir_filter', {{'*.m', 0}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_dir_filter_error

    f_tree(pwd, struct('dir_filter', ['a' filesep 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_cell_dir_filter_error

    f_tree(pwd, struct('dir_filter', {{['a' filesep 'b']}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_type_file_skip_filter_error

    f_tree(pwd, struct('file_skip_filter', 0));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_cell_type_file_skip_filter_error

    f_tree(pwd, struct('file_skip_filter', {{'*.m', 0}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_file_skip_filter_error

    f_tree(pwd, struct('file_skip_filter', ['a' filesep 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_cell_file_skip_filter_error

    f_tree(pwd, struct('file_skip_filter', ['a' filesep 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_type_dir_skip_filter_error

    f_tree(pwd, struct('dir_skip_filter', 0));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_wrong_cell_type_dir_skip_filter_error

    f_tree(pwd, struct('dir_skip_filter', {{'*.m', 0}}));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_dir_skip_filter_error

    f_tree(pwd, struct('dir_skip_filter', ['a' fs 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_filesep_cell_dir_skip_filter_error

    f_tree(pwd, struct('dir_skip_filter', ['a' fs 'b']));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_path_stru_not_scalar_2_error

    f_tree(pwd, [struct('depth', 0) struct('depth', 0)]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function f_tree_f_tree_too_many_args_error

    f_tree(f_tree(pwd, struct('depth', 0)), struct('depth', 0));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_no_arg

    fT  = f_tree;
    pL  = fT.path_list;
    Ret = isscalar(pL) && strcmp(pL{1}, [pwd fs]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_depth_0

    pa  = fullfile(osstesm_root, hlp);
    fT  = f_tree(pa, struct('depth', 0));
    pL  = fT.path_list;
    Ret = isscalar(pL) && strcmp(pL{1}, [pa fs]);

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_depth_1

    pa   = fullfile(osstesm_root, hlp);
    fT   = f_tree(pa, struct('depth', 1));
    pL   = fT.path_list;
    di   = cellfun(@(x) strcmp(x(end - numel(fs) + 1 : end), fs), pL);
    pLDi = pL(di);
    pLFi = pL(~di);
    Ret  = numel(pL) > numel(pLDi) ...
             && ...
           isequal(sort(pLDi), ...
                   sort({[pa fs], [fullfile(pa, tst_case) fs]})) ...
             && ...
           all(cellfun(@(x) strcmp(fileparts(x), pa), pLFi));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_depth_2

    pa   = fullfile(osstesm_root, hlp);
    fT   = f_tree(pa, struct('depth', 2));
    pL   = fT.path_list;
    di   = cellfun(@(x) strcmp(x(end - numel(fs) + 1 : end), fs), pL);
    pLDi = pL(di);
    pLFi = pL(~di);
    Ret  = numel(pL) > numel(pLDi) ...
             && ...
           isequal(sort(pLDi), ...
                   sort({[pa fs], ...
                         [fullfile(pa, tst_case) fs], ...
                         [fullfile(fullfile(pa, tst_case), ...
                                   'private') ...
                          fs]})) ...
             && ...
           any(is_lvl_1_file) ...
             && ...
           any(is_lvl_2_file) ...
             && ...
           all(is_lvl_1_file | is_lvl_2_file);

    function a = is_lvl_1_file
        p1 = pa;
        a  = cellfun(@(x) strcmp(fileparts(x), p1), pLFi);
    endfunction

    function a = is_lvl_2_file
        p1 = pa;
        d2 = tst_case;
        a  = cellfun(@(x) strcmp(fileparts(x), fullfile(p1, d2)), pLFi);
    endfunction

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_filters

    pa = fullfile(osstesm_root, hlp);

    fTNoFlt = f_tree(pa, struct('depth',            -1, ...
                                'file_filter',      '', ...
                                'dir_filter',       '', ...
                                'file_skip_filter', '', ...
                                'dir_skip_filter',  ''));
    pLNoFlt = fTNoFlt.path_list;

    Ret = numel(find(is_tst_case_dir(pLNoFlt))) == 1 ...
            && ...
          any(is_private_dir(pLNoFlt)) ...
            && ...
          any(is_dep_file(pLNoFlt)) ...
            && ...
          any(is_is_file(pLNoFlt));

    fTDep = f_tree(pa, struct('depth',            -1, ...
                              'file_filter',      dep, ...
                              'dir_filter',       '', ...
                              'file_skip_filter', '', ...
                              'dir_skip_filter',  ''));
    pLDep = fTDep.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLDep))) == 1 ...
                   && ...
                 any(is_private_dir(pLDep)) ...
                   && ...
                 any(is_dep_file(pLDep)) ...
                   && ...
                 ~any(is_is_file(pLDep));

    fTDepIs = f_tree(pa, struct('depth',            -1, ...
                                'file_filter',      {{dep, is_flt}}, ...
                                'dir_filter',       '', ...
                                'file_skip_filter', '', ...
                                'dir_skip_filter',  ''));
    pLDepIs = fTDepIs.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLDepIs))) == 1 ...
                   && ...
                 any(is_private_dir(pLDepIs)) ...
                   && ...
                 all(is_dep_file(pLDepIs) ...
                       | ...
                     is_is_file(pLDepIs) ...
                       | ...
                     is_a_dir(pLDepIs));

    fTTst = f_tree(pa, struct('depth',            -1, ...
                              'file_filter',      '', ...
                              'dir_filter',       tst_case, ...
                              'file_skip_filter', '', ...
                              'dir_skip_filter',  ''));
    pLTst = fTTst.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLTst))) == 1 ...
                   && ...
                 ~any(is_private_dir(pLTst)) ...
                   && ...
                 any(is_dep_file(pLTst)) ...
                   && ...
                 any(is_is_file(pLTst));

    fTPriv = f_tree(pa, struct('depth',            -1, ...
                               'file_filter',      '', ...
                               'dir_filter',       priv, ...
                               'file_skip_filter', '', ...
                               'dir_skip_filter',  ''));
    pLPriv = fTPriv.path_list;

    Ret = Ret && ~any(is_tst_case_dir(pLPriv)) ...
                   && ...
                 any(is_dep_file(pLPriv)) ...
                   && ...
                 any(is_is_file(pLPriv));

    fTTstPriv = f_tree(pa, struct('depth',            -1, ...
                                  'file_filter',      '', ...
                                  'dir_filter',       {{tst_case, priv}}, ...
                                  'file_skip_filter', '', ...
                                  'dir_skip_filter',  ''));
    pLTstPriv = fTTstPriv.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLTstPriv))) == 1 ...
                   && ...
                 any(is_private_dir(pLTstPriv)) ...
                   && ...
                 any(is_dep_file(pLTstPriv)) ...
                   && ...
                 any(is_is_file(pLTstPriv));

    fTNoDep = f_tree(pa, struct('depth',            -1, ...
                                'file_filter',      '', ...
                                'dir_filter',       '', ...
                                'file_skip_filter', dep, ...
                                'dir_skip_filter',  ''));
    pLNoDep = fTNoDep.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLNoDep))) == 1 ...
                   && ...
                 any(is_private_dir(pLNoDep)) ...
                   && ...
                 ~any(is_dep_file(pLNoDep)) ...
                   && ...
                 any(is_is_file(pLNoDep));

    fTNoDepNoIs = f_tree(pa, struct('depth',            -1, ...
                                    'file_filter',      '', ...
                                    'dir_filter',       '', ...
                                    'file_skip_filter', {{dep, is_flt}}, ...
                                    'dir_skip_filter',  ''));
    pLNoDepNoIs = fTNoDepNoIs.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLNoDepNoIs))) == 1 ...
                   && ...
                 any(is_private_dir(pLNoDepNoIs)) ...
                   && ...
                 ~any(is_dep_file(pLNoDepNoIs)) ...
                   && ...
                 ~any(is_is_file(pLNoDepNoIs));

    fTNoHlp = f_tree(pa, struct('depth',            -1, ...
                                'file_filter',      '', ...
                                'dir_filter',       '', ...
                                'file_skip_filter', '', ...
                                'dir_skip_filter',  hlp));
    pLNoHlp = fTNoHlp.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLNoHlp))) == 1 ...
                   && ...
                 any(is_private_dir(pLNoHlp)) ...
                   && ...
                 any(is_dep_file(pLNoHlp)) ...
                   && ...
                 any(is_is_file(pLNoHlp));

    fTNoPriv = f_tree(pa, struct('depth',            -1, ...
                                 'file_filter',      '', ...
                                 'dir_filter',       '', ...
                                 'file_skip_filter', '', ...
                                 'dir_skip_filter',  priv));
    pLNoPriv = fTNoPriv.path_list;

    Ret = Ret && numel(find(is_tst_case_dir(pLNoPriv))) == 1 ...
                   && ...
                 ~any(is_private_dir(pLNoPriv)) ...
                   && ...
                 any(is_dep_file(pLNoPriv)) ...
                   && ...
                 any(is_is_file(pLNoPriv));

    fTNoPrivNoTst = f_tree(pa, struct('depth',            -1, ...
                                      'file_filter',      '', ...
                                      'dir_filter',       '', ...
                                      'file_skip_filter', '', ...
                                      'dir_skip_filter',  {{priv, tst_case}}));
    pLNoPrivNoTst = fTNoPrivNoTst.path_list;

    Ret = Ret && ~any(is_tst_case_dir(pLNoPrivNoTst)) ...
                   && ...
                 ~any(is_private_dir(pLNoPrivNoTst)) ...
                   && ...
                 any(is_dep_file(pLNoPrivNoTst)) ...
                   && ...
                 any(is_is_file(pLNoPrivNoTst));

    function a = is_a_dir(PL)
        a = cellfun(@(x) strcmp(x(end - fs_l + 1 : end), fs), PL);
    endfunction

    function a = is_tst_case_dir(PL)
        p1 = pa;
        a  = cellfun(@(x) strcmp(x, [fullfile(p1, tst_case) fs]), PL);
    endfunction

    function a = is_private_dir(PL)
        a  = is_a_dir(PL) ...
               & ...
             cellfun(@(x) strcmp(x(end - fs_l + 1 : end), fs) ...
                             && ...
                           strcmp(file_basename(x(1 : end - fs_l)), ...
                                  priv), ...
                     PL);
    endfunction

    function a = is_dep_file(PL)
        a   = cellfun(@(x) strcmp(file_basename(x), dep), PL);
    endfunction

    function a = is_is_file(PL)
        pr  = is_flt;
        pr  = pr(1 : end - 1);
        prL = numel(pr);
        a   = cellfun(@(x) strncmp(file_basename(x), pr, prL), PL);
    endfunction

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_f_tree

    readmeMd = fullfile(osstesm_root, 'README.md');

    fT1 = f_tree(osstesm_root, struct('depth', 0));
    pL1 = fT1.path_list;
    fT2 = f_tree(readmeMd);
    pL2 = fT2.path_list;
    fT3 = f_tree(osstesm_root, struct('depth', 1, ...
                                      'file_filter', 'README.md', ...
                                      'dir_skip_filter', {{'*.*', '.*'}}));
    pL3 = fT3.path_list;

    Ret = numel(pL1) == 1 && strcmp(pL1{1}, [osstesm_root fs]);
    Ret = Ret && numel(pL2) == 1 && strcmp(pL2{1}, readmeMd);

    fTA = f_tree(fT1);
    Ret = Ret && isequal(fTA.path_list, pL1);

    fTA = f_tree(fT2);
    Ret = Ret && isequal(fTA.path_list, pL2);

    fTA = f_tree({fT1 fT2});
    Ret = Ret && isequal(fTA.path_list, pL3);

    fTA = f_tree({f_tree(readmeMd) f_tree(readmeMd)});
    Ret = Ret && isequal(fTA.path_list, {readmeMd});

    fT4 = f_tree(osstesm_root);
    fT5 = f_tree(osstesm_root);
    fTA = f_tree({fT4 fT5});
    Ret = Ret ...
            && ...
          isequal(fT4.path_list, fT5.path_list) ...
            && ...
          isequal(fT4.path_list, fTA.path_list);

    fT6 = f_tree(osstesm_root);
    fT7 = f_tree(fullfile(osstesm_root, hlp));
    fTA = f_tree({fT6 fT7});
    Ret = Ret ...
            && ...
          numel(fT6.path_list) > numel(fT7.path_list) ...
            && ...
          isequal(fT6.path_list, fTA.path_list);

    fT8  = f_tree(osstesm_root);
    pL8  = fT8.path_list;
    fT9  = f_tree(osstesm_root, struct('file_filter', 'test_*'));
    pL9  = fT9.path_list;
    fT10 = f_tree(osstesm_root, struct('file_skip_filter', 'test_*'));
    pL10  = fT10.path_list;
    fTA  = f_tree({fT9 fT10});
    Ret  = Ret ...
             && ...
           ~isequal(pL9, pL10) ...
             && ...
           isequal(pL8, fTA.path_list);

    fT11 = f_tree(fullfile(osstesm_root, hlp));
    fT12 = f_tree(fullfile(osstesm_root, argch));
    fT13 = f_tree(fullfile(osstesm_root, appm));
    fTA  = f_tree({fT3 fT11 fT12 fT13});
    pLA  = fTA.path_list;
    Ret  = Ret ...
             && ...
           isequal(pLA(2 : end - 1), ...
                   pL8(cellfun(@(x) ~isempty(strfind(x, [fs hlp fs])) ...
                                      || ...
                                    ~isempty(strfind(x, [fs appm fs])) ...
                                      || ...
                                    ~isempty(strfind(x, [fs argch fs])), ...
                               pL8))) ...
             && ...
           strcmp(pLA{end}, readmeMd) ...
             && ...
           strcmp(pLA{1}, [osstesm_root fs]);

    fT14 = f_tree(fullfile(osstesm_root, hlp));
    fT15 = f_tree(fullfile(osstesm_root, argch));
    fT16 = f_tree(fullfile(osstesm_root, appm));
    fTA  = f_tree({fT14 fT15 fT16});
    pLA  = fTA.path_list;
    Ret  = Ret ...
             && ...
           isequal(pLA, ...
                   pL8(cellfun(@(x) ~isempty(strfind(x, [fs hlp fs])) ...
                                      || ...
                                    ~isempty(strfind(x, [fs appm fs])) ...
                                      || ...
                                    ~isempty(strfind(x, [fs argch fs])), ...
                               pL8)));

endfunction

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function Ret = f_tree_file_list

    fT = f_tree(osstesm_root);

    pL = fT.path_list;
    fL = fT.file_list;

    Ret = numel(fL) < numel(pL) ...
            && ...
          isequal(fL, ...
                  pL(cellfun(@(x) ~strcmp(x(end - fs_l + 1: end), fs), pL)));

endfunction
