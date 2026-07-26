package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

XDG_RUNTIME_DIR :: "XDG_RUNTIME_DIR"

main :: proc() {
	my_arena: mem.Arena
	my_arena_memory := make([]byte, mem.Gigabyte * 8)
	mem.arena_init(&my_arena, my_arena_memory)
	context.allocator = mem.arena_allocator(&my_arena)
	defer free_all()

	socket_path_builder: strings.Builder
	strings.builder_init(&socket_path_builder)

	xdg_runtime_dir, err := os.lookup_env(XDG_RUNTIME_DIR, context.allocator)

	strings.write_string(&socket_path_builder, xdg_runtime_dir)

	socket_path := strings.to_string(socket_path_builder)

}
