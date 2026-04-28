# Input Modes
[Quickstart](../README.md)

## `T` or `Toggle` - TOGGLE
On click toggles the input - for numeric inputs switches between 1 and 0, booleans betwen `true` / `false`.
Takes no additional parameters.

### Syntax: `\T\<name>\!`
or `\Toggle\<name>\!`

Parameter | Required | Takes | Description
-|-|-|-
name | ✓ | text | Name of input to bind to

Example | Description
-|-
`\T\LandingGear\!` | on click toggle landing gear up/down when clicked



## `=` or `Set` - SET
On click sets input to a value.
Takes 1 additional parameter - the value to set input to.

### Syntax: `\=\<name>\<value>\!`
or `\Set\<name>\<value>\!`
Parameter | Required | Takes | Description
-|-|-|-
name | ✓ | text | Name of input to bind to
value | ✓ | number / text | Value to set input to


Example | Description
-|-
`\=\my_input\0.4\!` | on click set `my_input` to 0.4


## `+` - PLUS STEP
On click adds value to the input. Can optionally be supplied with min and max parameters

### Syntax: `\+\<name>\<step>\<min?>\<max?>\!`
Parameter | Required | Takes | Description
-|-|-|-
name | ✓ | text | Name of input to bind to
step | ✓ | number | Value to increment to input
min | ✗ | number | Lower bound for value of input
max | ✗ | number | Upper bound for value of input

Example | Description
-|-
`\+\my_input\2\!` | on click add 2 to `my_input`


## `-` - MINUS STEP
On click subtracts value from the input. Can optionally be supplied with min and max parameters

### Syntax: `\-\<name>\<step>\<min?>\<max?>\!`

Parameter | Required | Takes | Description
-|-|-|-
name | ✓ | text | Name of input to bind to
step | ✓ | number | Value to decrement input by
min | ✗ | number | Lower bound for value of input
max | ✗ | number | Upper bound for value of input

Example | Description
-|-
`\-\my_input\2\!` | on click subtracts 2 from `my_input`


## `S` or `Slider` - Mouse drag slider
When clicked and held, moving mouse up and down increments / decrements input. Can be configured to do so continuosly or in explicit steps.

### Syntax: `\S\<name>\<sens or step>\<screen step?>\<min?>\<max?>\!`
or `\Slider\<name>\<sens or step>\<screen step?>\<min?>\<max?>\!`

Parameter | Required | Takes | Description
-|-|-|-
name | ✓ | text | Name of input to bind to
sens or step | ✓ | number | Sensitivity of continuous input or value to add/subtract per step
screen step | ✗ | number | How many % of screen height mouse has to move for 1 step to happen.  **Leave blank for continuous input**
min | ✗ | number | Lower bound for value of input
max | ✗ | number | Upper bound for value of input

> Note: Continuous sensitivity is measured in units per screen height. For example, if sensitivity=4, the input will change by 4 after moving the mouse for distance that it would take to go from bottom to top of screen.

Example | Description
-|-
`\S\demo\4\\2\16` | Continuous input with sensitivity=4 clamped in between values 2 and 16
`\S\demo step\2\5\0\!` | Stepped input that changes `demo step` by 2 every time mouse moves equivalend of 5% of scren height. Input is clamped in between 0 and ∞.
