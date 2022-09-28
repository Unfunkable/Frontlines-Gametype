--== FRONTLINES VARIABLES ==--
declare global.number[0] with network priority high
declare global.number[1] with network priority low
declare global.number[2] with network priority low
declare global.number[3] with network priority low
declare global.number[4] with network priority low
declare global.object[0] with network priority low
declare global.object[1] with network priority local
declare global.object[3] with network priority low
declare global.object[4] with network priority low
declare global.object[5] with network priority low
declare global.number[5] with network priority local
declare global.number[6] with network priority low
declare global.number[7] with network priority local
declare global.number[8] with network priority local
declare global.timer[0] = 6
declare global.timer[1] = 720
declare global.team[0] with network priority low
declare global.player[0] with network priority low
declare global.player[1] with network priority low
declare object.timer[0] = script_option[3]
declare object.timer[1] = 3
declare object.timer[2] = 0
declare object.number[0] with network priority low
declare object.number[1] with network priority low
declare object.number[2] with network priority low
declare object.number[3] with network priority local
declare player.object[0] with network priority local
declare player.object[1] with network priority local
declare player.object[2] with network priority local
declare player.timer[0]
declare player.timer[1]

--== ANVIL EDITOR VARIABLES ==--
declare global.number[9] with network priority low
declare global.number[10] with network priority low
declare global.number[11] with network priority low
declare global.object[6] with network priority low
declare global.object[7] with network priority low
declare global.object[8] with network priority low
declare global.object[9] with network priority low
declare global.object[10] with network priority low
declare global.object[11] with network priority low
declare global.object[13] with network priority low
declare global.player[2] with network priority low
declare global.player[3] with network priority low
declare global.team[1] with network priority low
declare global.team[2] with network priority low
declare global.team[3] with network priority low
declare global.team[4] with network priority low
declare global.team[5] with network priority low
declare global.team[6] with network priority low
declare global.team[7] with network priority low
declare object.number[4] with network priority low
declare object.number[6] with network priority low
declare object.number[7] with network priority low
declare object.object[0] with network priority low
declare object.object[1] with network priority low
declare object.number[5] with network priority local
declare object.object[2] with network priority low 
declare object.object[3] with network priority local 
declare object.timer[3] = 3 
declare global.object[2] with network priority low 
declare global.object[12] with network priority local
declare global.object[14] with network priority local
declare global.object[15] with network priority low

alias phase = global.number[2]
alias phase_objective = global.number[3] -- 0 = both teams attacking, 1 = spartan team attacking, 2 = elite team attacking.
alias reds = object.number[0]
alias blues = object.number[1]
alias softkill = player.object[2]
alias capture_timer = object.timer[0]
alias music_timer = global.timer[0]
alias max_territories = global.number[4]
alias declared_sudden_death = global.number[5]
alias sudden_death_active = global.number[6]
alias temp_int = global.number[1]
alias primary_respawn = player.object[1]
alias temp_object = global.object[1]
alias danger_zone = object.object[0]
alias temp_team = global.team[0]
alias explosive = global.object[3]
alias bomb_carrier = global.player[0]
alias armed = object.number[0]
alias arm_timer = object.timer[1]
alias disarm_timer = object.timer[2]
alias class = object.number[0]
alias net_temp_object = global.object[4]
alias net_temp_object2 = global.object[5]
alias ability_timer = player.timer[0]
alias ability_cooldown = player.timer[1]
alias temp_player = global.player[1]

do
	global.timer[1].set_rate(-100%)
	if global.timer[1] == 360 and global.number[8] == 0 then
		for each player do 
			current_player.set_loadout_palette(elite_tier_2)
		end
		game.show_message_to(all_players, none, "Tier 2 loadouts available")
		global.number[8] = 1
	end
	if global.timer[1] == 359 and global.number[8] == 1 then
		global.number[8] = 0
	end
	if global.timer[1] == 0 and global.number[8] == 0 then
		for each player do
			current_player.set_loadout_palette(elite_tier_3)
		end
	game.show_message_to(all_players, none, "Tier 3 loadouts available")
	global.number[8] = 1
	end
	for each player do
		current_player.biped.set_spawn_location_permissions(mod_player, current_player, 0)
	end
end

function reset_timers()
	global.object[0].capture_timer.reset()
	global.object[0] = no_object
	game.round_timer.reset()
	game.round_timer.set_rate(-100%)
	game.sudden_death_timer.reset()
	game.sudden_death_timer.set_rate(0%)
	sudden_death_active = 0
	declared_sudden_death = 0
end

function add_spartan_lives()
	if script_option[4] != 0 or script_option[4] != -1 then 
		team[0].score += script_option[4]
	end
	if script_option[4] == -1 then
		for each object with label "s_lives_added" do
			if current_object.spawn_sequence != 0 then
				team[0].score += current_object.spawn_sequence
				team[0].score += 1
			end
		end
	end
end

function add_elite_lives()
	if script_option[4] != 0 or script_option[4] != -1 then 
		team[1].score += script_option[4]
	end
	if script_option[4] == -1 then
		for each object with label "s_lives_added" do
			if current_object.spawn_sequence != 0 then
				team[1].score += current_object.spawn_sequence
				team[1].score += 1
			end
		end
	end
end

function spartan_attack_success()
	reset_timers()
	global.object[0].danger_zone.delete()
	for each player do
		if current_player.team == team[0] then
			game.play_sound_for(current_player, announce_territories_captured, false)
			game.play_sound_for(current_player, announce_defense, false)
			current_player.set_round_card_text("Defense")
			current_player.set_round_card_title("Territory captured!\r\nPrepare for an enemy counter-attack.")
		end
		if current_player.team == team[1] then
			game.play_sound_for(current_player, announce_territories_lost, false)
			game.play_sound_for(current_player, announce_offense, false)
			current_player.set_round_card_text("Offense")
			current_player.set_round_card_title("Territory lost!\r\nRegain the enemy territory.")
		end
	end
	phase_objective = 2
	game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
	add_spartan_lives()
end


function spartan_defense_success()
	reset_timers()
	global.object[0].danger_zone.delete()
	for each player do
		if current_player.team == team[0] then
			game.play_sound_for(current_player, announce_offense, false)
			current_player.set_round_card_text("Offense")
			current_player.set_round_card_title("Defense successful!\r\nAttack the enemy territory.")
		end
		if current_player.team == team[1] then
			game.play_sound_for(current_player, announce_defense, false)
			current_player.set_round_card_text("Defense")
			current_player.set_round_card_title("Attack failed!\r\nPrepare for an enemy counter-attack.")
		end
	end
	phase_objective = 1
	if phase == max_territories then 
		game.play_sound_for(all_players, inv_cue_spartan_win_2, true)
	alt
		game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
	end
	add_spartan_lives()
