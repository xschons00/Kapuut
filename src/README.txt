Tento dokument popisuje adresárovú štruktúru projektu Kapuut.

--------------------------------------------------------------------------

/src
Koreňový adresár projektu obsahujúci všetku aplikačnú logiku, dáta a scény
Godot projektu.

/src/DAL
Dátová prístupová vrstva aplikácie. Zodpovedá za prácu s lokálne uloženými
dátami, ich načítanie, ukladanie a inicializáciu pri prvom spustení.

/src/DAL/DataAccess
Podsúčasť dátovej vrstvy určená na oddelený prístup k jednotlivým častiam
dátového modelu (profily, konfigurácia, herné témy).

/src/DAL/DataObjects
Dátové objekty reprezentujúce jednotlivé entity aplikácie. Slúžia ako
medzivrstva medzi dátovou vrstvou a aplikačnou logikou.

/src/scenes
Obsahuje všetky Godot scény aplikácie.

/src/scenes/components
Znovupoužiteľné vizuálne komponenty používateľského rozhrania.

/src/scenes/FlashCardGame
Scény súvisiace s tréningovým režimom a individuálnym precvičovaním otázok.

/src/scenes/PvPGame
Scény pre súťažný herný režim viacerých hráčov na jednom zariadení.

/src/scripts
Skripty riadiace správanie scén a komponentov používateľského rozhrania.

/src/scripts/components
Logika opakovane použiteľných UI komponentov.

/src/scripts/FlashCardGame
Skripty hernej logiky tréningového režimu.

/src/scripts/PvPGame
Skripty hernej logiky súťažného režimu.

--------------------------------------------------------------------------

