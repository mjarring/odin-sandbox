package main

import "base:runtime"
import "core:c"
import "core:fmt"
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

	red := cast(sdl.Uint8)sdl.GetTicks() % 255
	green := cast(sdl.Uint8)sdl.GetTicks() % 255
	blue := cast(sdl.Uint8)sdl.GetTicks() % 255

	sdl.SetRenderDrawColor(state.renderer, red, green, blue, 255)
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
