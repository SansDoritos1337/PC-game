extends Control

const PARTS = [
	{"id":"r5_7600", "name":"AMD Ryzen 5 7600", "category":"CPU", "price":899, "socket":"AM5", "power":65, "score":72, "detail":"6 rdzeni / 12 wątków · AM5"},
	{"id":"i5_14400f", "name":"Intel Core i5-14400F", "category":"CPU", "price":999, "socket":"LGA1700", "power":65, "score":78, "detail":"10 rdzeni (6P+4E) · LGA1700"},
	{"id":"r7_7800x3d", "name":"AMD Ryzen 7 7800X3D", "category":"CPU", "price":1699, "socket":"AM5", "power":120, "score":96, "detail":"8 rdzeni / 16 wątków · AM5"},
	{"id":"xeon_e2436", "name":"Intel Xeon E-2436", "category":"CPU", "price":2299, "socket":"LGA1700", "power":80, "score":90, "detail":"6 rdzeni / 12 wątków · ECC · LGA1700"},
	{"id":"b650", "name":"MSI PRO B650M-A WiFi", "category":"Płyta główna", "price":699, "socket":"AM5", "form":"mATX", "detail":"AM5 · DDR5 · mATX"},
	{"id":"b760", "name":"ASUS TUF GAMING B760-PLUS", "category":"Płyta główna", "price":849, "socket":"LGA1700", "form":"ATX", "detail":"LGA1700 · DDR5 · ATX"},
	{"id":"server_board", "name":"ASRock Rack W680D4U", "category":"Płyta główna", "price":1899, "socket":"LGA1700", "form":"mATX", "detail":"LGA1700 · ECC · IPMI · mATX"},
	{"id":"ram16", "name":"Kingston Fury Beast 16 GB", "category":"RAM", "price":229, "ram":16, "detail":"DDR5 · 2 × 8 GB"},
	{"id":"ram32", "name":"Kingston Fury Beast 32 GB", "category":"RAM", "price":399, "ram":32, "detail":"DDR5 · 2 × 16 GB"},
	{"id":"ram64ecc", "name":"Kingston Server Premier 64 GB ECC", "category":"RAM", "price":999, "ram":64, "detail":"DDR5 ECC · 2 × 32 GB"},
	{"id":"rtx4060", "name":"MSI GeForce RTX 4060 Ventus 2X", "category":"Karta graficzna", "price":1499, "gpu":65, "power":115, "detail":"8 GB GDDR6 · 115 W"},
	{"id":"rtx4070s", "name":"Gigabyte GeForce RTX 4070 SUPER", "category":"Karta graficzna", "price":2899, "gpu":92, "power":220, "detail":"12 GB GDDR6X · 220 W"},
	{"id":"ssd1tb", "name":"Samsung 990 EVO 1 TB", "category":"Dysk", "price":399, "storage":1000, "detail":"NVMe M.2 · 1 TB"},
	{"id":"ssd2tb", "name":"WD Black SN850X 2 TB", "category":"Dysk", "price":699, "storage":2000, "detail":"NVMe M.2 · 2 TB"},
	{"id":"enterprise4tb", "name":"Seagate IronWolf Pro 4 TB", "category":"Dysk", "price":899, "storage":4000, "detail":"HDD · 7200 rpm · 4 TB"},
	{"id":"psu650", "name":"be quiet! Pure Power 12 M 650 W", "category":"Zasilacz", "price":449, "watts":650, "detail":"650 W · 80+ Gold · modularny"},
	{"id":"psu850", "name":"Corsair RM850e 850 W", "category":"Zasilacz", "price":599, "watts":850, "detail":"850 W · 80+ Gold · modularny"},
	{"id":"psu1000", "name":"Seasonic Focus GX-1000", "category":"Zasilacz", "price":899, "watts":1000, "detail":"1000 W · 80+ Gold · modularny"},
	{"id":"case_mini", "name":"Fractal Design Pop Mini Air", "category":"Obudowa", "price":399, "form":"mATX", "detail":"mATX · przewiewny front"},
	{"id":"case_atx", "name":"be quiet! Pure Base 500DX", "category":"Obudowa", "price":499, "form":"ATX", "detail":"ATX / mATX · 3 wentylatory"},
	{"id":"rack", "name":"Chenbro RM14300 4U", "category":"Obudowa", "price":1599, "form":"mATX", "detail":"Obudowa rack 4U · mATX"}
]

