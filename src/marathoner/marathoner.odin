package main

import "base:runtime"
import "core:c"
import "core:fmt"
import "vendor:sdl3"

App_State :: struct {
	window:   ^sdl3.Window,
	renderer: ^sdl3.Renderer,
}

main :: proc() {
	// Use SDL application loop
	sdl3.EnterAppMainCallbacks(0, nil, app_init, app_iterate, app_event, app_quit)
}

app_init :: proc "c" (appstate: ^rawptr, argc: c.int, argv: [^]cstring) -> sdl3.AppResult {
	context = runtime.default_context()

	if !sdl3.Init({.VIDEO}) {
		fmt.eprintf("Failed to init SDL: %s\n", sdl3.GetError())
		return .FAILURE
	}

	state := new(App_State)
	appstate^ = state

	if !sdl3.CreateWindowAndRenderer(
		"Marathoner",
		800,
		600,
		{.RESIZABLE},
		&state.window,
		&state.renderer,
	) {
		fmt.eprintf("Failed to create window/renderer: %s\n", sdl3.GetError())
		return .FAILURE
	}

	return .CONTINUE
}

app_iterate :: proc "c" (appstate: rawptr) -> sdl3.AppResult {
	state := cast(^App_State)appstate

	sdl3.SetRenderDrawColorFloat(state.renderer, 0.2, 0.2, 0.2, sdl3.ALPHA_OPAQUE_FLOAT)
	sdl3.RenderClear(state.renderer)

	sdl3.RenderPresent(state.renderer)

	return .CONTINUE
}

app_event :: proc "c" (appstate: rawptr, event: ^sdl3.Event) -> sdl3.AppResult {
	#partial switch event.type {
	case .QUIT:
		return .SUCCESS
	}

	return .CONTINUE
}

app_quit :: proc "c" (appstate: rawptr, result: sdl3.AppResult) {
	context = runtime.default_context()
	state := cast(^App_State)appstate

	if state != nil {
		sdl3.DestroyRenderer(state.renderer)
		sdl3.DestroyWindow(state.window)
		free(state)
	}

	sdl3.Quit()
}
