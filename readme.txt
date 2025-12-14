Kapuut – přehled archivu a umístění klíčových částí FE
======================================================

Kořen repozitáře
----------------
- project.godot, Kapuut.pck/Kapuut.exe – Godot projekt a build.
- export_presets.cfg – nastavení exportů.
- README.md – základní popis projektu.
- docs/ – textové podklady (reporty).
- assets/ – grafika, pozadí, avatary, shadery.
- src/ – zdrojové soubory (scény, skripty, data).

Frontend (Godot) – hlavní adresáře
----------------------------------
- src/scenes/ – scény UI:
  - MainPage.tscn, FlashcardsMainPage.tscn, Profiles.tscn,PvPMainPageTmp.tscn (autor xschons00).
  - FlashCardGame/…, PvPGame/… (autor xjakubk00).
  - WheelOfFortuneMainPage.tscn (autor xpitkaa00).
- src/scripts/ – GDScript logika:
  - MainPage.gd, profiles.gd, components/Menu.gd, components/AvatarSelection.gd, components/BackgroundSelection.gd (autor xschons00 – navigace, profily, výběr avatara/pozadí, menu).
  - PvPGame/, FlashCardGame/ (autor xjakubk00 – herné logiky ).
  - components/game_selection_list.gd, components/game_selection_item.gd (autor xjakubk00 – komponenty výběru her).
  - WheelOfFortuneMainPage.gd, components/DailyMissions.gd (autor xpitkaa00 – kolo štěstí a denní úlohy).
- src/Globals.gd – globální inicializace, menu/daily missions singletony, defaultní cesty (autor xschons00).

Data vrstva
-----------
- src/DAL/DataAccess/… a DataObjects/… (autor xschons00,xjakubk00) – přístup k profilům, tématům a otázkám, ukládání do data.json.
- src/DAL/data.json – perzistentní data (themes, profiles, config).

Další
-----
- src/assets/shaders/…, assets/backgrounds/, assets/avatars/ – podklady pro UI.
- docs/01_xschons00_report.tex aj. – projektová dokumentace.
