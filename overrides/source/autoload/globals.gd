extends "res://source/autoload/globals.gd"


## This is how I recommend overriding base game files if necessary.
## Add an override file, extend the base file,
## and use super to reuse as much base game code as possible!
func print_spell_report():
	super.print_spell_report()
	print("GET THE FUCK OUT OF MY PALACE")
