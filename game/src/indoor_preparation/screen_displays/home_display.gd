class_name HomeDisplay extends Control

signal view_applicants_button_pressed()

@onready var audio_manager: AudioManager = $AudioManager
@onready var main_contents: Control = $MainContents
@onready var barrier_name: Label = $MainContents/BarrierName
@onready var barrier_portrait: TextureRect = $MainContents/BarrierDetails/Image
@onready var weakness_icon: TextureRect = $MainContents/BarrierDetails/StatsContainer/WeaknessContainer/MarginContainer/HBoxContainer/WeaknessIcon
@onready var power_value: Label = $MainContents/BarrierDetails/StatsContainer/PowerContainer/MarginContainer/HBoxContainer2/PowerValue
@onready var view_applicants_button: Button = $MarginContainer/Button
@onready var home_actions_display: HomeActionsDisplay = $MainContents/PanelContainer/MarginContainer/HBoxContainer/HomeActionsDisplay
@onready var total_power_display: TotalPowerDisplay = $MainContents/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/TotalPowerDisplay

func _ready() -> void:
    view_applicants_button.pressed.connect(_propagate_applicants_button_pressed)
    visibility_changed.connect(_on_visibility_changed)

func refresh_crew_info():
    home_actions_display.refresh()
    total_power_display.refresh()
    
func set_barrier(barrier_data: BarrierData):
    if barrier_data != null:
        barrier_name.text = barrier_data.name
        barrier_portrait.texture = barrier_data.graphic
        weakness_icon.texture = Database.stat_type_to_icon[barrier_data.weakness_type]
        power_value.text = String.num_int64(barrier_data.cost_to_overcome)
        main_contents.show()
    else:
        main_contents.hide()

func _propagate_applicants_button_pressed():
    view_applicants_button_pressed.emit()

func _on_visibility_changed():
    if visible:
        home_actions_display.enable_all()
    else:
        home_actions_display.disable_all()

#region Descendant SFX: enabled button mouse entered

func _on_button_mouse_entered():
    if view_applicants_button.disabled:
        return

    audio_manager.on_enabled_button_mouse_entered()

#endregion Descendant SFX: enabled button mouse entered
