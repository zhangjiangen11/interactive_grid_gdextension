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
	uint32_t flags{ 1 << 0 };
	godot::Color flags_color = godot::Color(1, 1, 1);

protected:
	static void _bind_methods();

public:
	CustomCellData();
	~CustomCellData();

	void set_custom_data_name(godot::String custom_data_name);
	void set_flags(uint32_t bitmask);
	void set_flags_color(const godot::Color &p_flags_color);

	godot::String get_custom_data_name() const;
	uint32_t get_flags() const;
	godot::Color get_flags_color() const;
};
