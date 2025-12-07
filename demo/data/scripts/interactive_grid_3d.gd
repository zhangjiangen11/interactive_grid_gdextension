#**************************************************************************#
#*  interactive_grid_3d.gd                                                *#
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

extends InteractiveGrid3D

@onready var pawn_player: CharacterBody3D = $"../PawnPlayer"
@onready var player_pawn_collision_shape_3d: CollisionShape3D = $"../PawnPlayer/PlayerPawnCollisionShape3D"
@onready var ray_cast_from_mouse: RayCast3D = $"../PawnPlayer/RayCastFromMouse"
@onready var try_me: Control = $"../TryMe"

var _is_grid_open: bool = false
var _path: PackedInt64Array = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if pawn_player == null: return
	
	# Highlight the cell under the mouse.
	if self.get_selected_cells().is_empty():
		self.highlight_on_hover(ray_cast_from_mouse.get_ray_intersection_position())
	else:
		var selected_cells: Array = self.get_selected_cells()
		var pawn_current_cell_index: int = self.get_cell_index_from_global_position(self.player_pawn_collision_shape_3d.global_position)
	
		_path = self.get_path(pawn_current_cell_index, selected_cells[0])
		
		pawn_player.move_player_along_path(_path)

func open_grid() -> void:
	if player_pawn_collision_shape_3d != null:
				pawn_player.move_player_along_path(_path)
				
				_is_grid_open = true
				try_me.visible = false

func _input(event) -> void:
	if event.is_action_pressed("open_grid") and not _is_grid_open:
		#  SPACE BAR: Open the grid.
		open_grid()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if pawn_player == null:
			return
			
		var ray_pos: Vector3 = ray_cast_from_mouse.get_ray_intersection_position()
		if ray_pos == null:
			return
			
		var selected_cells: Array = self.get_selected_cells()
		
		if selected_cells.size() < 1:
			# Retrieve the selected cells.
			var selected_cell: int = get_cell_index_from_global_position(ray_cast_from_mouse.get_ray_intersection_position())
			self.select_cell(selected_cell)
			
			# Select a cell.
			if self.get_selected_cells().is_empty():
				return
			
			var pawn_current_cell_index: int = self.get_cell_index_from_global_position(self.get_grid_center_global_position())
			self.set_cell_walkable(pawn_current_cell_index, true)
			
			# Retrieve the path.
			_path = self.get_path(pawn_current_cell_index, selected_cells[0]) # only the first one.
			print("Last selected cell:", self.get_latest_selected())
			print("Path:", _path)

			# Highlight the path.
			self.highlight_path(_path)

func _on_button_button_down() -> void:
	open_grid()
