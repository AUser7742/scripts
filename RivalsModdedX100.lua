local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- [[ ПРОВЕРКА ИГРЫ: ТОЛЬКО ДЛЯ RIVALS / GAME VALIDATION ]]
local function isRivalsGame()
	-- Universe ID: 6035872082 (все карты, арены 1v1, лобби)
	-- Place ID: 17625359962 (основное лобби)
	if game.GameId == 6035872082 or game.PlaceId == 17625359962 then
		return true
	end
	local ok, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if ok and info and type(info.Name) == "string" and string.find(string.upper(info.Name), "RIVALS", 1, true) then
		return true
	end
	return false
end

if not isRivalsGame() then
	warn("[RIVALS MODDED] Скрипт предназначен только для игры RIVALS!")
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "RIVALS MENU",
			Text = "Этот скрипт работает только в RIVALS!",
			Duration = 6
		})
	end)
	return
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

while not workspace.CurrentCamera do
	task.wait()
end
local camera = workspace.CurrentCamera

local CONFIG = {
	Title = string.upper(player.Name) .. " MENU",
	Logo = "W",
	Author = "by " .. player.Name,
	Version = "Version 7.0",
	ToggleKey = Enum.KeyCode.G,
	Theme = "Pumpkin",
	AutoThemeDelay = 6,
	Width = 720,
	Height = 520,
	Transparency = 0.16,
	ScreenMargin = 16,
	Blur = true,
	BlurSize = 10,
	AnimatedBorder = true,
}

local THEMES = {
	{
		Name = "Pumpkin",
		Accent = Color3.fromRGB(255, 145, 40),
		Accent2 = Color3.fromRGB(255, 208, 92),
		Window = Color3.fromRGB(36, 27, 22),
		Card = Color3.fromRGB(64, 49, 40),
		Field = Color3.fromRGB(52, 40, 33),
		TrackOff = Color3.fromRGB(96, 66, 36),
		IconTint = Color3.fromRGB(226, 160, 80),
	},
	{
		Name = "Witch",
		Accent = Color3.fromRGB(176, 96, 255),
		Accent2 = Color3.fromRGB(255, 128, 214),
		Window = Color3.fromRGB(27, 19, 40),
		Card = Color3.fromRGB(52, 37, 72),
		Field = Color3.fromRGB(42, 30, 58),
		TrackOff = Color3.fromRGB(76, 54, 104),
		IconTint = Color3.fromRGB(196, 156, 244),
	},
	{
		Name = "Vampire",
		Accent = Color3.fromRGB(236, 56, 76),
		Accent2 = Color3.fromRGB(255, 146, 118),
		Window = Color3.fromRGB(32, 15, 19),
		Card = Color3.fromRGB(62, 32, 38),
		Field = Color3.fromRGB(50, 25, 31),
		TrackOff = Color3.fromRGB(96, 42, 52),
		IconTint = Color3.fromRGB(238, 126, 136),
	},
	{
		Name = "Ghost",
		Accent = Color3.fromRGB(112, 212, 255),
		Accent2 = Color3.fromRGB(206, 242, 255),
		Window = Color3.fromRGB(17, 23, 32),
		Card = Color3.fromRGB(36, 47, 62),
		Field = Color3.fromRGB(29, 38, 51),
		TrackOff = Color3.fromRGB(52, 70, 92),
		IconTint = Color3.fromRGB(152, 204, 236),
	},
	{
		Name = "Potion",
		Accent = Color3.fromRGB(116, 232, 92),
		Accent2 = Color3.fromRGB(222, 255, 122),
		Window = Color3.fromRGB(17, 27, 19),
		Card = Color3.fromRGB(36, 55, 40),
		Field = Color3.fromRGB(29, 44, 32),
		TrackOff = Color3.fromRGB(54, 88, 52),
		IconTint = Color3.fromRGB(156, 222, 134),
	},
	{
		Name = "Midnight",
		Accent = Color3.fromRGB(96, 124, 255),
		Accent2 = Color3.fromRGB(150, 230, 255),
		Window = Color3.fromRGB(14, 16, 32),
		Card = Color3.fromRGB(32, 36, 66),
		Field = Color3.fromRGB(25, 28, 52),
		TrackOff = Color3.fromRGB(48, 54, 96),
		IconTint = Color3.fromRGB(150, 166, 240),
	},
	{
		Name = "Candy",
		Accent = Color3.fromRGB(255, 96, 170),
		Accent2 = Color3.fromRGB(255, 196, 120),
		Window = Color3.fromRGB(36, 18, 30),
		Card = Color3.fromRGB(68, 38, 58),
		Field = Color3.fromRGB(54, 30, 46),
		TrackOff = Color3.fromRGB(104, 52, 84),
		IconTint = Color3.fromRGB(246, 156, 200),
	},
	{
		Name = "Skeleton",
		Accent = Color3.fromRGB(235, 235, 240),
		Accent2 = Color3.fromRGB(140, 146, 160),
		Window = Color3.fromRGB(20, 20, 22),
		Card = Color3.fromRGB(44, 44, 48),
		Field = Color3.fromRGB(34, 34, 38),
		TrackOff = Color3.fromRGB(70, 70, 76),
		IconTint = Color3.fromRGB(190, 190, 198),
	},
	{
		Name = "Cursed",
		Accent = Color3.fromRGB(40, 220, 190),
		Accent2 = Color3.fromRGB(170, 110, 255),
		Window = Color3.fromRGB(14, 26, 28),
		Card = Color3.fromRGB(30, 52, 56),
		Field = Color3.fromRGB(24, 42, 46),
		TrackOff = Color3.fromRGB(40, 80, 80),
		IconTint = Color3.fromRGB(120, 210, 196),
	},
}

local COMMON = {
	Text = Color3.fromRGB(246, 240, 234),
	SubText = Color3.fromRGB(188, 178, 170),
	TabText = Color3.fromRGB(222, 213, 205),
	White = Color3.new(1, 1, 1),
	Black = Color3.new(0, 0, 0),
	Green = Color3.fromRGB(70, 235, 120),
	Close = Color3.fromRGB(235, 70, 60),
}

local THEME = {}
local currentTheme = THEMES[1]

local function loadTheme(name)
	for _, theme in ipairs(THEMES) do
		if theme.Name == name then
			currentTheme = theme
		end
	end
	for key, value in pairs(COMMON) do
		THEME[key] = value
	end
	for key, value in pairs(currentTheme) do
		THEME[key] = value
	end
end
loadTheme(CONFIG.Theme)

local FONT_BOLD = Enum.Font.GothamBold
local FONT_MEDIUM = Enum.Font.GothamMedium
local FONT_REGULAR = Enum.Font.Gotham

local state = {}
state.onClose = {}

local OWN_FONTS = {}
for _, enumFont in ipairs({ Enum.Font.GothamBold, Enum.Font.GothamMedium, Enum.Font.Gotham, Enum.Font.Code }) do
	pcall(function()
		OWN_FONTS[Font.fromEnum(enumFont).Family] = true
	end)
end
local function keepFont(instance)
	pcall(function()
		local mine = instance.FontFace
		if not mine then
			return
		end
		local fixes, firstFix = 0, 0
		local function check()
			local face = instance.FontFace
			if OWN_FONTS[face.Family] then
				mine = face
			elseif face ~= mine and fixes < 3 then
				if fixes == 0 or os.clock() - firstFix > 10 then
					fixes, firstFix = 0, os.clock()
				end
				fixes = fixes + 1
				task.defer(function()
					if instance.FontFace ~= mine and not OWN_FONTS[instance.FontFace.Family] then
						instance.FontFace = mine
					end
				end)
			end
		end
		instance:GetPropertyChangedSignal("FontFace"):Connect(check)
		instance:GetPropertyChangedSignal("Font"):Connect(check)
	end)
end

local LANGUAGES = {
	{ "en", "English" },
	{ "ru", "Русский" },
	{ "gd", "Gàidhlig" },
	{ "fr", "Français" },
}

local INFO_ABOUT = "A menu for your game: aim, ESP, themes, settings and your profile.\nAim assist, auto-shoot and saved settings — Aim tab (needs the GamePass)\nPlayers through walls, names, distance, health — ESP tab\n%d themes and Auto Theme — Themes tab\nLanguage, blur, transparency, border, notifications and the menu key — Settings tab\nYour avatar, account age and time in the menu — Profile tab"
local HOW_TO = "Press %s or the W button on the left to hide or show the menu. Drag the window by its top bar. Aim and ESP are on their own tabs, colors on the Themes tab, language and menu settings on the Settings tab."
local KEYS_TEXT = "%s or the W button on the left — hide / show the menu\n— minimize, □ maximize, × hide\nDrag the window by its top bar, drag the W button anywhere"

