class_name RegionDisplay extends PanelContainer

@onready var region_name_label: Label = $MarginContainer/VBoxContainer/RegionName
@onready var region_info_container: Container = $MarginContainer/VBoxContainer/RegionInfoContainer
@onready var region_info_label: RichTextLabel = $MarginContainer/VBoxContainer/RegionInfoContainer/MarginContainer/RegionInfo

var fade_tween: Tween

func _ready() -> void:
    Database.region_changed.connect(func(region, _y): _on_region_changed(region))
    _update_region_information(Database.current_region)
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _on_region_changed(new_region: Region):
    if region_name_label.text != new_region.region_name:
        const duration: float = 1

        if modulate == Color.WHITE:
            if fade_tween != null and fade_tween.is_valid():
                fade_tween.kill()
            fade_tween = create_tween()
            fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, duration)
            fade_tween.tween_callback(_update_region_information.bind(new_region))
            fade_tween.tween_property(self, "modulate", Color.WHITE, duration)
        else:
            _update_region_information(new_region)

func _update_region_information(region: Region):
    region_name_label.text = region.region_name
    region_info_label.text = "Region Info:\n%s" % region.gameplay_description

func _on_mouse_entered():
    region_info_container.show()

func _on_mouse_exited():
    region_info_container.hide()
