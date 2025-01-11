class_name ServerCMD

var status_format = "\nPeer ID: %s\nPeer Address: %s\nPeer Port: %s"

func status(server: Server):
	var target = server.target
	return status_format % [server.peer.get_peer(target), 
							server.peer.get_peer_address(target), 
							server.peer.get_peer_port(target)]
