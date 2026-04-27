-- LAMP 2.3.10
-- By: ghGhost, maintained by Djesse


--- requires `parts` intent
---@type part
currentPart = {}
---@type table
shared = {}
---@type script
script = {}
--- only in canvas context
---@type ui
ui = {}
---@type controls
controls = {}
---@type controls
inputs = {}
---@type controls
outputs = {}
--- outputs data onto console window. Note: doesn't behave like Lua's `print`
---@param msg any 
function log (msg) end


--- calls provided function after specified amount of time
---@param timeout number 
---@param callback function function to be called
function delay (timeout, callback) end


--- creates f(x)=y curve from provided points. Check discord for more info
---@param points table 
---@param resolution nil | number (default: 100) 
---@return curve
function createCurve (points, resolution)
    ---@type curve
    local r; return r
end


--- creates GUI Warning object with specified text
--- can only be used during initialization
---@param text nil | string (default: "") 
---@return warningGui
function createWarning (text)
    ---@type warningGui
    local r; return r
end


--- binds keys to perform action in Lua.
--- requires `createButton` intent
--- can only be used during initialization
---@param keyBind string 
---@param callback nil | function (default: nil) keys to be bound to. `+` separator. activates only when all are pressed
---@return keyBind
function createButton (keyBind, callback)
    ---@type keyBind
    local r; return r
end


---@type parts | part[]
--- requires `parts` intent
parts = {}
--- requires `location` intent
---@type location
location = {}
--- requires `ui` intent
--- can only be used during initialization
---@param xml string 
---@param pToHide nil | boolean (default: true) 
---@return uiObject
function createCanvas (xml, pToHide)
    ---@type uiObject
    local r; return r
end


--- requires `ui` intent
---@param position vec 
---@return vec
function worldToScreenPoint (position)
    ---@type vec
    local r; return r
end


---@param x number 
---@param y number 
---@param z number 
---@return vec
function vec3 (x, y, z)
    ---@type vec
    local r; return r
end


---@param x number 
---@param y number 
---@return vec
function vec2 (x, y)
    ---@type vec
    local r; return r
end




-- Everything else:
---@param path string 
---@return nil | table
function lampLoadFile (path)
    ---@type nil | table
    local r; return r
end

--- following operators work: #, ==, <, >, <=, >=, +, -, *, /
---@class vec3
---@class vec2
---@class vec
local _vec = {
    --- property can be set
    ---@type number
    x = 0,
    --- property can be set
    ---@type number
    y = 0,
    --- property can be set
    ---@type number
    z = 0,
    ---@type vec
    copy = {},
    --- table representation of current values, doesn't update property
    --- property can be set
    ---@type table
    t = {},
}

--- f(x)=y type curve with provided points. Check discord for more info
---@class curve
local _curve = {
}

--- returns `y` at specified point on that curve
---@param x number 
---@return number
function _curve:get (x)
    ---@type number
    local r; return r
end

--- returns a list of points that you can put into desmos for debugging
---@return string
function _curve:desmos ()
    ---@type string
    local r; return r
end

---@class enemy
local _enemy = {
    --- marker associated with this enemy
    ---@type marker
    marker = {},
    --- type of said enemy
    ---@type string | "'sam'" | "'sam_missile'" | "'sam_radar'" | "'tank'" | "'drone'"
    type = "",
    ---@type number
    longitude = 0,
    ---@type number
    latitude = 0,
    ---@type coord
    coordinates = {},
    ---@type number
    asl = 0,
    ---@type number
    agl = 0,
    ---@type number
    speed = 0,
    --- whether enemy is destroyed. positional data stops updating when enemy gets destroyed
    ---@type boolean
    destroyed = false,
    --- absolute (including height) distance to the enemy
    ---@type number
    distance = 0,
    ---@type number
    bearing = 0,
    --- requires `gameObjects` intent
    ---@type gameObject
    gameObject = {},
}

--- all fields are like configs in game
---@class fuel
local _fuel = {
    ---@type number
    id = 0,
    ---@type string
    name = "",
    ---@type number
    density = 0,
    ---@type number
    era = 0,
    ---@type number
    price = 0,
    ---@type number
    specific_energy = 0,
    ---@type number
    heat_capacity = 0,
    ---@type number
    stoichiometric_ratio = 0,
    ---@type number
    auto_ignition = 0,
    ---@type number
    freezing_point = 0,
}

--- use `createButton` function to create
---@class keyBind
local _keyBind = {
    --- is this first frame of being pressed?
    ---@type boolean
    triggered = false,
    --- is this actively being pressed now?
    ---@type boolean
    pressed = false,
}