local TEXTS = {
	["Search..."] = { ru = "Поиск...", gd = "Lorg...", fr = "Rechercher..." },
	["Today!"] = { ru = "Сегодня!", gd = "An-diugh!", fr = "Aujourd'hui !" },
	["%d days"] = { ru = "%d дн.", gd = "%d latha", fr = "%d jours" },
	["Press a key..."] = { ru = "Нажми клавишу...", gd = "Brùth iuchair...", fr = "Appuie sur une touche..." },
	["Hello, %s!"] = { ru = "Привет, %s!", gd = "Halò, %s!", fr = "Salut, %s !" },
	["Happy Halloween"] = { ru = "С Хэллоуином", gd = "Oidhche Shamhna shona", fr = "Joyeux Halloween" },
	["by %s"] = { ru = "от %s", gd = "le %s", fr = "par %s" },
	["Home"] = { ru = "Главная", gd = "Dachaigh", fr = "Accueil" },
	["Welcome!"] = { ru = "Добро пожаловать!", gd = "Fàilte!", fr = "Bienvenue !" },
	["until Halloween"] = { ru = "до Хэллоуина", gd = "gu Oidhche Shamhna", fr = "avant Halloween" },
	["toggle menu"] = { ru = "открыть меню", gd = "clàr-taice", fr = "ouvrir le menu" },
	["menu theme"] = { ru = "тема меню", gd = "ùrlar a' chlàir", fr = "thème du menu" },
	["Quick start"] = { ru = "Быстрый старт", gd = "Tòiseachadh luath", fr = "Démarrage rapide" },
	["How to use"] = { ru = "Как пользоваться", gd = "Mar a chleachdas tu e", fr = "Comment l'utiliser" },
	[HOW_TO] = {
		ru = "Нажми %s или кнопку W слева, чтобы открыть или спрятать меню. Окно можно двигать за верхнюю полосу. Аим и ESP — на своих вкладках, цвета — во вкладке «Темы», язык и меню — во вкладке «Настройки».",
		gd = "Brùth %s no am putan W air an taobh chlì gus an clàr-taice a shealltainn no fhalach. Slaod an uinneag leis a' bhàr aig a' mhullach. Tha Amas is ESP air na tabaichean aca fhèin, dathan air an tab Ùrlaran, cànan is roghainnean a' chlàir air an tab Roghainnean.",
		fr = "Appuie sur %s ou sur le bouton W à gauche pour afficher ou cacher le menu. Déplace la fenêtre par sa barre du haut. Visée et ESP ont leurs propres onglets, les couleurs sont dans Thèmes, la langue et le menu dans Paramètres.",
	},

	["AIM: BUY"] = { ru = "АИМ: КУПИТЬ", gd = "AMAS: CEANNAICH", fr = "VISÉE : ACHETER" },
	["AIM: ON"] = { ru = "АИМ: ВКЛ", gd = "AMAS: AIR", fr = "VISÉE : ON" },
	["AIM: OFF"] = { ru = "АИМ: ВЫКЛ", gd = "AMAS: DHETH", fr = "VISÉE : OFF" },
	["Instant aim"] = { ru = "Мгновенная наводка", gd = "Amas sa bhad", fr = "Visée instantanée" },
	["Aim speed: %d%%"] = { ru = "Скорость наводки: %d%%", gd = "Luaths amais: %d%%", fr = "Vitesse de visée : %d%%" },
	["Knife: no enemy closer than %d studs"] = { ru = "Нож: нет врага ближе %d студов", gd = "Sgian: chan eil nàmhaid nas fhaisge na %d studs", fr = "Couteau : aucun ennemi à moins de %d studs" },
	["No target  •  teammates: %d  •  outside circle: %d  •  behind walls: %d  •  shield: %d"] = { ru = "Нет цели  •  свои: %d  •  вне круга: %d  •  за стеной: %d  •  щит: %d", gd = "Gun targaid  •  sgioba: %d  •  taobh a-muigh: %d  •  air cùl balla: %d  •  sgiath: %d", fr = "Aucune cible  •  alliés : %d  •  hors cercle : %d  •  derrière un mur : %d  •  bouclier : %d" },
	["Target: %s  •  %d m"] = { ru = "Цель: %s  •  %d м", gd = "Targaid: %s  •  %d m", fr = "Cible : %s  •  %d m" },

	["Aim"] = { ru = "Аим", gd = "Amas", fr = "Visée" },
	["Aim assist and auto-shoot"] = { ru = "Наводка и автострел", gd = "Taic amais is fèin-losgadh", fr = "Aide à la visée et tir auto" },
	["Buy the Aim GamePass"] = { ru = "Купить геймпасс аима", gd = "Ceannaich an GamePass Amais", fr = "Acheter le GamePass Visée" },
	["Main"] = { ru = "Основное", gd = "Prìomh", fr = "Principal" },
	["%s — on / off"] = { ru = "%s — вкл / выкл", gd = "%s — air / dheth", fr = "%s — activer / désactiver" },
	["Camera Mode"] = { ru = "Режим камеры", gd = "Modh a' chamara", fr = "Mode caméra" },
	["Rivals — for the Rivals camera"] = { ru = "Rivals — для камеры Rivals", gd = "Rivals — airson camara Rivals", fr = "Rivals — pour la caméra de Rivals" },
	["Rivals"] = { ru = "Rivals", gd = "Rivals", fr = "Rivals" },
	["Normal"] = { ru = "Обычный", gd = "Àbhaisteach", fr = "Normal" },
	["Aim At"] = { ru = "Куда целиться", gd = "Amais air", fr = "Viser" },
	["Which body part"] = { ru = "Какая часть тела", gd = "Dè am pàirt den bhodhaig", fr = "Quelle partie du corps" },
	["Head"] = { ru = "Голова", gd = "Ceann", fr = "Tête" },
	["Body"] = { ru = "Торс", gd = "Bodhaig", fr = "Torse" },
	["Center"] = { ru = "Центр", gd = "Meadhan", fr = "Centre" },
	["Head Only"] = { ru = "Только голова", gd = "An ceann a-mhàin", fr = "Tête uniquement" },
	["Always the head, never switches to the body"] = { ru = "Всегда в голову, никогда не переходит на тело", gd = "An ceann an-còmhnaidh, chan ann a' bhodhaig", fr = "Toujours la tête, jamais le corps" },
	["Hold Right Mouse"] = { ru = "Зажатая ПКМ", gd = "Cùm am putan deas", fr = "Clic droit maintenu" },
	["PC: aim only while the right button is held"] = { ru = "ПК: наводка, только пока зажата ПКМ", gd = "PC: amas fhad 's a tha am putan deas ga chumail", fr = "PC : vise seulement avec le clic droit maintenu" },
	["Right Mouse Through Walls"] = { ru = "ПКМ сквозь стены", gd = "Putan deas tro bhallachan", fr = "Clic droit à travers les murs" },
	["While held, walls don't block the aim"] = { ru = "Пока зажата, стены не мешают", gd = "Fhad 's a tha e ga chumail, cha bhac ballachan an t-amas", fr = "Maintenu, les murs ne bloquent pas la visée" },
	["Aim Speed"] = { ru = "Скорость наводки", gd = "Luaths amais", fr = "Vitesse de visée" },
	["Speed"] = { ru = "Скорость", gd = "Luaths", fr = "Vitesse" },
	["Instant Aim"] = { ru = "Мгновенная наводка", gd = "Amas sa bhad", fr = "Visée instantanée" },
	["%s — on / off, %s / %s — speed"] = { ru = "%s — вкл / выкл, %s / %s — скорость", gd = "%s — air / dheth, %s / %s — luaths", fr = "%s — on / off, %s / %s — vitesse" },
	["Aim Height"] = { ru = "Высота прицела в голове", gd = "Àirde an amais sa cheann", fr = "Hauteur de visée sur la tête" },
	["Lock"] = { ru = "Захват", gd = "Glasadh", fr = "Verrouillage" },
	["FOV Radius"] = { ru = "Радиус FOV", gd = "Rèideas FOV", fr = "Rayon du FOV" },
	["Prediction"] = { ru = "Упреждение", gd = "Ro-innse", fr = "Anticipation" },
	["Keep Target"] = { ru = "Держать цель", gd = "Cùm an targaid", fr = "Garder la cible" },
	["Don't jump between players"] = { ru = "Не прыгать между игроками", gd = "Na leum eadar cluicheadairean", fr = "Ne pas sauter d'un joueur à l'autre" },
	["Keep After Cover"] = { ru = "Держать после укрытия", gd = "Cùm às dèidh fasgaidh", fr = "Garder après un abri" },
	["Auto-Shoot"] = { ru = "Автострел", gd = "Fèin-losgadh", fr = "Tir auto" },
	["Shoots when the aim is on an enemy"] = { ru = "Стреляет сам, когда прицел на враге", gd = "Loisgidh e nuair a tha an t-amas air nàmhaid", fr = "Tire quand la visée est sur un ennemi" },
	["Phone"] = { ru = "Телефон", gd = "Fòn", fr = "Téléphone" },
	["Everywhere"] = { ru = "Везде", gd = "Anns gach àite", fr = "Partout" },
	["Off"] = { ru = "Выкл", gd = "Dheth", fr = "Désactivé" },
	["Accuracy"] = { ru = "Точность", gd = "Cruinneas", fr = "Précision" },
	["Pause Between Shots"] = { ru = "Пауза между выстрелами", gd = "Stad eadar losgaidhean", fr = "Pause entre les tirs" },
	["Knife"] = { ru = "Нож", gd = "Sgian", fr = "Couteau" },
	["Knife Aim"] = { ru = "Аим ножом", gd = "Amas sgeine", fr = "Visée au couteau" },
	["Knife in hand: turns to the closest enemy's head"] = { ru = "Нож в руке: поворот к голове ближайшего врага", gd = "Sgian nad làimh: tionndaidh gu ceann an nàmhaid as fhaisge", fr = "Couteau en main : se tourne vers la tête de l'ennemi le plus proche" },
	["Knife Aim Range"] = { ru = "Дальность аима ножом", gd = "Raon amas sgeine", fr = "Portée de la visée au couteau" },
	["%d studs"] = { ru = "%d студов", gd = "%d studs", fr = "%d studs" },
	["Auto Swing"] = { ru = "Автоудар", gd = "Fèin-bhualadh", fr = "Coup auto" },
	["Swings by itself when the head is close enough"] = { ru = "Бьёт сам, когда голова достаточно близко", gd = "Buailidh e leis fhèin nuair a tha an ceann faisg gu leòr", fr = "Frappe tout seul quand la tête est assez proche" },
	["Swing Range"] = { ru = "Дальность удара", gd = "Raon bualaidh", fr = "Portée du coup" },
	["Pause Between Swings"] = { ru = "Пауза между ударами", gd = "Stad eadar buillean", fr = "Pause entre les coups" },
	["PC: Hold Right Mouse For Knife"] = { ru = "ПК: нож только по ПКМ", gd = "PC: Cùm am putan deas airson na sgeine", fr = "PC : clic droit pour le couteau" },
	["Off — works by itself, like on the phone"] = { ru = "Выкл — работает сам, как на телефоне", gd = "Dheth — obraichidh e leis fhèin, mar air an fhòn", fr = "Désactivé — marche tout seul, comme sur téléphone" },
	["Checks"] = { ru = "Проверки", gd = "Sgrùdaidhean", fr = "Vérifications" },
	["Team Check"] = { ru = "Не целиться в своих", gd = "Sgrùdadh sgioba", fr = "Vérif. d'équipe" },
	["Don't aim at teammates"] = { ru = "Свои не становятся целью", gd = "Na amais air do sgioba", fr = "Ne pas viser ses coéquipiers" },
	["Teams"] = { ru = "Команды", gd = "Sgiobaidhean", fr = "Équipes" },
	["Auto — find teams by itself"] = { ru = "Авто — сам находит команды", gd = "Fèin — lorgaidh e sgiobaidhean leis fhèin", fr = "Auto — trouve les équipes tout seul" },
	["Auto"] = { ru = "Авто", gd = "Fèin", fr = "Auto" },
	["All enemies"] = { ru = "Все враги", gd = "Nàimhdean uile", fr = "Tous ennemis" },
	["Your Team"] = { ru = "Твоя команда", gd = "Do sgioba", fr = "Ton équipe" },
	["Open the menu for a second — your team shows up here"] = { ru = "Открой меню на секунду — здесь появится твоя команда", gd = "Fosgail an clàr-taice airson diog — nochdaidh do sgioba an seo", fr = "Ouvre le menu une seconde — ton équipe s'affiche ici" },
	["Wall Check"] = { ru = "Проверка стен", gd = "Sgrùdadh bhallachan", fr = "Vérif. des murs" },
	["Don't aim through walls"] = { ru = "Не целиться сквозь стены", gd = "Na amais tro bhallachan", fr = "Ne pas viser à travers les murs" },
	["Target Bots"] = { ru = "Целиться в ботов", gd = "Amais air botaichean", fr = "Viser les bots" },
	["NPCs with a Humanoid too"] = { ru = "И NPC с Humanoid", gd = "NPCan le Humanoid cuideachd", fr = "Les PNJ avec un Humanoid aussi" },
	["Show FOV Circle"] = { ru = "Показывать круг FOV", gd = "Seall cearcall FOV", fr = "Afficher le cercle FOV" },
	["Circle around the aim point"] = { ru = "Круг вокруг точки наводки", gd = "Cearcall timcheall air puing an amais", fr = "Cercle autour du point de visée" },
	["Show Target"] = { ru = "Показывать цель", gd = "Seall an targaid", fr = "Afficher la cible" },
	["Name and distance at the top"] = { ru = "Ник и расстояние сверху", gd = "Ainm is astar aig a' mhullach", fr = "Nom et distance en haut" },
	["Saving"] = { ru = "Сохранение", gd = "Sàbhaladh", fr = "Sauvegarde" },
	["Your Settings"] = { ru = "Твои настройки", gd = "Do roghainnean", fr = "Tes paramètres" },
	["Loading your settings…"] = { ru = "Загрузка твоих настроек…", gd = "A' luchdadh do roghainnean…", fr = "Chargement de tes paramètres…" },
	["Reset Aim and ESP Settings"] = { ru = "Сбросить настройки аима и ESP", gd = "Ath-shuidhich roghainnean Amais is ESP", fr = "Réinitialiser Visée et ESP" },
	["Settings reset to default"] = { ru = "Настройки сброшены к стандартным", gd = "Chaidh na roghainnean ath-shuidheachadh", fr = "Paramètres réinitialisés" },

	["See where players are"] = { ru = "Видно, где игроки", gd = "Faic càite a bheil na cluicheadairean", fr = "Voir où sont les joueurs" },
	["Show players through walls"] = { ru = "Игроки видны сквозь стены", gd = "Seall cluicheadairean tro bhallachan", fr = "Voir les joueurs à travers les murs" },
	["Highlight"] = { ru = "Подсветка", gd = "Soillseachadh", fr = "Surbrillance" },
	["Glowing outline through walls"] = { ru = "Светящийся контур сквозь стены", gd = "Iomall deàlrach tro bhallachan", fr = "Contour lumineux à travers les murs" },
	["Names"] = { ru = "Ники", gd = "Ainmean", fr = "Noms" },
	["Name above the head"] = { ru = "Ник над головой", gd = "Ainm os cionn a' chinn", fr = "Nom au-dessus de la tête" },
	["Distance"] = { ru = "Расстояние", gd = "Astar", fr = "Distance" },
	["How far away they are"] = { ru = "Как далеко игрок", gd = "Dè cho fada air falbh 's a tha iad", fr = "À quelle distance ils sont" },
	["Health Bar"] = { ru = "Полоска HP", gd = "Bàr slàinte", fr = "Barre de vie" },
	["HP under the name"] = { ru = "HP под ником", gd = "HP fon ainm", fr = "PV sous le nom" },
	["Tracers"] = { ru = "Линии", gd = "Loidhnichean", fr = "Traceurs" },
	["Lines from the bottom of the screen"] = { ru = "Линии от низа экрана", gd = "Loidhnichean o bhonn na sgrìn", fr = "Lignes depuis le bas de l'écran" },
	["Show Teammates"] = { ru = "Показывать своих", gd = "Seall do sgioba", fr = "Afficher les coéquipiers" },
	["Your team too"] = { ru = "Свою команду тоже", gd = "Do sgioba cuideachd", fr = "Ton équipe aussi" },
	["Max Distance"] = { ru = "Макс. дистанция", gd = "An t-astar as motha", fr = "Distance max" },
	["%d m"] = { ru = "%d м", gd = "%d m", fr = "%d m" },

	["Saved at %s — next time they load by themselves"] = { ru = "Сохранено в %s — в следующий раз загрузится само", gd = "Air a shàbhaladh aig %s — an ath thuras luchdaichidh iad leotha fhèin", fr = "Sauvegardé à %s — la prochaine fois ils se chargeront tout seuls" },
	["Couldn't save, trying again…"] = { ru = "Не удалось сохранить, пробую ещё раз…", gd = "Cha b' urrainn sàbhaladh, a' feuchainn a-rithist…", fr = "Échec de la sauvegarde, nouvel essai…" },
	["Settings won't be kept after you leave: the game has no AimBotConfigServer script"] = { ru = "Настройки не запомнятся после выхода: в игре нет скрипта AimBotConfigServer", gd = "Cha tèid na roghainnean a chumail: chan eil an sgriobt AimBotConfigServer sa gheama", fr = "Les paramètres ne seront pas gardés : le jeu n'a pas le script AimBotConfigServer" },
	["Loading your settings… (try %d of 5)"] = { ru = "Загрузка твоих настроек… (попытка %d из 5)", gd = "A' luchdadh do roghainnean… (oidhirp %d de 5)", fr = "Chargement de tes paramètres… (essai %d sur 5)" },
	["Storage doesn't answer — settings won't be kept this time"] = { ru = "Хранилище не отвечает — в этот раз настройки не запомнятся", gd = "Chan eil an stòras a' freagairt — cha tèid na roghainnean a chumail an turas seo", fr = "Le stockage ne répond pas — paramètres non gardés cette fois" },
	["Your settings are loaded — just like last time"] = { ru = "Твои настройки загружены — как в прошлый раз", gd = "Chaidh do roghainnean a luchdadh — dìreach mar an turas mu dheireadh", fr = "Tes paramètres sont chargés — comme la dernière fois" },
	["Your aim settings are loaded"] = { ru = "Твои настройки аима загружены", gd = "Chaidh do roghainnean amais a luchdadh", fr = "Tes paramètres de visée sont chargés" },
	["First start: set everything up — it will be remembered"] = { ru = "Первый запуск: настрой всё под себя — это запомнится", gd = "A' chiad turas: suidhich a h-uile càil — thèid a chuimhneachadh", fr = "Premier lancement : règle tout — ce sera retenu" },
	["First start: set up your aim — it will be remembered"] = { ru = "Первый запуск: настрой аим — это запомнится", gd = "A' chiad turas: suidhich an t-amas — thèid a chuimhneachadh", fr = "Premier lancement : règle ta visée — ce sera retenu" },
	["player attribute"] = { ru = "атрибут игрока", gd = "buadh a' chluicheadair", fr = "attribut du joueur" },
	["character attribute"] = { ru = "атрибут персонажа", gd = "buadh a' charactair", fr = "attribut du personnage" },
	["Teams are off: every player is an enemy"] = { ru = "Команды выключены: все игроки — враги", gd = "Tha sgiobaidhean dheth: 's e nàmhaid a th' anns gach cluicheadair", fr = "Équipes désactivées : tous les joueurs sont ennemis" },
	["No team found — every player is an enemy"] = { ru = "Команда не найдена — все игроки враги", gd = "Cha deach sgioba a lorg — 's e nàmhaid a th' anns gach cluicheadair", fr = "Aucune équipe trouvée — tous les joueurs sont ennemis" },
	["Your team: %s (%s)%s\nTeammates: %d  •  Enemies: %d"] = { ru = "Твоя команда: %s (%s)%s\nСвоих: %d  •  Врагов: %d", gd = "Do sgioba: %s (%s)%s\nCo-chluicheadairean: %d  •  Nàimhdean: %d", fr = "Ton équipe : %s (%s)%s\nCoéquipiers : %d  •  Ennemis : %d" },
	[", everyone is in it — free for all"] = { ru = ", все в одной — каждый сам за себя", gd = ", tha a h-uile duine innte — gach neach air a shon fhèin", fr = ", tout le monde dedans — chacun pour soi" },

	["Themes"] = { ru = "Темы", gd = "Ùrlaran", fr = "Thèmes" },
	["Change the look of the menu"] = { ru = "Внешний вид меню", gd = "Atharraich coltas a' chlàir-taice", fr = "Changer l'apparence du menu" },
	["Choose a theme"] = { ru = "Выбери тему", gd = "Tagh ùrlar", fr = "Choisis un thème" },
	["ACTIVE"] = { ru = "ВКЛ", gd = "AIR", fr = "ACTIF" },
	["Click to apply"] = { ru = "Нажми, чтобы включить", gd = "Briog gus a chur an sàs", fr = "Clique pour appliquer" },
	["Theme changed"] = { ru = "Тема изменена", gd = "Chaidh an t-ùrlar atharrachadh", fr = "Thème changé" },
	["%s is on now"] = { ru = "Теперь включена %s", gd = "Tha %s air a-nis", fr = "%s est activé" },
	["Extra"] = { ru = "Дополнительно", gd = "A bharrachd", fr = "Extra" },
	["Auto Theme"] = { ru = "Автосмена темы", gd = "Ùrlar fèin-ghluasadach", fr = "Thème auto" },
	["Themes change every %d seconds"] = { ru = "Темы меняются каждые %d с", gd = "Atharraichidh ùrlaran gach %d diog", fr = "Les thèmes changent toutes les %d secondes" },
	["Auto Theme enabled"] = { ru = "Автосмена темы включена", gd = "Ùrlar fèin-ghluasadach air", fr = "Thème auto activé" },
	["Sit back and watch the colors"] = { ru = "Отдыхай и смотри на цвета", gd = "Gabh fois is coimhead air na dathan", fr = "Installe-toi et admire les couleurs" },
	["Auto Theme disabled"] = { ru = "Автосмена темы выключена", gd = "Ùrlar fèin-ghluasadach dheth", fr = "Thème auto désactivé" },
	["%s stays on"] = { ru = "Остаётся %s", gd = "Fanaidh %s air", fr = "%s reste activé" },

	[KEYS_TEXT] = {
		ru = "%s или кнопка W слева — открыть / спрятать меню\n— свернуть, □ развернуть, × спрятать\nОкно двигается за верхнюю полосу, кнопку W можно перетащить куда угодно",
		gd = "%s no am putan W air an taobh chlì — seall / falaich an clàr-taice\n— lùghdaich, □ meudaich, × falaich\nSlaod an uinneag leis a' bhàr aig a' mhullach, slaod am putan W gu àite sam bith",
		fr = "%s ou le bouton W à gauche — afficher / cacher le menu\n— réduire, □ agrandir, × cacher\nDéplace la fenêtre par sa barre du haut, et le bouton W où tu veux",
	},
	["Key changed"] = { ru = "Клавиша изменена", gd = "Chaidh an iuchair atharrachadh", fr = "Touche changée" },
	["New key: %s"] = { ru = "Новая клавиша: %s", gd = "Iuchair ùr: %s", fr = "Nouvelle touche : %s" },
	["Settings"] = { ru = "Настройки", gd = "Roghainnean", fr = "Paramètres" },
	["Menu look and keys"] = { ru = "Язык, вид меню и клавиши", gd = "Cànan, coltas is iuchraichean", fr = "Langue, apparence et touches" },
	["Language"] = { ru = "Язык", gd = "Cànan", fr = "Langue" },
	["Language changed"] = { ru = "Язык изменён", gd = "Chaidh an cànan atharrachadh", fr = "Langue changée" },
	["Menu"] = { ru = "Меню", gd = "Clàr-taice", fr = "Menu" },
	["Blur"] = { ru = "Размытие", gd = "Sgleò", fr = "Flou" },
	["Blur the game behind the menu"] = { ru = "Размывать игру за меню", gd = "Cuir sgleò air a' gheama air cùl a' chlàir", fr = "Flouter le jeu derrière le menu" },
	["Blur Strength"] = { ru = "Сила размытия", gd = "Neart an sgleò", fr = "Intensité du flou" },
	["Window Transparency"] = { ru = "Прозрачность окна", gd = "Trìd-shoilleireachd na h-uinneige", fr = "Transparence de la fenêtre" },
	["Animated Border"] = { ru = "Анимированная рамка", gd = "Iomall beòthail", fr = "Bordure animée" },
	["The glowing border slowly spins"] = { ru = "Светящаяся рамка медленно крутится", gd = "Tionndaidhidh an t-iomall deàlrach gu slaodach", fr = "La bordure lumineuse tourne lentement" },
	["Notifications"] = { ru = "Уведомления", gd = "Brathan", fr = "Notifications" },
	["Pop-ups in the bottom-right corner"] = { ru = "Окошки в правом нижнем углу", gd = "Brathan san oisean gu h-ìosal air an làimh dheis", fr = "Fenêtres en bas à droite" },
	["Keybinds"] = { ru = "Клавиши", gd = "Iuchraichean", fr = "Touches" },
	["How to change a key"] = { ru = "Как поменять клавишу", gd = "Mar a dh'atharraicheas tu iuchair", fr = "Comment changer une touche" },
	["Click the key button, then press a new key. Escape cancels."] = { ru = "Нажми на кнопку клавиши, потом нажми новую клавишу. Escape — отмена.", gd = "Briog air putan na h-iuchrach, an uairsin brùth iuchair ùr. Sguiridh Escape dheth.", fr = "Clique sur le bouton de la touche, puis appuie sur une nouvelle touche. Échap annule." },
	["Show / Hide Menu"] = { ru = "Открыть / спрятать меню", gd = "Seall / Falaich an clàr-taice", fr = "Afficher / cacher le menu" },

	["Profile"] = { ru = "Профиль", gd = "Pròifil", fr = "Profil" },
	["Your account"] = { ru = "Твой аккаунт", gd = "An cunntas agad", fr = "Ton compte" },
	["account age"] = { ru = "возраст аккаунта", gd = "aois a' chunntais", fr = "âge du compte" },
	["Yes"] = { ru = "Да", gd = "Tha", fr = "Oui" },
	["No"] = { ru = "Нет", gd = "Chan eil", fr = "Non" },
	["Premium"] = { ru = "Premium", gd = "Premium", fr = "Premium" },
	["in menu"] = { ru = "в меню", gd = "sa chlàr-taice", fr = "dans le menu" },
	["Info"] = { ru = "Инфо", gd = "Fiosrachadh", fr = "Infos" },
	["About the menu"] = { ru = "О меню", gd = "Mun chlàr-taice", fr = "À propos du menu" },
	["Made for %s\nTheme: %s"] = { ru = "Сделано для %s\nТема: %s", gd = "Air a dhèanamh airson %s\nÙrlar: %s", fr = "Fait pour %s\nThème : %s" },
	["Controls"] = { ru = "Управление", gd = "Smachdan", fr = "Commandes" },
	["Keys and buttons"] = { ru = "Клавиши и кнопки", gd = "Iuchraichean is putanan", fr = "Touches et boutons" },
	["What's inside"] = { ru = "Что внутри", gd = "Na tha na bhroinn", fr = "Contenu" },
	[INFO_ABOUT] = {
		ru = "Меню для твоей игры: аим, ESP, темы, настройки и профиль.\nНаводка, автострел и сохранение настроек — вкладка «Аим» (нужен геймпасс)\nИгроки сквозь стены, ники, расстояние, здоровье — вкладка ESP\n%d тем и автосмена темы — вкладка «Темы»\nЯзык, размытие, прозрачность, рамка, уведомления и клавиша меню — вкладка «Настройки»\nАватар, возраст аккаунта и время в меню — вкладка «Профиль»",
		gd = "Clàr-taice airson do gheama: amas, ESP, ùrlaran, roghainnean is do phròifil.\nTaic amais, fèin-losgadh is roghainnean air an sàbhaladh — tab Amas (feumaidh e an GamePass)\nCluicheadairean tro bhallachan, ainmean, astar, slàinte — tab ESP\n%d ùrlaran is ùrlar fèin-ghluasadach — tab Ùrlaran\nCànan, sgleò, trìd-shoilleireachd, iomall, brathan is iuchair a' chlàir — tab Roghainnean\nDo dhealbh, aois a' chunntais is ùine sa chlàr-taice — tab Pròifil",
		fr = "Un menu pour ton jeu : visée, ESP, thèmes, paramètres et profil.\nAide à la visée, tir auto et paramètres sauvegardés — onglet Visée (GamePass requis)\nJoueurs à travers les murs, noms, distance, vie — onglet ESP\n%d thèmes et thème auto — onglet Thèmes\nLangue, flou, transparence, bordure, notifications et touche du menu — onglet Paramètres\nTon avatar, l'âge du compte et le temps dans le menu — onglet Profil",
	},
	["Menu hidden"] = { ru = "Меню спрятано", gd = "Chaidh an clàr-taice fhalach", fr = "Menu caché" },
	["Press %s or the W button on the left"] = { ru = "Нажми %s или кнопку W слева", gd = "Brùth %s no am putan W air an taobh chlì", fr = "Appuie sur %s ou sur le bouton W à gauche" },
	["Welcome, %s!"] = { ru = "Добро пожаловать, %s!", gd = "Fàilte, %s!", fr = "Bienvenue, %s !" },
	["Press %s to hide the menu"] = { ru = "Нажми %s, чтобы спрятать меню", gd = "Brùth %s gus an clàr-taice fhalach", fr = "Appuie sur %s pour cacher le menu" },
	["Loading theme..."] = { ru = "Загрузка темы...", gd = "A' luchdadh an ùrlair...", fr = "Chargement du thème..." },
	["Preparing menu..."] = { ru = "Подготовка меню...", gd = "Ag ullachadh a' chlàir-taice...", fr = "Préparation du menu..." },
	["Almost there..."] = { ru = "Почти готово...", gd = "Cha mhòr deiseil...", fr = "Presque prêt..." },
	["Done!"] = { ru = "Готово!", gd = "Deiseil!", fr = "Terminé !" },
	["Auto-Shoot: ON"] = { ru = "Автострел: ВКЛ", gd = "Fèin-losgadh: AIR", fr = "Tir auto : ON" },
	["Auto-Shoot: OFF"] = { ru = "Автострел: ВЫКЛ", gd = "Fèin-losgadh: DHETH", fr = "Tir auto : OFF" },
	["PC: Auto-Shoot Key"] = { ru = "ПК: Клавиша автострела", gd = "PC: Iuchair fèin-losgaidh", fr = "PC : Touche tir auto" },
	["KnifeAuto (150 DMG)"] = { ru = "KnifeAuto (150 урона)", gd = "KnifeAuto (150 milleadh)", fr = "KnifeAuto (150 dégâts)" },
	["Auto Heavy Attack in timing (150 damage)"] = { ru = "Авто-удар Heavy Attack в тайминг на 150 урона", gd = "Fèin-bhualadh Heavy Attack (150 milleadh)", fr = "Frappe lourde auto 150 dégâts" },
	["KnifeAuto Range"] = { ru = "Дальность KnifeAuto", gd = "Raon KnifeAuto", fr = "Portée KnifeAuto" },
	["Show Weapon in ESP"] = { ru = "Показывать оружие в ESP", gd = "Seall arm ann an ESP", fr = "Afficher l'arme dans l'ESP" },
}

