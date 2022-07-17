extends RigidBody2D

const player = preload("res://Resources/PlayerStats.tres")

func _enter_tree():
	$Hitbox.damage = player.damage
	$Hitbox.knockback_vector = Vector2(cos(rotation),sin(rotation))


func _on_Hitbox_body_entered(body):
	queue_free()
