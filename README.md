puppet-dashboard-face
=====================

Description
-----------

A Puppet Face for interacting with Puppet Dashboard.

Requirements
------------

* `puppet` ~> 2.7.0`

Installation
------------

Install puppet-dashboard-face as a module in your Puppet master's module path.

Usage
-----

### Searching for nodes ###

    $ puppet dashboard search nodes --class class
	  $ puppet dashboard search nodes --group group
	  $ puppet dashboard search nodes --class class --group group

### Listing classes ###

    $ puppet dashboard list classes
    
### Listing groups ###

    $ puppet dashboard list groups
    
### Listing nodes ###

    $ puppet dashboard list nodes

Author
------

Kelsey Hightower <kelsey.hightower@tsys.com>


License
-------

    Author:: Kelsey Hightower (<kelsey.hightower@gmail.com>)
    Copyright:: Copyright (c) 2011 Kelsey Hightower
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