local DICT, REVERSE = {}, {}
for _, language in ipairs(LANGUAGES) do
	DICT[language[1]] = {}
	REVERSE[language[1]] = {}
end
for english, row in pairs(TEXTS) do
	for code, text in pairs(row) do
		DICT[code][english] = text
		if REVERSE[code][text] == nil then
			REVERSE[code][text] = english
		end
	end
end

local currentLanguage = "en"
pcall(function()
	local locale = string.lower(game:GetService("LocalizationService").RobloxLocaleId)
	local code = string.sub(locale, 1, 2)
	if DICT[code] then
		currentLanguage = code
	end
end)

local function tr(text)
	return DICT[currentLanguage][text] or text
end

local function trf(template, ...)
	return string.format(tr(template), ...)
end

local textSources = setmetatable({}, { __mode = "k" })
local placeholderSources = setmetatable({}, { __mode = "k" })
local languageHooks = {}

local function watchText(instance)
	if instance:IsA("TextBox") then
		placeholderSources[instance] = instance.PlaceholderText
		instance.PlaceholderText = tr(instance.PlaceholderText)
		return
	end
	local function update()
		local text = instance.Text
		local source = REVERSE[currentLanguage][text] or text
		textSources[instance] = source
		local shown = tr(source)
		if shown ~= text then
			instance.Text = shown
		end
	end
	update()
	instance:GetPropertyChangedSignal("Text"):Connect(update)
end

local function onLanguage(hook)
	table.insert(languageHooks, hook)
	hook()
end

local function setLanguage(code)
	if not DICT[code] or code == currentLanguage then
		return false
	end
	currentLanguage = code
	for instance, source in pairs(textSources) do
		local shown = tr(source)
		if instance.Text ~= shown then
			instance.Text = shown
		end
	end
	for instance, source in pairs(placeholderSources) do
		instance.PlaceholderText = tr(source)
	end
	for _, hook in ipairs(languageHooks) do
		task.spawn(hook)
	end
	return true
end

local function create(className, props)
	local instance = Instance.new(className)
	if instance:IsA("GuiObject") then
		instance.BorderSizePixel = 0
	end
	local parent = props.Parent
	props.Parent = nil
	for key, value in pairs(props) do
		instance[key] = value
	end
	if className == "TextLabel" or className == "TextButton" or className == "TextBox" then
		keepFont(instance)
		watchText(instance)
	end
	instance.Parent = parent
	return instance
end

local function tween(object, duration, goal, style, direction)
	local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
	local animation = TweenService:Create(object, info, goal)
	animation:Play()
	return animation
end

local function corner(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = parent })
end

local function round(parent)
	return create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent })
end

local function stroke(parent, transparency, thickness, color)
	return create("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = color or COMMON.White,
		Transparency = transparency or 0.9,
		Thickness = thickness or 1,
		Parent = parent,
	})
end

local function padding(parent, top, right, bottom, left)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft = UDim.new(0, left or 0),
		Parent = parent,
	})
end

local function label(props)
	props.BackgroundTransparency = 1
	props.Font = props.Font or FONT_MEDIUM
	props.TextSize = props.TextSize or 15
	props.TextColor3 = props.TextColor3 or COMMON.Text
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	return create("TextLabel", props)
end

local function fadeEdges(middle)
	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, middle),
		NumberSequenceKeypoint.new(1, 1),
	})
end

local function staticAccent(parent, rotation)
	return create("UIGradient", {
		Rotation = rotation or 0,
		Color = ColorSequence.new(THEME.Accent, THEME.Accent2),
		Parent = parent,
	})
end

local function removeFrom(list, item)
	for index, value in ipairs(list) do
		if value == item then
			table.remove(list, index)
			return
		end
	end
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local themeHooks = {}

local function onTheme(hook)
	table.insert(themeHooks, hook)
	hook(true)
end

local function setTheme(name)
	if currentTheme.Name == name then
		return false
	end
	loadTheme(name)
	if currentTheme.Name ~= name then
		return false
	end
	CONFIG.Theme = name
	for _, hook in ipairs(themeHooks) do
		hook(false)
	end
	return true
end

local function paint(object, property, key)
	onTheme(function(instant)
		if instant then
			object[property] = THEME[key]
		else
			tween(object, 0.45, { [property] = THEME[key] })
		end
	end)
	return object
end

local function paintGradient(gradient, keyA, keyB)
	onTheme(function()
		gradient.Color = ColorSequence.new(THEME[keyA], THEME[keyB])
	end)
	return gradient
end

local spinningGradients = {}
local shimmerGradients = {}
local swingers = {}

local function accent(parent, rotation, spinning)
	local gradient = paintGradient(create("UIGradient", { Rotation = rotation or 0, Parent = parent }), "Accent", "Accent2")
	if spinning then
		table.insert(spinningGradients, gradient)
	end
	return gradient
end

local function shimmerSequence()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, COMMON.Text),
		ColorSequenceKeypoint.new(0.4, COMMON.Text),
		ColorSequenceKeypoint.new(0.5, THEME.Accent2),
		ColorSequenceKeypoint.new(0.6, COMMON.Text),
		ColorSequenceKeypoint.new(1, COMMON.Text),
	})
end

local function shimmer(textObject)
	local gradient = create("UIGradient", { Offset = Vector2.new(-1, 0), Parent = textObject })
	onTheme(function()
		gradient.Color = shimmerSequence()
	end)
	table.insert(shimmerGradients, gradient)
	return gradient
end

local GUI_NAME = "GameMenu"

local guiParent = playerGui
local oldGui = playerGui:FindFirstChild(GUI_NAME)
if oldGui then
	oldGui:Destroy()
end
local oldBlur = Lighting:FindFirstChild(GUI_NAME .. "_Blur")
if oldBlur then
	oldBlur:Destroy()
end

local gui = create("ScreenGui", {
	Name = GUI_NAME,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 10000,
	Parent = guiParent,
})
pcall(function()
	gui.ScreenInsets = Enum.ScreenInsets.None
end)

local blur = create("BlurEffect", { Name = GUI_NAME .. "_Blur", Size = 0, Parent = Lighting })
gui.Destroying:Connect(function()
	blur:Destroy()
	for key, value in pairs(state) do
		if value == true then
			state[key] = false
		end
	end
	for _, cleanup in ipairs(state.onClose) do
		pcall(cleanup)
	end
end)

local toastHolder = create("Frame", {
	Name = "Notifications",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -20, 1, -20),
	Size = UDim2.new(0, 310, 1, -40),
	BackgroundTransparency = 1,
	ZIndex = 30,
	Parent = gui,
})
create("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Padding = UDim.new(0, 10),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = toastHolder,
})

local toastCount = 0
local openToasts = {}
state.notificationsEnabled = true

local function notify(title, text, duration)
	if not state.notificationsEnabled then
		return
	end
	duration = duration or 4
	toastCount = toastCount + 1
	if #openToasts >= 5 then
		local oldest = table.remove(openToasts, 1)
		pcall(oldest)
	end

	local wrapper = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = toastCount,
		Parent = toastHolder,
	})
	local toast = create("TextButton", {
		Position = UDim2.fromOffset(340, 0),
		Size = UDim2.new(1, 0, 0, 72),
		BackgroundColor3 = THEME.Window,
		BackgroundTransparency = 0.06,
		AutoButtonColor = false,
		Text = "",
		Parent = wrapper,
	})
	corner(toast, 14)
	staticAccent(stroke(toast, 0.3, 1.5), 45)

	label({
		Position = UDim2.fromOffset(18, 14),
		Size = UDim2.new(1, -32, 0, 20),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = toast,
	})
	label({
		Position = UDim2.fromOffset(18, 35),
		Size = UDim2.new(1, -32, 0, 18),
		Text = text,
		Font = FONT_REGULAR,
		TextSize = 13,
		TextColor3 = COMMON.SubText,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = toast,
	})
	local progress = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 14, 1, -8),
		Size = UDim2.new(1, -28, 0, 3),
		BackgroundColor3 = COMMON.White,
		Parent = toast,
	})
	round(progress)
	staticAccent(progress, 0)

	tween(wrapper, 0.35, { Size = UDim2.new(1, 0, 0, 72) })
	tween(toast, 0.6, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
	tween(progress, duration, { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)

	local closed = false
	local close
	function close()
		if closed then
			return
		end
		closed = true
		local index = table.find(openToasts, close)
		if index then
			table.remove(openToasts, index)
		end
		local slide = tween(toast, 0.4, { Position = UDim2.fromOffset(340, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		slide.Completed:Connect(function()
			local shrink = tween(wrapper, 0.25, { Size = UDim2.new(1, 0, 0, 0) })
			shrink.Completed:Connect(function()
				wrapper:Destroy()
			end)
		end)
	end
	toast.MouseButton1Click:Connect(close)
	table.insert(openToasts, close)
	task.delay(duration, close)
end

local holder = create("Frame", {
	Name = "Holder",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height),
	BackgroundTransparency = 1,
	Visible = false,
	Parent = gui,
})
local fitScale = create("UIScale", { Parent = holder })

local window = create("Frame", {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Parent = holder,
})
local popScale = create("UIScale", { Scale = 0, Parent = window })

local TOP = 70
local windowLayers = {}

for i = 1, 4 do
	local spread = i * 8
	local shadow = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 10 - spread / 2),
		Size = UDim2.new(1, spread, 1, spread),
		BackgroundColor3 = COMMON.Black,
		BackgroundTransparency = 0.9 + i * 0.02,
		ZIndex = 0,
		Parent = window,
	})
	corner(shadow, 16 + spread / 2)
	table.insert(windowLayers, { shadow, UDim2.new(1, spread, 0, TOP + spread), UDim2.new(1, spread, 1, spread) })
end

for _, layer in ipairs({ { 2, 0.72 }, { 7, 0.88 }, { 14, 0.95 } }) do
	local glow = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 1,
		Parent = window,
	})
	corner(glow, 16)
	accent(stroke(glow, layer[2], layer[1]), 45, true)
	table.insert(windowLayers, { glow, UDim2.new(1, 0, 0, TOP), UDim2.fromScale(1, 1) })
end

local main = create("Frame", {
	Name = "Main",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = THEME.Window,
	BackgroundTransparency = CONFIG.Transparency,
	ClipsDescendants = true,
	Active = true,
	ZIndex = 2,
	Parent = window,
})
paint(main, "BackgroundColor3", "Window")
corner(main, 16)
accent(stroke(main, 0.15, 1.5), 45, true)
create("UIGradient", {
	Rotation = 90,
	Color = ColorSequence.new(COMMON.White, Color3.fromRGB(178, 168, 162)),
	Transparency = NumberSequence.new(0, 0.18),
	Parent = main,
})
table.insert(windowLayers, { main, UDim2.new(1, 0, 0, TOP), UDim2.fromScale(1, 1) })

state.freeMouse = create("TextButton", {
	Name = "FreeMouse",
	Modal = true,
	Visible = false,
	Size = UDim2.fromOffset(1, 1),
	BackgroundTransparency = 1,
	Text = "",
	AutoButtonColor = false,
	Parent = main,
})

local shine = create("Frame", {
	Size = UDim2.new(1, 0, 0, 150),
	BackgroundColor3 = COMMON.White,
	BackgroundTransparency = 0.94,
	ZIndex = 1,
	Parent = main,
})
create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = shine })

local topBar = create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, TOP),
	BackgroundTransparency = 1,
	ZIndex = 3,
	Parent = main,
})

local logo = create("Frame", {
	Position = UDim2.fromOffset(18, 15),
	Size = UDim2.fromOffset(40, 40),
	BackgroundColor3 = THEME.Field,
	BackgroundTransparency = 0.1,
	Parent = topBar,
})
paint(logo, "BackgroundColor3", "Field")
corner(logo, 12)
accent(stroke(logo, 0, 1.5), 0, true)
local logoEmoji = label({
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	Text = CONFIG.Logo,
	Font = FONT_BOLD,
	TextSize = 20,
	TextXAlignment = Enum.TextXAlignment.Center,
	Parent = logo,
})

local titleRow = create("Frame", {
	Position = UDim2.fromOffset(70, 11),
	Size = UDim2.fromOffset(0, 28),
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1,
	Parent = topBar,
})
create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = titleRow,
})
local titleLabel = label({
	Size = UDim2.fromOffset(0, 26),
	AutomaticSize = Enum.AutomaticSize.X,
	Text = CONFIG.Title,
	Font = FONT_BOLD,
	TextSize = 19,
	TextColor3 = COMMON.White,
	LayoutOrder = 1,
	Parent = titleRow,
})
shimmer(titleLabel)
local versionPill = create("Frame", {
	Size = UDim2.fromOffset(0, 24),
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundColor3 = COMMON.Green,
	LayoutOrder = 3,
	Parent = titleRow,
})
round(versionPill)
padding(versionPill, 0, 12, 0, 12)
local versionGlow = stroke(versionPill, 0.5, 2, COMMON.Green)
label({
	Size = UDim2.fromScale(0, 1),
	AutomaticSize = Enum.AutomaticSize.X,
	Text = CONFIG.Version,
	Font = FONT_BOLD,
	TextSize = 13,
	TextColor3 = Color3.fromRGB(14, 30, 18),
	Parent = versionPill,
})

local authorLabel
authorLabel = label({
	Position = UDim2.fromOffset(70, 42),
	Size = UDim2.fromOffset(260, 16),
	Text = CONFIG.Author,
	Font = FONT_BOLD,
	TextSize = 13,
	TextColor3 = COMMON.White,
	Parent = topBar,
})
onLanguage(function()
	authorLabel.Text = trf("by %s", player.Name)
end)
accent(authorLabel, 0, false)

local hoveringWindowButton = false

local function iconBar(parent, width, height, rotation, position)
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position or UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height),
		Rotation = rotation or 0,
		BackgroundColor3 = THEME.Accent,
		Parent = parent,
	})
	round(bar)
	return bar
end

local function windowButton(kind, offsetX)
	local isClose = kind == "close"
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, offsetX, 0.5, 0),
		Size = UDim2.fromOffset(32, 32),
		BackgroundColor3 = isClose and COMMON.Close or THEME.Card,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = topBar,
	})
	corner(button, 10)
	if not isClose then
		paint(button, "BackgroundColor3", "Card")
	end

	local icon = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		Parent = button,
	})
	local bars = {}
	if isClose then
		table.insert(bars, iconBar(icon, 16, 2, 45))
		table.insert(bars, iconBar(icon, 16, 2, -45))
	elseif kind == "minimize" then
		table.insert(bars, iconBar(icon, 14, 2, 0))
	else
		for _, c in ipairs({ { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 } }) do
			table.insert(bars, iconBar(icon, 5, 2, 0, UDim2.new(0.5, c[1] * 4.5, 0.5, c[2] * 6)))
			table.insert(bars, iconBar(icon, 2, 5, 0, UDim2.new(0.5, c[1] * 6, 0.5, c[2] * 4.5)))
		end
	end

	local hovered = false
	local function recolor(duration)
		for _, bar in ipairs(bars) do
			tween(bar, duration, { BackgroundColor3 = hovered and COMMON.White or THEME.Accent })
		end
	end
	onTheme(function(instant)
		recolor(instant and 0 or 0.45)
	end)

	button.MouseEnter:Connect(function()
		hovered = true
		hoveringWindowButton = true
		tween(button, 0.2, { BackgroundTransparency = isClose and 0.1 or 0.35 })
		if isClose then
			tween(icon, 0.35, { Rotation = 90 })
		end
		recolor(0.2)
	end)
	button.MouseLeave:Connect(function()
		hovered = false
		hoveringWindowButton = false
		tween(button, 0.2, { BackgroundTransparency = 1 })
		tween(icon, 0.35, { Rotation = 0 })
		recolor(0.2)
	end)

	local function reset()
		hovered = false
		hoveringWindowButton = false
		button.BackgroundTransparency = 1
		icon.Rotation = 0
		recolor(0)
	end
	return button, reset
end

local closeButton, resetCloseButton = windowButton("close", -16)
local maximizeButton = windowButton("maximize", -54)
local minimizeButton = windowButton("minimize", -92)

local headerLine = create("Frame", {
	Position = UDim2.new(0, 16, 0, TOP - 1),
	Size = UDim2.new(1, -32, 0, 1),
	BackgroundColor3 = COMMON.White,
	ZIndex = 3,
	Parent = main,
})
accent(headerLine, 0, false).Transparency = fadeEdges(0.45)

local body = create("Frame", {
	Name = "Body",
	Position = UDim2.fromOffset(0, TOP),
	Size = UDim2.new(1, 0, 1, -TOP),
	BackgroundTransparency = 1,
	ZIndex = 3,
	Parent = main,
})

local SIDEBAR_W = 232
local sidebar = create("Frame", {
	Name = "Sidebar",
	Position = UDim2.fromOffset(14, 12),
	Size = UDim2.new(0, SIDEBAR_W, 1, -26),
	BackgroundTransparency = 1,
	Parent = body,
})

local searchFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundColor3 = THEME.Field,
	BackgroundTransparency = 0.25,
	Parent = sidebar,
})
paint(searchFrame, "BackgroundColor3", "Field")
corner(searchFrame, 12)
local searchStroke = stroke(searchFrame, 0.85, 1)
local searchBox = create("TextBox", {
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(1, -48, 1, 0),
	BackgroundTransparency = 1,
	ClearTextOnFocus = false,
	Text = "",
	PlaceholderText = "Search...",
	PlaceholderColor3 = THEME.IconTint,
	TextColor3 = COMMON.Text,
	Font = FONT_MEDIUM,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = searchFrame,
})
paint(searchBox, "PlaceholderColor3", "IconTint")
local clearButton = create("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -9, 0.5, 0),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = COMMON.White,
	BackgroundTransparency = 0.88,
	AutoButtonColor = false,
	Text = "×",
	Font = FONT_BOLD,
	TextSize = 16,
	TextColor3 = COMMON.Text,
	Visible = false,
	Parent = searchFrame,
})
round(clearButton)

