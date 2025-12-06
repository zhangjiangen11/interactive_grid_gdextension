/*+===================================================================
File: custom_cell_data.h

Summary: // TODO

Last Modified: December 2, 2025

This file is part of the InteractiveGrid GDExtension Source Code.
Repository: https://github.com/antoinecharruel/interactive_grid

Version InteractiveGrid: 1.7.0
Version: Godot Engine v4.5.stable.steam - https://godotengine.org

Author: Antoine Charruel
===================================================================+*/

#pragma once

#include "common.h"

// Godot engine
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/core/class_db.hpp>

class CustomCellData : public godot::Resource {
private:
	GDCLASS(CustomCellData, Resource);

	godot::String custom_data_name = "";
	uint32_t layer_mask = 1;
	uint32_t collision_layer = 1;
	bool custom_color_enabled = false;
	godot::Color color = godot::Color(1, 1, 1);

protected:
	static void _bind_methods();

public:
	CustomCellData();
	~CustomCellData();

	void set_custom_data_name(godot::String p_name);
	godot::String get_custom_data_name() const;

	void set_layer_mask(const uint32_t p_layer_mask);
	uint32_t get_layer_mask() const;

	void set_collision_layer(uint32_t p_layer);
	uint32_t get_collision_layer() const;

	void set_color(const godot::Color &p_color);
	godot::Color get_color() const;

	void set_custom_color_enabled(bool p_enabled);
	bool get_custom_color_enabled() const;

	bool has_layers_in_mask(const uint32_t p_layer_mask) const;

	bool get_collision_layer_value(int p_layer_number) const;
};