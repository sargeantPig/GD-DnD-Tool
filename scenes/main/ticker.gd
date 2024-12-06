class_name Ticker

var ticked: bool = true
var tick: float = 1
var ticker: float = 0

func _init(_tick: float):
	self.tick = _tick

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !ticked:
		ticker += delta
	if ticker >= tick:
		self.finish()
	pass

func start():
	ticked = false

func finish():
	ticked = true
	ticker = 0
