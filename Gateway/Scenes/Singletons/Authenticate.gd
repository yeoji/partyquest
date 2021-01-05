extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"

#EC2 Game Server
#var ip = "172.31.47.233"
var port = 1911

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect to authentication server")
	
func _OnConnectionSucceeded():
	print("Successfully connected to authentication server")
	
func AuthenticatePlayer(username, password, player_id):
	print("Sending authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, player_id)
	
remote func AuthenticationResults(result, player_id, token):
	print("auth results received and replying to player")
	Gateway.ReturnLoginRequest(result, player_id, token)

func RequestCharacterList(token, player_id):
	print("Requesting character list")
	rpc_id(1, "FetchPlayerCharacterList", token, player_id)
	
remote func CharacterListResults(char_list, player_id):
	print("Got character list")
	Gateway.ReturnCharacterListResults(char_list, player_id)

func CreateCharacter(char_name, char_sprite, token, player_id):
	print("Sending create character request")
	rpc_id(1, "CreateCharacter", char_name, char_sprite, token, player_id)
	
remote func CreateCharacterResults(result, player_id, message):
	print("Returning results of character create")
	Gateway.ReturnCreateCharacterRequest(result, player_id, message)

func CreateAccount(username, password, player_id):
	print("Sending create account request")
	rpc_id(1, "CreateAccount", username, password, player_id)

remote func CreateAccountResults(result, player_id, message):
	print("Results received and replying to player create account request")
	Gateway.ReturnCreateAccountRequest(result, player_id, message)