const SLOTS = ["CPU", "Płyta główna", "RAM", "Karta graficzna", "Dysk", "Zasilacz", "Obudowa"]
const REQUIRED = ["CPU", "Płyta główna", "RAM", "Dysk", "Zasilacz", "Obudowa"]
const CATEGORIES = ["Wszystkie", "CPU", "Płyta główna", "RAM", "Karta graficzna", "Dysk", "Zasilacz", "Obudowa"]
const INK = Color("#e8eef8")
const MUTED = Color("#98a8bf")
const PANEL = Color("#101a2a")
const ACCENT = Color("#48dfb0")

var cash := 18000
var inventory: Dictionary = {}
var slot_choices: Dictionary = {}
var slot_menus: Dictionary = {}
var market_box: VBoxContainer
var stock_box: VBoxContainer
var status_label: Label
var cash_label: Label
var contract_label: Label
var filter_category := "Wszystkie"
var selected_market_id := ""
var mode := "PC"
var day := 1
var history: Array[String] = ["Witaj w warsztacie! Zrealizuj pierwsze zlecenie."]

func _ready() -> void:
	build_interface()
	refresh_all()

func build_interface() -> void:
	var background := ColorRect.new()
	background.color = Color("#090f19")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var page := VBoxContainer.new()
	page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("separation", 14)
	page.add_theme_constant_override("margin_left", 28)
	page.add_theme_constant_override("margin_right", 28)
	page.add_theme_constant_override("margin_top", 22)
	page.add_theme_constant_override("margin_bottom", 22)
	add_child(page)

	var header := HBoxContainer.new()
	page.add_child(header)
	var title_stack := VBoxContainer.new()
	header.add_child(title_stack)
	var title := make_label("BYTEWORKS  /  WARSZTAT", 27, INK)
	title_stack.add_child(title)
	title_stack.add_child(make_label("SKŁADAJ KOMPUTERY. URUCHAMIAJ SERWERY. ZARABIAJ.", 11, MUTED))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	var day_label := make_label("DZIEŃ  %d" % day, 13, MUTED)
	header.add_child(day_label)
	cash_label = make_label("", 22, ACCENT)
	cash_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(cash_label)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	page.add_child(body)
	var left := make_panel()
	left.custom_minimum_size.x = 390
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(left)
	var right := make_panel()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(right)

	left.add_child(make_label("01  /  ZLECENIE", 13, ACCENT))
	contract_label = make_label("", 14, INK)
	contract_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	left.add_child(contract_label)
	var shop_header := HBoxContainer.new()
	shop_header.add_child(make_label("02  /  SKLEP Z CZĘŚCIAMI", 13, ACCENT))
	var shop_spacer := Control.new()
	shop_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shop_header.add_child(shop_spacer)
	left.add_child(shop_header)
	var filters := HFlowContainer.new()
	filters.add_theme_constant_override("h_separation", 5)
	filters.add_theme_constant_override("v_separation", 5)
	left.add_child(filters)
	for category in CATEGORIES:
		var button := Button.new()
		button.text = category
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_on_filter.bind(category))
		filters.add_child(button)
	var market_scroll := ScrollContainer.new()
	market_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	market_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left.add_child(market_scroll)
	market_box = VBoxContainer.new()
	market_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	market_box.add_theme_constant_override("separation", 7)
	market_scroll.add_child(market_box)

	right.add_child(make_label("03  /  STANOWISKO MONTAŻOWE", 13, ACCENT))
	var modes := HBoxContainer.new()
	right.add_child(modes)
	var pc_button := Button.new()
	pc_button.text = "Zlecenie: komputer PC"
	pc_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pc_button.pressed.connect(_set_mode.bind("PC"))
	modes.add_child(pc_button)
	var server_button := Button.new()
	server_button.text = "Zlecenie: serwer"
	server_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	server_button.pressed.connect(_set_mode.bind("Serwer"))
	modes.add_child(server_button)
	var info := make_label("Wybierz elementy ze swojego magazynu. Zgodność gniazda, obudowy i mocy sprawdzimy przy montażu.", 12, MUTED)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(info)
	var assembly_scroll := ScrollContainer.new()
	assembly_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	assembly_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right.add_child(assembly_scroll)
	var assembly := VBoxContainer.new()
	assembly.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	assembly.add_theme_constant_override("separation", 9)
	assembly_scroll.add_child(assembly)
	for slot in SLOTS:
		var row := HBoxContainer.new()
		row.add_child(make_label(slot, 13, INK))
		var fill := Control.new()
		fill.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(fill)
		var menu := OptionButton.new()
		menu.custom_minimum_size.x = 330
		menu.item_selected.connect(_on_slot_selected.bind(slot))
		row.add_child(menu)
		assembly.add_child(row)
		slot_menus[slot] = menu
	var build_button := Button.new()
	build_button.text = "⚙   ZMONTUJ I ODDAJ ZLECENIE"
	build_button.custom_minimum_size.y = 48
	build_button.add_theme_font_size_override("font_size", 15)
	build_button.pressed.connect(_assemble)
	assembly.add_child(build_button)
	status_label = make_label("", 13, MUTED)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	assembly.add_child(status_label)

	var footer := HBoxContainer.new()
	page.add_child(footer)
	footer.add_child(make_label("DZIENNIK WARSZTATU", 11, ACCENT))
	var log_spacer := Control.new()
	log_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(log_spacer)
	var log_label := make_label("", 11, MUTED)
	log_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.add_child(log_label)
	set_meta("day_label", day_label)
	set_meta("log_label", log_label)

