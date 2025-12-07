#**************************************************************************#
#*  pawn_player.gd                                                        *#
#**************************************************************************#
#*                         This file is part of:                          *#
#*                     INTERACTIVE GRID GDExtension                       *#
#*         https://github.com/antoinecharruel/interactive_grid            *#
#**************************************************************************#
#* Copyright (c) 2025 Antoine Charruel.                                   *#
#*                                                                        *#
#* Permission is hereby granted, free of charge, to any person obtaining  *#
#* a copy of this software and associated documentation files (the        *#
#* "Software"), to deal in the Software without restriction, including    *#
#* without limitation the rights to use, copy, modify, merge, publish,    *#
#* distribute, sublicense, and/or sell copies of the Software, and to     *#
#* permit persons to whom the Software is furnished to do so, subject to  *#
#* the following conditions:                                              *#
#*                                                                        *#
#* The above copyright notice and this permission notice shall be         *#
#* included in all copies or substantial portions of the Software.        *#
#*                                                                        *#
#* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        *#
#* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     *#
#* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. *#
#* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   *#
#* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   *#
#* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      *#
#* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 *#
#**************************************************************************#

extends CharacterBody3D

@onready var interactive_grid_3d: InteractiveGrid3D = $"../InteractiveGrid3D"
@onready var animation_player: AnimationPlayer = $model/AnimationPlayer
@onready var player_pawn_collision_shape_3d: CollisionShape3D = $PlayerPawnCollisionShape3D
@onready var model: Node3D = $model
@onready var try_me: Control = $"../TryMe"

enum PawnMovementsStates{
	IDLE,
	WALKING,
	RUN
}

const SPEED:float = 5.0
const JUMP_VELOCITY:float = 4.5
const DISTANCE_THRESHOLD:float = 0.25
var _movement_state:int = PawnMovementsStates.IDLE
var _cells_traveled:int = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
	
	if self.velocity == Vector3.ZERO:
		if _movement_state != PawnMovementsStates.IDLE:
			_movement_state = PawnMovementsStates.IDLE
		else:
			animation_player.play("idle", 0.2)
	
func move_player_to(global_position: Vector3)-> void:
	var pawn_global_position:Vector3 = self.player_pawn_collision_shape_3d.global_position
	var target_global_position: Vector3 = Vector3(global_position.x, pawn_global_position.y, global_position.z)
	var direction:Vector3 = (target_global_position - pawn_global_position).normalized()
	var distance_to_target: float = pawn_global_position.distance_to(target_global_position)

	if distance_to_target <= DISTANCE_THRESHOLD:
		if _movement_state != PawnMovementsStates.IDLE:
			_movement_state = PawnMovementsStates.IDLE
	else:
		self.velocity = direction * SPEED

		if _movement_state != PawnMovementsStates.RUN:
			_movement_state = PawnMovementsStates.RUN
		else:
			animation_player.play("run", 0.2)

		var dir = (target_global_position - model.global_position)
		dir.y = 0
		dir = dir.normalized()

		var target_rot = atan2(-dir.x, -dir.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rot, 0.2)

		move_and_slide()
	
func move_player_along_path(path: PackedInt64Array)-> void:
	if not is_on_target_cell():
		move_towards_next_cell(path)
	
func move_towards_next_cell(path: PackedInt64Array)-> void:
	var cells_traveled: int = get_how_many_cells_traveled()
	
	if path.size() > 1 and cells_traveled < path.size():
		var next_cell_index: int = path[cells_traveled+1]
		var next_cell_global_position: Vector3 = interactive_grid_3d.get_cell_global_position(next_cell_index)
		
		move_player_to(next_cell_global_position)

		if self.global_position.distance_to(next_cell_global_position) <= DISTANCE_THRESHOLD:
			set_how_many_cells_traveled(cells_traveled + 1)
	else:
		target_cell_reached()
	
func target_cell_reached()-> void:
	self.velocity = Vector3.ZERO
	set_how_many_cells_traveled(0)
	
	if self.velocity == Vector3.ZERO:
		
		interactive_grid_3d.set_visible(true)
		interactive_grid_3d.center(self.player_pawn_collision_shape_3d.global_position)
		
		var pawn_current_cell_index: int = interactive_grid_3d.get_cell_index_from_global_position(self.player_pawn_collision_shape_3d.global_position)

		# To prevent the player from getting stuck.
		interactive_grid_3d.set_cell_walkable(pawn_current_cell_index, true)
		interactive_grid_3d.set_cell_reachable(pawn_current_cell_index, true)
		
		interactive_grid_3d.compute_unreachable_cells(pawn_current_cell_index)

		var neighbors: PackedInt64Array = interactive_grid_3d.get_neighbors(pawn_current_cell_index)
		
		for neighbor_index in neighbors:
			interactive_grid_3d.add_custom_cell_data(neighbor_index, "CFL_NEIGHBORS")
	
		interactive_grid_3d.add_custom_cell_data(pawn_current_cell_index, "CFL_PLAYER")
		interactive_grid_3d.update_custom_data()
		interactive_grid_3d.hide_distant_cells(pawn_current_cell_index, 6)
	
func is_on_target_cell()-> bool:
	var is_on_target: bool = false
	var target_cell: Vector3
	var selected_cells: Array = interactive_grid_3d.get_selected_cells()
	
	if selected_cells.size() > 0:
		target_cell = interactive_grid_3d.get_cell_global_position(selected_cells[0])
	
	if self.global_position.distance_to(target_cell) <= DISTANCE_THRESHOLD:
		is_on_target = true
	
	return is_on_target
	
func get_how_many_cells_traveled()-> int:
	return _cells_traveled
	
func set_how_many_cells_traveled(count:int)-> void:
	_cells_traveled = count
