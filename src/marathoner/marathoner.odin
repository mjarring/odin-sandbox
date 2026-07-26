package main

import "core:fmt"
import "core:mem"
import wl "../../odin-wayland/"

struct marathoner_state {
  wl_display: ^wl.display
}

main :: proc() {
	my_arena: mem.Arena
	my_arena_memory := make([]byte, mem.Gigabyte * 8)
	mem.arena_init(&my_arena, my_arena_memory)
	context.allocator = mem.arena_allocator(&my_arena)
	defer free_all()

  display := wl.display_connect(nil)
  if display != nil {
    fmt.println("Connected!")
  } else {
    fmt.println("Not connected!")
    return
  }

}