---@class marker
local _marker = {
    --- enemy associated with this marker
    ---@type nil | enemy
    enemy = {},
    ---@type number
    longitude = 0,
    ---@type number
    latitude = 0,
    ---@type coord
    coordinates = {},
    ---@type number
    asl = 0,
    ---@type number
    agl = 0,
    --- absolute (including height) distance to the enemy
    ---@type number
    distance = 0,
    ---@type number
    bearing = 0,
    --- default - 10. starting from 14 you lose distance readout on marker itself
    --- property can be set
    ---@type number
    fontSize = 0,
    --- HEX format (#0369CF)
    --- property can be set
    ---@type string | table
    color = "",
    --- property can be set
    ---@type string
    text = "",
    --- property can be set
    ---@type boolean
    enabled = false,
}

--- requires `parts` intent
---@class part
local _part = {
    --- requires `gameObjects` intent
    ---@type gameObject
    gameObject = {},
    ---@type number
    id = 0,
    ---@type string
    name = "",
    --- can be used to determine what part it is
    ---@type string
    internalName = "",
    --- is this .obj imported object?
    ---@type boolean
    isModded = false,
    --- to which part current one is attached
    ---@type nil | part
    parent = {},
    --- inputs associated with this part
    ---@type inputProcessor[]
    inputs = {},
    ---@type part[]
    children = {},
    --- property can be set
    ---@type vec3 | table
    scale = {},
    --- property can be set
    ---@type vec3 | table
    pos = {},
    --- property can be set
    ---@type vec3 | table
    rot = {},
    --- property can be set
    ---@type vec3 | table
    globalPos = {},
    --- property can be set
    ---@type vec3 | table
    globalRot = {},
    --- property can be set
    ---@type vec3 | table
    worldPos = {},
    --- property can be set
    ---@type vec3 | table
    worldRot = {},
    --- calculate drag on the current part
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type boolean
    calcDrag = false,
    --- RPM of Electric Motors, Piston Engines, Turbines, Ducted Fans, Propellers, Rotors, Tail Rotors, Landing Gear and Wheels
    ---@type number
    shaftRpm = 0,
    --- fuel tank component of this part
    ---@type nil | fuelTank
    fuelTank = {},
    --- missile component of this part
    ---@type nil | missile
    missile = {},
    --- gearbox component of this part
    ---@type nil | gearbox
    gearbox = {},
    --- turbine component of this part
    ---@type nil | turbine
    turbine = {},
    --- piston engine component of this part
    ---@type nil | pistonEngine
    pistonEngine = {},
    --- speaker component of this part
    ---@type nil | speaker
    speaker = {},
    --- rocket pod component of this part
    ---@type nil | rocketPod
    rocketPod = {},
    --- gun component of this part
    ---@type nil | gun
    gun = {},
    --- drum magazine component of this part
    ---@type nil | drumMag
    drumMag = {},
    --- radar component of this part
    ---@type nil | radar
    radar = {},
    --- rocket motor component of this part
    ---@type nil | rocketMotor
    rocketMotor = {},
    --- warhead component of this part
    ---@type nil | warhead
    warhead = {},
    --- irst component of this part
    ---@type nil | irst
    irst = {},
    --- seeker component of this part
    ---@type nil | seeker
    seeker = {},
    --- jammer component of this part
    ---@type nil | jammer
    jammer = {},
    --- targeting pod component of this part
    ---@type nil | targetingPod
    targetingPod = {},
    --- dispenser component of this part
    ---@type nil | dispenser
    dispenser = {},
    --- battery component of this part
    ---@type nil | battery
    battery = {},
    --- rwr component of this part
    ---@type nil | rwr
    rwr = {},
}

--- used to add custom behavior to parts. returns component that action was performed on
--- can only be used during initialization
---@param name string "'fuelTank'"
---@param table table config for this part
---@param mirror nil | boolean (default: false) should this be applied to mirrored part
---@return nil | any
function _part:addModule (name, table, mirror)
    ---@type nil | any
    local r; return r
end

--- used to add functions on left click to parts. Executes function when clicked
--- can only be used during initialization
---@param callback function 
function _part:onLeftClick (callback) end

--- used to add functions on right click to parts. Executes function when clicked
--- can only be used during initialization
---@param callback function 
function _part:onRightClick (callback) end

--- explode current part, bool for explosion fx
---@param explosionEffect nil | boolean (default: false) 
function _part:explode (explosionEffect) end

---@class warningGui
local _warningGui = {
    --- default - 13
    --- property can be set
    ---@type number
    fontSize = 0,
    --- HEX format (#0369CF)
    --- property can be set
    ---@type string | table
    color = "",
    --- property can be set
    ---@type string
    text = "",
    --- property can be set
    ---@type boolean
    enabled = false,
}

--- requires `parts` intent
---@class parts
local _parts = {
}

--- requires `location` intent
---@class location
local _location = {
    ---@type number
    startingLongitude = 0,
    ---@type number
    startingLatitude = 0,
    ---@type number
    longitude = 0,
    ---@type number
    latitude = 0,
    --- list of all enemies on the map
    ---@type enemy[]
    enemies = {},
    --- list of all markers on the map
    ---@type marker[]
    markers = {},
    --- list of all areas on the map
    ---@type area[]
    areas = {},
    --- get/set custom spawn distance for enemies
    --- property can be set
    ---@type number
    spawnDist = 0,
    --- get/set custom spawn altitude for enemies
    --- property can be set
    ---@type number
    spawnDir = 0,
    --- get/set custom spawn altitude for enemies
    --- property can be set
    ---@type boolean
    enableDist = false,
    --- get/set custom spawn altitude for enemies
    --- property can be set
    ---@type boolean
    enableDir = false,
}

--- initial bearing (forward azimuth) to said coordinates
---@param tarLat number 
---@param tarLon number 
---@param curLat nil | number (default: current) 
---@param curLon nil | number (default: current) 
---@return number
function _location.bearing (tarLat, tarLon, curLat, curLon)
    ---@type number
    local r; return r
end

--- haversine distance, without height, to said coordinates
---@param tarLat number 
---@param tarLon number 
---@param curLat nil | number (default: current) 
---@param curLon nil | number (default: current) 
---@return number
function _location.distance (tarLat, tarLon, curLat, curLon)
    ---@type number
    local r; return r
end

--- returns ASL height at specified coordinates
---@param lat number 
---@param lon number 
---@return number
function _location.heightAt (lat, lon)
    ---@type number
    local r; return r
end

--- creates enemy-like marker on specified coordinates
---@param lat number 
---@param lon number 
---@param alt number 
---@param name string text of said marker
---@param color nil | string | table (default: "blue") use HEX format (#0369CF)
---@param asl nil | boolean (default: false) whether altitude should be ASL or AGL
---@return marker
function _location.createMarker (lat, lon, alt, name, color, asl)
    ---@type marker
    local r; return r
end

---@param maxDistance nil | number (default: 200000,) 
---@param terrainOnly nil | boolean (default: false) 
---@return coord
function _location.underMouse (maxDistance, terrainOnly)
    ---@type coord
    local r; return r
end

---@param maxDistance nil | number (default: 10,) 
---@param snapToCollider nil | boolean (default: false) 
---@return coord
function _location.onCraft (maxDistance, snapToCollider)
    ---@type coord
    local r; return r
end

function _location.spawnDrone () end

function _location.spawnSam () end

function _location.spawnTank () end

function _location.spawnSamRadar () end

--- creates and returns empty gameObject at defined coordinates/alt
---@param lat number 
---@param lon number 
---@param alt nil | number (default: 0,) 
---@param asl nil | boolean (default: false) 
---@return gameObject
function _location.spawnEmpty (lat, lon, alt, asl)
    ---@type gameObject
    local r; return r
end

---@class inputProcessor
local _inputProcessor = {
    --- this value will decay to default value with some speed
    --- property can be set
    ---@type number
    value = 0,
    --- speed of value changing. doesn't affect setting value from Lua.
    --- property can be set
    ---@type number
    speed = 0,
    --- property can be set
    ---@type number
    default = 0,
    --- property can be set
    ---@type number
    min = 0,
    --- property can be set
    ---@type number
    max = 0,
    ---@type string
    title = "",
    ---@type nil | inputProcessor
    mirror = {},
}

--- settings related to script instance
---@class script
local _script = {
    --- whether current stage is initialisation
    ---@type boolean
    isInit = false,
    ---@type string
    scriptName = "",
    ---@type string
    intents = "",
    ---@type table
    env = {},
    ---@type boolean
    hasPart = false,
    ---@type number
    luaErrors = 0,
    ---@type string
    rootFolder = "",
    --- property can be set
    ---@type boolean
    logConsole = false,
    --- property can be set
    ---@type boolean
    logUi = false,
    --- property can be set
    ---@type nil | function
    onUpdate = nil,
    --- property can be set
    ---@type nil | function
    onDestroy = nil,
}

---@param msg any 
function _script.log (msg) end

---@param msg any 
function _script.warning (msg) end

---@param msg any 
function _script.error (msg) end

---@class coord
local _coord = {
    ---@type number
    latitude = 0,
    ---@type number
    longitude = 0,
    ---@type number
    asl = 0,
    ---@type number
    agl = 0,
    --- XYZ global coordinates relative to aircraft
    ---@type vec3 | table
    xyz = {},
    ---@type number
    x = 0,
    ---@type number
    y = 0,
    ---@type number
    z = 0,
}

--- requires `gameObjects` intent
---@class gameObject
local _gameObject = {
    --- property can be set
    ---@type string
    name = "",
    --- property can be set
    ---@type nil | gameObject
    parent = {},
    --- property can be set
    ---@type boolean
    enabled = false,
    ---@type gameObject[]
    children = {},
    --- property can be set
    ---@type vec3 | table
    scale = {},
    --- property can be set
    ---@type vec3 | table
    pos = {},
    --- property can be set
    ---@type vec3 | table
    rot = {},
    --- property can be set
    ---@type vec3 | table
    globalPos = {},
    --- property can be set
    ---@type vec3 | table
    globalRot = {},
    --- property can be set
    ---@type vec3 | table
    worldPos = {},
    --- property can be set
    ---@type vec3 | table
    worldRot = {},
    ---@type coord
    coordinates = {},
}

function _gameObject:destroy () end

---@class area
local _area = {
    --- requires `gameObjects` intent
    ---@type gameObject
    gameObject = {},
    ---@type number
    longitude = 0,
    ---@type number
    latitude = 0,
    ---@type coord
    coordinates = {},
    ---@type number
    asl = 0,
    ---@type number
    agl = 0,
    --- absolute (including height) distance to the area
    ---@type number
    distance = 0,
    ---@type number
    bearing = 0,
}

---@class signature
local _signature = {
    --- requires `gameObjects` intent
    ---@type nil | gameObject
    gameObject = {},
    ---@type coord
    coordinates = {},
    ---@type number
    speed = 0,
    ---@type nil | number[]
    rcs = {},
    ---@type vec3 | table
    extents = {},
    ---@type vec3 | table
    center = {},
    ---@type boolean
    hasHeat = false,
    ---@type boolean
    hasRadar = false,
    ---@type boolean
    hasRcs = false,
}

---@class canvas
local _canvas = {
    --- property can be set
    ---@type vec2 | table
    size = {},
    --- requires `gameObjects` intent
    ---@type gameObject
    gameObject = {},
}

---@class uiObject
local _uiObject = {
    --- property can be set
    ---@type vec2 | table
    size = {},
    --- property can be set
    ---@type vec3 | table
    scale = {},
    --- property can be set
    ---@type vec3 | table
    rotation = {},
    --- property can be set
    ---@type vec2 | table
    position = {},
    --- property can be set
    ---@type vec2 | table
    anchor = {},
    --- property can be set
    ---@type boolean
    hidden = false,
    --- property can be set
    ---@type number
    depth = 0,
    --- property can be set
    ---@type style
    style = {},
    --- property can be set
    ---@type nil | string
    text = "",
    --- property can be set
    ---@type nil | string
    image = "",
    --- property can be set
    ---@type boolean
    imageIsMask = false,
    ---@type nil | function
    onClick = nil,
    --- property can be set
    ---@type nil | number
    scrollbar = 0,
    --- property can be set
    ---@type nil | boolean
    checkbox = false,
    --- property can be set
    ---@type nil | string
    input = "",
    --- property can be set
    ---@type nil | number
    inputPosition = 0,
    --- property can be set
    ---@type nil | number
    inputLimit = 0,
    --- property can be set
    ---@type nil | string
    placeholder = "",
    --- requires `gameObjects` intent
    ---@type gameObject
    gameObject = {},
}

---@param text string 
function _uiObject:parse (text) end

---@param content uiObject 
---@param vertical nil | uiObject (default: nil) 
---@param horizontal nil | uiObject (default: nil) 
---@param movement nil | string | "'clamped'" | "'elastic'" | "'unrestricted'" (default: "clamped") 
function _uiObject:asScrollView (content, vertical, horizontal, movement) end

function _uiObject:destroy () end

---@class style
local _style = {
    --- property can be set
    ---@type string | table
    foreground = "",
    --- property can be set
    ---@type string | table
    background = "",
    --- property can be set
    ---@type boolean
    ["auto-height"] = false,
    --- property can be set
    ---@type boolean
    ["auto-width"] = false,
    --- property can be set
    ---@type string
    ["font-name"] = "",
    --- property can be set
    ---@type number
    ["font-size"] = 0,
    --- property can be set
    ---@type string | "'normal'" | "'bold'" | "'italic'" | "'underline'" | "'lowercase'" | "'uppercase'" | "'smallcaps'" | "'strikethrough'" | "'superscript'" | "'subscript'" | "'highlight'"
    ["font-style"] = "",
    --- property can be set
    ---@type string | "'left'" | "'center'" | "'right'" | "'justified'" | "'flush'" | "'geometry'"
    ["text-align-hor"] = "",
}

---@param value string 
function _style:set (value) end

--- requires `ui` intent
---@class ui
local _ui = {
    ---@type uiObject[]
    obj = {},
}

---@param name string 
---@param func function 
function _ui:register (name, func) end

---@param obj uiObject 
---@param table table 
---@param field string | "'position-x'" | "'position-y'" | "'hidden'" 
---@return simpleAnimation
function _ui:simpleAnimation (obj, table, field)
    ---@type simpleAnimation
    local r; return r
end

--- requires `ui` intent
---@class simpleAnimation
local _simpleAnimation = {
}

---@param forwards nil | boolean (default: true) 
function _simpleAnimation:play (forwards) end

function _simpleAnimation:stop () end

--- requires `ui` intent
---@class uiObj
local _uiObj = {
}

---@class fuelTank
local _fuelTank = {
    --- property can be set
    ---@type string
    title = "",
    --- property can be set
    ---@type number
    priority = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    capacity = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    dryMass = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    fuelMass = 0,
    --- property can be set
    ---@type fuel
    fuel = {},
    --- property can be set
    ---@type boolean
    closed = false,
    --- property can be set
    ---@type boolean
    disconnected = false,
}

---@class missile
local _missile = {
    ---@type boolean
    isLaunched = false,
    ---@type nil | seeker
    seeker = {},
    ---@type number
    speed = 0,
    ---@type number
    mach = 0,
    ---@type number
    g = 0,
    ---@type number
    longitude = 0,
    ---@type number
    latitude = 0,
    ---@type coord
    coordinates = {},
    ---@type number
    asl = 0,
    ---@type number
    agl = 0,
    ---@type nil | marker
    marker = {},
    ---@type part
    part = {},
    ---@type number
    stage = 0,
    ---@type number
    stageCount = 0,
}

---@param enemy enemy 
---@return vec3 | table
function _missile:canSee (enemy)
    ---@type vec3 | table
    local r; return r
end

function _missile:fire () end

---@class gearbox
local _gearbox = {
    ---@type inputProcessor
    clutch = {},
    ---@type number
    finalDrive = 0,
    --- property can be set
    ---@type number
    gear = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    gearRatio = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number[]
    gearRatios = {},
    ---@type number
    inputRpm = 0,
    ---@type number
    outputRpm = 0,
    ---@type number
    inputInertia = 0,
    ---@type number
    outputInertia = 0,
    --- parts connected to input nodes
    ---@type part[]
    inputs = {},
    --- parts connected to output nodes
    ---@type part[]
    outputs = {},
}

---@class turbine
local _turbine = {
    --- property can be set
    ---@type boolean
    fuelValve = false,
    --- property can be set
    ---@type boolean
    ignition = false,
    --- property can be set
    ---@type boolean
    starter = false,
    --- property can be set
    ---@type boolean
    bleedAir = false,
    ---@type number
    n1Rpm = 0,
    ---@type number
    n2Rpm = 0,
    ---@type number
    n3Rpm = 0,
    ---@type number
    n1Mach = 0,
    ---@type number
    n2Mach = 0,
    ---@type number
    n3Mach = 0,
    ---@type number
    compTemp = 0,
    ---@type number
    combTemp = 0,
}

---@class pistonEngine
local _pistonEngine = {
    --- property can be set
    ---@type number
    afr = 0,
    --- property can be set
    ---@type boolean
    ignition = false,
    ---@type number
    preIgnition = 0,
    ---@type number
    combustionEfficiency = 0,
    ---@type number
    power = 0,
    ---@type number
    torque = 0,
    ---@type number
    t2 = 0,
    ---@type number
    t3 = 0,
    ---@type number
    t4 = 0,
    ---@type number
    cylTemp = 0,
}

---@class speaker
local _speaker = {
    ---@type boolean
    isPlaying = false,
    ---@type string
    currentClip = "",
}

function _speaker:playOnce () end

function _speaker:clearClips () end

---@param wavPath string 
---@param clipName string 
function _speaker:addClip (wavPath, clipName) end

function _speaker:pause () end

function _speaker:stop () end

function _speaker:continue () end

---@param clipName string 
function _speaker:selectClip (clipName) end

---@class rocketPod
local _rocketPod = {
    ---@type number
    rocketsLeft = 0,
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type boolean
    infiniteRockets = false,
}

function _rocketPod:fire () end

---@class gun
local _gun = {
}

function _gun:fire () end

---@class drumMag
local _drumMag = {
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    ammo = 0,
}

---@class radar
local _radar = {
    ---@type nil | seeker
    seeker = {},
    --- property can be set
    ---@type boolean
    enabled = false,
    --- contains `signature`, `strength` and `track` for every visible signature
    ---@type table
    visible = {},
}

---@class rocketMotor
local _rocketMotor = {
    ---@type number
    stage = 0,
}

function _rocketMotor:fire () end

---@class warhead
local _warhead = {
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    explosiveMass = 0,
    ---@type number
    stage = 0,
}

function _warhead:explode () end

---@class irst
local _irst = {
    ---@type nil | seeker
    seeker = {},
    --- contains `signature` and `strength` for every visible signature
    ---@type table
    visible = {},
}

---@class seeker
local _seeker = {
    ---@type nil | signature
    target = {},
    ---@type number
    strength = 0,
}

---@class jammer
local _jammer = {
    --- property can be set
    ---@type boolean
    enabled = false,
    ---@type nil | vec2 | table[]
    bands = {},
}

---@param id number 
---@param enabled boolean 
function _jammer:setBand (id, enabled) end

---@class targetingPod
local _targetingPod = {
    ---@type nil | signature
    target = {},
    ---@type boolean
    locked = false,
    --- property can be set
    ---@type boolean
    enabled = false,
}

---@class dispenser
local _dispenser = {
    --- to set value:
    --- requires `cheats` intent
    --- property can be set
    ---@type number
    amount = 0,
}

function _dispenser:fire () end

function _dispenser:chaff () end

function _dispenser:flare () end

---@class battery
local _battery = {
    --- property can be set
    ---@type boolean
    enabled = false,
    --- property can be set
    ---@type number
    charge = 0,
    --- property can be set
    ---@type number
    capacity = 0,
}

---@class rwr
local _rwr = {
}

---@class fuelTank_config
local _fuelTank_config = {
    --- property can be set
    ---@type string
    title = "",
    --- property can be set
    ---@type number
    priority = 0,
    --- property can be set
    ---@type number
    capacity = 0,
    --- property can be set
    ---@type number
    dryMass = 0,
    --- property can be set
    ---@type number
    fuelMass = 0,
---@type fuel|string|number
    --- property can be set
    fuel = {},
    --- property can be set
    ---@type boolean
    closed = false,
}

---@class controls
local _controls = {
    --- can: get 
    ---@type number
    Pitch = 0,
    --- can: get 
    ---@type number
    Roll = 0,
    --- can: get 
    ---@type number
    Yaw = 0,
    --- can: get set
    ---@type number
    TrimPitch = 0,
    --- can: get set
    ---@type number
    TrimRoll = 0,
    --- can: get set
    ---@type number
    TrimYaw = 0,
    --- can: get set
    --- (0, 0.25, 0.5, 0.75, 1)
    ---@type number
    Flaps = 0,
    --- can: get 
    ---@type number
    Brake = 0,
    --- can: get set
    ---@type boolean
    ParkingBrake = false,
    --- can: get set
    ---@type number
    Throttle = 0,
    --- can: get set
    ---@type number
    Collective = 0,
    --- can: get set
    ---@type boolean
    LandingGear = false,
    --- can: get set
    ---@type boolean
    Lights = false,
    --- can: get 
    ---@type boolean
    IsUpsideDown = false,
    --- can: get 
    ---@type number
    Mass = 0,
    --- can: get 
    ---@type number
    IAS = 0,
    --- can: get 
    ---@type number
    MachAngle = 0,
    --- can: get 
    ---@type number
    LocalTimeSec = 0,
    --- can: get 
    ---@type string
    LocalTimeZone = "",
    --- can: get 
    ---@type string
    LocalTimeText = "",
    --- can: get 
    --- time in seconds from launch
    ---@type number
    Time = 0,
    --- can: get 
    --- time in seconds between frames
    ---@type number
    DeltaTime = 0,
    --- can: get 
    ---@type number
    Mach = 0,
    --- can: get 
    ---@type number
    ASL = 0,
    --- can: get 
    ---@type number
    AGL = 0,
    --- can: get 
    ---@type number
    Alpha = 0,
    --- can: get 
    ---@type number
    Slip = 0,
    --- can: get 
    ---@type number
    Bank = 0,
    --- can: get 
    ---@type number
    PitchAtt = 0,
    --- can: get 
    ---@type number
    Heading = 0,
    --- can: get 
    ---@type number
    Course = 0,
    --- can: get 
    ---@type number
    Climb = 0,
    --- can: get 
    ---@type number
    G = 0,
    --- can: get 
    ---@type number
    StaticPressure = 0,
    --- can: get 
    ---@type number
    DynamicPressure = 0,
    --- can: get 
    ---@type number
    StaticTemperature = 0,
    --- can: get 
    ---@type vec3 | table
    Acceleration = {},
    --- can: get 
    --- see: Acceleration
    ---@type number
    Acceleration_X = 0,
    --- can: get 
    --- see: Acceleration
    ---@type number
    Acceleration_Y = 0,
    --- can: get 
    --- see: Acceleration
    ---@type number
    Acceleration_Z = 0,
    --- can: get 
    ---@type vec3 | table
    AngularVel = {},
    --- can: get 
    --- see: AngularVel
    ---@type number
    AngularVel_X = 0,
    --- can: get 
    --- see: AngularVel
    ---@type number
    AngularVel_Y = 0,
    --- can: get 
    --- see: AngularVel
    ---@type number
    AngularVel_Z = 0,
    --- can: get 
    ---@type vec3 | table
    AngularAccel = {},
    --- can: get 
    --- see: AngularAccel
    ---@type number
    AngularAccel_X = 0,
    --- can: get 
    --- see: AngularAccel
    ---@type number
    AngularAccel_Y = 0,
    --- can: get 
    --- see: AngularAccel
    ---@type number
    AngularAccel_Z = 0,
    --- can: get 
    ---@type vec3 | table
    Airspeed = {},
    --- can: get 
    --- see: Airspeed
    ---@type number
    Airspeed_X = 0,
    --- can: get 
    --- see: Airspeed
    ---@type number
    Airspeed_Y = 0,
    --- can: get 
    --- see: Airspeed
    ---@type number
    Airspeed_Z = 0,
    --- can: get 
    ---@type vec3 | table
    Vel = {},
    --- can: get 
    --- see: Vel
    ---@type number
    Vel_X = 0,
    --- can: get 
    --- see: Vel
    ---@type number
    Vel_Y = 0,
    --- can: get 
    --- see: Vel
    ---@type number
    Vel_Z = 0,
    --- can: get 
    ---@type number
    Drag = 0,
    --- can: get 
    ---@type vec3 | table
    DragForce = {},
    --- can: get 
    --- see: DragForce
    ---@type number
    DragForce_X = 0,
    --- can: get 
    --- see: DragForce
    ---@type number
    DragForce_Y = 0,
    --- can: get 
    --- see: DragForce
    ---@type number
    DragForce_Z = 0,
    --- can: get 
    ---@type number
    Lift = 0,
    --- can: get 
    ---@type vec3 | table
    LiftForce = {},
    --- can: get 
    --- see: LiftForce
    ---@type number
    LiftForce_X = 0,
    --- can: get 
    --- see: LiftForce
    ---@type number
    LiftForce_Y = 0,
    --- can: get 
    --- see: LiftForce
    ---@type number
    LiftForce_Z = 0,
    --- can: get 
    ---@type number
    Thrust = 0,
    --- can: get 
    ---@type vec3 | table
    ThrustForce = {},
    --- can: get 
    --- see: ThrustForce
    ---@type number
    ThrustForce_X = 0,
    --- can: get 
    --- see: ThrustForce
    ---@type number
    ThrustForce_Y = 0,
    --- can: get 
    --- see: ThrustForce
    ---@type number
    ThrustForce_Z = 0,
    --- can: get set
    ---@type boolean
    ["fbw.Enabled"] = false,
    --- can: get set
    ---@type boolean
    ["fbw.UsePedal"] = false,
    --- can: get set
    ---@type number
    ["fbw.PitchGain"] = 0,
    --- can: get set
    ---@type number
    ["fbw.YawGain"] = 0,
    --- can: get set
    ---@type number
    ["fbw.RollGain"] = 0,
    --- can: get set
    ---@type number
    ["fbw.PitchDampRate"] = 0,
    --- can: get set
    ---@type number
    ["fbw.YawDampRate"] = 0,
    --- can: get set
    ---@type number
    ["fbw.RollDampRate"] = 0,
    --- can: get set
    ---@type number
    ["fbw.PitchPressureDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.YawPressureDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.RollPressureDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.AoaDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.GDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.SlipDamp"] = 0,
    --- can: get set
    ---@type number
    ["fbw.AoaLimitStart"] = 0,
    --- can: get set
    ---@type number
    ["fbw.AoaLimitFull"] = 0,
    --- can: get set
    ---@type number
    ["fbw.GLimitStart"] = 0,
    --- can: get set
    ---@type number
    ["fbw.GLimitFull"] = 0,
    --- can: get set
    ---@type number
    ["fbw.AutoLevelPitch"] = 0,
    --- can: get set
    ---@type number
    ["fbw.AutoLevelRoll"] = 0,
    --- can: get set
    ---@type number
    ["fbw.SpeedLimitStart"] = 0,
    --- can: get set
    ---@type number
    ["fbw.SpeedLimitFull"] = 0,
    --- can: get set
    ---@type number
    ["warn.OverG"] = 0,
    --- can: get set
    ---@type number
    ["warn.OverSpeed"] = 0,
    --- can: get set
    ---@type number
    ["warn.Stall"] = 0,
    --- can: get set
    ---@type number
    ["warn.LowFuel"] = 0,
    --- can: get set
    ---@type number
    ["warn.GroundProximity"] = 0,
    --- can: get 
    ---@type number
    hydraulic = 0,
    --- can: get 
    ---@type number
    bleedMass = 0,
    --- can: get 
    ---@type number
    bleedPressure = 0,
    --- can: get 
    ---@type number
    bleedTemperature = 0,
    --- can: get 
    ---@type number
    electricCapacity = 0,
    --- can: get 
    ---@type number
    electricCharge = 0,
    --- can: get 
    ---@type number
    electricDelta = 0,
    --- can: get 
    ---@type number
    fuelCapacity = 0,
    --- can: get 
    ---@type number
    fuelDuration = 0,
    --- can: get 
    ---@type number
    fuelFraction = 0,
    --- can: get 
    ---@type number
    fuelFlow = 0,
    --- can: get 
    ---@type number
    fuelMass = 0,
    --- can: get 
    ---@type fuel
    fuelType = {},
    --- can: get 
    ---@type number
    fuelCost = 0,
    --- can: get 
    ---@type number
    fuelBurnt = 0,
    --- can: get 
    ---@type nil | part
    selectedMissile = {},
    --- can: get 
    ---@type string
    lampVersion = "",
    --- can: get set
    ---@type boolean
    ["autopilot.Enabled"] = false,
    --- can: get set
    ---@type number
    ["autopilot.Altitude"] = 0,
    --- can: get set
    ---@type number
    ["autopilot.Heading"] = 0,
    --- can: get set
    ---@type string | "'Mach'" | "'IAS'" | "'TAS'"
    ["autopilot.SpeedUnit"] = "",
    --- can: get set
    ---@type number
    ["autopilot.Ias"] = 0,
    --- can: get set
    ---@type number
    ["autopilot.Tas"] = 0,
    --- can: get set
    ---@type number
    ["autopilot.Mach"] = 0,
    --- can: get set
    --- current mouse position in pixel coordinates
--- requires `ui` intent
    ---@type vec2 | table
    mousePos = {},
    --- can: get set
    --- see: mousePos
    ---@type number
    mousePos_X = 0,
    --- can: get set
    --- see: mousePos
    ---@type number
    mousePos_Y = 0,
    --- can: get 
--- requires `ui` intent
    ---@type vec2 | table
    mouseBounds = {},
    --- can: get 
    --- see: mouseBounds
    ---@type number
    mouseBounds_X = 0,
    --- can: get 
    --- see: mouseBounds
    ---@type number
    mouseBounds_Y = 0,
    --- can: get 
    ---@type boolean
    lmbPressed = false,
    --- can: get 
    ---@type boolean
    lmbTriggered = false,
    --- can: get 
    ---@type boolean
    rmbPressed = false,
    --- can: get 
    ---@type boolean
    rmbTriggered = false,
    --- can: get set
    ---@type string | "'Off'" | "'Bore'" | "'Search'" | "'Hmd'" | "'Tws'" | "'Stt'"
    radarMode = "",
    --- can: get 
    ---@type nil | gameObject
    mainCam = {},
}


