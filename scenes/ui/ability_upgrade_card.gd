extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel

var disable: bool = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	scale = Vector2.ZERO
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_gui_input(event: InputEvent):
	if disable:
		return
	if event.is_action_pressed("left_click"):
		select_card()


func play_discard():
	$AnimationPlayer.play("discard")


func select_card():
	disable = true
	$AnimationPlayer.play("selected")
	for other_cards in get_tree().get_nodes_in_group("upgrade_card"):
		if other_cards == self:
			continue
		other_cards.play_discard()
	await $AnimationPlayer.animation_finished
	selected.emit()


func on_mouse_entered():
	if disable:
		return
	$HoverAnimationPlayer.play("hover")