local TAB_H, TAB_GAP = 42, 4
local tabScroll = create("ScrollingFrame", {
	Position = UDim2.fromOffset(0, 52),
	Size = UDim2.new(1, 0, 1, -52 - 82),
	BackgroundTransparency = 1,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = COMMON.SubText,
	ScrollBarImageTransparency = 0.5,
	Parent = sidebar,
})
local tabHighlight = create("Frame", {
	Size = UDim2.new(1, -10, 0, TAB_H),
	BackgroundColor3 = COMMON.White,
	BackgroundTransparency = 0.9,
	Visible = false,
	Parent = tabScroll,
})
corner(tabHighlight, 12)
local highlightBar = create("Frame", {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.fromScale(0, 0.5),
	Size = UDim2.fromOffset(3, 18),
	BackgroundColor3 = COMMON.White,
	Parent = tabHighlight,
})
round(highlightBar)
accent(highlightBar, 90, false)
local tabButtons = create("Frame", {
	Size = UDim2.new(1, -10, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 2,
	Parent = tabScroll,
})
create("UIListLayout", { Padding = UDim.new(0, TAB_GAP), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabButtons })

local profileCard = create("TextButton", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.fromScale(0, 1),
	Size = UDim2.new(1, 0, 0, 70),
	BackgroundColor3 = THEME.Card,
	BackgroundTransparency = 0.35,
	AutoButtonColor = false,
	Text = "",
	Parent = sidebar,
})
paint(profileCard, "BackgroundColor3", "Card")
corner(profileCard, 14)
local profileStroke = stroke(profileCard, 0.92, 1)
local avatarHolder = create("Frame", {
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 12, 0.5, 0),
	Size = UDim2.fromOffset(46, 46),
	BackgroundColor3 = THEME.Field,
	Parent = profileCard,
})
paint(avatarHolder, "BackgroundColor3", "Field")
round(avatarHolder)
accent(stroke(avatarHolder, 0, 2), 0, true)
local avatarImage = create("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(player.UserId),
	Parent = avatarHolder,
})
round(avatarImage)
local onlineDot = create("Frame", {
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 2, 1, 2),
	Size = UDim2.fromOffset(13, 13),
	BackgroundColor3 = COMMON.Green,
	ZIndex = 3,
	Parent = avatarHolder,
})
round(onlineDot)
paint(stroke(onlineDot, 0, 2), "Color", "Card")
local onlinePulse = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = COMMON.Green,
	BackgroundTransparency = 1,
	Parent = onlineDot,
})
round(onlinePulse)
label({
	Position = UDim2.fromOffset(70, 15),
	Size = UDim2.new(1, -80, 0, 20),
	Text = player.DisplayName,
	Font = FONT_BOLD,
	TextSize = 16,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = profileCard,
})
label({
	Position = UDim2.fromOffset(70, 37),
	Size = UDim2.new(1, -80, 0, 16),
	Text = "@" .. player.Name,
	Font = FONT_REGULAR,
	TextSize = 13,
	TextColor3 = COMMON.SubText,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Parent = profileCard,
})
profileCard.MouseEnter:Connect(function()
	tween(profileStroke, 0.25, { Transparency = 0.75 })
end)
profileCard.MouseLeave:Connect(function()
	tween(profileStroke, 0.25, { Transparency = 0.92 })
end)

local separator = create("Frame", {
	Position = UDim2.fromOffset(14 + SIDEBAR_W + 12, 14),
	Size = UDim2.new(0, 1, 1, -28),
	BackgroundColor3 = COMMON.White,
	Parent = body,
})
create("UIGradient", { Rotation = 90, Transparency = fadeEdges(0.82), Parent = separator })

local CONTENT_X = 14 + SIDEBAR_W + 26
local content = create("Frame", {
	Name = "Content",
	Position = UDim2.fromOffset(CONTENT_X, 4),
	Size = UDim2.new(1, -CONTENT_X - 10, 1, -10),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Parent = body,
})

local tabs = {}
local selectedTab = nil
local layoutOrder = 0

local function nextOrder()
	layoutOrder = layoutOrder + 1
	return layoutOrder
end

local function tabOffsetY(target)
	local y = 0
	for _, tab in ipairs(tabs) do
		if tab == target then
			return y
		end
		if tab.Button.Visible then
			y = y + TAB_H + TAB_GAP
		end
	end
	return y
end

local function refreshTabs(duration)
	for _, tab in ipairs(tabs) do
		local active = tab == selectedTab
		tween(tab.Icon, duration, { TextColor3 = active and THEME.Accent or THEME.IconTint })
		tween(tab.Label, duration, { TextColor3 = active and COMMON.White or COMMON.TabText })
	end
	if selectedTab and selectedTab.Button.Visible then
		tabHighlight.Visible = true
		tween(tabHighlight, duration, { Position = UDim2.fromOffset(0, tabOffsetY(selectedTab)) })
	else
		tabHighlight.Visible = false
	end
end
onTheme(function(instant)
	refreshTabs(instant and 0 or 0.45)
end)

local function selectTab(tab)
	if selectedTab == tab then
		return
	end
	selectedTab = tab
	for _, other in ipairs(tabs) do
		other.Page.Visible = other == tab
	end
	refreshTabs(0.35)
	tab.Page.CanvasPosition = Vector2.new(0, 0)
	tab.Page.Position = UDim2.fromOffset(0, 22)
	tween(tab.Page, 0.45, { Position = UDim2.fromOffset(0, 0) })
	tab.Underline.Size = UDim2.fromOffset(0, 3)
	tween(tab.Underline, 0.7, { Size = UDim2.fromOffset(46, 3) })
end

local function createTab(name, icon, subtitle)
	local button = create("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, TAB_H),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = nextOrder(),
		Parent = tabButtons,
	})
	local inner = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = button })
	local iconLabel = label({
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(0, 24, 1, 0),
		Text = icon,
		Font = FONT_BOLD,
		TextSize = 18,
		TextColor3 = THEME.IconTint,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = inner,
	})
	local nameLabel = label({
		Position = UDim2.fromOffset(48, 0),
		Size = UDim2.new(1, -54, 1, 0),
		Text = name,
		TextSize = 15,
		TextColor3 = COMMON.TabText,
		Parent = inner,
	})

	local page = create("ScrollingFrame", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = COMMON.SubText,
		ScrollBarImageTransparency = 0.5,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		Visible = false,
		Parent = content,
	})
	create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
	padding(page, 6, 12, 18, 2)

	local header = create("Frame", {
		Size = UDim2.new(1, 0, 0, 64),
		BackgroundTransparency = 1,
		LayoutOrder = nextOrder(),
		Parent = page,
	})
	label({
		Size = UDim2.new(1, 0, 0, 30),
		Text = name,
		Font = FONT_BOLD,
		TextSize = 24,
		Parent = header,
	})
	label({
		Position = UDim2.fromOffset(0, 32),
		Size = UDim2.new(1, 0, 0, 18),
		Text = subtitle or "",
		Font = FONT_REGULAR,
		TextSize = 14,
		TextColor3 = COMMON.SubText,
		Parent = header,
	})
	local underline = create("Frame", {
		Position = UDim2.fromOffset(0, 58),
		Size = UDim2.fromOffset(46, 3),
		BackgroundColor3 = COMMON.White,
		Parent = header,
	})
	round(underline)
	accent(underline, 0, false)

	local tab = {
		Name = name,
		Button = button,
		Inner = inner,
		Icon = iconLabel,
		Label = nameLabel,
		Page = page,
		Underline = underline,
	}
	table.insert(tabs, tab)

	button.MouseEnter:Connect(function()
		tween(inner, 0.25, { Position = UDim2.fromOffset(5, 0) })
		if selectedTab ~= tab then
			tween(nameLabel, 0.25, { TextColor3 = COMMON.White })
		end
	end)
	button.MouseLeave:Connect(function()
		tween(inner, 0.25, { Position = UDim2.fromOffset(0, 0) })
		if selectedTab ~= tab then
			tween(nameLabel, 0.25, { TextColor3 = COMMON.TabText })
		end
	end)
	button.MouseButton1Click:Connect(function()
		selectTab(tab)
	end)

	return page, tab
end

local function playTabEntrance()
	for index, tab in ipairs(tabs) do
		tab.Inner.Position = UDim2.fromOffset(-28, 0)
		tab.Icon.TextTransparency = 1
		tab.Label.TextTransparency = 1
		task.delay(0.1 + index * 0.05, function()
			tween(tab.Inner, 0.5, { Position = UDim2.fromOffset(0, 0) })
			tween(tab.Icon, 0.5, { TextTransparency = 0 })
			tween(tab.Label, 0.5, { TextTransparency = 0 })
		end)
	end
end

local function lowerText(text)
	local ok, result = pcall(function()
		local out = {}
		for _, code in utf8.codes(text) do
			if code >= 0x0410 and code <= 0x042F then
				code = code + 0x20
			elseif code == 0x0401 then
				code = 0x0451
			elseif code >= 65 and code <= 90 then
				code = code + 32
			end
			table.insert(out, utf8.char(code))
		end
		return table.concat(out)
	end)
	return ok and result or string.lower(text)
end

local function applySearch()
	local query = lowerText(searchBox.Text)
	for _, tab in ipairs(tabs) do
		tab.Button.Visible = query == "" or string.find(lowerText(tab.Name), query, 1, true) ~= nil
			or string.find(lowerText(tr(tab.Name)), query, 1, true) ~= nil
	end
	clearButton.Visible = searchBox.Text ~= ""
	refreshTabs(0.3)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)
searchBox.Focused:Connect(function()
	tween(searchStroke, 0.25, { Color = THEME.Accent, Transparency = 0.2 })
end)
searchBox.FocusLost:Connect(function(enterPressed)
	tween(searchStroke, 0.25, { Color = COMMON.White, Transparency = 0.85 })
	if enterPressed then
		for _, tab in ipairs(tabs) do
			if tab.Button.Visible then
				selectTab(tab)
				break
			end
		end
	end
end)
clearButton.MouseButton1Click:Connect(function()
	searchBox.Text = ""
end)

local menuVisible = false
local minimized = false
local maximized = false
local introDone = true

local function updateBlur()
	local target = (CONFIG.Blur and menuVisible and not minimized) and CONFIG.BlurSize or 0
	tween(blur, 0.45, { Size = target })
end

local function fitToScreen()
	local viewport = camera.ViewportSize
	local margin, topMargin = 20, 20
	if state.screenMargins then
		margin, topMargin = state.screenMargins()
	end
	local base = math.min(
		(viewport.X - 100) / CONFIG.Width,
		(viewport.Y - topMargin - margin) / CONFIG.Height,
		1
	)
	fitScale.Scale = math.max(base, 0.45)
	if state.keepWindowOnScreen then
		state.keepWindowOnScreen(0.3)
	end
end

function state.screenMargins()
	local margin = CONFIG.ScreenMargin
	local ok, inset = pcall(function()
		return game:GetService("GuiService"):GetGuiInset()
	end)
	local topBar = (ok and typeof(inset) == "Vector2") and inset.Y or 0
	return margin, math.max(margin, topBar + 8)
end

function state.windowOffset(x, y)
	local viewport = camera.ViewportSize
	local scale = fitScale.Scale
	local factor = maximized and 1.15 or 1
	local width = CONFIG.Width * factor * scale
	local height = CONFIG.Height * factor * scale
	local visibleHeight = minimized and TOP * scale or height
	local margin, topMargin = state.screenMargins()

	local maxX = viewport.X / 2 - width / 2 - margin
	x = maxX >= 0 and math.clamp(x, -maxX, maxX) or 0

	local minY = height / 2 - viewport.Y / 2 + topMargin
	local maxY = viewport.Y / 2 + height / 2 - visibleHeight - margin
	if minY <= maxY then
		y = math.clamp(y, minY, maxY)
	else
		y = minY
	end
	return x, y
end

function state.keepWindowOnScreen(duration)
	local position = holder.Position
	local x, y = state.windowOffset(position.X.Offset, position.Y.Offset)
	if x ~= position.X.Offset or y ~= position.Y.Offset then
		tween(holder, duration or 0.3, { Position = UDim2.new(0.5, x, 0.5, y) })
	end
end

local openDock = create("Frame", {
	Name = "OpenButton",
	AnchorPoint = Vector2.new(0, 0.5),
	Position = UDim2.new(0, 18, 0.5, 0),
	Size = UDim2.fromOffset(52, 52),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = gui,
})
local openScale = create("UIScale", { Parent = openDock })
local openPulse = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = THEME.Accent,
	BackgroundTransparency = 1,
	Parent = openDock,
})
paint(openPulse, "BackgroundColor3", "Accent")
round(openPulse)
local openButton = create("TextButton", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = THEME.Window,
	BackgroundTransparency = 0.1,
	AutoButtonColor = false,
	Text = "",
	ZIndex = 2,
	Parent = openDock,
})
paint(openButton, "BackgroundColor3", "Window")
round(openButton)
accent(stroke(openButton, 0, 2), 0, true)
local openEmoji = label({
	Size = UDim2.fromScale(1, 1),
	Text = CONFIG.Logo,
	Font = FONT_BOLD,
	TextSize = 22,
	TextXAlignment = Enum.TextXAlignment.Center,
	Parent = openButton,
})

local function setMenuVisible(visible)
	if menuVisible == visible then
		return
	end
	menuVisible = visible
	state.freeMouse.Visible = visible
	if not visible and state.onMenuClosed then
		task.spawn(state.onMenuClosed)
	end
	if visible then
		holder.Visible = true
		tween(popScale, 0.55, { Scale = 1 }, Enum.EasingStyle.Back)
		playTabEntrance()
	else
		local closing = tween(popScale, 0.3, { Scale = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		closing.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed and not menuVisible then
				holder.Visible = false
			end
		end)
	end
	tween(openScale, 0.3, { Scale = visible and 0.9 or 1 })
	updateBlur()
end

local function setMinimized(value)
	minimized = value
	if minimized then
		body.Visible = false
	end
	local resize
	for _, layer in ipairs(windowLayers) do
		local animation = tween(layer[1], 0.45, { Size = minimized and layer[2] or layer[3] })
		if layer[1] == main then
			resize = animation
		end
	end
	if not minimized and resize then
		resize.Completed:Connect(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed and not minimized then
				body.Visible = true
			end
		end)
	end
	updateBlur()
	state.keepWindowOnScreen(0.45)
end

local function setMaximized(value)
	maximized = value
	local factor = maximized and 1.15 or 1
	tween(holder, 0.45, { Size = UDim2.fromOffset(CONFIG.Width * factor, CONFIG.Height * factor) })
	state.keepWindowOnScreen(0.45)
end

local function halloweenCountdown()
	local now = os.date("*t")
	local today = os.time({ year = now.year, month = now.month, day = now.day, hour = 12 })
	local target = os.time({ year = now.year, month = 10, day = 31, hour = 12 })
	if target < today then
		target = os.time({ year = now.year + 1, month = 10, day = 31, hour = 12 })
	end
	local days = math.floor((target - today) / 86400 + 0.5)
	return days == 0 and tr("Today!") or trf("%d days", days)
end

local function section(page, title)
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = nextOrder(),
		Parent = page,
	})
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(0, 21),
		Size = UDim2.fromOffset(4, 16),
		BackgroundColor3 = COMMON.White,
		Parent = row,
	})
	round(bar)
	accent(bar, 90, false)
	label({
		Position = UDim2.fromOffset(12, 8),
		Size = UDim2.new(1, -12, 0, 26),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 17,
		Parent = row,
	})
	return row
end

local function card(page, height, className)
	local frame = create(className or "Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = THEME.Card,
		BackgroundTransparency = 0.3,
		LayoutOrder = nextOrder(),
		Parent = page,
	})
	if className == "TextButton" then
		frame.AutoButtonColor = false
		frame.Text = ""
	end
	paint(frame, "BackgroundColor3", "Card")
	corner(frame, 12)
	local cardStroke = stroke(frame, 0.93, 1)
	frame.MouseEnter:Connect(function()
		tween(cardStroke, 0.25, { Transparency = 0.8 })
		tween(frame, 0.25, { BackgroundTransparency = 0.22 })
	end)
	frame.MouseLeave:Connect(function()
		tween(cardStroke, 0.25, { Transparency = 0.93 })
		tween(frame, 0.25, { BackgroundTransparency = 0.3 })
	end)
	return frame
end

local function paragraph(page, title, text)
	local frame = card(page, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	padding(frame, 14, 16, 14, 16)
	create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame })
	label({
		Size = UDim2.new(1, 0, 0, 20),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 16,
		LayoutOrder = 1,
		Parent = frame,
	})
	local textLabel = label({
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = text,
		TextWrapped = true,
		Font = FONT_REGULAR,
		TextSize = 14,
		TextColor3 = COMMON.SubText,
		LayoutOrder = 2,
		Parent = frame,
	})
	return frame, textLabel
end

local function toggle(page, icon, title, description, default, callback)
	local frame = card(page, 66, "TextButton")

	local textX = 18
	if icon then
		textX = 64
		local bubble = create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 14, 0.5, 0),
			Size = UDim2.fromOffset(38, 38),
			BackgroundColor3 = THEME.Field,
			Parent = frame,
		})
		paint(bubble, "BackgroundColor3", "Field")
		corner(bubble, 10)
		label({
			Size = UDim2.fromScale(1, 1),
			Text = icon,
			TextSize = 19,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = bubble,
		})
	end
	label({
		Position = UDim2.fromOffset(textX, 13),
		Size = UDim2.new(1, -textX - 76, 0, 20),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	local descriptionLabel = label({
		Position = UDim2.fromOffset(textX, 35),
		Size = UDim2.new(1, -textX - 76, 0, 18),
		Text = description,
		Font = FONT_REGULAR,
		TextSize = 13,
		TextColor3 = COMMON.SubText,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})

	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(48, 26),
		BackgroundColor3 = THEME.TrackOff,
		Parent = frame,
	})
	paint(track, "BackgroundColor3", "TrackOff")
	round(track)
	local trackStroke = stroke(track, 0.85, 1)
	local fill = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = COMMON.White,
		BackgroundTransparency = 1,
		Parent = track,
	})
	round(fill)
	accent(fill, 0, false)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 4, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = COMMON.White,
		ZIndex = 2,
		Parent = track,
	})
	round(knob)

	local state = default == true
	local function render(duration)
		tween(fill, duration, { BackgroundTransparency = state and 0 or 1 })
		tween(trackStroke, duration, { Transparency = state and 1 or 0.85 })
		tween(knob, duration, {
			Position = state and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
		}, Enum.EasingStyle.Back)
	end
	render(0)

	local api = {}
	function api.Set(value)
		state = value == true
		render(0.35)
		if callback then
			task.spawn(callback, state)
		end
	end
	function api.Get()
		return state
	end
	function api.SetDescription(text)
		descriptionLabel.Text = text
	end
	function api.Sync(value)
		value = value == true
		if value ~= state then
			state = value
			render(0.25)
		end
	end

	frame.MouseButton1Click:Connect(function()
		api.Set(not state)
	end)
	return api
end

