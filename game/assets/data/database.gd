# Defines variables shared across scenes with the correct data types.
extends Node

enum StatType {
    MIGHT,
    WIT,
    CHAOS,
}

const _initial_barriers_overcome_count : int = 0
const _initial_war_transport_health_maximum : int = 1000

var barriers_overcome_count : int
var current_barrier_cost_to_overcome_number : int
var war_transport_health_current : int
var war_transport_health_maximum : int

func _ready():
    reset_values()

func reset_values() -> void:
    set_barriers_overcome_count(_initial_barriers_overcome_count)
    set_war_transport_health_maximum(_initial_war_transport_health_maximum)

    set_war_transport_health_to_maximum()

func set_barriers_overcome_count(updated_count : int) -> void:
    barriers_overcome_count = updated_count

func set_current_barrier_cost_to_overcome_number(updated_number : int) -> void:
    current_barrier_cost_to_overcome_number = updated_number

func set_war_transport_health_current(updated_health : int) -> void:
    war_transport_health_current = updated_health

func set_war_transport_health_maximum(updated_health : int) -> void:
    war_transport_health_maximum = updated_health

func set_war_transport_health_to_maximum() -> void:
    set_war_transport_health_current(_initial_war_transport_health_maximum)
