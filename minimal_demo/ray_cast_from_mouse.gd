# =================================================================================================
# File: ray_cast_from_mouse.gd
#
# Summary: Script extending InteractiveGrid to handle player interaction with the grid.
#
# Node: RayCastFromMouse (RayCast3D).
#
# Last modified: December 01, 2025
#
# This file is part of the InteractiveGrid GDExtension Source Code.
# Repository: https://github.com/antoinecharruel/interactive_grid_gdextension
#
# Version InteractiveGrid: 1.7.1
# Godot Version: Godot Engine v4.5.stable.steam - https://godotengine.org
#
# Author: Antoine Charruel
# =================================================================================================

extends RayCast3D

@export var debug_sphere_ray_cast_: MeshInstance3D
@onready var camera_3d: Camera3D = $"../Pawn/Camera3D"

func _ready() -> void:

	# Create a sphere for raycast debugging.
	debug_sphere_ray_cast_ = MeshInstance3D.new()
	debug_sphere_ray_cast_.mesh = SphereMesh.new()
	var mat_target = StandardMaterial3D.new()
	mat_target.albedo_color = Color.GREEN
	debug_sphere_ray_cast_.material_override = mat_target
	debug_sphere_ray_cast_.scale = Vector3(0.3, 0.3, 0.3)
	add_child(debug_sphere_ray_cast_)
	
func _process(delta: float) -> void:

	# Position the debug sphere at the ray intersection point from the mouse.
	if(self):
		debug_sphere_ray_cast_.global_transform.origin = get_ray_intersection_position()
	
func get_ray_intersection_position() -> Vector3:

	var intersect_ray_position: Vector3 = Vector3.ZERO

	var mouse_pos:Vector2 = get_viewport().get_mouse_position()
	var ray_origin:Vector3 = camera_3d.project_ray_origin(mouse_pos)
	var ray_direction:Vector3 = camera_3d.project_ray_normal(mouse_pos)
	var ray_length:int = 2000
	
	# Position and orient the RayCast.
	self.global_position = ray_origin
	self.target_position = ray_direction * ray_length
	self.collide_with_areas = true
	
	self.collision_mask = 0 # Reset.
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(15, false) # Ignore this layer.
	
	var debug_sphere_raycast: MeshInstance3D

	self.force_raycast_update()
	
	# Force an immediate RayCast update.
	if self.is_colliding():
		var collider:Node3D = self.get_collider()
		
		intersect_ray_position = self.get_collision_point()
		#print("[GetRayIntersectionPosition] Collision detected at: ", intersect_ray_position)
		#print("[GetRayIntersectionPosition] Collision detected with: ", collider.name)
		
	return intersect_ray_position