local function slider(page, title, minimum, maximum, default, suffix, callback, formatter)
	local frame = card(page, 76)
	label({
		Position = UDim2.fromOffset(18, 13),
		Size = UDim2.new(1, -130, 0, 20),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	local valueLabel = label({
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -18, 0, 13),
		Size = UDim2.fromOffset(110, 20),
		Text = "",
		Font = FONT_BOLD,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = frame,
	})
	paint(valueLabel, "TextColor3", "Accent2")

	local hitbox = create("TextButton", {
		Position = UDim2.new(0, 18, 0, 40),
		Size = UDim2.new(1, -36, 0, 26),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = frame,
	})
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = THEME.TrackOff,
		Parent = hitbox,
	})
	paint(bar, "BackgroundColor3", "TrackOff")
	round(bar)
	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = COMMON.White,
		Parent = bar,
	})
	round(fill)
	accent(fill, 0, false)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = COMMON.White,
		ZIndex = 2,
		Parent = bar,
	})
	round(knob)
	paint(stroke(knob, 0.2, 2), "Color", "Accent")

	local value = math.clamp(default, minimum, maximum)
	local function render(duration)
		local alpha = (value - minimum) / (maximum - minimum)
		tween(fill, duration, { Size = UDim2.fromScale(alpha, 1) })
		tween(knob, duration, { Position = UDim2.fromScale(alpha, 0.5) })
		valueLabel.Text = formatter and formatter(value) or (value .. (suffix or ""))
	end
	render(0)

	local api = {}
	function api.Set(newValue)
		newValue = math.clamp(math.floor(newValue + 0.5), minimum, maximum)
		if newValue == value then
			return
		end
		value = newValue
		render(0.12)
		if callback then
			task.spawn(callback, value)
		end
	end
	function api.Get()
		return value
	end
	function api.Sync(newValue)
		newValue = math.clamp(math.floor(newValue + 0.5), minimum, maximum)
		if newValue ~= value then
			value = newValue
			render(0.12)
		end
	end
	if formatter then
		table.insert(languageHooks, function()
			render(0)
		end)
	end

	local sliding = false
	local function slideTo(input)
		local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		api.Set(minimum + (maximum - minimum) * alpha)
	end
	hitbox.InputBegan:Connect(function(input)
		if isPress(input) then
			sliding = true
			tween(knob, 0.15, { Size = UDim2.fromOffset(20, 20) })
			slideTo(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if sliding and isMove(input) then
			slideTo(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if sliding and isPress(input) then
			sliding = false
			tween(knob, 0.15, { Size = UDim2.fromOffset(16, 16) })
		end
	end)
	return api
end

local bindingKey = false

local function keybind(page, title, configKey, onChanged)
	local frame = card(page, 58)
	label({
		Position = UDim2.fromOffset(18, 0),
		Size = UDim2.new(1, -170, 1, 0),
		Text = title,
		Font = FONT_BOLD,
		TextSize = 15,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(0, 32),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = THEME.Field,
		AutoButtonColor = false,
		Text = CONFIG[configKey].Name,
		Font = FONT_BOLD,
		TextSize = 14,
		TextColor3 = COMMON.Text,
		Parent = frame,
	})
	paint(button, "BackgroundColor3", "Field")
	corner(button, 9)
	padding(button, 0, 14, 0, 14)
	local buttonStroke = stroke(button, 0.85, 1)

	local waiting = false
	button.MouseButton1Click:Connect(function()
		if waiting then
			return
		end
		waiting = true
		bindingKey = true
		button.Text = "Press a key..."
		tween(buttonStroke, 0.2, { Color = THEME.Accent, Transparency = 0 })

		local connection
		connection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			connection:Disconnect()
			waiting = false
			local key = input.KeyCode
			if key ~= Enum.KeyCode.Escape and key ~= Enum.KeyCode.Unknown then
				CONFIG[configKey] = key
				if onChanged then
					onChanged(key)
				end
			end
			button.Text = CONFIG[configKey].Name
			tween(buttonStroke, 0.2, { Color = COMMON.White, Transparency = 0.85 })
			task.delay(0.2, function()
				bindingKey = false
			end)
		end)
	end)
end

local function statGrid(page, items)
	local grid = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = nextOrder(),
		Parent = page,
	})
	create("UIGridLayout", {
		CellSize = UDim2.new(1 / 3, -8, 0, 70),
		CellPadding = UDim2.fromOffset(12, 12),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})
	local values = {}
	for index, item in ipairs(items) do
		local tile = create("Frame", {
			BackgroundColor3 = THEME.Card,
			BackgroundTransparency = 0.3,
			LayoutOrder = index,
			Parent = grid,
		})
		paint(tile, "BackgroundColor3", "Card")
		corner(tile, 12)
		stroke(tile, 0.93, 1)
		values[index] = label({
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.new(1, -20, 0, 24),
			Text = item[1],
			Font = FONT_BOLD,
			TextSize = 18,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = tile,
		})
		label({
			Position = UDim2.fromOffset(14, 42),
			Size = UDim2.new(1, -20, 0, 14),
			Text = item[2],
			Font = FONT_REGULAR,
			TextSize = 12,
			TextColor3 = COMMON.SubText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = tile,
		})
	end
	return values
end

local function hero(page)
	local banner = create("Frame", {
		Size = UDim2.new(1, 0, 0, 132),
		BackgroundColor3 = COMMON.White,
		ClipsDescendants = true,
		LayoutOrder = nextOrder(),
		Parent = page,
	})
	corner(banner, 16)
	stroke(banner, 0.85, 1)
	local gradient = create("UIGradient", {
		Rotation = 25,
		Transparency = NumberSequence.new(0.05, 0.25),
		Parent = banner,
	})
	onTheme(function()
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, THEME.Accent),
			ColorSequenceKeypoint.new(0.6, THEME.Accent:Lerp(THEME.Window, 0.55)),
			ColorSequenceKeypoint.new(1, THEME.Window),
		})
	end)
	for _, c in ipairs({ { 0.78, -0.1, 150, 0.9 }, { 0.62, 1.05, 90, 0.93 } }) do
		local circle = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(c[1], c[2]),
			Size = UDim2.fromOffset(c[3], c[3]),
			BackgroundColor3 = COMMON.White,
			BackgroundTransparency = c[4],
			Parent = banner,
		})
		round(circle)
	end
	local helloLabel = label({
		Position = UDim2.fromOffset(20, 22),
		Size = UDim2.new(1, -140, 0, 32),
		Text = "",
		Font = FONT_BOLD,
		TextSize = 26,
		TextColor3 = COMMON.White,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = banner,
	})
	onLanguage(function()
		helloLabel.Text = trf("Hello, %s!", player.Name)
	end)
	label({
		Position = UDim2.fromOffset(20, 56),
		Size = UDim2.new(1, -140, 0, 20),
		Text = "Happy Halloween",
		TextSize = 15,
		TextColor3 = COMMON.White,
		TextTransparency = 0.1,
		Parent = banner,
	})
	local tag = create("Frame", {
		Position = UDim2.fromOffset(20, 90),
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = COMMON.Black,
		BackgroundTransparency = 0.7,
		Parent = banner,
	})
	round(tag)
	padding(tag, 0, 12, 0, 12)
	label({
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = CONFIG.Title .. "  •  " .. CONFIG.Version,
		Font = FONT_BOLD,
		TextSize = 12,
		TextColor3 = COMMON.White,
		Parent = tag,
	})
	return banner
end