func make_panel() -> VBoxContainer:
	var panel := VBoxContainer.new()
	panel.add_theme_constant_override("separation", 10)
	panel.add_theme_constant_override("margin_left", 16)
	panel.add_theme_constant_override("margin_right", 16)
	panel.add_theme_constant_override("margin_top", 16)
	panel.add_theme_constant_override("margin_bottom", 16)
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL
	style.set_corner_radius_all(10)
	style.set_border_width_all(1)
	style.border_color = Color("#1c2a3e")
	panel.add_theme_stylebox_override("panel", style)
	var shell := PanelContainer.new()
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.add_theme_stylebox_override("panel", style)
	shell.add_child(panel)
	return _wrap_panel(panel, shell)

func _wrap_panel(panel: VBoxContainer, shell: PanelContainer) -> VBoxContainer:
	panel.set_meta("panel_shell", shell)
	return panel

func make_label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func refresh_all() -> void:
	cash_label.text = "%s zł" % _money(cash)
	var target := "16 GB RAM · SSD 1 TB · karta graficzna" if mode == "PC" else "64 GB RAM · 4 TB danych · pamięć ECC"
	var reward := 9500 if mode == "PC" else 14500
	contract_label.text = "%s\n\nKlient: %s\nWymagania: %s\n\nWypłata: %s zł\n\nKup części w sklepie, wybierz je na stanowisku i złóż zestaw." % ["ZLECENIE #%03d" % day, "Studio gier" if mode == "PC" else "Mała firma", target, _money(reward)]
	_refresh_market()
	_refresh_slots()
	get_meta("day_label").text = "DZIEŃ  %d" % day
	get_meta("log_label").text = "   ·   ".join(history.slice(maxi(0, history.size() - 3), history.size()))

func _refresh_market() -> void:
	for child in market_box.get_children():
		child.queue_free()
	for part in PARTS:
		if filter_category != "Wszystkie" and part.category != filter_category:
			continue
		var button := Button.new()
		button.custom_minimum_size.y = 54
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var count: int = inventory.get(part.id, 0)
		button.text = "%s   ·   %s zł%s\n%s" % [part.name, _money(part.price), "   [w magazynie: %d]" % count if count > 0 else "", part.detail]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_buy_part.bind(part.id))
		market_box.add_child(button)

func _refresh_slots() -> void:
	for slot in SLOTS:
		var menu: OptionButton = slot_menus[slot]
		menu.clear()
		var optional_gpu := slot == "Karta graficzna" and mode == "Serwer"
		menu.add_item("— pomiń —" if optional_gpu else "— wybierz część —")
		menu.set_item_metadata(0, "")
		var choices: Array[String] = []
		for part in PARTS:
			if part.category == slot and int(inventory.get(part.id, 0)) > 0:
				choices.append(part.id)
		for part_id in choices:
			var part: Dictionary = _part_by_id(part_id)
			menu.add_item("%s  (x%d)" % [part.name, inventory[part_id]])
			menu.set_item_metadata(menu.item_count - 1, part_id)
		var selected_id: String = slot_choices.get(slot, "")
		for i in range(menu.item_count):
			if str(menu.get_item_metadata(i)) == selected_id:
				menu.select(i)
				break
		if selected_id != "" and not choices.has(selected_id):
			slot_choices[slot] = ""

