Leopardrun - Mutlti Plattformer

iOS Team: Felix Böttger, Jonathan Wiemers, Ilyas Hallakoglu


Bibliotheken die benutzt werden:

    SwiftyJson => JSON Parser
    SocketRocket => WebSocket Verbindung in Swift

Für die Abhängigkeiten wird CocoaPods benutzt, jedoch befindet sich SwiftyJSON unter Helper, da dieser nicht
bei CocoaPods vorhanden ist. 


Grundstruktur der Groups:

Sounds: Alle Wav Dateien
Helper: SwiftyJSON - Bibliothek um json Dateien zu de/serialisieren, für Swift optimiert
Sprites: Sämtliche Atlas Sets, welche wiederum die einzelnen Bilder für eine animation beinhaltet.
Screens: Die eigentlichen Screens die angezeigt werden und die Spiel Logik beinhalten
Manager: Beinhaltet alle Manager Klasse die als Singleton fungieren
Entity: Hier befinden sich die Spielobjekte (ValueObjects)
Supporting Files: Hier liegen die standard Dateien die XCode automatisch erstellt, bzw. allgemein Dateien die benötigt werden.

Struktur Screens:

    Base/GameViewController
        - Einstiegspunkt in der App
        - Lädt die Menü Scene
        - Bietet kleinere Hilfsmethoden an

    Menu/MenuScene
        - Einfache Menüauswahl zwischen New Game (Single Player) und Challenges (Multiplayer)
        - Lädt die entsprechenden Scenens nach Auswahl

    Base/GameBaseScene
        - Grundlegende Funktionen wurden vom GameScreen in den GameBaseScreen verschoben
        - Dient dazu um die Übersicht zu behalten
        - Erbt von SKScene

    Single/GameScene
        - Das Spiel für New Game, also Einzelspieler
        - Erweitert den GameBaseScreen um sämtliche Single Player funktionen
        - Lädt Daten vom Server und baut das Level auf
        - Benutzt dabei folgende Manager: Sound, Level, Network und Score

    Mutli/LobbyScene
        - Lädt mithilfe des NetworkManager die besten 10 Challenges vom Server
        - Nach Auswahl einer Challenge initalisiert er die GameMultiScene
        - Gibt dem LevelManager die benötigten Informationen zum Level bauen
        - Dient als "Schnittstelle" zwischen LevelManager und NetworkManager, da hier
          erst entschieden wird, welche Challenge der Spieler nimmt

    Multi/GameMultiScene
        - Erbt vom GameScene
        - Erweitert GameScene um die Multiplayer Komponente wie z.B. Ghost (anzeigen/steuern) und den Challenge Score anzuzeigen

    Gameover/GameOver
        - Zeigt den erreichten Score an
        - Sendet mithilfe des NetworkManager den erreichten Score an Server (falls erwünscht)
        - Gibt die Möglichkeit Spielname und Spielernamen einzutragen

Struktur Entities
    Definition des Physicskörpers befinden sich so gut wie in jeder Klasse

    Entity
        - Grund Klasse
        - Beinhaltet defintion für normales Sprite sowie Animierte Sprites (Entity, SpriteEntity)
        - Definiert die Bit Categories für die Physic Engine
        - SpriteEntity lädt die Atlas Dateien und erstellt eine korrekt Animation

    Player
        - Beinhaltet State Logik um verschiedene animationen anzuzeigen (laufen, springen, fliegen, etc.)
        - Per Update Methode kann der Player sich selbst aktualisieren und wird im GameLoop aufgerufen

    Obstacle
        - Kann Ground oder Box sein => Objekte kann anhand statischer Methoden erstellt werden
        - "Abbrennen" Logik

    Item
        - Typ wird festgelegt (Momentan nur einer)

    Wall
        - Brennende Wand, relativ Schlank da hier nur die Animation gestartet wird

    Challenge
        - Beinhaltet alle Informationen für eine Challenge (Level, Score, Spieler Actions etc.)

    Sky
        - Unsichtbares Objekt was den Player davon abhält aus dem Bildschirm heraus zu springen
        - Befindet sich immer über dem Spieler

    Ghost
        - Erweiterung vom Player
        - Überschreibt bestimmte Methoden, da der Ghost z.B. andere Animationen hat

Manager Struktur

    SoundManager
        - Lädt Sounds und kann diese abspielen
        - Sounds werden zum start in einem Dictionary abegelgt und sind so Zwischengespeichert

    LevelManager
        - Baut das Level mithilfe einer JSON vom Server auf
        - Bietet ein Delegate, wenn ein Level fertig gebaut ist (ReceiveData)
        - per setLevelJson kann vom außen ein Level gesetzt werden
        - Setzt beim NetworkManager ein delegate

    NetworkManager
        - Verwaltet die Verbindung und den Datenaustausch mit dem Server per WebSocket
        - implementiert dafür das SRWebSocketDelegate Protokoll (=> externe lib in Pods, SocketRocket)
        - Bietet ein Delegate, wenn das Level vom Server empfangen wurde (NetworkListener/getLevelData)

    ScoreManager
        - Kümmert sich um das hochzählen des Score
        - Bietet ein SKLabelNode an, mit dem man den Score auf einem Screen anzeigen kann