end

function elite_attack_success()
	reset_timers()
	global.object[0].danger_zone.delete()
	for each player do
		if current_player.team == team[0] then
			game.play_sound_for(current_player, announce_territories_lost, false)
			game.play_sound_for(current_player, announce_offense, false)
			current_player.set_round_card_text("Offense")
			current_player.set_round_card_title("Territory lost!\r\nRegain the enemy territory.")
		end
		if current_player.team == team[1] then
			game.play_sound_for(current_player, announce_territories_captured, false)
			game.play_sound_for(current_player, announce_defense, false)
			current_player.set_round_card_text("Defense")
			current_player.set_round_card_title("Territory captured!\r\nPrepare for an enemy counterattack.")
		end
	end
	phase_objective = 1
	game.play_sound_for(all_players, inv_cue_covenant_win_1, true)
	add_elite_lives()
end

function elite_defense_success()
	reset_timers()
	global.object[0].danger_zone.delete()
	for each player do
		if current_player.team == team[0] then
			game.play_sound_for(current_player, announce_defense, false)
			current_player.set_round_card_text("Defense")
			current_player.set_round_card_title("Attack failed!\r\nPrepare for an enemy counter-attack.")
		end
		if current_player.team == team[1] then
			game.play_sound_for(current_player, announce_offense, false)
			current_player.set_round_card_text("Offense")
			current_player.set_round_card_title("Defense successful!\r\nAttack the enemy territory.")
		end
	end
	phase_objective = 2
	if phase == 1 then
		game.play_sound_for(all_players, inv_cue_covenant_win_2, true)
	alt
		game.play_sound_for(all_players, inv_cue_covenant_win_1, true)
	end
	add_elite_lives()
end	

function spartan_victory()
	temp_team = team[0]
	game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
	phase_objective = -1
	game.round_timer.set_rate(0%)
	music_timer.set_rate(-100%)
	team[1].score = 0
end

function elite_victory()
	temp_team = team[1]
	game.play_sound_for(all_players, inv_cue_covenant_win_big, true)
	phase_objective = -1
	game.round_timer.set_rate(0%)
	music_timer.set_rate(-100%)
	team[0].score = 0
end

function ticket_victory()
	for each player do
		if current_player.team == temp_team then
			current_player.set_round_card_text("Victory!")
			current_player.set_round_card_title("The enemy has run out of\r\nreinforcements and is forced to retreat.")
		end
		if current_player.team != temp_team then
			current_player.set_round_card_text("Defeat!")
			current_player.set_round_card_title("We have run out of reinforcements\r\n and are forced to retreat.")
		end
	end
end

function capture_victory()
	for each player do
		if current_player.team == temp_team then
			current_player.set_round_card_text("Victory!")
			current_player.set_round_card_title("We have captured the enemy HQ!")
		end
		if current_player.team != temp_team then
			current_player.set_round_card_text("Defeat!")
			current_player.set_round_card_title("Our HQ has been lost!")
		end
	end
end


function start_sudden_death()
	if declared_sudden_death == 0 then
		game.play_sound_for(all_players, announce_sudden_death, false)
		declared_sudden_death = 1
	end
	game.sudden_death_timer.set_rate(-100%)
	sudden_death_active = 1
end

-- ANVIL EDITOR
function anvil_trigger_0()
	current_object.detach()
	if current_object.number[5] == 0 then 
	   current_object.number[5] = current_object.spawn_sequence
	   if current_object.spawn_sequence < -10 then 
		  current_object.number[5] += 101
		  current_object.number[5] *= 2
		  if current_object.spawn_sequence > -71 then 
			 current_object.number[5] *= 2
			 if current_object.spawn_sequence > -41 then 
				current_object.number[5] *= 3
				current_object.number[5] /= 2
			 end
		  end
	   end
	   current_object.number[5] *= 10
	   current_object.number[5] += 100
	   if current_object.spawn_sequence < -10 then 
		  current_object.number[5] += 1000
		  if current_object.spawn_sequence > -71 then 
			 current_object.number[5] += -600
			 if current_object.spawn_sequence > -41 then 
				current_object.number[5] += -1200
			 end
		  end
	   end
	   if current_object.spawn_sequence == -10 then 
		  current_object.number[5] = 1
	   end
	   current_object.set_scale(current_object.number[5])
	   current_object.copy_rotation_from(current_object, false)
	   if current_object.object[2] != no_object then 
		  current_object.copy_rotation_from(current_object, true)
		  current_object.attach_to(current_object.object[2], 0, 0, 0, relative)
	   end
	   current_object.number[3] = 1
	end
 end

-- Init stuff
do 
	if global.number[0] == 0 then 
		phase = -1
		for each team do 
			if global.number[0] == 0 then
				if script_option[0] == -1 then
					for each object with label "s_lives" do 
						temp_int = current_object.spawn_sequence
						temp_int *= 10
						current_team.score = temp_int
					end
				altif script_option[0] == 1 then -- This block and the one below it are here because the script_option values cannot exceed 511.
					current_team.score = 750
				altif script_option[0] == 2 then
					current_team.score = 1000
				alt
				current_team.score = script_option[0]
				end
			end
			for each player do
				if current_player.team == team[0] then 
					current_player.set_round_card_text("Swords of Sanghelios")
					current_player.set_round_card_title("Capture territories to advance the frontline.")
				end
				if current_player.team == team[1] then 
					current_player.set_round_card_text("Covenant")
					current_player.set_round_card_title("Capture territories to advance the frontline.")
				end
			end
		end 
		for each object with label "frontline" do 
			max_territories += 1 
		end
		global.number[0] = 1
	end
end

-- Sudden death
do
	if sudden_death_active == 1 then 
		if game.sudden_death_timer.is_zero() then
			if phase_objective == 1 then
				global.object[0].danger_zone.delete()
				elite_defense_success()
			alt
				global.object[0].danger_zone.delete()
				spartan_defense_success()
			end
		end
		if phase_objective == 1 and global.object[0].reds == 0 then
			if script_option[3] != -1 and global.object[0].capture_timer == script_option[3] then 
				global.object[0].danger_zone.delete()
				elite_defense_success()
			end
			if script_option[3] == -1 and global.object[0].capture_timer == global.object[0].number[3] then
				global.object[0].danger_zone.delete()
				elite_defense_success()
			end
		end
		if phase_objective == 2 and global.object[0].blues == 0 then
			if script_option[3] != -1 and global.object[0].capture_timer == script_option[3] then 
				global.object[0].danger_zone.delete()
				spartan_defense_success()
			end
			if script_option[3] == -1 and global.object[0].capture_timer == global.object[0].number[3] then
				global.object[0].danger_zone.delete()
				spartan_defense_success()
			end
		end
	end
