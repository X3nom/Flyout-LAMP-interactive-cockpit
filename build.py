#!/usr/bin/python
import subprocess, sys
from pathlib import Path
import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    "-d", "--dist",
    default=".",
    required=False,
    help="directory for bundled output script"
)
args = parser.parse_args()



SRC     = Path("src")
DIST    = Path(args.dist) # default . (here)
OUTPUT  = DIST / "InteractiveCockpit.lua"
ENTRY   = "src/main"

def discover_modules():
    modules = []
    for f in sorted(SRC.rglob("*.lua")):
        # Convert src/handlers/toggle.lua -> handlers.toggle
        rel = f.relative_to(SRC)
        mod = ".".join(rel.with_suffix("").parts)
        if mod != ENTRY:
            modules.append(mod)
    return modules

DIST.mkdir(exist_ok=True)
modules = discover_modules()


HEADER_STOP_SEQ = "--header-end--"
with open("./"+ENTRY+".lua", "r") as f:
    header_line_count = 0
    while HEADER_STOP_SEQ not in f.readline():
        header_line_count = header_line_count+1


# luacc required, installed using luarocks
cmd = ["luacc", "-p", str(header_line_count), "-i", str(SRC), "-o", str(OUTPUT), ENTRY] + modules
print("Bundling:", " ".join(cmd))

result = subprocess.run(cmd)

sys.exit(result.returncode)
