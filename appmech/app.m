## Copyright (C) 2019 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Protected property} {} app.state
## Internal state.
##
## @command{app} is an @strong{abstract} value class, meant to be used as
## ancestor for application classes.
##
## Please see @command{mentalsum} as an example application class. TODO: Give
## details about common code and configuration concept for application classes.
##
## @seealso{mentalsum}
## @end deftypefn
##
## @deftypefn {Protected property} {} app.config
## Configuration.
##
## @command{app} is an @strong{abstract} value class, meant to be used as
## ancestor for application classes.
##
## Please see @command{mentalsum} as an example application class. TODO: Give
## details about common code and configuration concept for application classes.
##
## @seealso{mentalsum}
## @end deftypefn


## Author: Thierry Rascle <thierr26@free.fr>

classdef (Abstract) app

    properties (Access = protected)

        state
        config
        # config is meant to be initialized on instantiation, not supposed to
        # change after that.

    endproperties

endclassdef