end

-- Assign loadouts depending on which team the player is on, and display the appropriate round title card.
for each player do
	if global.timer[1] > 360 then
		current_player.set_loadout_palette(elite_tier_1)
		current_player.set_round_card_icon(invasion)
	altif global.timer[1] > 0 then 
		current_player.set_loadout_palette(elite_tier_2)
	alt
		current_player.set_loadout_palette(elite_tier_3)
	end
end

-- Turns on coop spawning to allow respawning at territories.
for each team do
	current_team.set_co_op_spawning(true)
end

for each object with label "pregame" do 
	current_object.delete()
end

-- Determines who is attacking first if the option is set to "Map default"
	if phase == -1 then
		if script_option[1] == -1 then
			for each object with label "s_first_attack" do
				if current_object.spawn_sequence == 0 then 
					phase_objective = 0
				end
				if current_object.spawn_sequence == 1 then
					phase_objective = 1 
				end
				if current_object.spawn_sequence == 2 then 
					phase_objective = 2 
				end
			end
		end
		if script_option[1] == 0 then -- If "First Attack" is set to "Both"
			phase_objective = 0
		end
		if script_option[1] == 1 then -- If "First Attack" is set to "Spartans"
			phase_objective = 1 
		end
		if script_option[1] == 2 then -- If "First Attack" is set to "Elites"
			phase_objective = 2 
		end
	end


do 
	if phase == -1 then -- Determines what to do when the game starts
		if phase_objective == 0 then -- Neutral territory must be captured to determine who is attacking first.
			for each object with label "frontline" do 
				if current_object.team != team[0] and current_object.team != team[1] then
					send_incident(team_offense, all_players, all_players)
					phase = current_object.spawn_sequence
				end
			end
		end
		if phase_objective == 1 then -- Spartans are attacking first. Gets the elite territory closest to the frontline.
			phase = 511
			for each object with label "frontline" do 
				if current_object.spawn_sequence < phase and current_object.team == team[1] then 
					phase = current_object.spawn_sequence
				end
			end
		end
		if phase_objective == 2 then -- Elites are attacking first. Gets the spartan territory closest to the frontline.
			for each object with label "frontline" do
				if current_object.spawn_sequence > phase and current_object.team == team[0] then 
					phase = current_object.spawn_sequence
				end
			end
		end
	end
end

for each object with label "frontline" do
	if phase == current_object.spawn_sequence then -- Figures out what territory is being fought over, and displays a marker over it.
		global.object[0] = current_object
		global.object[0].set_waypoint_visibility(everyone)
		global.object[0].set_waypoint_icon(inward)
		current_object.set_waypoint_timer(object.capture_timer)
		global.object[0].reds = 0
		global.object[0].blues = 0
		if global.object[0].danger_zone == no_object then -- Sets up a danger zone that checks if enemies are near the frontline.
			global.object[0].danger_zone = global.object[0].place_at_me(hill_marker, none, never_garbage_collect, 0, 0, 0, default)
			temp_object = no_object
			temp_object = global.object[0].danger_zone
			temp_object.team = global.object[0].team
			temp_object.set_shape(cylinder, 150, 150, 150)
		end
		temp_object = no_object
		temp_object = global.object[0].danger_zone
		temp_object.reds = 0
		temp_object.blues = 0
		for each player do -- Counts the number of players from each side who are in the territory.
			if global.object[0].shape_contains(current_player.biped) then
				if current_player.team == team[0] then
					global.object[0].reds += 1
				end
				if current_player.team == team[1] then 
					global.object[0].blues += 1
				end
			end
			if temp_object.shape_contains(current_player.biped) then
				if current_player.team == team[0] then
					temp_object.reds += 1
				end
				if current_player.team == team[1] then
					temp_object.blues += 1
				end
			end
			--Determines if any enemies are near the frontline, and changes spawning permissions accordingly.
			if current_player.team != global.object[0].team then
				current_object.set_spawn_location_permissions(mod_player, current_player, 0)
			end
			if current_player.team == team[0] and global.object[0].team == team[0] and temp_object.blues < 1 then
				current_object.set_spawn_location_permissions(mod_player, current_player, 1)
			end
			if current_player.team == team[0] and global.object[0].team == team[0] and temp_object.blues > 0 then
				current_object.set_spawn_location_permissions(mod_player, current_player, 0)
			end
			if current_player.team == team[1] and global.object[0].team == team[1] and temp_object.reds < 1 then
				current_object.set_spawn_location_permissions(mod_player, current_player, 1)
			end
			if current_player.team == team[1] and global.object[0].team == team[1] and temp_object.reds > 0 then
				current_object.set_spawn_location_permissions(mod_player, current_player, 0)
			end
		end
	end
	if phase != current_object.spawn_sequence then
		current_object.set_waypoint_visibility(no_one) -- Makes sure any territories that are not being fought over don't have waypoints.
		for each player do
			if current_object.team == current_player.team and current_object.spawn_sequence != max_territories and current_object.spawn_sequence != 1 then -- If this territory isn't the final one (for either side), this allows the controlling team to spawn on it.
				current_object.set_spawn_location_permissions(mod_player, current_player, 1)
				temp_object = current_player.primary_respawn -- The following tries to set the default respawn point to the territory closest to the frontline.
				if current_object.spawn_sequence > temp_object.spawn_sequence and current_player.team == team[0] then
					current_player.primary_respawn = current_object
				end
				if current_object.spawn_sequence < temp_object.spawn_sequence and current_player.team == team[1] then
					current_player.primary_respawn = current_object
				end
			end
			if current_object.team != current_player.team then
				current_object.set_spawn_location_permissions(mod_player, current_player, 0)
			end
		end
	end
	for each player do
		if current_object == current_player.primary_respawn then
			current_player.set_primary_respawn_object(current_object)
		end
	end
end

-- Both teams will always be able to spawn at their HQ. This is so they have somewhere to spawn if their last territory is being attacked.
for each object with label "hq" do 
	for each player do
		if current_object.team == current_player.team then 
			current_object.set_spawn_location_permissions(mod_player, current_player, 1)
		alt
			current_object.set_spawn_location_permissions(mod_player, current_player, 0)
		end
	end
