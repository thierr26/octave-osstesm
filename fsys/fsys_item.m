## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn  {Constructor} {@var{Obj} =} fsys_item (@var{AbsolutePath})
## @deftypefnx {Constructor} {@var{Obj} =} fsys_item (@var{RelativePath})
## @deftypefnx {Constructor} {@var{Obj} =} fsys_item (@var{ParentItem}, @var{@
## Name})
## @deftypefnx {Constructor} {@var{Obj} =} fsys_item (@var{ParentItem}, @var{@
## Name}, @var{Ext})
## Create a file system item handle.
##
## @command{fsys_item} is a handle class of objects designating file system
## items (like directories and files). You cannot instantiate
## @command{fsys_item} as it is an abstract class but you can instantiate the
## derived classes @command{directory} and @command{normal_file}. You probably
## won't need to derive a new class from @command{fsys_item}. Derive from
## @command{directory} and @command{normal_file} instead.
##
## The constructor argument can be the absolute path to the item as a character
## vector (@var{AbsolutePath}). It can also be a relative path
## (@var{RelativePath}). In this case, the absolute path to the item is
## computed by prepending the current directory (as returned by @code{pwd}).
##
## Alternatively, you can provide the parent directory of the item as
## @var{ParentItem}, another instance of @command{fsys_item} (more precisely an
## instance of @command{directory} or of one of its derived class) and the name
## of the item as a non-empty row character vector (@var{Name}). If the name of
## the item has an extension and it's not included in @var{Name}, you can
## provide it as a separate argument (@var{Ext}). If it's not empty, it must
## start with a dot.
##
## Providing no argument is equivalent to providing a single @var{pwd}
## argument.
##
## @seealso{directory, normal_file, pwd}
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.parent ()
## Return the parent item (for objects constructed with a @var{ParentItem}).
##
## The method issues an error if the object constructor was not called with a
## @var{ParentItem}) argument.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.is_root ()
## Return true if the file system item is a file system root.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.parent_dir ()
## Return the absolute path of the file system item parent directory.
##
## The return value is a row character vector, empty if the file system item is
## a file system root.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.path ()
## Return the file system item absolute path.
##
## The return value is a row character vector, empty if the file system item is
## a file system root.
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.basename ()
## Return the file system item name (with extension, without directory path).
## @end deftypefn
##
## @deftypefn {Sealed method} {@var{Ret} =} fsys_item.is_dir ()
## Return true for a @command{directory} object.
##
## @seealso{directory}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

classdef (Abstract) fsys_item < tree_node

    properties (Access = protected)

        parent_item_or_path

    endproperties

    properties (Access = private)

        name
        ext

    endproperties

# -----------------------------------------------------------------------------

    methods (Sealed)

        function Ret = parent(Obj)

            check_usage(nargin == 1 ...
                          && ...
                        isa(Obj.parent_item_or_path, mfilename));

            Ret = Obj.parent_item_or_path;

        endfunction

        function Ret = is_root(Obj)

            check_usage(nargin == 1);

            Ret = isempty(Obj.parent_item_or_path);

        endfunction

        function Ret = parent_dir(Obj)

            check_usage(nargin == 1);

            if Obj.is_root
                Ret = '';
            elseif ischar(Obj.parent_item_or_path)
                Ret = Obj.parent_item_or_path;
            else
                Ret = Obj.parent_item_or_path.path;
            endif

        endfunction

        function Ret = path(Obj)

            check_usage(nargin == 1);

            if Obj.is_root
                Ret = [Obj.name Obj.ext];
            elseif ischar(Obj.parent_item_or_path)
                Ret = fullfile(Obj.parent_item_or_path, [Obj.name Obj.ext]);
            else
                Ret = fullfile(Obj.parent_item_or_path.path, ...
                               [Obj.name Obj.ext]);
            endif

        endfunction

        function Ret = basename(Obj)

            check_usage(nargin == 1);

            Ret = [Obj.name Obj.ext];

        endfunction

        function Ret = is_dir(Obj)

            check_usage(nargin == 1);

            Ret = isa(Obj, 'directory');

        endfunction

    endmethods

# -----------------------------------------------------------------------------

    methods

        function Obj = fsys_item(varargin)

            check_usage(nargin == 0 ...
                          || ...
                        (nargin == 1 && (is_str(varargin{1}) ...
                                           && ...
                                         ~isempty(varargin{1}))) ...
                          || ...
                        (...
                          nargin >= 2 ...
                            && ...
                          (...
                            isa_scalar(varargin{1}, 'directory') ...
                              && ...
                            is_str(varargin{2}) ...
                              && ...
                            ~isempty(varargin{2}) ...
                          ) ...
                            && ...
                          (nargin == 2 || is_str(varargin{3})) ...
                        ));

            if nargin <= 1

                if nargin == 1
                    [~, ~, ~, absPath] = path_props(varargin{1});
                else
                    absPath = pwd;
                endif

                [Obj.parent_item_or_path, ...
                 Obj.name, Obj.ext]           = fileparts(absPath);

                if ispc ...
                     && ...
                   numel(Obj.parent_item_or_path) == 2 ...
                     && ...
                   Obj.parent_item_or_path(2) == ':'

                    Obj.parent_item_or_path = [Obj.parent_item_or_path ...
                                               filesep];

                endif

                if isempty(Obj.name)
                    Obj.name = Obj.ext;
                    Obj.ext  = '';
                endif

                if isempty(Obj.name)
                    Obj.name                = Obj.parent_item_or_path;
                    Obj.parent_item_or_path = [];
                endif

            else

                [~, ~, isBase, absPath] = path_props(varargin{2});

                assert(isBase, ...
                       'Second argument should be a file name, not a path');

                na = file_basename(absPath);

                if nargin == 3 && ~isempty(varargin{3})

                    ex = file_ext(varargin{3});
                    assert(strcmp(ex, varargin{3}), ...
                           ['Third argument should be an extension (and ' ...
                            'include the leading dot)']);
                else
                    ex = '';
                endif

                [~, Obj.name, Obj.ext] = fileparts([na ex]);

                Obj.parent_item_or_path = varargin{1};
                Obj.parent_item_or_path.add_child(Obj);

            endif

        endfunction

    endmethods

