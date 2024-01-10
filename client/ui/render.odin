// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

/*
import (
	"image"
	"sync"

	tb "github.com/nsf/termbox-go"
)

type Drawable interface {
	GetRect() image.Rectangle
	SetRect(int, int, int, int)
	Draw(*Buffer)
	sync.Locker
}
*/

// explicit procedure overloading

draw :: proc {
	draw_block,
}

get_rect :: proc {
	get_rect_block,
}

set_rect :: proc {
	set_rect_block,
}

// need parametric polymorphism? line 629 in demo
render :: proc(items: ..Drawable) {
	for item, _ in items {
		buf := new_buffer(get_rect(item))
		//item.Lock()
		draw(item, buf)
		//item.Unlock()
		for cell, point in buf.cell_map {
			if point.in(buf.rectangle) {
				tb.set_cell(
					point.x, point.y,
					cell.rune,
					tb.Attribute(cell.Style.Fg+1)|tb.Attribute(cell.Style.Modifier), tb.Attribute(cell.Style.Bg+1),
				)
			}
		}
	}
	tb.flush()
}
