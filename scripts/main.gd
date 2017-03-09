
extends Node


func _ready():
	pass

#================================
func saveFile():
	var game_state
	var f = File.new()
	var err = f.open_encrypted_with_pass("user://savedata.bin", File.WRITE, OS.get_unique_ID())
	f.store_var(game_state)
	f.close()

func save():
	""""
    var savedict = {
        filename=get_filename(),
        parent=get_parent().get_path(),
        posx=get_pos().x, #Vector2 is not supported by json
        posy=get_pos().y,
        attack=attack,
        defense=defense,
        currenthealth=currenthealth,
        maxhealth=maxhealth,
        damage=damage,
        regen=regen,
        experience=experience,
        TNL=TNL,
        level=level,
        AttackGrowth=AttackGrowth,
        DefenseGrowth=DefenseGrowth,
        HealthGrowth=HealthGrowth,
        isalive=isalive,
        last_attack=last_attack
    }
    return savedict
	"""
	pass

func save_game():
	var savegame = File.new()
	savegame.open("user://savegame.save", File.WRITE)
	var savenodes = get_tree().get_nodes_in_group("Persist")

	for i in savenodes:
		var nodedata = i.save()
		savegame.store_line(nodedata.to_json())

	savegame.close()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load

	# We need to revert the game state so we're not cloning objects during loading.  This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
	var savenodes = get_tree().get_nodes_in_group("Persist")
	for i in savenodes:
		i.queue_free()
	
	# Load the file line by line and process that dictionary to restore the object it represents
	var currentline = {} # dict.parse_json() requires a declared dict.
	savegame.open("user://savegame.save", File.READ)
	while (!savegame.eof_reached()):
		currentline.parse_json(savegame.get_line())
		# First we need to create the object and add it to the tree and set its position.
		var newobject = load(currentline["filename"]).instance()
		get_node(currentline["parent"]).add_child(newobject)
		newobject.set_pos(Vector2(currentline["posx"],currentline["posy"]))
		# Now we set the remaining variables.
		
		for i in currentline.keys():
			if (i == "filename" or i == "parent" or i == "posx" or i == "posy"):
				continue
			
			newobject.set(i, currentline[i])
		
	savegame.close()

