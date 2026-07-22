package main

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:math"
import sdl "vendor:sdl3"

App_State :: struct {
	window:   ^sdl.Window,
	renderer: ^sdl.Renderer,
}

main :: proc() {
	// Use SDL application loop
	sdl.EnterAppMainCallbacks(0, nil, app_init, app_iterate, app_event, app_quit)
}

app_init :: proc "c" (appstate: ^rawptr, argc: c.int, argv: [^]cstring) -> sdl.AppResult {
	context = runtime.default_context()

	if !sdl.Init({.VIDEO}) {
		fmt.eprintf("Failed to init SDL: %s\n", sdl.GetError())
		return .FAILURE
	}

	state := new(App_State)
	appstate^ = state

	if !sdl.CreateWindowAndRenderer(
		"Sample SDL w/ Odin",
		800,
		600,
		{.RESIZABLE},
		&state.window,
		&state.renderer,
	) {
		fmt.eprintf("Failed to create window/renderer: %s\n", sdl.GetError())
		return .FAILURE
	}

	return .CONTINUE
}

app_iterate :: proc "c" (appstate: rawptr) -> sdl.AppResult {
	state := cast(^App_State)appstate

	current_time_seconds := cast(f32)sdl.GetTicks() / 1000.0
	red := 0.5 + 0.5 * math.sin(current_time_seconds)
	green := 0.5 + 0.5 * math.sin(current_time_seconds + math.PI * 2 / 3)
	blue := 0.5 + 0.5 * math.sin(current_time_seconds + math.PI * 4 / 3)

	sdl.SetRenderDrawColorFloat(state.renderer, red, green, blue, sdl.ALPHA_OPAQUE_FLOAT)
	sdl.RenderClear(state.renderer)

	sdl.RenderPresent(state.renderer)

	return .CONTINUE
}

app_event :: proc "c" (appstate: rawptr, event: ^sdl.Event) -> sdl.AppResult {
	#partial switch event.type {
	case .QUIT:
		return .SUCCESS
	}

	return .CONTINUE
}

app_quit :: proc "c" (appstate: rawptr, result: sdl.AppResult) {
	context = runtime.default_context()
	state := cast(^App_State)appstate

	if state != nil {
		sdl.DestroyRenderer(state.renderer)
		sdl.DestroyWindow(state.window)
		free(state)
	}

	sdl.Quit()
}