local function profileHeader(page)
	local frame = card(page, 112)
	local ring = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(78, 78),
		BackgroundColor3 = THEME.Field,
		Parent = frame,
	})
	paint(ring, "BackgroundColor3", "Field")
	round(ring)
	accent(stroke(ring, 0, 3), 0, true)
	local bust = create("ImageLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = ("rbxthumb://type=AvatarBust&id=%d&w=150&h=150"):format(player.UserId),
		Parent = ring,
	})
	round(bust)
	local dot = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -2, 1, -2),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = COMMON.Green,
		ZIndex = 2,
		Parent = ring,
	})
	round(dot)
	paint(stroke(dot, 0, 3), "Color", "Card")
	label({
		Position = UDim2.fromOffset(112, 20),
		Size = UDim2.new(1, -124, 0, 28),
		Text = player.DisplayName,
		Font = FONT_BOLD,
		TextSize = 22,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	label({
		Position = UDim2.fromOffset(112, 50),
		Size = UDim2.new(1, -124, 0, 18),
		Text = "@" .. player.Name,
		TextSize = 14,
		TextColor3 = COMMON.SubText,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = frame,
	})
	local idPill = create("Frame", {
		Position = UDim2.fromOffset(112, 76),
		Size = UDim2.fromOffset(0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = THEME.Field,
		Parent = frame,
	})
	paint(idPill, "BackgroundColor3", "Field")
	corner(idPill, 7)
	padding(idPill, 0, 10, 0, 10)
	label({
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = "ID " .. player.UserId,
		Font = FONT_BOLD,
		TextSize = 12,
		TextColor3 = COMMON.SubText,
		Parent = idPill,
	})
	return frame
end

local homePage = createTab("Home", "★", "Welcome!")
hero(homePage)
local homeStats = statGrid(homePage, {
	{ halloweenCountdown(), "until Halloween" },
	{ CONFIG.ToggleKey.Name, "toggle menu" },
	{ "RIVALS", "Current place" },
})
table.insert(languageHooks, function()
	homeStats[1].Text = halloweenCountdown()
end)
onTheme(function()
	homeStats[3].Text = THEME.Name
end)
section(homePage, "Quick start")
local _, homeHowText = paragraph(homePage, "How to use", "")

local function setupAim()
	local MarketplaceService = game:GetService("MarketplaceService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local AIM = {
		GamePassId = 0,
		AimMode = "Override",
		AimPart = "Head",
		FOV = 160,
		Smoothness = 0.85,
		InstantSnap = true,
		SpeedStep = 0.05,
		Prediction = 0,
		StickyTarget = true,
		LockGrace = 0,
		HoldToAim = true,
		HoldThroughWalls = true,
		AutoShoot = "All",
		AutoShootAngle = 10,
		AutoShootDelay = 0,
		AutoShootKey = Enum.KeyCode.V,
		KnifeAuto = true,
		KnifeAutoRange = 8.5,
		ESPShowWeapon = true,
		NoCameraShake = true,
		ShowKeybinds = true,
		TeamCheck = true,
		TeamMode = "Auto",
		TeamAttribute = "Team",
		WallCheck = true,
		TargetNPC = false,
		ShowFOV = true,
		ShowTargetInfo = true,
		Language = currentLanguage,
		HeadOnly = true,
		AimHeight = 0.2,
		ESP = true,
		ESPHighlight = true,
		ESPNames = true,
		ESPDistance = true,
		ESPHealth = true,
		ESPTracers = false,
		ESPTeammates = false,
		ESPMaxDistance = 1500,
		ToggleKey = Enum.KeyCode.F,
		AimHoldButton = Enum.UserInputType.MouseButton2,
		SpeedUpKey = Enum.KeyCode.Equals,
		SpeedDownKey = Enum.KeyCode.Minus,
		SnapKey = Enum.KeyCode.X,
	}
	local DEFAULTS = table.clone(AIM)

	local enabled = false
	local holding = false
	local hasPass = (AIM.GamePassId == 0)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

	local COLORS = {
		bg = Color3.fromRGB(14, 8, 20),
		bg2 = Color3.fromRGB(38, 18, 50),
		accent = Color3.fromRGB(255, 122, 26),
		slime = Color3.fromRGB(140, 236, 72),
		slimeDark = Color3.fromRGB(70, 150, 44),
		red = Color3.fromRGB(190, 28, 44),
		gold = Color3.fromRGB(255, 186, 64),
		enemy = Color3.fromRGB(255, 96, 36),
		team = Color3.fromRGB(130, 230, 255),
	}

	local function outline(inst, color, thickness, transparency)
		local s = Instance.new("UIStroke")
		s.Color = color
		s.Thickness = thickness or 1
		s.Transparency = transparency or 0
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = inst
		return s
	end

	local function loopTween(inst, props, time)
		local t = TweenService:Create(inst, TweenInfo.new(
			time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true
		), props)
		t:Play()
		return t
	end

	local function keyName(key)
		if key == Enum.KeyCode.Equals then return "+" end
		if key == Enum.KeyCode.Minus then return "−" end
		return key.Name
	end

	local hud = Instance.new("ScreenGui")
	hud.Name = "AimHud"
	hud.ResetOnSpawn = false
	hud.IgnoreGuiInset = true
	hud.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	hud.DisplayOrder = 5
	hud.Parent = playerGui

	local espFolder = Instance.new("Folder")
	espFolder.Name = "AimESP"
	espFolder.Parent = playerGui

	local circle = Instance.new("Frame")
	circle.Name = "FOVCircle"
	circle.AnchorPoint = Vector2.new(0.5, 0.5)
	circle.BackgroundTransparency = 1
	circle.Parent = hud
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	local circleStroke = outline(circle, COLORS.accent, 2, 0.25)
	loopTween(circleStroke, { Transparency = 0.6 }, 1.1)

	local targetInfo = Instance.new("TextLabel")
	targetInfo.Name = "TargetInfo"
	targetInfo.AnchorPoint = Vector2.new(0.5, 0)
	targetInfo.Position = UDim2.new(0.5, 0, 0, 14) -- Compact, clean at very top
	targetInfo.Size = UDim2.fromOffset(0, 24) -- Sleek pill badge
	targetInfo.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
	targetInfo.BackgroundTransparency = 0.25
	targetInfo.Font = Enum.Font.GothamBold
	targetInfo.TextSize = 13
	targetInfo.TextColor3 = COLORS.enemy
	targetInfo.Visible = false
	targetInfo.AutomaticSize = Enum.AutomaticSize.X
	targetInfo.Parent = hud
	local targetPad = Instance.new("UIPadding")
	targetPad.PaddingLeft = UDim.new(0, 12)
	targetPad.PaddingRight = UDim.new(0, 12)
	targetPad.Parent = targetInfo
	corner(targetInfo, 12) -- Pill rounded shape
	outline(targetInfo, COLORS.accent, 1, 0.4)

	local function makeSideButton(name, posY)
		local b = Instance.new("TextButton")
		b.Name = name
		b.AnchorPoint = Vector2.new(1, 0.5)
		b.Position = UDim2.new(1, -16, 0.35, posY)
		b.Size = UDim2.fromOffset(104, 40)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 14
		b.TextColor3 = Color3.new(1, 1, 1)
		b.BackgroundColor3 = COLORS.bg2
		b.BackgroundTransparency = 0.2
		b.AutoButtonColor = true
		b.Parent = hud
		corner(b, 12)
		outline(b, COLORS.accent, 1, 0.4)
		return b
	end

	local toggleBtn = makeSideButton("AimToggle", 0)

	local refreshers = {}
	local function refreshAll()
		for _, f in ipairs(refreshers) do
			f()
		end
	end

	local onSettingsChanged = function() end

	local function updateUI()
		local suffix = isMobile and "" or (" (" .. keyName(AIM.ToggleKey) .. ")")
		if not hasPass then
			toggleBtn.Text = tr("AIM: BUY")
			toggleBtn.BackgroundColor3 = COLORS.gold
		elseif enabled then
			toggleBtn.Text = tr("AIM: ON") .. suffix
			toggleBtn.BackgroundColor3 = COLORS.slimeDark
		else
			toggleBtn.Text = tr("AIM: OFF") .. suffix
			toggleBtn.BackgroundColor3 = COLORS.red
		end
		circle.Visible = AIM.ShowFOV and hasPass and enabled
		refreshAll()
		onSettingsChanged()
	end

	local function applyConfig()
		circle.Size = UDim2.fromOffset(AIM.FOV * 2, AIM.FOV * 2)
		updateUI()
	end

	local function buyPass()
		MarketplaceService:PromptGamePassPurchase(player, AIM.GamePassId)
	end

	local function toggleAim()
		if not hasPass then
			buyPass()
			return
		end
		enabled = not enabled
		updateUI()
	end

	toggleBtn.Activated:Connect(toggleAim)

	local speedInfo = Instance.new("TextLabel")
	speedInfo.Name = "SpeedInfo"
	speedInfo.AnchorPoint = Vector2.new(0.5, 0)
	speedInfo.Position = UDim2.new(0.5, 0, 0, 104)
	speedInfo.Size = UDim2.fromOffset(230, 26)
	speedInfo.BackgroundColor3 = COLORS.bg
	speedInfo.BackgroundTransparency = 0.15
	speedInfo.Font = Enum.Font.GothamBold
	speedInfo.TextSize = 14
	speedInfo.TextColor3 = COLORS.slime
	speedInfo.Visible = false
	speedInfo.Parent = hud
	corner(speedInfo, 8)

	local function isInstant()
		return AIM.InstantSnap or AIM.Smoothness >= 1
	end

	local function speedText()
		if isInstant() then
			return tr("Instant aim")
		end
		return trf("Aim speed: %d%%", math.floor(AIM.Smoothness * 100 + 0.5))
	end

	local speedShowId = 0
	local function showSpeed()
		speedShowId += 1
		local id = speedShowId
		speedInfo.Text = speedText()
		speedInfo.TextColor3 = isInstant() and COLORS.accent or COLORS.slime
		speedInfo.Visible = true
		task.delay(1.5, function()
			if speedShowId == id then
				speedInfo.Visible = false
			end
		end)
	end

	local function changeSpeed(dir)
		if not hasPass then return end
		if AIM.InstantSnap then
			if dir < 0 then
				AIM.InstantSnap = false
			end
			applyConfig()
			showSpeed()
			return
		end
		local v = AIM.Smoothness + dir * AIM.SpeedStep
		v = math.floor(v * 100 + 0.5) / 100
		AIM.Smoothness = math.clamp(v, 0.05, 1)
		applyConfig()
		showSpeed()
	end

	local function toggleSnap()
		if not hasPass then return end
		AIM.InstantSnap = not AIM.InstantSnap
		applyConfig()
		showSpeed()
	end

	local function makeSpeedButton(name, text, rightOffset)
		local b = makeSideButton(name, 52)
		b.Position = UDim2.new(1, -20 - rightOffset, 0.35, 52)
		b.Size = UDim2.fromOffset(34, 40)
		b.TextSize = 20
		b.Text = text
		return b
	end

	local speedUpBtn = makeSpeedButton("SpeedUp", "+", 0)
	local snapBtn = makeSpeedButton("InstantSnap", "MAX", 38)
	snapBtn.TextSize = 12
	local speedDownBtn = makeSpeedButton("SpeedDown", "−", 76)

	speedUpBtn.Activated:Connect(function()
		changeSpeed(1)
	end)
	speedDownBtn.Activated:Connect(function()
		changeSpeed(-1)
	end)
	snapBtn.Activated:Connect(toggleSnap)

	table.insert(refreshers, function()
		local show = hasPass and enabled
		speedUpBtn.Visible = show
		speedDownBtn.Visible = show
		snapBtn.Visible = show
		snapBtn.BackgroundColor3 = AIM.InstantSnap and COLORS.accent or COLORS.bg2
	end)

	local SAVE_KEYS = {}
	for k, v in pairs(DEFAULTS) do
		local t = typeof(v)
		if (t == "boolean" or t == "number" or t == "string")
			and k ~= "GamePassId" and k ~= "TeamAttribute" then
			table.insert(SAVE_KEYS, k)
		end
	end
	table.sort(SAVE_KEYS)

	local CHOICES = {
		AimMode = { Override = true, Classic = true },
		AimPart = { Head = true, UpperTorso = true, HumanoidRootPart = true },
		AutoShoot = { Phone = true, All = true, Off = true },
		TeamMode = { Auto = true, Off = true },
		Language = { en = true, ru = true, gd = true, fr = true },
	}

	local RANGES = {
		FOV = { 30, 800 }, Smoothness = { 0.05, 1 }, Prediction = { 0, 0.3 },
		LockGrace = { 0, 1 }, AutoShootAngle = { 0.5, 30 }, AutoShootDelay = { 0, 0.5 },
		KnifeAutoRange = { 3, 20 },
		ESPMaxDistance = { 50, 5000 }, SpeedStep = { 0.01, 0.5 },
		AimHeight = { -1, 1 },
	}

	local function exportCode()
		local parts = { "enabled=" .. (enabled and "1" or "0") }
		for _, k in ipairs(SAVE_KEYS) do
			local v = AIM[k]
			if type(v) == "boolean" then
				v = v and "1" or "0"
			elseif type(v) == "number" then
				v = string.format("%g", v)
			elseif typeof(v) == "EnumItem" then
				v = v.Name
			end
			table.insert(parts, k .. "=" .. tostring(v))
		end
		return table.concat(parts, ";")
	end

	local function importCode(code)
		if type(code) ~= "string" then return 0 end
		local applied = 0
		for pair in string.gmatch(code, "[^;]+") do
			local k, v = string.match(pair, "^%s*([%w_]+)%s*=%s*(.-)%s*$")
			if k == "enabled" then
				if v == "1" or v == "0" then
					applied += 1
				end
			elseif k and table.find(SAVE_KEYS, k) then
				local def = DEFAULTS[k]
				if type(def) == "boolean" and (v == "1" or v == "0" or v == "true" or v == "false") then
					AIM[k] = (v == "1" or v == "true")
					applied += 1
				elseif type(def) == "number" and tonumber(v) then
					local n = tonumber(v)
					local r = RANGES[k]
					if r then
						n = math.clamp(n, r[1], r[2])
					end
					AIM[k] = n
					applied += 1
				elseif type(def) == "string" and (not CHOICES[k] or CHOICES[k][v]) then
					AIM[k] = v
					applied += 1
				elseif typeof(def) == "EnumItem" then
					pcall(function()
						AIM[k] = Enum.KeyCode[v]
						applied += 1
					end)
				end
			end
		end
		return applied
	end

	local configStatus = nil
	local teamInfoLabel = nil

	local function setStatus(text, color)
		if configStatus then
			configStatus.Text = text
			configStatus.TextColor3 = color or COMMON.SubText
		end
	end

	local SAVE_DELAY = 0.6
	local persistReady = false
	local dirtyAt = nil
	local flushSave = function() end
	onSettingsChanged = function()
		if persistReady then
			dirtyAt = os.clock()
		end
	end

	local function getValue(key)
		if key == "enabled" then
			return enabled
		end
		return AIM[key]
	end

	local function aimToggle(page, title, description, key)
		local api
		local describe = type(description) == "function" and description or nil
		api = toggle(page, nil, title, describe and describe() or description, getValue(key), function(on)
			if key == "enabled" then
				if on and not hasPass then
					api.Sync(false)
					buyPass()
					return
				end
				enabled = on
			else
				AIM[key] = on
			end
			applyConfig()
		end)
		table.insert(refreshers, function()
			api.Sync(getValue(key))
		end)
		if describe then
			table.insert(languageHooks, function()
				api.SetDescription(describe())
			end)
		end
	end

	local function aimSlider(page, title, key, minimum, maximum, scale, formatter)
		local api
		api = slider(page, title, minimum, maximum, math.floor(AIM[key] * scale + 0.5), "", function(v)
			AIM[key] = v / scale
			applyConfig()
		end, formatter)
		table.insert(refreshers, function()
			api.Sync(math.floor(AIM[key] * scale + 0.5))
		end)
	end

	local function aimChoice(page, title, description, key, options)
		local frame = card(page, 66, "TextButton")
		label({
			Position = UDim2.fromOffset(18, 13),
			Size = UDim2.new(1, -170, 0, 20),
			Text = title,
			Font = FONT_BOLD,
			TextSize = 15,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = frame,
		})
		label({
			Position = UDim2.fromOffset(18, 35),
			Size = UDim2.new(1, -170, 0, 18),
			Text = description,
			Font = FONT_REGULAR,
			TextSize = 13,
			TextColor3 = COMMON.SubText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = frame,
		})
		local pill = create("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16, 0.5, 0),
			Size = UDim2.fromOffset(130, 30),
			BackgroundColor3 = THEME.Field,
			Font = FONT_BOLD,
			TextSize = 13,
			TextColor3 = THEME.Accent2,
			Text = "",
			Parent = frame,
		})
		paint(pill, "BackgroundColor3", "Field")
		paint(pill, "TextColor3", "Accent2")
		corner(pill, 9)
		local function sync()
			for _, opt in ipairs(options) do
				if opt[1] == AIM[key] then
					pill.Text = tr(opt[2]) .. "  ›"
				end
			end
		end
		frame.MouseButton1Click:Connect(function()
			local idx = 1
			for i, opt in ipairs(options) do
				if opt[1] == AIM[key] then
					idx = i
				end
			end
			AIM[key] = options[idx % #options + 1][1]
			applyConfig()
		end)
		table.insert(refreshers, sync)
		sync()
	end

	local function aimButton(page, text, callback)
		local button = card(page, 44, "TextButton")
		label({
			Size = UDim2.fromScale(1, 1),
			Text = text,
			Font = FONT_BOLD,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = button,
		})
		button.MouseButton1Click:Connect(callback)
		return button
	end

	local function aimKeybind(page, title, aimKey, onChanged)
		local frame = card(page, 58)
		label({
			Position = UDim2.fromOffset(18, 0),
			Size = UDim2.new(1, -170, 1, 0),
			Text = title,
			Font = FONT_BOLD,
			TextSize = 15,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = frame,
		})
		local function keyName()
			local v = AIM[aimKey]
			return (typeof(v) == "EnumItem") and v.Name or tostring(v)
		end
		local button = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.fromOffset(0, 32),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = THEME.Field,
			AutoButtonColor = false,
			Text = keyName(),
			Font = FONT_BOLD,
			TextSize = 14,
			TextColor3 = COMMON.Text,
			Parent = frame,
		})
		paint(button, "BackgroundColor3", "Field")
		corner(button, 9)
		padding(button, 0, 14, 0, 14)
		local buttonStroke = stroke(button, 0.85, 1)
		local waiting = false
		button.MouseButton1Click:Connect(function()
			if waiting then return end
			waiting = true
			bindingKey = true
			button.Text = "Press a key..."
			tween(buttonStroke, 0.2, { Color = THEME.Accent, Transparency = 0 })
			local connection
			connection = UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
				connection:Disconnect()
				waiting = false
				local key = input.KeyCode
				if key ~= Enum.KeyCode.Escape and key ~= Enum.KeyCode.Unknown then
					AIM[aimKey] = key
					if onChanged then onChanged(key) end
					applyConfig()
				end
				button.Text = keyName()
				tween(buttonStroke, 0.2, { Color = COMMON.White, Transparency = 0.85 })
				task.delay(0.2, function() bindingKey = false end)
			end)
		end)
		table.insert(refreshers, function()
			button.Text = keyName()
		end)
	end

	local aimPage, aimTab = createTab("Aim", "◎", "Aim assist and auto-shoot")

	local buyButton = aimButton(aimPage, "Buy the Aim GamePass", buyPass)
	table.insert(refreshers, function()
		buyButton.Visible = not hasPass
	end)

	section(aimPage, "Main")
	aimToggle(aimPage, "Aim", function()
		return trf("%s — on / off", keyName(AIM.ToggleKey))
	end, "enabled")
	aimChoice(aimPage, "Camera Mode", "Rivals — for the Rivals camera", "AimMode", {
		{ "Override", "Rivals" },
		{ "Classic", "Normal" },
	})
	aimChoice(aimPage, "Aim At", "Which body part", "AimPart", {
		{ "Head", "Head" },
		{ "UpperTorso", "Body" },
		{ "HumanoidRootPart", "Center" },
	})
	aimToggle(aimPage, "Head Only", "Always the head, never switches to the body", "HeadOnly")
	aimToggle(aimPage, "Hold Right Mouse", "PC: aim only while the right button is held", "HoldToAim")
	aimToggle(aimPage, "Right Mouse Through Walls", "While held, walls don't block the aim", "HoldThroughWalls")

	section(aimPage, "Aim Speed")
	aimSlider(aimPage, "Speed", "Smoothness", 5, 100, 100, function(v)
		return v .. "%"
	end)
	aimToggle(aimPage, "Instant Aim", function()
		return trf("%s — on / off, %s / %s — speed", keyName(AIM.SnapKey), keyName(AIM.SpeedUpKey), keyName(AIM.SpeedDownKey))
	end, "InstantSnap")

	section(aimPage, "Lock")
	aimSlider(aimPage, "Aim Height", "AimHeight", -100, 100, 100, function(v)
		return string.format("%+.2f", v / 100)
	end)
	aimSlider(aimPage, "FOV Radius", "FOV", 30, 400, 1, function(v)
		return v .. " px"
	end)
	aimSlider(aimPage, "Prediction", "Prediction", 0, 300, 1000, function(v)
		return v .. " ms"
	end)
	aimToggle(aimPage, "Keep Target", "Don't jump between players", "StickyTarget")
	aimSlider(aimPage, "Keep After Cover", "LockGrace", 0, 1000, 1000, function(v)
		return v .. " ms"
	end)

	section(aimPage, "Auto-Shoot")
	aimChoice(aimPage, "Auto-Shoot", "Shoots when the aim is on an enemy", "AutoShoot", {
		{ "All", "Everywhere" },
		{ "Phone", "Phone" },
		{ "Off", "Off" },
	})
	aimSlider(aimPage, "Accuracy", "AutoShootAngle", 1, 30, 1, function(v)
		return v .. "°"
	end)
	aimSlider(aimPage, "Pause Between Shots", "AutoShootDelay", 0, 500, 1000, function(v)
		return v .. " ms"
	end)
	aimKeybind(aimPage, "PC: Auto-Shoot Key", "AutoShootKey", function(k)
		notify("Key changed", "Auto-Shoot key: " .. k.Name, 2)
		onSettingsChanged()
	end)

	section(aimPage, "KnifeAuto (150 DMG)")
	aimToggle(aimPage, "KnifeAuto", "Auto Heavy Attack in timing (150 damage)", "KnifeAuto")
	aimSlider(aimPage, "KnifeAuto Range", "KnifeAutoRange", 3, 20, 1, function(v)
		return trf("%d studs", v)
	end)

	section(aimPage, "Checks")
	aimToggle(aimPage, "Team Check", "Don't aim at teammates", "TeamCheck")
	aimChoice(aimPage, "Teams", "Auto — find teams by itself", "TeamMode", {
		{ "Auto", "Auto" },
		{ "Off", "All enemies" },
	})
	local _, teamText = paragraph(aimPage, "Your Team", "Open the menu for a second — your team shows up here")
	teamInfoLabel = teamText
	aimToggle(aimPage, "Wall Check", "Don't aim through walls", "WallCheck")
	aimToggle(aimPage, "Target Bots", "NPCs with a Humanoid too", "TargetNPC")
	aimToggle(aimPage, "No Camera Shake", "Removes camera wobble and recoil shake", "NoCameraShake")
	aimToggle(aimPage, "Show FOV Circle", "Circle around the aim point", "ShowFOV")
	aimToggle(aimPage, "Show Target", "Name and distance at the top", "ShowTargetInfo")

	section(aimPage, "Saving")
	local _, statusText = paragraph(aimPage, "Your Settings", "Loading your settings…")
	configStatus = statusText
	aimButton(aimPage, "Reset Aim and ESP Settings", function()
		for _, k in ipairs(SAVE_KEYS) do
			if k ~= "Language" then
				AIM[k] = DEFAULTS[k]
			end
		end
		enabled = false
		applyConfig()
		setStatus("Settings reset to default", COMMON.SubText)
	end)

	local espPage = createTab("ESP", "◇", "See where players are")
	section(espPage, "ESP")
	aimToggle(espPage, "ESP", "Show players through walls", "ESP")
	aimToggle(espPage, "Show Weapon in ESP", "Display held item under player name", "ESPShowWeapon")
	aimToggle(espPage, "Highlight", "Glowing outline through walls", "ESPHighlight")
	aimToggle(espPage, "Names", "Name above the head", "ESPNames")
	aimToggle(espPage, "Distance", "How far away they are", "ESPDistance")
	aimToggle(espPage, "Health Bar", "HP under the name", "ESPHealth")
	aimToggle(espPage, "Tracers", "Lines from the bottom of the screen", "ESPTracers")
	aimToggle(espPage, "Show Teammates", "Your team too", "ESPTeammates")
	aimSlider(espPage, "Max Distance", "ESPMaxDistance", 50, 3000, 1, function(v)
		return trf("%d m", v)
	end)

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, id, purchased)
		if plr == player and id == AIM.GamePassId and purchased then
			hasPass = true
			enabled = true
			updateUI()
		end
	end)

	if not hasPass then
		task.spawn(function()
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, AIM.GamePassId)
			end)
			if ok and owns then
				hasPass = true
				updateUI()
			end
		end)
	end

	applyConfig()
	table.insert(languageHooks, function()
		AIM.Language = currentLanguage
		updateUI()
	end)

	local function showToast(text, _, seconds)
		notify("Aim", text, seconds or 3)
	end

	local saveRemote = nil
	local lastSaved = nil
	local saveBusy = false
	local CONFIG_FILE = "RivalsModded_Settings.cfg"

	local function saveLocalFile(str)
		if writefile then
			local ok = pcall(function() writefile(CONFIG_FILE, str) end)
			return ok
		end
		return false
	end

	local function readLocalFile()
		if isfile and readfile then
			local exists = false
			pcall(function() exists = isfile(CONFIG_FILE) end)
			if exists then
				local ok, data = pcall(function() return readfile(CONFIG_FILE) end)
				if ok and type(data) == "string" and data ~= "" then
					return data
				end
			end
		end
		return nil
	end

	local function saveNow()
		if not persistReady or saveBusy then return end
		local code = exportCode()
		if code == lastSaved then
			dirtyAt = nil
			return
		end
		saveBusy = true
		dirtyAt = nil

		-- 1. Always save locally to file (persists across game joins / leaves!)
		local savedLocally = saveLocalFile(code)

		-- 2. If game server has AimBotConfig RemoteFunction, save there too
		local savedRemotely = false
		if saveRemote then
			local ok, res = pcall(saveRemote.InvokeServer, saveRemote, "save", code)
			savedRemotely = ok and (res == true)
		end

		saveBusy = false
		if savedLocally or savedRemotely then
			lastSaved = code
			setStatus(trf("Saved at %s - next time they load by themselves", os.date("%H:%M")), COLORS.slime)
		else
			setStatus("Executor does not support writefile - cannot save locally", COLORS.gold)
		end
	end
	flushSave = saveNow
	state.onMenuClosed = function()
		flushSave()
	end

	onSettingsChanged = function()
		if persistReady then
			dirtyAt = os.clock()
			saveNow() -- Save immediately on any change!
		end
	end

	task.spawn(function()
		persistReady = true

		-- First attempt: load from local persistent file (Delta, Fluxus, Synapse, etc.)
		local localCode = readLocalFile()
		if localCode and localCode ~= "" then
			importCode(localCode)
			setLanguage(AIM.Language)
			applyConfig()
			lastSaved = localCode
			setStatus("Your settings are loaded - just like last time", COLORS.slime)
			showToast("Your aim settings are loaded", COLORS.slime, 3)
		end

		-- Also attempt to connect with AimBotConfig RemoteFunction if present
		local remote = ReplicatedStorage:WaitForChild("AimBotConfig", 3)
		if remote and remote:IsA("RemoteFunction") then
			saveRemote = remote
			if not localCode or localCode == "" then
				local ok, r = pcall(remote.InvokeServer, remote, "load")
				if ok and type(r) == "table" and r.ok and type(r.code) == "string" and r.code ~= "" then
					importCode(r.code)
					setLanguage(AIM.Language)
					applyConfig()
					lastSaved = r.code
					saveLocalFile(r.code)
					setStatus("Your settings are loaded - just like last time", COLORS.slime)
					showToast("Your aim settings are loaded", COLORS.slime, 3)
				end
			end
		end

		if not lastSaved or lastSaved == "" then
			lastSaved = exportCode()
			saveNow()
			setStatus("Your settings are saved and remembered", COLORS.slime)
		end

		while true do
			task.wait(0.25)
			if dirtyAt and os.clock() - dirtyAt >= SAVE_DELAY then
				saveNow()
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if input.UserInputType == AIM.AimHoldButton then
			holding = true
			return
		end
		if processed or bindingKey then return end
		local key = input.KeyCode
		if key == AIM.AutoShootKey then
			if AIM.AutoShoot == "Off" then
				AIM.AutoShoot = "All"
				notify("Auto-Shoot", "Auto-Shoot: ON", 2)
			else
				AIM.AutoShoot = "Off"
				notify("Auto-Shoot", "Auto-Shoot: OFF", 2)
			end
			applyConfig()
			return
		end
		if key == AIM.ToggleKey then
			toggleAim()
		elseif key == AIM.SpeedUpKey or key == Enum.KeyCode.KeypadPlus then
			changeSpeed(1)
		elseif key == AIM.SpeedDownKey or key == Enum.KeyCode.KeypadMinus then
			changeSpeed(-1)
		elseif key == AIM.SnapKey then
			toggleSnap()
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == AIM.AimHoldButton then
			holding = false
		end
	end)

	UserInputService.WindowFocusReleased:Connect(function()
		holding = false
	end)

	local TEAM_FIELDS = { AIM.TeamAttribute, "Team", "TeamName", "TeamId", "TeamID", "TeamColor", "Side", "Squad" }

	local function readTeam(inst)
		if not inst then return nil end
		for _, field in ipairs(TEAM_FIELDS) do
			local ok, attr = pcall(inst.GetAttribute, inst, field)
			if ok and attr ~= nil and attr ~= "" then
				return tostring(attr)
			end
			local v = inst:FindFirstChild(field)
			if v and v:IsA("ValueBase") then
				local val = v.Value
				if typeof(val) == "Instance" then
					return val.Name
				elseif val ~= nil and val ~= "" then
					return tostring(val)
				end
			end
		end
		return nil
	end

	local function teamOf(plr)
		if not plr then return nil, nil end
		local k = readTeam(plr)
		if k then return "a:" .. k, "player attribute" end
		k = readTeam(plr.Character)
		if k then return "a:" .. k, "character attribute" end
		k = readTeam(plr:FindFirstChild("leaderstats"))
		if k then return "a:" .. k, "leaderstats" end
		if plr.Team then return "t:" .. plr.Team.Name, "Teams" end
		if not plr.Neutral then return "c:" .. plr.TeamColor.Name, "TeamColor" end
		return nil, nil
	end

	local teamCache = { at = -1, keys = {}, mine = nil, ffa = false }
	local function updateTeamCache()
		if os.clock() - teamCache.at < 0.25 then return end
		teamCache.at = os.clock()
		local keys = {}
		local mine = teamOf(player)
		local all, same = 0, 0
		for _, plr in ipairs(Players:GetPlayers()) do
			local k = teamOf(plr)
			keys[plr] = k or false
			all += 1
			if k ~= nil and k == mine then
				same += 1
			end
		end
		teamCache.keys = keys
		teamCache.mine = mine
		teamCache.ffa = all >= 2 and same == all
	end

	local function isTeammate(plr)
		if not plr or plr == player then return false end
		if AIM.TeamMode == "Off" then return false end
		updateTeamCache()
		if teamCache.ffa or not teamCache.mine then return false end
		local theirs = teamCache.keys[plr]
		if theirs == nil then
			theirs = teamOf(plr) or false
		end
		return theirs ~= false and theirs == teamCache.mine
	end

	task.spawn(function()
		while true do
			task.wait(1)
			if teamInfoLabel and menuVisible then
				local text
				if AIM.TeamMode == "Off" then
					text = "Teams are off: every player is an enemy"
				else
					updateTeamCache()
					local key, how = teamOf(player)
					local mates, foes = 0, 0
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= player then
							if isTeammate(plr) then
								mates += 1
							else
								foes += 1
							end
						end
					end
					if not key then
						text = "No team found — every player is an enemy"
					else
						text = trf("Your team: %s (%s)%s\nTeammates: %d  •  Enemies: %d",
							string.sub(key, 3), tr(how),
							teamCache.ffa and tr(", everyone is in it — free for all") or "",
							mates, foes)
					end
				end
				teamInfoLabel.Text = text
			end
		end
	end)

	local npcCache, lastNpcScan = {}, 0
	local function scanNPCs()
		npcCache = {}
		local function check(m)
			if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid")
				and not Players:GetPlayerFromCharacter(m) then
				table.insert(npcCache, m)
			end
		end
		for _, obj in ipairs(workspace:GetChildren()) do
			check(obj)
			if obj:IsA("Folder") or (obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid")) then
				for _, sub in ipairs(obj:GetChildren()) do
					check(sub)
				end
			end
		end
	end

	local function getTargets()
		local list = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				table.insert(list, { char = plr.Character, plr = plr, name = plr.DisplayName })
			end
		end
		if AIM.TargetNPC then
			if os.clock() - lastNpcScan > 2 then
				scanNPCs()
				lastNpcScan = os.clock()
			end
			for _, m in ipairs(npcCache) do
				if m.Parent and m ~= player.Character then
					table.insert(list, { char = m, name = m.Name })
				end
			end
		end
		return list
	end

	-- [[ МОДУЛЬ ОПРЕДЕЛЕНИЯ ОРУЖИЯ В РУКАХ / WEAPON DETECTOR ]]
	local WeaponDetector = {}
	local MELEE_KEYWORDS = {
		knife = true, blade = true, katana = true, sword = true, dagger = true,
		scythe = true, axe = true, machete = true, karambit = true, butterfly = true,
		bat = true, crowbar = true, hammer = true, fists = true, melee = true
	}

	function WeaponDetector.GetHeldItem(char)
		if not char then return nil end
		local tool = char:FindFirstChildOfClass("Tool")
		if tool then
			local lowerName = string.lower(tool.Name)
			local isMelee = tool:GetAttribute("Melee") == true
			if not isMelee then
				for kw in pairs(MELEE_KEYWORDS) do
					if string.find(lowerName, kw, 1, true) then
						isMelee = true
						break
					end
				end
			end
			return { Tool = tool, Name = tool.Name, IsMelee = isMelee, Type = isMelee and "Melee" or "Gun" }
		end
		local attrName = char:GetAttribute("EquippedWeapon") or char:GetAttribute("CurrentWeapon") or char:GetAttribute("Weapon")
		if attrName then
			local lowerName = string.lower(tostring(attrName))
			local isMelee = false
			for kw in pairs(MELEE_KEYWORDS) do
				if string.find(lowerName, kw, 1, true) then
					isMelee = true
					break
				end
			end
			return { Tool = nil, Name = tostring(attrName), IsMelee = isMelee, Type = isMelee and "Melee" or "Gun" }
		end
		return nil
	end

	-- [[ МОДУЛЬ KNIFEAUTO / HEAVY ATTACK 150 DMG TIMING ]]
	local KnifeAutoModule = {
		LastHeavy = 0,
		Cooldown = 0.45,
	}

	function KnifeAutoModule.IsHeavyTiming(myRoot, enemyRoot)
		if not (myRoot and enemyRoot) then return false end
		local dist = (enemyRoot.Position - myRoot.Position).Magnitude
		local maxRange = AIM.KnifeAutoRange or 8.5
		if dist > maxRange then return false end

		local enemyLook = enemyRoot.CFrame.LookVector
		local toEnemy = (enemyRoot.Position - myRoot.Position).Unit
		local myLook = myRoot.CFrame.LookVector

		-- Heavy Attack наносит 150 урона при ударе в спину/фланг или в критический тайминг дистанции
		local facingSameWay = myLook:Dot(enemyLook)
		local behindEnemy = enemyLook:Dot(toEnemy) > -0.25

		if (facingSameWay > 0.15 and behindEnemy) or dist <= 5.8 then
			return true, dist
		end
		return false, dist
	end

	function KnifeAutoModule.ExecuteHeavy(tool)
		if not tool then return end
		tool:Activate()
		local heavyEvt = tool:FindFirstChild("Heavy") or tool:FindFirstChild("Secondary") or tool:FindFirstChild("Attack")
		if heavyEvt and heavyEvt:IsA("RemoteEvent") then
			pcall(function() heavyEvt:FireServer("Heavy") end)
		end
		pcall(function()
			if mouse2click then
				mouse2click()
			elseif mouse2press and mouse2release then
				mouse2press()
				task.wait(0.03)
				mouse2release()
			end
		end)
	end

	local function aliveHumanoid(char)
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			return hum
		end
		return nil
	end

	local espObjects = {}

	local function createESP(char)
		local o = {}

		local hl = Instance.new("Highlight")
		hl.Name = "AimHighlight"
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillTransparency = 0.65
		hl.OutlineTransparency = 0
		hl.Adornee = char
		hl.Parent = char
		o.highlight = hl

		local bb = Instance.new("BillboardGui")
		bb.Name = "ESP_" .. char.Name
		bb.AlwaysOnTop = true
		bb.Size = UDim2.fromOffset(200, 46)
		bb.StudsOffset = Vector3.new(0, 2.6, 0)
		bb.LightInfluence = 0
		bb.Parent = espFolder
		o.billboard = bb

		local function textLabel(y, h, size)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Position = UDim2.fromOffset(0, y)
			l.Size = UDim2.new(1, 0, 0, h)
			l.Font = Enum.Font.GothamBold
			l.TextSize = size
			l.TextStrokeTransparency = 0.3
			l.TextColor3 = Color3.new(1, 1, 1)
			l.Parent = bb
			return l
		end
		o.name = textLabel(0, 18, 15)
		o.info = textLabel(18, 16, 13)

		local hpBack = Instance.new("Frame")
		hpBack.AnchorPoint = Vector2.new(0.5, 0)
		hpBack.Position = UDim2.new(0.5, 0, 0, 37)
		hpBack.Size = UDim2.fromOffset(70, 5)
		hpBack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		hpBack.BorderSizePixel = 0
		hpBack.Parent = bb
		local hpFill = Instance.new("Frame")
		hpFill.BorderSizePixel = 0
		hpFill.Parent = hpBack
		o.hpBack, o.hpFill = hpBack, hpFill

		local tracer = Instance.new("Frame")
		tracer.AnchorPoint = Vector2.new(0.5, 0.5)
		tracer.BorderSizePixel = 0
		tracer.BackgroundTransparency = 0.2
		tracer.Visible = false
		tracer.Parent = hud
		o.tracer = tracer

		espObjects[char] = o
		return o
	end

	local function destroyESP(char)
		local o = espObjects[char]
		if not o then return end
		o.highlight:Destroy()
		o.billboard:Destroy()
		o.tracer:Destroy()
		espObjects[char] = nil
	end

	local function drawLine(frame, a, b)
		local d = b - a
		frame.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
		frame.Size = UDim2.fromOffset(d.Magnitude, 1.5)
		frame.Rotation = math.deg(math.atan2(d.Y, d.X))
	end

	local function updateESP(cam, targets)
		local seen = {}

		if hasPass and AIM.ESP then
			local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local origin = myRoot and myRoot.Position or cam.CFrame.Position
			local vs = cam.ViewportSize

			for _, t in ipairs(targets) do
				local char = t.char
				local hum = aliveHumanoid(char)
				local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
				if hum and root then
					local mate = isTeammate(t.plr)
					local dist = (root.Position - origin).Magnitude
					if (AIM.ESPTeammates or not mate) and dist <= AIM.ESPMaxDistance then
						seen[char] = true
						local o = espObjects[char] or createESP(char)
						local color = mate and COLORS.team or COLORS.enemy

						o.highlight.Enabled = AIM.ESPHighlight
						o.highlight.FillColor = color
						o.highlight.OutlineColor = color

						o.billboard.Adornee = char:FindFirstChild("Head") or root
						o.billboard.Enabled = AIM.ESPNames or AIM.ESPDistance or AIM.ESPHealth

						o.name.Visible = AIM.ESPNames
						local held = (AIM.ESPShowWeapon and aliveHumanoid(char)) and WeaponDetector.GetHeldItem(char)
						local weaponTag = held and (" [" .. held.Name .. "]") or ""
						o.name.Text = t.name .. weaponTag
						o.name.TextColor3 = color

						o.info.Visible = AIM.ESPDistance
						o.info.Text = trf("%d m", math.floor(dist + 0.5))

						o.hpBack.Visible = AIM.ESPHealth
						local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
						o.hpFill.Size = UDim2.fromScale(hp, 1)
						o.hpFill.BackgroundColor3 = Color3.fromHSV(hp * 0.33, 0.9, 0.95)

						if AIM.ESPTracers then
							local sp = cam:WorldToViewportPoint(root.Position)
							if sp.Z > 0 then
								o.tracer.BackgroundColor3 = color
								drawLine(o.tracer, Vector2.new(vs.X / 2, vs.Y), Vector2.new(sp.X, sp.Y))
								o.tracer.Visible = true
							else
								o.tracer.Visible = false
							end
						else
							o.tracer.Visible = false
						end
					end
				end
			end
		end

		for char in pairs(espObjects) do
			if not seen[char] then
				destroyESP(char)
			end
		end
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude

	local function getAimCenter(cam)
		-- FOV circle & aim center ALWAYS locked to screen crosshair center!
		local vs = cam.ViewportSize
		return Vector2.new(vs.X / 2, vs.Y / 2), true
	end

	local function aimRayDirection(cam)
		local center, centered = getAimCenter(cam)
		if centered then
			return cam.CFrame.LookVector
		end
		return cam:ViewportPointToRay(center.X, center.Y).Direction.Unit
	end

	local PART_NAMES = {
		Head = { "Head" },
		UpperTorso = { "UpperTorso", "Torso" },
		HumanoidRootPart = { "HumanoidRootPart", "Torso" },
	}

	local function getAimPart(char)
		local partName = AIM.HeadOnly and "Head" or AIM.AimPart
		for _, name in ipairs(PART_NAMES[partName] or { partName }) do
			local p = char:FindFirstChild(name)
			if p and p:IsA("BasePart") then
				return p
			end
		end
		return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	end

	local function isVisible(cam, part, targetChar)
		if not AIM.WallCheck then return true end
		if holding and AIM.HoldThroughWalls and not isMobile then return true end
		local origin = cam.CFrame.Position
		local dir = part.Position - origin
		local ignore = { targetChar, player.Character, cam }

		for _ = 1, 10 do
			rayParams.FilterDescendantsInstances = ignore
			local result = workspace:Raycast(origin, dir, rayParams)
			if not result then
				return true
			end
			local hit = result.Instance
			local model = hit:FindFirstAncestorOfClass("Model")
			local isCharacter = model and model:FindFirstChildOfClass("Humanoid")
			if hit.Transparency > 0.6 or not hit.CanCollide or isCharacter then
				table.insert(ignore, isCharacter and model or hit)
			else
				return false
			end
		end
		return false
	end

	local VISIBLE_PARTS = { "Head", "UpperTorso", "Torso", "HumanoidRootPart" }

	local function checkTarget(cam, t, center, maxDist)
		local char = t.char
		if not char.Parent or not aliveHumanoid(char) then return nil end
		if char:FindFirstChildOfClass("ForceField") then return nil end
		if AIM.TeamCheck and isTeammate(t.plr) then return nil end

		local part = getAimPart(char)
		if not part then return nil end

		local sp, onScreen = cam:WorldToViewportPoint(part.Position)
		if not onScreen then return nil end

		local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
		if dist >= maxDist then return nil end

		if not isVisible(cam, part, char) then
			if AIM.HeadOnly then
				return nil
			end
			local alt = nil
			for _, n in ipairs(VISIBLE_PARTS) do
				local p = char:FindFirstChild(n)
				if p and p ~= part and p:IsA("BasePart") and isVisible(cam, p, char) then
					alt = p
					break
				end
			end
			if not alt then return nil end
			part = alt
		end

		return part, dist
	end

	local lockSeenAt = 0

	local KEEP_RADIUS = 1.5
	local MIN_GRACE = 0.2

	local function getClosestTarget(cam, targets, current)
		local center = getAimCenter(cam)

		if current and AIM.StickyTarget then
			local part = checkTarget(cam, current, center, AIM.FOV * KEEP_RADIUS)
			if part then
				lockSeenAt = os.clock()
				return part, current
			end
			if os.clock() - lockSeenAt < math.max(AIM.LockGrace, MIN_GRACE)
				and current.char.Parent and aliveHumanoid(current.char)
				and not (AIM.TeamCheck and isTeammate(current.plr)) then
				local p = getAimPart(current.char)
				if p then
					return p, current
				end
			end
		end

		local bestPart, bestTarget, bestDist = nil, nil, AIM.FOV
		for _, t in ipairs(targets) do
			local part, dist = checkTarget(cam, t, center, bestDist)
			if part then
				bestPart, bestTarget, bestDist = part, t, dist
			end
		end

		if bestTarget then
			lockSeenAt = os.clock()
		end
		return bestPart, bestTarget
	end

	local function wantsAim()
		if not (hasPass and enabled) or menuVisible then return false end
		if AIM.HoldToAim and not isMobile and not holding then return false end
		return aliveHumanoid(player.Character) ~= nil
	end

	local function aimPosition(part)
		local pos = part.Position
		if part.Name == "Head" then
			pos += Vector3.new(0, AIM.AimHeight, 0)
		end
		if AIM.Prediction > 0 then
			local model = part.Parent
			local root = model and model:FindFirstChild("HumanoidRootPart")
			pos += (root or part).AssemblyLinearVelocity * AIM.Prediction
		end
		return pos
	end

	local function smoothAlpha(dt)
		if AIM.InstantSnap or AIM.Smoothness >= 0.95 then
			return 1
		end
		local speed = math.clamp(AIM.Smoothness * 2.8, 0.05, 1)
		return 1 - (1 - speed) ^ (dt * 120)
	end

	local function rotationBetween(a, b)
		local axis = a:Cross(b)
		if axis.Magnitude < 1e-6 then
			return CFrame.identity
		end
		local angle = math.acos(math.clamp(a:Dot(b), -1, 1))
		return CFrame.fromAxisAngle(axis.Unit, angle)
	end

	local function lookCFrame(pos, look)
		if math.abs(look.Y) > 0.999 then
			look = Vector3.new(look.X + 0.001, math.sign(look.Y) * 0.999, look.Z).Unit
		end
		return CFrame.lookAt(pos, pos + look)
	end

	local function wantedLook(cam, part)
		local camCF = cam.CFrame
		local want = (aimPosition(part) - camCF.Position).Unit
		local center, centered = getAimCenter(cam)
		if centered then
			return want
		end
		local mouseDirection = cam:ViewportPointToRay(center.X, center.Y).Direction.Unit
		return rotationBetween(mouseDirection, want):VectorToWorldSpace(camCF.LookVector).Unit
	end

	local lockedPart, lockedTarget = nil, nil
	local aimLook = nil

	local SNAP_COS = math.cos(math.rad(0.15))
	local prevWant, prevChar = nil, nil

	local function trackLook(current, want, dt)
		local char = lockedTarget and lockedTarget.char
		if prevWant and prevChar == char then
			current = rotationBetween(prevWant, want):VectorToWorldSpace(current)
		end
		prevWant, prevChar = want, char

		local newLook = current:Lerp(want, smoothAlpha(dt))
		if newLook.Magnitude < 1e-3 then
			return want
		end
		newLook = newLook.Unit
		if newLook:Dot(want) > SNAP_COS then
			return want
		end
		return newLook
	end

	local diagnoseAt, diagnoseText = 0, ""
	local function diagnose(cam, targets)
		if os.clock() - diagnoseAt < 0.25 then
			return diagnoseText
		end
		diagnoseAt = os.clock()
		local center = getAimCenter(cam)
		local mates, outside, walls, shields = 0, 0, 0, 0
		for _, t in ipairs(targets) do
			local char = t.char
			if aliveHumanoid(char) then
				if AIM.TeamCheck and isTeammate(t.plr) then
					mates += 1
				elseif char:FindFirstChildOfClass("ForceField") then
					shields += 1
				else
					local part = getAimPart(char)
					if part then
						local sp, onScreen = cam:WorldToViewportPoint(part.Position)
						if not onScreen or (Vector2.new(sp.X, sp.Y) - center).Magnitude >= AIM.FOV then
							outside += 1
						elseif not isVisible(cam, part, char) then
							walls += 1
						end
					end
				end
			end
		end
		diagnoseText = trf("No target  •  teammates: %d  •  outside circle: %d  •  behind walls: %d  •  shield: %d", mates, outside, walls, shields)
		return diagnoseText
	end

	RunService:BindToRenderStep("AimMain", Enum.RenderPriority.Camera.Value + 1, function(dt)
		local cam = workspace.CurrentCamera
		if not cam then return end

		-- [[ NO CAMERA SHAKE ]]
		if AIM.NoCameraShake then
			local myChar = player.Character
			local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
			if hum and hum.CameraOffset.Magnitude > 0.005 then
				hum.CameraOffset = Vector3.zero
			end
		end



		local targets = getTargets()
		updateESP(cam, targets)

		if circle.Visible then
			local c = getAimCenter(cam)
			circle.Position = UDim2.fromOffset(c.X, c.Y)
		end

		local prevTarget = lockedTarget
		lockedPart, lockedTarget = nil, nil
		if wantsAim() then
			lockedPart, lockedTarget = getClosestTarget(cam, targets, prevTarget)
		end
		if not lockedPart then
			prevWant, prevChar = nil, nil
		end
		player:SetAttribute("AimPoint", lockedPart and aimPosition(lockedPart) or nil)

		if lockedTarget and AIM.ShowTargetInfo then
			local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local d = myRoot and math.floor((lockedPart.Position - myRoot.Position).Magnitude + 0.5) or 0
			local enemyWeapon = WeaponDetector.GetHeldItem(lockedTarget.char)
			local weaponInfo = enemyWeapon and (" [" .. enemyWeapon.Name .. "]") or ""
			targetInfo.Text = trf("🎯 %s%s  •  %d m", lockedTarget.name, weaponInfo, d)
			targetInfo.TextColor3 = COLORS.enemy
			targetInfo.Visible = true
		else
			-- Compact & clean: Hide banner completely when no locked target!
			targetInfo.Visible = false
		end

		-- [[ UNIFIED AIM ROTATION & CHARACTER SYNC ]]
		if lockedPart then
			local want = wantedLook(cam, lockedPart)
			aimLook = trackLook(aimLook or cam.CFrame.LookVector, want, dt)
			cam.CFrame = lookCFrame(cam.CFrame.Position, aimLook)

			-- Synchronize character body rotation so weapon does NOT slide sideways,
			-- and spectators/teammates see your character aiming properly at the enemy
			local myChar = player.Character
			local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
			if myRoot then
				local flatLook = Vector3.new(aimLook.X, 0, aimLook.Z)
				if flatLook.Magnitude > 0.01 then
					myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + flatLook.Unit)
				end
			end
		else
			aimLook = nil
		end
	end)

	local function customFire(down)
	end

	local firing, lastShot = false, 0

	local function setTrigger(down)
		local char = player.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if tool then
			if down then
				tool:Activate()
			else
				tool:Deactivate()
			end
		end
		customFire(down)
	end

	local function autoShootAllowed()
		if AIM.AutoShoot == "All" then return true end
		if AIM.AutoShoot == "Phone" then return isMobile end
		return false
	end

	RunService:BindToRenderStep("AimAutoShoot", Enum.RenderPriority.Last.Value + 1, function()
		local cam = workspace.CurrentCamera
		if not cam then return end

		local myChar = player.Character
		if not (myChar and aliveHumanoid(myChar)) then
			if firing then
				setTrigger(false)
				firing = false
			end
			return
		end

		local myRoot = myChar:FindFirstChild("HumanoidRootPart")
		local held = WeaponDetector.GetHeldItem(myChar)
		local targets = getTargets()

		-- [[ 1. KNIFEAUTO: HEAVY ATTACK В ТАЙМИНГ НА 150 УРОНА ]]
		if AIM.KnifeAuto and held and held.IsMelee and myRoot then
			local now = os.clock()
			if now - KnifeAutoModule.LastHeavy >= KnifeAutoModule.Cooldown then
				for _, t in ipairs(targets) do
					local enemyChar = t.char
					local enemyRoot = enemyChar and (enemyChar:FindFirstChild("HumanoidRootPart") or enemyChar.PrimaryPart)
					if enemyRoot and aliveHumanoid(enemyChar) and not enemyChar:FindFirstChildOfClass("ForceField") then
						if not (AIM.TeamCheck and isTeammate(t.plr)) then
							local isTiming, d = KnifeAutoModule.IsHeavyTiming(myRoot, enemyRoot)
							if isTiming then
								KnifeAutoModule.ExecuteHeavy(held.Tool)
								KnifeAutoModule.LastHeavy = now
								break
							end
						end
					end
				end
			end
		end

		-- [[ 2. АВТОСТРЕЛ: ТОЧНОСТЬ 10°, 0 ЗАДЕРЖКА, БЕЗ ЛИШНИХ ПАУЗ ]]
		if not autoShootAllowed() then
			if firing then
				setTrigger(false)
				firing = false
			end
			return
		end

		local shouldFire = false
		local pause = AIM.AutoShootDelay or 0
		local aimDir = aimRayDirection(cam)

		-- Проверка: залоченная цель или любой враг, на которого направлен прицел
		local candidates = {}
		if lockedPart then
			table.insert(candidates, lockedPart)
		else
			for _, t in ipairs(targets) do
				local char = t.char
				if char and char.Parent and aliveHumanoid(char) and not char:FindFirstChildOfClass("ForceField") then
					if not (AIM.TeamCheck and isTeammate(t.plr)) then
						local p = getAimPart(char)
						if p and isVisible(cam, p, char) then
							table.insert(candidates, p)
						end
					end
				end
			end
		end

		for _, part in ipairs(candidates) do
			local dir = (aimPosition(part) - cam.CFrame.Position).Unit
			local dot = math.clamp(aimDir:Dot(dir), -1, 1)
			if math.deg(math.acos(dot)) <= (AIM.AutoShootAngle or 10) then
				shouldFire = true
				break
			end
		end

		if shouldFire then
			local now = os.clock()
			if pause <= 0 or (now - lastShot >= pause) then
				if firing then
					setTrigger(false)
				end
				setTrigger(true)
				firing = true
				lastShot = now
			end
		elseif firing then
			setTrigger(false)
			firing = false
		end
	end)
