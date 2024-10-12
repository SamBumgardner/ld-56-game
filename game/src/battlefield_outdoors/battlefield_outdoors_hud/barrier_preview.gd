class_name BarrierPreview extends PanelContainer

@onready var name_label: Label = $VB/NameContainer/MC/Name
@onready var power_value: Label = $VB/StatsContainer/VB/TotalPowerContainer/MarginContainer/VBoxContainer/TotalPowerValue
@onready var weakness_icon: TextureRect = $VB/StatsContainer/VB/HB/WeaknessContainer/MarginContainer/VBoxContainer/WeaknessIcon

func refresh():
    var barrier_data: BarrierData = Database.current_barrier_data
    name_label.text = barrier_data.name
    power_value.text = String.num_int64(barrier_data.cost_to_overcome)
    weakness_icon.texture = Database.stat_type_to_icon[barrier_data.weakness_type]
