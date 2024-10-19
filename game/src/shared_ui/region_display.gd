class_name RegionDisplay extends PanelContainer

@onready var region_name_label: Label = $MarginContainer/VBoxContainer/RegionName

var fade_tween: Tween

func _ready() -> void:
    Database.region_changed.connect(_on_region_changed)

func _on_region_changed(new_region: Region):
    if region_name_label.text != new_region.region_name:
        const duration: float = 1

        if modulate == Color.WHITE:
            if fade_tween != null and fade_tween.is_valid():
                fade_tween.kill()
            fade_tween = create_tween()
            fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, duration)
            fade_tween.tween_callback(_update_name_label_text.bind(new_region.region_name))
            fade_tween.tween_property(self, "modulate", Color.WHITE, duration)
        else:
            _update_name_label_text(new_region.region_name)

func _update_name_label_text(new_name: String):
    region_name_label.text = new_name
