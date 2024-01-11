// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

/* List of available widgets:

	- Paragraph

*/

/* ##########################
 * #### PARAGRAPH WIDGET ####
 * ########################## */

Paragraph :: struct {
	using block: Block,
	text:        string,
	text_style:  Style,
	wrap_text:   bool,
}

new_paragraph :: proc() -> Block {
	b := new_block()
	b.derived = Paragraph{
		block = b,
		text_style = theme.paragraph.text,
		wrap_text = true,
	}
	return b
}

draw_paragraph :: proc(p: Paragraph, buf: ^Buffer) {
	draw(p.block, buf)

	cells := parse_styles(p.text, p.text_style)
	if p.wrap_text {
		cells = wrap_cells(cells, uint(p.inner.dx()))
	}

	rows := split_cells(cells, '\n')

	for row, y in rows {
		if y+p.inner.min.y >= p.inner.max.y {
			break
		}
		row = trim_cells(row, p.inner.dx())
		for cx, _ in build_cell_with_xarray(row) {
			x, cell := cx.x, cx.cell
			buf.set_cell(cell, pt_add(pt(x, y), p.inner.min))
		}
	}
}
