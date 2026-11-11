extends "res://main.gd"

const DAILY_EVENTS := [
	{"title": "Klient VIP", "description": "Klient PC płaci premię za zlecenie.", "mode": "PC", "bonus": 2200},
	{"title": "Awaria centrum danych", "description": "Pilnie potrzebny serwer — za serwer dostaniesz premię.", "mode": "Serwer", "bonus": 3200},
	{"title": "Gamingowy weekend", "description": "Studio gier szuka mocnego komputera.", "mode": "PC", "bonus": 1800},
	{"title": "Kontrakt hostingowy", "description": "Firma hostingowa dopłaca za wykonanie zlecenia serwerowego.", "mode": "Serwer", "bonus": 2500},
	{"title": "Dzień bez dodatkowych zleceń", "description": "Spokojny dzień w warsztacie — skup się na zwykłym kontrakcie.", "mode": "Brak", "bonus": 0}
]

var daily_event: Dictionary = {}

func _ready() -> void:
	_roll_daily_event()
	super._ready()

func refresh_all() -> void:
	super.refresh_all()
	if is_instance_valid(contract_label) and not daily_event.is_empty():
		var event_text := "\n\nWYDARZENIE DNIA: %s\n%s" % [daily_event.title, daily_event.description]
		if int(daily_event.bonus) > 0:
			event_text += "\nPremia: %s zł za zlecenie: %s" % [_money(int(daily_event.bonus)), daily_event.mode]
		contract_label.text += event_text

func _assemble() -> void:
	var day_before := day
	var completed_mode := mode
	super._assemble()
	if day == day_before:
		return

	var bonus := 0
	if completed_mode == str(daily_event.get("mode", "Brak")):
		bonus = int(daily_event.get("bonus", 0))
	if bonus > 0:
		cash += bonus
		history.append("Wydarzenie „%s”: premia +%s zł" % [daily_event.title, _money(bonus)])
		status_label.text = "Zlecenie wykonane! Premia za wydarzenie „%s”: +%s zł." % [daily_event.title, _money(bonus)]
	else:
		status_label.text = "Zlecenie wykonane! Tym razem bez premii za wydarzenie dnia."

	_roll_daily_event()
	refresh_all()

func _roll_daily_event() -> void:
	daily_event = DAILY_EVENTS.pick_random()