endclassdef

# -----------------------------------------------------------------------------

function [IsAbsolute, varargout] = path_props(Path)

    # IsAbsolute: True if Path is an absolute path.
    # varargout{1} (isRoot): True if Path is a root path.
    # varargout{2} (isBase): True if Path is a name, and not a path with
    # multiple components.
    # varargout{3} (absPath): Absolute path with trailing file separators
    # removed and duplicated file separators removed and drive letter in upper
    # case (if applicable).
    #
    # Issues an error if Path contains semicolons at unexpected places (under
    # Windows only).
    #
    # For a full validation of the path, make sure to require all output
    # arguments.

    # TODO: Optimize:
    # - Don't use varargout.
    # - Output only really needed arguments.
    # - Do only one loop.
    # <2019-10-15>

    underWin = ispc;
    fileSepLen = numel(filesep);

    if underWin

        driveLength = 2;

        IsAbsolute = numel(Path) >= driveLength + fileSepLen ...
                       && ...
                     Path(driveLength) == ':' ...
                       && ...
                     strncmp(Path(driveLength + 1 : end), filesep, fileSepLen);

        invalidDriveLetter = IsAbsolute && ~ismember(Path(1), ...
                                                     ['a' : 'z', 'A' : 'Z']);
        assert(~invalidDriveLetter, 'Invalid drive letter in path: %s', Path);

        semiColonCount = numel(strfind(Path, ':'));
        unexpectedSemiColon = semiColonCount > 1 ...
                                || ...
                              (...
                                semiColonCount == 1 ...
                                  && ...
                                ~IsAbsolute ...
                              );
        assert(~unexpectedSemiColon, 'Unexpected semicolon in path: %s', Path);

    else

        driveLength = 0;
        IsAbsolute  = strncmp(Path, filesep, fileSepLen);

    endif

    if nargout >= 2

        # Remove duplicated file separators in Path.
        k = 0;
        doubleFileSep = [filesep filesep];
        doubleFileSepLen = numel(doubleFileSep);
        while k < numel(Path)
            k = k + 1;
            if strncmp(Path(k : end), doubleFileSep, doubleFileSepLen)
                Path = [Path(1 : k - 1) Path(k + fileSepLen : end)];
                k = k - 1;
            endif
        endwhile

        isRoot       = IsAbsolute && numel(Path) == driveLength + fileSepLen;
        varargout{1} = isRoot;

        if nargout >= 3

            if ~isRoot

                if strcmp(Path(end - fileSepLen + 1 : end), filesep)
                    # Remove trailing file separator in Path.
                    Path = Path(1 : end - fileSepLen);
                endif

            endif

            isBase = ~isRoot && isempty(strfind(Path, filesep));
            varargout{2} = isBase;

            if nargout >= 4

                if IsAbsolute
                    if underWin
                        Path(1) = upper(Path(1));
                    endif
                    absPath = Path;
                else
                    absPath = fullfile(pwd, Path);
                endif

                # Expand "." and ".." components.
                compRk = 0;
                compLa = driveLength;
                while compLa < numel(absPath) - fileSepLen

                    compRk = compRk + 1;
                    compFi = compLa + 1;
                    fSPos  = strfind(absPath(compFi : end), filesep) + compLa;
                    if isscalar(fSPos)
                        compLa = numel(absPath);
                    else
                        compLa = fSPos(2) - 1;
                    endif
                    comp   = absPath(compFi : compLa);
                    compBa = comp(fileSepLen + 1 : end);

                    doubleDot = strcmp(compBa, '..');
                    if strcmp(compBa, '.') ...
                         || ...
                       (doubleDot && compRk == 1)

                        absPath = [absPath(1          : compFi - 1) ...
                                   absPath(compLa + 1 : end       )];
                        compRk = compRk - 1;
                        compLa = compFi - 1;

                    elseif doubleDot

                        newCompLa = strfind(absPath(1 : compFi - 1), filesep);
                        newCompLa = newCompLa(end) - 1;
                        absPath = [absPath(1          : newCompLa) ...
                                   absPath(compLa + 1 : end      )];
                        compRk = compRk - 2;
                        compLa = newCompLa;

                    endif

                endwhile

                if compRk == 0
                    absPath = [absPath filesep];
                endif

                varargout{3} = absPath;

            endif

        endif

    endif

endfunction