end
local aimOk, aimErr = pcall(setupAim)
if not aimOk then
	warn("[RIVALS MODDED] setupAim ERROR: " .. tostring(aimErr))
	if game:GetService("StarterGui") then
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "AIM ERROR",
			Text = tostring(aimErr),
			Duration = 15
		})
	end
end

local themesPage = createTab("Themes", "◆", "Change the look of the menu")
section(themesPage, "Choose a theme")

local themeGrid = create("Frame", {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	LayoutOrder = nextOrder(),
	Parent = themesPage,
})
create("UIGridLayout", {
	CellSize = UDim2.new(0.5, -6, 0, 96),
	CellPadding = UDim2.fromOffset(12, 12),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = themeGrid,
})

local themeCards = {}
state.autoThemeEnabled = false

local function refreshThemeCards(duration)
	for _, themeCard in ipairs(themeCards) do
		local active = themeCard.Theme == currentTheme
		tween(themeCard.Stroke, duration, { Transparency = active and 0 or 0.85, Thickness = active and 2 or 1 })
		themeCard.Badge.Visible = active
	end
end

for index, theme in ipairs(THEMES) do
	local button = create("TextButton", {
		BackgroundColor3 = theme.Window,
		BackgroundTransparency = 0.05,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = index,
		Parent = themeGrid,
	})
	corner(button, 12)
	local cardScale = create("UIScale", { Parent = button })
	local cardStroke = stroke(button, 0.85, 1, theme.Accent)

	local swatch = create("Frame", {
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.new(1, -24, 0, 32),
		BackgroundColor3 = COMMON.White,
		Parent = button,
	})
	corner(swatch, 8)
	create("UIGradient", { Color = ColorSequence.new(theme.Accent, theme.Accent2), Parent = swatch })

	local badge = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -6, 0.5, 0),
		Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = COMMON.Black,
		BackgroundTransparency = 0.45,
		Visible = false,
		Parent = swatch,
	})
	round(badge)
	padding(badge, 0, 9, 0, 9)
	label({
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = "ACTIVE",
		Font = FONT_BOLD,
		TextSize = 11,
		TextColor3 = COMMON.White,
		Parent = badge,
	})

	label({
		Position = UDim2.fromOffset(14, 54),
		Size = UDim2.new(1, -90, 0, 20),
		Text = theme.Name,
		Font = FONT_BOLD,
		TextSize = 15,
		TextColor3 = COMMON.Text,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = button,
	})
	label({
		Position = UDim2.fromOffset(14, 73),
		Size = UDim2.new(1, -90, 0, 14),
		Text = "Click to apply",
		Font = FONT_REGULAR,
		TextSize = 12,
		TextColor3 = theme.IconTint,
		Parent = button,
	})

	for dotIndex, color in ipairs({ theme.Card, theme.Field, theme.IconTint }) do
		local dot = create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12 - (3 - dotIndex) * 20, 0, 70),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = color,
			Parent = button,
		})
		round(dot)
		stroke(dot, 0.8, 1)
	end

	button.MouseEnter:Connect(function()
		tween(cardScale, 0.25, { Scale = 1.03 })
	end)
	button.MouseLeave:Connect(function()
		tween(cardScale, 0.25, { Scale = 1 })
	end)
	button.MouseButton1Click:Connect(function()
		if setTheme(theme.Name) then
			notify("Theme changed", trf("%s is on now", theme.Name), 3)
		end
	end)

	table.insert(themeCards, { Theme = theme, Stroke = cardStroke, Badge = badge })