end

do
	if phase_objective == 0 then -- If both teams are attacking
		game.round_timer.set_rate(0%)
		if global.object[0].reds > global.object[0].blues then -- If there are more spartans than elites
			global.object[0].capture_timer.set_rate(-100%) 
			if global.object[0].timer[0].is_zero() then -- Initiates a Spartan victory
				global.object[0].team = team[0]
				global.object[0].timer[0].reset()
				global.object[0].danger_zone.delete()
				spartan_attack_success()
			end
		altif global.object[0].blues > global.object[0].reds then -- if there are more elites than spartans
			global.object[0].timer[0].set_rate(-100%)
			if global.object[0].timer[0].is_zero() then -- Initiates an Elite victory.
				global.object[0].team = team[1]
				global.object[0].danger_zone.delete()
				elite_attack_success()
			end
		altif global.object[0].timer[0] != script_option[3] then -- If no Spartan or Elites are in the territory, it will automatically regenerate up to 20.
			global.object[0].timer[0].set_rate(100%)
		alt
			global.object[0].timer[0].set_rate(0%)
		end
	end
	if phase_objective == 1 then -- If the spartans are attacking
		if global.object[0].reds > global.object[0].blues then --If there are more spartans than Elites, the capture timer will go down.
			temp_int = global.object[0].reds
			temp_int -= global.object[0].blues
			if script_option[5] == 0 and temp_int > 0 then
				global.object[0].timer[0].set_rate(-100%)
			end
			if script_option[5] == 1 then	
				if temp_int == 1 then
					global.object[0].timer[0].set_rate(-50%)
				end
				if temp_int == 2 then
					global.object[0].timer[0].set_rate(-75%)
				end
				if temp_int == 3 then
					global.object[0].timer[0].set_rate(-100%)
				end
				if temp_int == 4 then
					global.object[0].timer[0].set_rate(-125%)
				end
				if temp_int == 5 then
					global.object[0].timer[0].set_rate(-150%)
				end
				if temp_int == 6 then
					global.object[0].timer[0].set_rate(-175%)
				end
				if temp_int == 7 or temp_int == 8 then
					global.object[0].timer[0].set_rate(-200%)
				end
			end
			if global.object[0].timer[0].is_zero() then
				global.object[0].team = team[0]
				global.object[0].timer[0].reset()
				global.object[0].danger_zone.delete()
				if phase == max_territories then -- If this is the last territory, the game will end with a Spartan victory.
					spartan_victory()
					capture_victory()
				alt
					spartan_attack_success()
				end
			end
		altif global.object[0].blues > global.object[0].reds and global.object[0].timer[0] != script_option[3] then -- If there are more Elites than Spartans in the territory, the timer will regenerate up to the set amount.
			temp_int = global.object[0].blues
			temp_int -= global.object[0].reds
			if script_option[5] == 0 and temp_int > 0 then
				global.object[0].timer[0].set_rate(-100%)
			end
			if script_option[5] == 1 then
				if temp_int == 1 then
					global.object[0].timer[0].set_rate(50%)
				end
				if temp_int == 2 then
					global.object[0].timer[0].set_rate(75%)
				end
				if temp_int == 3 then
					global.object[0].timer[0].set_rate(100%)
				end
				if temp_int == 4 then
					global.object[0].timer[0].set_rate(125%)
				end
				if temp_int == 5 then
					global.object[0].timer[0].set_rate(150%)
				end
				if temp_int == 6 then
					global.object[0].timer[0].set_rate(175%)
				end
				if temp_int == 7 or temp_int == 8 then
					global.object[0].timer[0].set_rate(200%)
				end
			end
		alt 
			global.object[0].timer[0].set_rate(0%)
		end
		if game.round_time_limit > 0 and game.round_timer.is_zero() and global.object[0].reds <= 0 then -- If no Spartans are in the territory when the round timer ends then they will fail the attack.
			global.object[0].danger_zone.delete()
			global.object[0] = no_object
			phase -= 1
			elite_defense_success()
		end
		if game.round_time_limit > 0 and game.round_timer.is_zero() and global.object[0].reds > 0 then -- If the round timer reaches 0 but there is at least 1 Spartan in the territory, sudden death will start.
			start_sudden_death()
		end
		if global.object[0].reds > 0 then 
			global.object[0].set_waypoint_priority(blink)
		alt
			global.object[0].set_waypoint_priority(high)
		end
	end
	if phase_objective == 2 then -- If the elites are attacking
		if global.object[0].blues > global.object[0].reds then --If there are more elites than spartans
			temp_int = global.object[0].blues
			temp_int -= global.object[0].reds
			if temp_int == 1 then
				global.object[0].timer[0].set_rate(-50%)
			end
			if temp_int == 2 then
				global.object[0].timer[0].set_rate(-75%)
			end
			if temp_int == 3 then
				global.object[0].timer[0].set_rate(-100%)
			end
			if temp_int == 4 then
				global.object[0].timer[0].set_rate(-125%)
			end
			if temp_int == 5 then
				global.object[0].timer[0].set_rate(-150%)
			end
			if temp_int == 6 then
				global.object[0].timer[0].set_rate(-175%)
			end
			if temp_int == 7 or temp_int == 8 then
				global.object[0].timer[0].set_rate(-200%)
			end
			if global.object[0].timer[0].is_zero() then -- Initiates an Elite victory
				global.object[0].team = team[1]
				global.object[0].timer[0].reset()
				global.object[0].danger_zone.delete()
				if phase == 1 then -- If this is the last territory, the game will end with an Elite victory.
					elite_victory()
					capture_victory()
				alt
					elite_attack_success()
				end
			end
		altif global.object[0].reds > global.object[0].blues and global.object[0].timer[0] != script_option[3] then --If there are more Spartans than Elites in the territory, the timer will regenerate up to 20.
			temp_int = global.object[0].reds
			temp_int -= global.object[0].blues
			if temp_int == 1 then
				global.object[0].timer[0].set_rate(50%)
			end
			if temp_int == 2 then
				global.object[0].timer[0].set_rate(75%)
			end
			if temp_int == 3 then
				global.object[0].timer[0].set_rate(100%)
			end
			if temp_int == 4 then
				global.object[0].timer[0].set_rate(125%)
			end
			if temp_int == 5 then
				global.object[0].timer[0].set_rate(150%)
			end
			if temp_int == 6 then
				global.object[0].timer[0].set_rate(175%)
			end
			if temp_int == 7 or temp_int == 8 then
				global.object[0].timer[0].set_rate(200%)
			end
		alt 
			global.object[0].timer[0].set_rate(0%)
		end
		if game.round_time_limit > 0 and game.round_timer.is_zero() and global.object[0].blues <= 0 then -- If no elites are in the territory when the round timer ends then they will fail the attack.
			global.object[0].danger_zone.delete()
			global.object[0] = no_object
			phase += 1
			spartan_defense_success()
		end
		if game.round_time_limit > 0 and game.round_timer.is_zero() and global.object[0].blues > 0 then  -- If the round timer reaches 0 but there is at least 1 Elite in the territory, sudden death will start.
			start_sudden_death()
		end
		if global.object[0].blues > 0 then 
			global.object[0].set_waypoint_priority(blink)
		alt
			global.object[0].set_waypoint_priority(high)
		end
	end