func _on_filter(category: String) -> void:
	filter_category = category
	_refresh_market()

func _set_mode(new_mode: String) -> void:
	mode = new_mode
	status_label.text = "Wybrano zlecenie: %s." % mode
	_refresh_all()

func _on_slot_selected(index: int, slot: String) -> void:
	var menu: OptionButton = slot_menus[slot]
	slot_choices[slot] = str(menu.get_item_metadata(index))

func _buy_part(part_id: String) -> void:
	var part := _part_by_id(part_id)
	if cash < int(part.price):
		status_label.text = "Za mało gotówki na tę część. Zrealizuj zlecenie, aby zarobić."
		return
	cash -= int(part.price)
	inventory[part_id] = int(inventory.get(part_id, 0)) + 1
	selected_market_id = part_id
	history.append("Kupiono: %s" % part.name)
	status_label.text = "Dodano do magazynu: %s." % part.name
	refresh_all()

func _assemble() -> void:
	var build: Dictionary = {}
	for slot in REQUIRED:
		var part_id: String = slot_choices.get(slot, "")
		if part_id == "" or int(inventory.get(part_id, 0)) < 1:
			status_label.text = "Brakuje elementu: %s. Kup część i wybierz ją z listy." % slot
			return
		build[slot] = _part_by_id(part_id)
	var gpu_id: String = slot_choices.get("Karta graficzna", "")
	if gpu_id != "" and int(inventory.get(gpu_id, 0)) > 0:
		build["Karta graficzna"] = _part_by_id(gpu_id)
	elif mode == "PC":
		status_label.text = "Komputer do gier wymaga dedykowanej karty graficznej."
		return
	var cpu: Dictionary = build["CPU"]
	var board: Dictionary = build["Płyta główna"]
	if cpu.socket != board.socket:
		status_label.text = "Niezgodność: procesor %s nie pasuje do gniazda %s na płycie." % [cpu.socket, board.socket]
		return
	var form := str(board.get("form", "ATX"))
	if build["Obudowa"].get("form", "") != form:
		status_label.text = "Niezgodność formatu: płyta %s nie pasuje do tej obudowy." % form
		return
	var required_ram := 16 if mode == "PC" else 64
	var required_storage := 1000 if mode == "PC" else 4000
	if int(build["RAM"].get("ram", 0)) < required_ram:
		status_label.text = "Zlecenie wymaga co najmniej %d GB RAM." % required_ram
		return
	if int(build["Dysk"].get("storage", 0)) < required_storage:
		status_label.text = "Zlecenie wymaga dysku o pojemności co najmniej %d GB." % required_storage
		return
	if mode == "PC" and int(cpu.get("score", 0)) < 60:
		status_label.text = "Procesor jest za słaby do zlecenia gamingowego."
		return
	if mode == "Serwer" and not str(build["RAM"].name).contains("ECC"):
		status_label.text = "Klient serwerowy wymaga pamięci ECC."
		return
	var power_need := int(cpu.get("power", 65)) + 100
	if build.has("Karta graficzna"):
		power_need += int(build["Karta graficzna"].get("power", 0))
	if int(build["Zasilacz"].get("watts", 0)) < power_need:
		status_label.text = "Zasilacz za słaby: zestaw potrzebuje około %d W." % power_need
		return
	for slot in build:
		var part_id := str(slot_choices[slot])
		inventory[part_id] = int(inventory.get(part_id, 0)) - 1
		if inventory[part_id] <= 0:
			inventory.erase(part_id)
			slot_choices[slot] = ""
	var reward := 9500 if mode == "PC" else 14500
	cash += reward
	history.append("Oddano zlecenie %s: +%s zł" % [mode, _money(reward)])
	day += 1
	status_label.text = "Zestaw działa! Zlecenie oddane, wypłata %s zł. Czas na następne." % _money(reward)
	refresh_all()

func _part_by_id(part_id: String) -> Dictionary:
	for part in PARTS:
		if part.id == part_id:
			return part
	return {}

func _money(amount: int) -> String:
	return "%,d" % amount
