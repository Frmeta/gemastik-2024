extends Node3D

func swap_mesh(is_big):
	if is_big:
		$PerangkapRec_Skeleton.visible=true
		$PerangkapSquare_Skeleton.visible = false
	else:
		$PerangkapRec_Skeleton.visible=false
		$PerangkapSquare_Skeleton.visible = true
