extends Node

func carregar_dados_arquivo(player : CharacterBody2D) -> bool:
	var caminho_arquivo =  "res://data/characters/" + player.char_name + ".json"
	
	if not FileAccess.file_exists(caminho_arquivo):
		print("Erro ao acessar o arquivo do personagem '", player.char_name, "' não foi encontrado!")
		return false
	
	var file = FileAccess.open(caminho_arquivo, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	
	if json.parse(json_string) == OK:
		player.char_move_list[player.char_name] = json.data
		return true

	return false
