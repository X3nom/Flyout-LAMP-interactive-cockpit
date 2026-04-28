# Interactive Cockpit
A Flyout LAMP mod script that allows for creation of working input and output methods using the in game parts.

In practice that means the ability to have working buttons, segment displays and more modeled inside your cockpit!

## Quickstart

Add the `InteractiveCockpit.lua` script to your aircraft folder (or the LAMP shared folder)

Add a part named "Lua: InteractiveCockpit.lua" (or whatever your correct path to this script is) to your aircraft.
The part can be anything (cube with scale 0 slapped onto Jimmy is more than enough)

OR

rename the script to main.lua


## Naming system
The mod uses rules you define in the name of a part to define its behavior.
**Every rule has to start with `\` and end with `\!`**

Folowing the initial `\`, there has to be a "mode" specified, which decides the general type of action that should happen.

After that, another `\` follows, after which you should enter the name of your input.

Following the name, there can be additional parameters 
separated by `\` or the rule can be closed using `\!`

> Note: optional parameters are documented as `<parameterName?>` (`?` at the end)

You may want to keep some optional parameters empty. To do so, simply leave the field empty like this: `\<param1>\\<param3>\!`

> Note: Anything outside the start - end range (`\` - `\!`) is ignored so you can have the part named as whatever you like and still keep the functionality. This also means you can write multiple rules after each other
> example valid part name: `my button toggles \T\some_input\! and it also sets \=\other_input\0.1\!`

## Features:
- [Input Modes](docs/inputs.md)
- [14 Segment Display](docs/14segment.md)
