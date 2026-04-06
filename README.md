# Interactive Cockpit
A Flyout LAMP mod script that allows for creation of clickable parts that bind to inputs.

In practice that means the ability to have working buttons modeled inside your cockpit!

## How to use

Add this script to your aircraft folder (or the shared folder)

Add part named "Lua: InteractiveCockpit.lua" (or whatever your correct path to this script is) to your aircraft.
The part can be anything (cube with scale 0 slapped onto Jimmy is more than enough)

OR

rename the script to main.lua


## Naming system
The mod uses rules you define in the name of a part to decide what to do on click
Every rule has to start with `\I` *(as in `\`+`I`nput)* and end with `\!`

Folowing the `I` in rule beginning, there has to be a "mode" specified in the form of one of following symbols: `T`, `S`, `+`, `-`
After that, another '\' follows, after which you should enter the name of your input. 
After the input name, the rule can either be closed off using '\!' or continue with another backslash for additional parameters.

> Note: Anything outside the start - end range (`\I` - `\!`) is ignored so you can have the part named as whatever you like and still keep the functionality. This also means you can write multiple rules after each other

> example valid name: `my button toggles \IT\some_input\! and it also sets \IS\other_input\0.1\!`

### Modes:

#### `T` - TOGGLE
Toggles the input - for numeric inputs switches between 1 and 0, booleans betwen `true` / `false`.
Takes no additional parameters - has to be closed off right after the input name.

| TOGGLE | rule | description
|--|------|--
|format  | `\IS\<name>\!` | toggle `<name>` input
|example | `\IT\LandingGear\!` | on click toggle landing gear up/down when clicked


#### `S` - SET
Sets input to a value
Takes 1 additional parameter - the value to set input to

| SET | rule | description
|--|------|--
|format | `\IS\<name>\<value>\!` | set `<name>` to `<value>`
|example | `\IS\my_input\0.4\!` | on click set `my_input` to 0.4


#### `+` - PLUS STEP
Adds a step value to the input. Can optionally be supplied with min and max parameters
| + | rule | description
|--|------|--
|format | `\I+\<name>\<step>\!` | set `<name>` to `<name>`+`<step>`
|format | `\I+\<name>\<step>\<min?>\<max?>!` | set `<name>` to `<name>`+`<step>` and ensure that `<min>` ≤ `<name>` ≤ `<max>`
|example | `\I+\my_input\2\!` | on click add 2 to `my_input`


#### `-` - MINUS STEP
Subtracts a step value from the input. Can optionally be supplied with min and max parameters
| - | rule | description
|--|------|--
|format | `\I-\<name>\<step>\!` | set `<name>` to `<name>`-`<step>`
|format | `\I-\<name>\<step>\<min?>\<max?>!` | set `<name>` to `<name>`-`<step>` and ensure that `<min>` ≤ `<name>` ≤ `<max>`


<!-- ## Important notes -->
