package main

import "vendor:raylib"

main :: proc() {
	raylib.InitWindow(800, 600, "Marathoner")

	for (!raylib.WindowShouldClose()) {
		raylib.BeginDrawing()

		raylib.ClearBackground(raylib.RAYWHITE)

		raylib.DrawText("Welcome to Marahoner!", 400, 80, 20, raylib.LIGHTGRAY)

		raylib.EndDrawing()
	}

	raylib.CloseWindow()
}