end

-- Capture progress bar for people in the territory
for each player do
	if global.object[0].shape_contains(current_player.biped) then
		global.object[0].set_progress_bar(object.capture_timer, mod_player, current_player, 1)
	end
end

-- Depletes tickets if the game isn't over
for each player do 
	if current_player.killer_type_is(kill|guardians) and music_timer == 6 then
		if current_player.team == team[0] then 
			team[0].score -= 1 
		end
		if current_player.team == team[1] then
			team[1].score -= 1 
		end
	end
end

-- When tickets for a team are depleted, end the game, and have the other team win
do
	if team[0].score <= 0 and phase_objective != -1 and script_option[2] == 0 then
		elite_victory()
		ticket_victory()
	end
	if team[1].score <= 0 and phase_objective != -1 and script_option[2] == 0 then
		spartan_victory()
		ticket_victory()
	end
end

-- Ends the game after you get to hear the cool music 
do
	if music_timer.is_zero() then 
		game.end_round()
	end
end

--=== LOADOUT SYSTEM ===--

enum class
    none
    minor -- "Warrior". Tier 1 & 2. No special abilities.
    spec_ops -- Tier 1, 2 & 3 Permenant camo, no shields.
    major -- "Warden". Tier 2 & 3. Active ability that disables weapon overheat for self and nearby allies for a short time.
    ultra -- "Champion". Tier 3. Berserks when sheild drops, giving them an energy sword and infinite sprint.
    ranger -- Tier 3. Tag damanged enemies for a short time. Replaces minor.
    zealot -- Tier 3. Extra shield and speed. Instant shield & health regen on assassination. Immune to operator's sonar frags.
    guard -- Tier 1 & 2. No special abilities.
    corpsman -- Tier 1, 2 & 3. Passive ability that increases damage resistance for nearby allies.
    operator -- Tier 2 & 3. Grenade indicator and sonar frags.
    grenadier -- Tier 3. Can hold 4 frags and they regenerate over time. Replaces guard
    marksman -- Tier 3. Increased radar range
    juggernaut -- Tier 3. Can deploy machine gun anywhere.
end

function save_player_info()
    current_player.object[0] = current_player.try_get_weapon(primary)
    current_player.object[1] = current_player.try_get_weapon(secondary)
    current_player.biped.remove_weapon(primary, false)
    current_player.biped.remove_weapon(secondary, false)
    net_temp_object = current_player.biped
end

function apply_player_info()
    current_player.set_biped(net_temp_object2)
    net_temp_object.delete()
    current_player.biped.remove_weapon(primary, true)
    current_player.biped.remove_weapon(secondary, true)
    current_player.add_weapon(current_player.object[0])
    current_player.add_weapon(current_player.object[1])
end

-- Class detection
for each player do
    if current_player.is_elite() and current_player.biped != no_object then
        net_temp_object = current_player.biped
        if net_temp_object.class == class.none then
            net_temp_object = current_player.try_get_weapon(primary)
            if net_temp_object.is_of_type(plasma_rifle) then -- Check if they're an elite minor or major
                net_temp_object = current_player.try_get_armor_ability()
                if net_temp_object.is_of_type(evade) then -- minor
                    save_player_info()
                    net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, minor)
                    apply_player_info()
                    net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, evade, 0)
                    current_player.plasma_grenades = 1
                    current_player.frag_grenades = 0
                    net_temp_object2.class = class.minor
                end
                if net_temp_object.is_of_type(drop_shield) then -- major
                    save_player_info()
                    net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, officer)
                    apply_player_info()
                    net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, drop_shield, 0)
                    current_player.plasma_grenades = 1
                    current_player.frag_grenades = 0
                    net_temp_object2.class = class.major
                end
            end
            if net_temp_object.is_of_type(energy_sword) then -- Zealot
                save_player_info()
                net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, zealot)
                apply_player_info()
                net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, hologram, 0)
                current_player.plasma_grenades = 0
                current_player.frag_grenades = 0
                net_temp_object2.class = class.zealot
            end
            net_temp_object = current_player.try_get_armor_ability()
            if net_temp_object.is_of_type(active_camo_aa) then -- Spec ops
                save_player_info()
                net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, spec_ops)
                apply_player_info()
                net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, active_camo_aa, 0)
                current_player.plasma_grenades = 1
                current_player.frag_grenades = 0
                net_temp_object2.class = class.spec_ops
            end
            if net_temp_object.is_of_type(drop_shield) then -- Ultra
                save_player_info()
                net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, ultra)
                apply_player_info()
                net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, drop_shield, 0)
                current_player.plasma_grenades = 1
                current_player.frag_grenades = 0
                net_temp_object2.class = class.ultra
            end
            if net_temp_object.is_of_type(jetpack) then -- Ranger
                save_player_info()
                net_temp_object2 = current_player.biped.place_at_me(elite, none, none, 0, 0, 0, jetpack)
                apply_player_info()
                net_temp_object = net_temp_object2.place_between_me_and(net_temp_object2, jetpack, 0)
                current_player.plasma_grenades = 0
                current_player.frag_grenades = 0
                net_temp_object2.class = class.ranger
            end
        end
    end
    if not current_player.is_elite() then
        if current_player.biped != no_object then
            net_temp_object2 = current_player.biped
            if net_temp_object2.class == class.none then
                net_temp_object = current_player.try_get_weapon(primary)
                if net_temp_object.is_of_type(magnum) then
                    net_temp_object = current_player.try_get_armor_ability()
                    if net_temp_object.is_of_type(sprint) then
                        net_temp_object2.class = class.grenadier
                    alt
                        net_temp_object2.class = class.corpsman
                    end
                end
                if net_temp_object.is_of_type(dmr) then
                    net_temp_object2.class = class.marksman
                end
                if net_temp_object.is_of_type(detached_machine_gun_turret) then
                    net_temp_object2.class = class.juggernaut
                end
                net_temp_object = current_player.try_get_armor_ability()
                if net_temp_object.is_of_type(sprint) then
                    net_temp_object2.class = class.guard
                end
                if net_temp_object.is_of_type(hologram) then
                    net_temp_object2.class = class.operator
                end
            end
        end
    end     
