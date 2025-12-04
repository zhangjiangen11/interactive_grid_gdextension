#include "custom_cell_data.h"

void CustomCellData::set_custom_data_name(godot::String name) {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	custom_data_name = name;
}

void CustomCellData::set_flags(uint32_t bitmask) {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	flags = bitmask;
}

void CustomCellData::set_flags_color(const godot::Color &p_flags_color) {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	flags_color = p_flags_color;
}

godot::String CustomCellData::get_custom_data_name() const {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	return custom_data_name;
}

uint32_t CustomCellData::get_flags() const {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	return flags;
}

godot::Color CustomCellData::get_flags_color() const {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/
	return flags_color;
}

void CustomCellData::_bind_methods() {
	/*M+M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M+++M
  Summary: // TODO
  M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M---M-M*/

	godot::ClassDB::bind_method(godot::D_METHOD("set_custom_data_name"), &CustomCellData::set_custom_data_name);
	godot::ClassDB::bind_method(godot::D_METHOD("get_custom_data_name"), &CustomCellData::get_custom_data_name);

	godot::ClassDB::bind_method(godot::D_METHOD("set_flags", "bitmask"), &CustomCellData::set_flags);
	godot::ClassDB::bind_method(godot::D_METHOD("get_flags"), &CustomCellData::get_flags);

	godot::ClassDB::bind_method(godot::D_METHOD("set_flags_color"), &CustomCellData::set_flags_color);
	godot::ClassDB::bind_method(godot::D_METHOD("get_flags_color"), &CustomCellData::get_flags_color);

	ADD_PROPERTY(godot::PropertyInfo(godot::Variant::STRING, "custom_data_name"), "set_custom_data_name", "get_custom_data_name");
	ADD_PROPERTY(godot::PropertyInfo(godot::Variant::INT, "flags", godot::PROPERTY_HINT_LAYERS_3D_PHYSICS), "set_flags", "get_flags");
	ADD_PROPERTY(godot::PropertyInfo(godot::Variant::COLOR, "flags_color"), "set_flags_color", "get_flags_color");
}

CustomCellData::CustomCellData() {}

CustomCellData::~CustomCellData() {}