end

onTheme(function(instant)
	refreshThemeCards(instant and 0 or 0.35)
end)

section(themesPage, "Extra")
local autoThemeToggle
autoThemeToggle = toggle(themesPage, nil, "Auto Theme", "", false, function(enabled)
	state.autoThemeEnabled = enabled
	if enabled then
		notify("Auto Theme enabled", "Sit back and watch the colors", 3)
	else
		notify("Auto Theme disabled", trf("%s stays on", currentTheme.Name), 3)
	end
end)
onLanguage(function()
	autoThemeToggle.SetDescription(trf("Themes change every %d seconds", CONFIG.AutoThemeDelay))
end)

task.spawn(function()
	while gui.Parent do
		task.wait(CONFIG.AutoThemeDelay)
		if state.autoThemeEnabled then
			local nextIndex = (table.find(THEMES, currentTheme) or 0) % #THEMES + 1
			setTheme(THEMES[nextIndex].Name)
		end
	end
end)

local infoKeysText = nil

local function refreshKeyTexts()
	homeStats[2].Text = CONFIG.ToggleKey.Name
	homeHowText.Text = trf(HOW_TO, CONFIG.ToggleKey.Name)
	if infoKeysText then
		infoKeysText.Text = trf(KEYS_TEXT, CONFIG.ToggleKey.Name)
	end
end
table.insert(languageHooks, refreshKeyTexts)

local function keyChanged(key)
	refreshKeyTexts()
	notify("Key changed", trf("New key: %s", key.Name), 3)
end

local settingsPage = createTab("Settings", "◉", "Menu look and keys")

section(settingsPage, "Language")
local languageGrid = create("Frame", {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	LayoutOrder = nextOrder(),
	Parent = settingsPage,
})
create("UIGridLayout", {
	CellSize = UDim2.new(0.5, -6, 0, 46),
	CellPadding = UDim2.fromOffset(12, 12),
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = languageGrid,
})
local languageButtons = {}
local function refreshLanguageButtons()
	for code, item in pairs(languageButtons) do
		local active = code == currentLanguage
		tween(item.Stroke, 0.25, { Transparency = active and 0 or 0.85, Thickness = active and 2 or 1 })
		tween(item.Button, 0.25, { BackgroundTransparency = active and 0.05 or 0.3 })
	end
end
for index, language in ipairs(LANGUAGES) do
	local button = create("TextButton", {
		BackgroundColor3 = THEME.Card,
		BackgroundTransparency = 0.3,
		AutoButtonColor = false,
		Text = "",
		LayoutOrder = index,
		Parent = languageGrid,
	})
	paint(button, "BackgroundColor3", "Card")
	corner(button, 12)
	local buttonStroke = stroke(button, 0.85, 1)
	paint(buttonStroke, "Color", "Accent")
	label({
		Size = UDim2.fromScale(1, 1),
		Text = language[2],
		Font = FONT_BOLD,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = button,
	})
	button.MouseButton1Click:Connect(function()
		if setLanguage(language[1]) then
			notify("Language changed", language[2], 3)
		end
	end)
	languageButtons[language[1]] = { Button = button, Stroke = buttonStroke }
end
onLanguage(refreshLanguageButtons)

section(settingsPage, "Menu")
toggle(settingsPage, nil, "Blur", "Blur the game behind the menu", CONFIG.Blur, function(enabled)
	CONFIG.Blur = enabled
	updateBlur()
end)
slider(settingsPage, "Blur Strength", 1, 30, CONFIG.BlurSize, "", function(value)
	CONFIG.BlurSize = value
	updateBlur()
end)
slider(settingsPage, "Window Transparency", 0, 80, math.floor(CONFIG.Transparency * 100 + 0.5), "%", function(value)
	CONFIG.Transparency = value / 100
	main.BackgroundTransparency = CONFIG.Transparency
end)
toggle(settingsPage, nil, "Animated Border", "The glowing border slowly spins", CONFIG.AnimatedBorder, function(enabled)
	CONFIG.AnimatedBorder = enabled
end)
toggle(settingsPage, nil, "Notifications", "Pop-ups in the bottom-right corner", state.notificationsEnabled, function(enabled)
	state.notificationsEnabled = enabled
end)

section(settingsPage, "Keybinds")
paragraph(settingsPage, "How to change a key", "Click the key button, then press a new key. Escape cancels.")
keybind(settingsPage, "Show / Hide Menu", "ToggleKey", keyChanged)

local profilePage, profileTab = createTab("Profile", "●", "Your account")
profileHeader(profilePage)
local profileStats = statGrid(profilePage, {
	{ trf("%d days", player.AccountAge), "account age" },
	{ player.MembershipType == Enum.MembershipType.Premium and "Yes" or "No", "Premium" },
	{ "00:00", "in menu" },
})
table.insert(languageHooks, function()
	profileStats[1].Text = trf("%d days", player.AccountAge)
end)

local infoPage = createTab("Info", "■", "About the menu")
section(infoPage, CONFIG.Title)
local _, infoThemeText = paragraph(infoPage, CONFIG.Version, "")
local function refreshInfoTheme()
	infoThemeText.Text = trf("Made for %s\nTheme: %s", player.Name, THEME.Name)
end
onTheme(refreshInfoTheme)
table.insert(languageHooks, refreshInfoTheme)
section(infoPage, "Controls")
_, infoKeysText = paragraph(infoPage, "Keys and buttons", "")
section(infoPage, "What's inside")
local _, infoAboutText = paragraph(infoPage, "Menu", "")
onLanguage(function()
	infoAboutText.Text = trf(INFO_ABOUT, #THEMES)
end)
refreshKeyTexts()

selectTab(tabs[1])

minimizeButton.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)

maximizeButton.MouseButton1Click:Connect(function()
	setMaximized(not maximized)
end)

closeButton.MouseButton1Click:Connect(function()
	resetCloseButton()
	setMenuVisible(false)
	notify("Menu hidden", trf("Press %s or the W button on the left", CONFIG.ToggleKey.Name), 4)
end)

profileCard.MouseButton1Click:Connect(function()
	selectTab(profileTab)
end)

openButton.MouseEnter:Connect(function()
	tween(openEmoji, 0.3, { Rotation = 15 })
	tween(openScale, 0.25, { Scale = menuVisible and 1 or 1.1 })
end)
openButton.MouseLeave:Connect(function()
	tween(openEmoji, 0.3, { Rotation = 0 })
	tween(openScale, 0.25, { Scale = menuVisible and 0.9 or 1 })
end)
do
	local pressing = false
	local moved = false
	local pressStart = nil
	local dockStart = nil
	local DRAG_THRESHOLD = 6

	local function dockPosition()
		local viewport = camera.ViewportSize
		local pos = openDock.Position
		return Vector2.new(
			pos.X.Scale * viewport.X + pos.X.Offset,
			pos.Y.Scale * viewport.Y + pos.Y.Offset
		)
	end

	local function placeDock(point)
		-- No clamp/barrier: free drag anywhere (mobile users can hide the button during combat)
		openDock.Position = UDim2.fromOffset(point.X, point.Y)
	end

	openButton.InputBegan:Connect(function(input)
		if isPress(input) then
			pressing = true
			moved = false
			pressStart = Vector2.new(input.Position.X, input.Position.Y)
			dockStart = dockPosition()
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not pressing or not isMove(input) then
			return
		end
		local delta = Vector2.new(input.Position.X, input.Position.Y) - pressStart
		if not moved and delta.Magnitude >= DRAG_THRESHOLD then
			moved = true
			tween(openScale, 0.2, { Scale = 1.15 })
		end
		if moved then
			placeDock(dockStart + delta)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if pressing and isPress(input) then
			pressing = false
			if moved then
				tween(openScale, 0.3, { Scale = menuVisible and 0.9 or 1 }, Enum.EasingStyle.Back)
			end
		end
	end)

	openButton.MouseButton1Click:Connect(function()
		if moved then
			moved = false
			return
		end
		if introDone then
			setMenuVisible(not menuVisible)
		end
	end)

	camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if openDock.Position.X.Scale == 0 and openDock.Position.Y.Scale == 0 then
			placeDock(dockPosition())
		end
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not introDone or bindingKey then
		return
	end
	if input.KeyCode == CONFIG.ToggleKey then
		setMenuVisible(not menuVisible)
	end
end)

local dragging = false
local dragStart, startPosition

topBar.InputBegan:Connect(function(input)
	if isPress(input) and not hoveringWindowButton then
		dragging = true
		dragStart = input.Position
		startPosition = holder.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and isMove(input) then
		local delta = input.Position - dragStart
		local x, y = state.windowOffset(startPosition.X.Offset + delta.X, startPosition.Y.Offset + delta.Y)
		tween(holder, 0.1, { Position = UDim2.new(0.5, x, 0.5, y) }, Enum.EasingStyle.Sine)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if isPress(input) then
		dragging = false
	end
end)

fitToScreen()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen)

local clock = 0
RunService.RenderStepped:Connect(function(dt)
	-- OPTIMIZATION: Do not process UI animations when menu is closed!
	if not menuVisible then return end

	clock = clock + dt
	if CONFIG.AnimatedBorder then
		for _, gradient in ipairs(spinningGradients) do
			gradient.Rotation = (gradient.Rotation + dt * 70) % 360
		end
	end
	local phase = clock % 4
	local offset = phase < 1.4 and (-1 + 2 * phase / 1.4) or 1
	for _, gradient in ipairs(shimmerGradients) do
		gradient.Offset = Vector2.new(offset, 0)
	end
	logoEmoji.Position = UDim2.new(0.5, 0, 0.5, math.sin(clock * 2.2) * 2)
	versionGlow.Transparency = 0.55 + math.sin(clock * 3) * 0.3
	for _, swing in ipairs(swingers) do
		swing.Object.Rotation = swing.Base + math.sin(clock * swing.Speed) * swing.Amount
	end
end)

task.spawn(function()
	while gui.Parent do
		if menuVisible then
			onlinePulse.Size = UDim2.fromScale(1, 1)
			onlinePulse.BackgroundTransparency = 0.35
			tween(onlinePulse, 1.2, { Size = UDim2.fromScale(2.4, 2.4), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
			task.wait(1.8)
		else
			task.wait(0.5)
		end
	end
end)

task.spawn(function()
	while gui.Parent do
		if introDone and not menuVisible then
			openPulse.Size = UDim2.fromScale(1, 1)
			openPulse.BackgroundTransparency = 0.45
			tween(openPulse, 1.3, { Size = UDim2.fromScale(1.9, 1.9), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
			task.wait(1.6)
		else
			task.wait(0.3)
		end
	end
end)

task.spawn(function()
	local seconds = 0
	while gui.Parent do
		local whole = math.floor(seconds)
		local days, hours = math.floor(whole / 86400), math.floor(whole / 3600) % 24
		local clock = string.format("%02d:%02d", math.floor(whole / 60) % 60, whole % 60)
		if whole >= 86400 then
			clock = days .. "d " .. string.format("%02d:", hours) .. clock
		elseif whole >= 3600 then
			clock = hours .. ":" .. clock
		end
		profileStats[3].Text = clock
		seconds = seconds + task.wait(1)
	end
end)

-- [[ ИНИЦИАЛИЗАЦИЯ / INITIALIZATION ]]
-- Загрузка завершена без интро, меню закрыто и открывается только по бинду (ПК) или кнопке (телефон)
introDone = true
setMenuVisible(false)