end

-- Class abilities
for each player do 
    net_temp_object = current_player.biped
    if net_temp_object.class == class.minor then
        current_player.apply_traits(script_traits[0])
    end
    if net_temp_object.class == class.major then
        current_player.apply_traits(script_traits[1])
        if current_player.ability_cooldown > 0 then
            current_player.apply_traits(script_traits[11])
        end
        net_temp_object.set_shape(cylinder, 7, 7, 7)
        current_player.ability_cooldown.set_rate(-100%)
        net_temp_object2 = current_player.try_get_armor_ability()
        if net_temp_object2.is_in_use() then
            net_temp_object2.delete()
            net_temp_object2 = current_player.biped.place_between_me_and(current_player.biped, drop_shield, 0)
            if current_player.ability_cooldown == 0 then
                current_player.ability_timer = 7
                current_player.ability_timer.set_rate(-100%)
                current_player.ability_cooldown = 30
            end
        end
        net_temp_object2 = current_player.try_get_weapon(primary)
        if current_player.ability_timer > 0 then
            if net_temp_object2.is_of_type(plasma_rifle) or net_temp_object2.is_of_type(plasma_pistol) or net_temp_object2.is_of_type(detached_plasma_cannon) or net_temp_object.is_of_type(plasma_repeater) then
                current_player.apply_traits(script_traits[9])
                net_temp_object.set_shape_visibility(allies)
            end
        end
        if current_player.ability_timer == 0 then
            net_temp_object.set_shape_visibility(no_one)
        end
        temp_player = current_player
        for each player do
            net_temp_object2 = current_player.try_get_weapon(primary)
            if net_temp_object.shape_contains(current_player.biped) and temp_player.ability_timer > 0 then
                if net_temp_object2.is_of_type(plasma_rifle) or net_temp_object2.is_of_type(plasma_pistol) or net_temp_object2.is_of_type(detached_plasma_cannon) or net_temp_object.is_of_type(plasma_repeater) then
                    current_player.apply_traits(script_traits[9])
                end
            end
        end
    end
    if net_temp_object.class == class.spec_ops then
        current_player.apply_traits(script_traits[2])
    end
    if net_temp_object.class == class.ultra then
        current_player.apply_traits(script_traits[3])
        temp_int = net_temp_object.shields
        if temp_int == 0 then
            current_player.ability_timer = 10
            current_player.ability_timer.set_rate(-100%)
        end
        if current_player.ability_timer > 0 then
            current_player.apply_traits(script_traits[10])
            net_temp_object = current_player.try_get_weapon(primary)
            if not net_temp_object.is_of_type(energy_sword) then
                current_player.biped.remove_weapon(primary, false)
                current_player.biped.add_weapon(energy_sword, force)
            end
            net_temp_object = current_player.try_get_armor_ability()
            if not net_temp_object.is_of_type(sprint) then
                net_temp_object.delete()
                net_temp_object = current_player.biped.place_between_me_and(current_player.biped, sprint, 0)
            end
        end
        if current_player.ability_timer == 0 then
            net_temp_object = current_player.try_get_weapon(primary)
            if net_temp_object.is_of_type(energy_sword) then
                net_temp_object.delete()
            end
            net_temp_object = current_player.try_get_armor_ability()
            if net_temp_object.is_of_type(sprint) then
                net_temp_object.delete()
                net_temp_object = current_player.biped.place_between_me_and(current_player.biped, drop_shield, 0)
            end
        end
    end
    if net_temp_object.class == class.ranger then
        current_player.apply_traits(script_traits[4])
    end
    if net_temp_object.class == class.zealot then
        current_player.apply_traits(script_traits[5])
    end
    if net_temp_object.class == class.marksman then
        current_player.apply_traits(script_traits[7])
    end
    if net_temp_object.class == class.operator then
        current_player.apply_traits(script_traits[12])
    end
    if net_temp_object.class == class.corpsman then
        net_temp_object.set_shape(cylinder, 7, 7, 7)
        for each player do
            if net_temp_object.shape_contains(current_player.biped) then
                current_player.apply_traits(script_traits[13])
            end
        end
    end
    if net_temp_object.class == class.grenadier then
        current_player.apply_traits(script_traits[14])
    end
end

-- Anti-tryhard
if script_option[6] == 1 then
    net_temp_object = current_player.biped
    if net_temp_object.class != class.marksman then
        for each object do
            if current_object.is_of_type(dmr) then
                current_object.set_pickup_permissions(mod_player, current_player, 0)
            end
        end
    end
    if net_temp_object.class != class.ranger then
        for each object do
            if current_object.is_of_type(needle_rifle) then
                current_object.set_pickup_permissions(mod_player, current_player, 0)
            end
        end
    end
    if net_temp_object.class != class.zealot then
        for each object do
            if current_object.is_of_type(energy_sword) then
                current_object.set_pickup_permissions(mod_player, current_player, 0)
            end
        end
    end
end

-- Ability widgets
for each player do
    if current_player.ability_timer == 0 then
        script_widget[0].set_visibility(current_player, false)
        script_widget[1].set_visibility(current_player, false)
    end
    net_temp_object = current_player.biped
    if net_temp_object.class == class.major and current_player.ability_timer > 0 then
        script_widget[0].set_visibility(current_player, true)
        script_widget[0].set_text("OVERCHARGE %n", hud_player.ability_timer)
    end
    if net_temp_object.class == class.ultra and current_player.ability_timer > 0 then
        script_widget[1].set_visibility(current_player, true)
        script_widget[1].set_text("BERSERK %n", hud_player.ability_timer)
    end
end

--=== ANVIL EDITOR STUFF BELOW ===--
for each object with label "attach_base" do
    if current_object.spawn_sequence != 0 then 
       global.object[2] = no_object
       global.object[2] = current_object
       global.number[9] = current_object.spawn_sequence
       global.number[9] *= -1
       for each object with label "attachment" do
          if current_object.spawn_sequence != 0 and global.object[2].spawn_sequence == current_object.spawn_sequence or global.number[9] == current_object.spawn_sequence and current_object.number[4] == 0 then 
             if current_object.spawn_sequence < 0 then 
                global.object[2] = current_object
                for each object do
                   global.number[10] = current_object.get_distance_to(global.object[2])
                   global.player[3] = current_object.try_get_carrier()
                   if global.number[10] == 0 and global.player[3] == no_player and global.object[2] != current_object and not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) and not current_object.is_of_type(monitor) then 
                      current_object.detach()
                      current_object.attach_to(global.object[2], 0, 0, 5, relative)
                      if current_object.is_of_type(warthog_turret_rocket) or current_object.is_of_type(warthog_turret_gauss) or current_object.is_of_type(warthog_turret) or current_object.is_of_type(shade_gun_plasma) then 
                         current_object.object[0] = current_object.place_at_me(flag_stand, none, none, 0, 0, 0, none)
                         current_object.object[0].set_scale(1)
                         current_object.detach()
                         current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
                         current_object.object[0].attach_to(global.object[2], 0, 0, 5, relative)
                         global.object[2].object[0] = current_object
                         current_object.object[0].set_shape(box, 5, 5, 10, 0)
                      end
                   end
                end
                current_object.attach_to(global.object[2], 0, 0, 0, relative)
                current_object.number[4] = 1
                if current_object.spawn_sequence < -50 then 
                   current_object.set_scale(1)
                end
             end
             if current_object.spawn_sequence > 74 then 
                global.object[2] = current_object.place_at_me(flag_stand, none, none, 0, 0, 0, troop)
                global.object[2].set_scale(1)
                global.object[2].attach_to(global.object[2], 0, 0, 0, relative)
                current_object.attach_to(global.object[2], 0, 0, 0, relative)
                current_object.number[4] = 1
             end
             if current_object.spawn_sequence > 0 then 
                current_object.attach_to(global.object[2], 0, 0, 0, relative)
                current_object.number[4] = 1
             end
          end
       end
       for each object do
          if global.object[2].spawn_sequence < 0 then 
             global.object[2].set_shape_visibility(everyone)
             if global.object[2].team == current_object.team or global.object[2].team == neutral_team and global.object[2].shape_contains(current_object) and not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) and not current_object.is_of_type(monitor) then 
                current_object.attach_to(global.object[2], 0, 0, 0, relative)
             end
          end
       end
    end
 end

 for each object with label "spawner" do
    if current_object.object[0] == no_object then 
       current_object.number[3] = current_object.spawn_sequence
       if current_object.spawn_sequence == 1 then 
          current_object.object[0] = current_object.place_at_me(bomb, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 2 then 
          current_object.object[0] = current_object.place_at_me(covenant_bomb, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 3 then 
          current_object.object[0] = current_object.place_at_me(flag, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 4 then 
          current_object.object[0] = current_object.place_at_me(skull, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 5 then 
          current_object.object[0] = current_object.place_at_me(unsc_data_core, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 6 then 
          current_object.object[0] = current_object.place_at_me(covenant_power_core, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 7 then 
          current_object.object[0] = current_object.place_at_me(spartan, none, never_garbage_collect, 0, 0, 0, player_skull)
       end
       if current_object.spawn_sequence == 8 then 
          current_object.object[0] = current_object.place_at_me(elite, none, never_garbage_collect, 0, 0, 0, jetpack)
       end
       if current_object.spawn_sequence == 9 then 
          current_object.object[0] = current_object.place_at_me(pelican_scenery, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 10 then 
          current_object.object[0] = current_object.place_at_me(phantom_scenery, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 11 then 
          current_object.object[0] = current_object.place_at_me(warthog_turret, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 12 then 
          current_object.object[0] = current_object.place_at_me(warthog_turret_gauss, none, never_garbage_collect, 0, 0, 0, none)
          if current_object.team == team[1] and current_object.object[1] == no_object then 
             current_object.object[1] = current_object.place_at_me(flag_stand, none, never_garbage_collect, 0, 0, 0, none)
             current_object.object[2] = current_object.place_at_me(shade, none, never_garbage_collect, 0, 0, 0, none)
             current_object.object[2].set_shape(cylinder, 10, 10, 0)
             global.object[13] = current_object.object[2]
             for each object do
                if global.object[13].shape_contains(current_object) and current_object.is_of_type(shade_gun_plasma) then 
                   current_object.delete()
                end
             end
             current_object.object[2].set_scale(10)
             current_object.object[1].set_scale(1)
             current_object.object[2].attach_to(current_object.object[0], 0, 0, 0, relative)
             current_object.object[2].detach()
             current_object.object[1].attach_to(current_object.object[2], 0, 0, 0, relative)
             current_object.object[0].attach_to(current_object.object[1], 0, 0, 0, relative)
          end
       end
       if current_object.spawn_sequence == 13 then 
          current_object.object[0] = current_object.place_at_me(warthog_turret_rocket, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 14 then 
          current_object.object[0] = current_object.place_at_me(phantom, none, never_garbage_collect, 0, 0, 0, none)
          current_object.object[0].attach_to(current_object, 0, 0, 0, relative)
       end
       if current_object.spawn_sequence == 15 then 
          current_object.object[0] = current_object.place_at_me(longsword, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 16 then 
          current_object.object[0] = current_object.place_at_me(covenant_power_module_stand, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 17 then 
          current_object.object[0] = current_object.place_at_me(unsc_data_core_holder, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == 18 then 
          current_object.object[0] = current_object.place_at_me(longsword, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.spawn_sequence == -3 then 
          if current_object.team == team[1] then 
             set_scenario_interpolator_state(1, 1)
          end
          if current_object.team == team[3] then 
             set_scenario_interpolator_state(2, 1)
          end
          if current_object.team == team[5] then 
             set_scenario_interpolator_state(3, 1)
          end
          if current_object.team == team[7] then 
             set_scenario_interpolator_state(4, 1)
          end
       end
       if current_object.spawn_sequence == -4 then 
          current_object.set_waypoint_visibility(everyone)
          if current_object.team == team[1] then 
             set_scenario_interpolator_state(5, 1)
          end
          if current_object.team == team[3] then 
             set_scenario_interpolator_state(6, 1)
          end
          if current_object.team == team[5] then 
             set_scenario_interpolator_state(7, 1)
          end
          if current_object.team == team[7] then 
             set_scenario_interpolator_state(8, 1)
          end
       end
       current_object.object[0].copy_rotation_from(current_object, true)
       if current_object.team == team[0] and current_object.spawn_sequence != -5 then 
          current_object.object[0].attach_to(current_object, 0, 0, 0, relative)
       end
    end
    if current_object.spawn_sequence == -5 and current_object.object[0] == no_object then 
       if current_object.team != team[3] then 
          current_object.object[0] = current_object.place_at_me(heavy_barrier, none, never_garbage_collect, 0, 0, 0, none)
          if current_object.object[0] == no_object then 
             current_object.object[0] = current_object.place_at_me(warthog_turret, none, never_garbage_collect, 0, 0, 0, none)
          end
       end
       if current_object.team == team[3] then 
          current_object.object[0] = current_object.place_at_me(monitor, none, never_garbage_collect, 0, 0, 0, none)
       end
       current_object.object[0].set_invincibility(1)
       current_object.object[0].set_scale(50)
       current_object.object[0].attach_to(current_object, 0, 0, 0, relative)
       current_object.object[0].detach()
       current_object.object[0].copy_rotation_from(current_object, true)
       current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
       current_object.object[0].copy_rotation_from(current_object.object[0], false)
    end
    if current_object.spawn_sequence == -6 or current_object.spawn_sequence == -7 and current_object.number[2] == 0 then 
       global.object[7] = no_object
       global.object[7] = current_object
       for each object do
          global.number[10] = current_object.get_distance_to(global.object[7])
          if global.number[10] == 0 and global.object[7] != current_object then 
             if global.object[7].spawn_sequence == -7 then 
                current_object.delete()
             end
             if global.object[7].spawn_sequence == -6 then 
                current_object.attach_to(global.object[7], 0, 0, 0, relative)
             end
             global.object[7].number[2] = 1
          end
       end
    end
    if current_object.spawn_sequence == -8 or current_object.spawn_sequence == -9 then 
       global.object[12] = current_object
       for each object do
          if global.object[12].shape_contains(current_object) and global.object[12].team == current_object.team or global.object[12].team == neutral_team then 
             if global.object[12].spawn_sequence == -8 then 
                current_object.set_invincibility(1)
             end
             if global.object[12].spawn_sequence == -9 then 
                current_object.set_invincibility(0)
             end
          end
       end
    end
 end

 for each object with label "scale" do
    if current_object.number[3] == 0 then 
       if current_object.team == team[2] then 
          current_object.object[2] = current_object.place_at_me(heavy_barrier, none, never_garbage_collect, 0, 0, 0, none)
          if current_object.object[2] == no_object then 
             current_object.object[2] = current_object.place_at_me(warthog_turret, none, never_garbage_collect, 0, 0, 0, none)
          end
       end
       if current_object.team == team[3] then 
          current_object.object[2] = current_object.place_at_me(monitor, none, never_garbage_collect, 0, 0, 0, none)
       end
       if current_object.object[2] != no_object then 
          current_object.object[2].set_invincibility(1)
          current_object.object[2].set_scale(50)
          current_object.object[2].attach_to(current_object, 0, 0, 0, relative)
          current_object.object[2].detach()
          current_object.object[2].copy_rotation_from(current_object, false)
          current_object.attach_to(current_object.object[2], 0, 0, 0, relative)
       end
       anvil_trigger_0()
    end
 end

 on local: do
    for each object with label "object_by_index" do
       if current_object.timer[3].is_zero() then 
          current_object.object[3].detach()
          current_object.object[3].copy_rotation_from(current_object, true)
          current_object.timer[3].reset()
       end
       if current_object.object[3] == no_object then 
          current_object.timer[3].set_rate(-100%)
          global.number[11] = current_object.spawn_sequence
          global.number[11] += 100
          global.object[14] = no_object
          temp_int = 0
          for each object do
             if not current_object.is_of_type(monitor) and not current_object.is_of_type(flag_stand) and not current_object.is_of_type(kill_ball) and not current_object.is_of_type(elite) and not current_object.is_of_type(spartan) and not current_object.is_of_type(landmine) and not current_object.is_of_type(hill_marker) and not current_object.is_of_type(capture_plate) then 
                if temp_int == global.number[11] then 
                   global.object[14] = current_object
                end
                temp_int += 1
             end
          end
          current_object.object[3] = global.object[14]
          current_object.object[3].copy_rotation_from(current_object, true)
          current_object.object[3].attach_to(current_object, 0, 0, 0, relative)
       end
    end
    for each object with label "scale" do
       if current_object.number[3] == 0 then 
          if current_object.team == team[2] or current_object.team == team[3] and current_object.object[2] != no_object then 
             anvil_trigger_0()
             current_object.copy_rotation_from(current_object, true)
             current_object.attach_to(current_object.object[2], 0, 0, 0, relative)
          end
          if current_object.team != team[2] and current_object.team != team[3] then 
             anvil_trigger_0()
          end
       end
       if current_object.is_of_type(hill_marker) then 
          current_object.set_shape_visibility(everyone)
          if current_object.team == team[7] or current_object.team == team[5] then 
             current_object.number[5] = current_object.spawn_sequence
             if current_object.spawn_sequence == 0 then 
                current_object.number[5] = 100
             end
             if current_object.spawn_sequence < 0 then 
                current_object.number[5] *= -1
                current_object.number[5] += 100
             end
          end
          global.object[15] = current_object
          for each object do
             if global.object[15].team == current_object.team or global.object[15].team == neutral_team or global.object[15].team == team[5] or global.object[15].team == team[6] or global.object[15].team == team[7] and global.object[15].shape_contains(current_object) and global.object[15] != current_object and current_object.number[7] != 9999 then 
                current_object.set_scale(global.object[15].number[1])
                current_object.copy_rotation_from(current_object, false)
                if global.object[15].team == team[6] or global.object[15].team == team[7] then 
                   current_object.number[7] = 9999
                end
             end
          end
       end
    end
    for each object with label "spawner" do
       if current_object.spawn_sequence == -3 then 
          if current_object.team == team[1] then 
             set_scenario_interpolator_state(1, 1)
          end
          if current_object.team == team[3] then 
             set_scenario_interpolator_state(2, 1)
          end
          if current_object.team == team[5] then 
             set_scenario_interpolator_state(3, 1)
          end
          if current_object.team == team[7] then 
             set_scenario_interpolator_state(4, 1)
          end
       end
       if current_object.spawn_sequence == -4 then 
          current_object.set_waypoint_visibility(everyone)
          if current_object.team == team[1] then 
             set_scenario_interpolator_state(5, 1)
          end
          if current_object.team == team[3] then 
             set_scenario_interpolator_state(6, 1)
          end
          if current_object.team == team[5] then 
             set_scenario_interpolator_state(7, 1)
          end
          if current_object.team == team[7] then 
             set_scenario_interpolator_state(8, 1)
          end
       end
    end
 end